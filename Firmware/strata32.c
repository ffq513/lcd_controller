/*************************************************************************/
/*                                                                       */
/* FILE NAME                                      VERSION                */
/*                                                                       */
/* source\strata.c                                  1.0                  */
/*                                                                       */
/* DATA STRUCTURES                                                       */
/*                                                                       */
/* FUNCTIONS : Strata (Intel flash) program test routine                 */
/*                                                                       */
/* DEPENDENCIES                                                          */
/*                                                                       */
/*                                                                       */
/*************************************************************************/

#include <stdlib.h>
#include <string.h>
#include "strata32.h"
#include "config.h"

#define TARGET_ADDR_28F320      0x00000000  // 32MB area
#define SOURCE_ADDR_FOR_28F320  0x50000000 // SDRAM Preload Flash program buffer base address(bank2)
#define SDRAM_BASE_ADDR 0x50000000
#define SRAM_CTRL_REG 0x70001000
                                            
#define BLOB_FLASH_LEN		(256 * 1024)
#define PARAM_FLASH_LEN     (256 * 1024)
#define KERNEL_FLASH_LEN	(1024 * 1024 * 2)                                            
#define RAMDISK_FLASH_LEN	(5 * 1024 * 1024)

#define BLOB_RAM_BASE       (0x50f00000)
#define KERNEL_RAM_BASE     (0x50008000)
#define PARAM_RAM_BASE      (0x50400000)
#define RAMDISK_RAM_BASE    (0x50500000)

#define BLOB_FLASH_BASE		(0x00000000)
#define PARAM_FLASH_BASE	(BLOB_FLASH_BASE + BLOB_FLASH_LEN)
#define KERNEL_FLASH_BASE	(PARAM_FLASH_BASE + PARAM_FLASH_LEN)
#define RAMDISK_FLASH_BASE	(KERNEL_FLASH_BASE + KERNEL_FLASH_LEN)

#define _WR(addr,data)  *((volatile unsigned int *)(addr))=(unsigned int)data 
#define _RD(addr)       ( *((volatile unsigned int *)(addr)) )       
#define _RESET()    _WR(TARGET_ADDR_28F320,0x00ff00ff)

static void InputProgramSize(void);

static int  Strata_ProgFlash(unsigned int realAddr,unsigned int data);
static void Strata_EraseSector( int targetAddr);
unsigned int  Strata_CheckID(unsigned int targetAddr);
static int  Strata_BlankCheck(int targetAddress,int targetSize);

static int Strata_ProgFlash_Buffer(unsigned int realAddr, unsigned int srcAddress, unsigned int size);
void Program28F320J3A(void);

extern void udelay(int time);
extern void Uart_Printf(char *fmt,...);

unsigned int srcAddress;
unsigned int targetAddress = TARGET_ADDR_28F320; 
unsigned int targetSize; 

int error_erase=0;       // Read Status Register, SR.5
int error_program=0;     // Read Status Register, SR.4


//==========================================================================================
unsigned int Strata_CheckID(unsigned int targetAddr) 
{
int manufacture_id,device_id;
char* manufacture;
char* device;
unsigned int t;

Uart_Printf("\n flash base address : 0x%x \n\r", targetAddr);

	t = _RD(SRAM_CTRL_REG);
	t = t | 0x0406;
	_WR(SRAM_CTRL_REG, t);    

	
 _RESET();
 udelay(40);

  _WR(targetAddr, 0x00900090); 
 udelay(40);
	
 manufacture_id = _RD(targetAddr) >> 16;
  udelay(40);
 device_id = _RD(targetAddr+0x4) >> 16;
  udelay(40);
 switch(manufacture_id & 0xffff){
     case 0x2c : manufacture = "MICTRON";
           break;
     case 0x89 : manufacture = "INTEL";
           break;     	
     default  : manufacture  = "unknown";
     break;
 } 
 switch(device_id & 0xffff){
     case 0x16 : device = "32MB";
           break;
     case 0x17 : device = "64MB";
           break;
     case 0x18 : device = "128MB";
           break;            	
     default  : device = "unknown";
 }          	
  Uart_Printf("\n Flash Manufacturer ID Code : %x (%s) ", manufacture_id,manufacture);	
  Uart_Printf("\n Flash Device ID Code : %x (%s) ", device_id,device);  
    return _RD(targetAddr); // Read Identifier Code, including lower, higher 16-bit, 8MB, Intel Strate Flash ROM
                            // targetAddress must be the beginning location of a Block Address
    _RESET();  
  
}

//==========================================================================================
int Strata_CheckBlockLock(int targetAddr) 
{
    _RESET();
 udelay(400);  

    _WR(targetAddr, 0x00900090);
 udelay(400);  

    return _RD(targetAddr+0x8); // Read Block Lock configuration, 

    _RESET();
                                // targetAddress must be the beginning location of a Block Address
 udelay(400);  
}

void Strata_Unlock_block(int targetAddr)
{
    unsigned long ReadStatus;
    
  _RESET();
  _WR(targetAddress, 0x00500050); // Status Register Clear	
  mdelay(400);
  _WR(targetAddress, 0x00600060); // Block Lock control 	
  mdelay(400);
  _WR(targetAddress, 0x00d000d0); // Unlock setup  	
  mdelay(400);
    _WR(targetAddress, 0x00700070); // Status Read 
  mdelay(400);  	
    ReadStatus=_RD(targetAddr); 	
mdelay(400);    

    _RESET();   
  if (!(ReadStatus & 0x00800080)) {
     Uart_Printf("\rError Block Lock Bit Setup!!");
  }
}
	
   	
    
//==========================================================================================
void Strata_EraseSector(int targetAddr) 
{
    unsigned long ReadStatus;
    unsigned long bSR7;     // Write State Machine Status, lower 16bit, 8MB Intel Strate Flash ROM
  Strata_Unlock_block(targetAddr);  // pjk 050801
  _RESET();
  udelay(4000);   
  _WR(targetAddr, 0x00500050); // Status Register Clear
  udelay(4000);
    _WR(targetAddr, 0x00200020); // Block Erase, First Bus Cycle, targetAddress is the address withint the block
  udelay(4000);  
   _WR(targetAddr, 0x00d000d0); // Block Erase, Second Bus Cycle, targetAddress is the address withint the block
  udelay(4000);  

  do {
    _WR(targetAddr, 0x00700070); // read status register
    udelay(4000);
    bSR7 = _RD(targetAddr);
  } while((~bSR7 & 0x00800080) != 0);

    _WR(targetAddr, 0x00700070); // When the block erase is complete, status register bit SR.5 should be checked. 
  udelay(4000);  
                    // If a block erase error is detected, the status register should be cleared before
                    // system software attempts correct actions.
    ReadStatus=_RD(targetAddr);  
  if((ReadStatus & 0x00200020) != 0) {
     Uart_Printf("\rError in Block Erasure!!");
  }
    else
    {
        Uart_Printf("\nBlock_%x Erase O.K. ",targetAddr);
        _RESET(); udelay(4000); return;
    } 
//	udelay(400);
    _RESET();   // write 0xffh(_RESET(TARGETADDR)()) after the last opoeration to reset the device to read array mode.
  udelay(400);  
}

//==========================================================================================
int Strata_BlankCheck(int targetAddr,int targetSize) 
{
    int i,j;
    for (i=0; i<targetSize; i+=400) 
    {
        j=*((volatile unsigned int *)(i+targetAddr));
        if (j!=0xffffffff)      // In erasure it changes all block dta to 0xff
        {
            Uart_Printf("\nE : %x = %x", (i+targetAddr), j);
            return 0;
        }
 //       	udelay(400);
    }
    return 1;
}

//==========================================================================================
int Strata_ProgFlash(unsigned int realAddr,unsigned int data) 
{
    volatile unsigned int *ptargetAddr; 
    unsigned long ReadStatus;
    unsigned long bSR4;    // Erase and Clear Lock-bits Status, lower 16bit, 8MB Intel Strate Flash ROM
    unsigned long bSR4_2;  // Erase and Clear Lock-bits Status, higher 16bit, 8MB Intel Strate Flash ROM
    unsigned long bSR7;    // Write State Machine Status, lower 16bit, 8MB Intel Strate Flash ROM
    unsigned long bSR7_2;  // Write State Machine Status, higher 16bit, 8MB Intel Strate Flash ROM
    
    /* flash commands for two 16 bit intel flash chips */
	/*
	#define READ_ARRAY		0x00FF00FF
	#define ERASE_SETUP		0x00200020
	#define ERASE_CONFIRM		0x00D000D0
	#define	PGM_SETUP		0x00400040
	#define	STATUS_READ		0x00700070
	#define	STATUS_CLEAR		0x00500050
	#define STATUS_BUSY		0x00800080
	#define STATUS_ERASE_ERR	0x00200020
	#define STATUS_PGM_ERR		0x00100010

	#define CONFIG_SETUP		0x00600060
	#define LOCK_SECTOR		0x00010001
	#define UNLOCK_SECTOR		0x00D000D0
	#define READ_CONFIG		0x00900090
	#define LOCK_STATUS_LOCKED	0x00010001
	#define LOCK_STATUS_LOCKEDDOWN	0x00020002
	*/

    ptargetAddr = (volatile unsigned int *)realAddr;
    _RESET();

    _WR(realAddr, 0x00400040);  // realAddr is any valid adress within the device
 udelay(10);  
                                // Word/Byte Program(or 0x00100010 can be used)
    *ptargetAddr=data;          // 32 bit data
 udelay(10);  

    _RESET();
    _WR(realAddr, 0x00700070);  // Read Status Register
 udelay(10);  

    ReadStatus=_RD(realAddr);   // realAddr is any valid address within the device
    bSR7=ReadStatus & (1<<7);
    bSR7_2=ReadStatus & (1<<(7+16));


    while(!bSR7 || !bSR7_2) 
    {
         _RESET();
        _WR(realAddr, 0x00700070);        // Read Status Register
  udelay(10);  
        ReadStatus=_RD(realAddr);
        bSR7=ReadStatus & (1<<7);
        bSR7_2=ReadStatus & (1<<(7+16));
    }
    

    _WR(realAddr, 0x00700070); 
 udelay(10);  

    ReadStatus=_RD(realAddr);             // Real Status Register
    bSR4=ReadStatus & (1<<4);
    bSR4_2=ReadStatus & (1<<(4+16));
    
    if (bSR4==0 && bSR4_2==0) 
    {
//        Uart_Printf("\rSuccessful Program!!");
        error_program=0;                    // But not major, is it casual ? //doong2 20031011
        ;
    } 
    else 
    {
        Uart_Printf("\rError Program!!");
        _WR(realAddr, 0x00500050);          // Clear Status Register mask doong2 20031011
        error_program=1;                    // But not major, is it casual ?
    }

    _WR(realAddr, 0x00500050);          // Clear Status Register add 20031009
 udelay(1);  

    _RESET();
 udelay(1);  
    return 0;
}



int Strata_ProgFlash_Buffer(unsigned int realAddr, unsigned int srcAddress,unsigned int size) 
{

    volatile unsigned int *ptargetAddr;
    volatile unsigned int *psrcAddr;
	int i;
    unsigned long ReadStatus;
    unsigned long bSR4;    // Erase and Clear Lock-bits Status, lower 16bit, 8MB Intel Strate Flash ROM
    unsigned long bSR4_2;  // Erase and Clear Lock-bits Status, higher 16bit, 8MB Intel Strate Flash ROM
    unsigned long bSR7;    // Write State Machine Status, lower 16bit, 8MB Intel Strate Flash ROM
    unsigned long bSR7_2;  // Write State Machine Status, higher 16bit, 8MB Intel Strate Flash ROM

    ptargetAddr = (volatile unsigned int *)realAddr;
    psrcAddr = (volatile unsigned int *)srcAddress;

    for(i=0; i<size; i+=4,ptargetAddr++,psrcAddr++){

     _WR(realAddr, 0x00400040);  // realAddr is any valid adress within the device
  udelay(10);  
                                 // Word/Byte Program(or 0x00100010 can be used)
     *ptargetAddr=*psrcAddr;          // 32 bit data
  udelay(10);  

     _WR(realAddr, 0x00700070);  // Read Status Register
  udelay(10);  

     ReadStatus=_RD(realAddr);   // realAddr is any valid address within the device
     bSR7=ReadStatus & (1<<7);
     bSR7_2=ReadStatus & (1<<(7+16));


     while(!bSR7 || !bSR7_2) 
     {
         _WR(realAddr, 0x00700070);        // Read Status Register
   udelay(10);  

         ReadStatus=_RD(realAddr);
         bSR7=ReadStatus & (1<<7);
         bSR7_2=ReadStatus & (1<<(7+16));
     }
    
     _WR(realAddr, 0x00700070); 
  udelay(10);  

     ReadStatus=_RD(realAddr);             // Real Status Register
     bSR4=ReadStatus & (1<<4);
     bSR4_2=ReadStatus & (1<<(4+16));
    
     if (bSR4==0 && bSR4_2==0)
     {
        error_program=0;                    // But not major, is it casual ? //doong2 20031011
     } 
     else
     {
  Uart_Printf("\nError Program!!");
        error_program=1;   
        _WR(realAddr, 0x00500050);          // Clear Status Register mask doong2 20031011
  udelay(10);  
	
  break;
     }

        if(i%0x10000==0xfffc)
        Uart_Printf(" [%x]",(i+128)/0x10000);
    }
    
    _WR(realAddr, 0x00500050);          // Clear Status Register add 20031009
 udelay(10);  

    _RESET();
 udelay(10);  
    return error_program;
}


//==========================================================================================                                            
void select_map_fusing(void)
{
// FlashROM write program must reside at RAM region NOT ROM region
// In reading and writing all interrupts are disabled because the flash ROM
// strongly dislike to be disturbed by other stuff.
// And the region of flash ROM must be I/O region which means NO cacheable
// and NO bufferable in MMU. Check it out !!!

    int i;
    unsigned int man_Id,dev_Id;
	unsigned int t;
	
	t = _RD(SRAM_CTRL_REG);
	t = t | 0x0406;
	_WR(SRAM_CTRL_REG, t);    

    Uart_Printf("\nSource base address = 0x%x",srcAddress);
    Uart_Printf("\nThis is Preload prgram buffer base address on SDRAM.");
    Uart_Printf("\nTarget base address = 0x%x",targetAddress);
    Uart_Printf("\nTarget size        (0x20000*n)  = 0x%x",targetSize);




// man id read
    _RESET();
  udelay(10);  

    _WR(TARGET_ADDR_28F320, 0x00900090);
  udelay(10);  

    man_Id = _RD(TARGET_ADDR_28F320+0x4); // Read Device Code, including lower, higher 16-bit, 8MB, Intel Strate Flash ROM
                                // targetAddress must be the beginning location of a Block Address

    _WR(TARGET_ADDR_28F320, 0x00900090); 
  udelay(10);  

    dev_Id = _RD(TARGET_ADDR_28F320) >>16 ; // Read Identifier Code, including lower, higher 16-bit, 8MB, Intel Strate Flash ROM
                            // targetAddress must be the beginning location of a Block Address

    _RESET();
  udelay(10);  




    if ( (dev_Id & 0xffffffff) != 0x00000089 )       // ID number = 0x0089
    {
        Uart_Printf("\nIdentification check error !!");
        return ;
    }

    _RESET();
    Uart_Printf("\nErase the sector : 0x%x.", targetAddress);

    for(i=0;i<targetSize;i+=0x40000)
    {
        Strata_EraseSector(targetAddress+i);
    }
    Uart_Printf("\nAll Erased!!");
    
    if(!Strata_BlankCheck(targetAddress,targetSize))
    {
	    Uart_Printf("\nBlank Check Error!!!");
	    return;
    }
    else 
	   	Uart_Printf(" Blank Check Passed !!");

    
  //  fpga_uart0_getchar();


    Uart_Printf("\nStart of the data writing...");


    for (i=0; i<targetSize; i+=4) 
    {
       Strata_ProgFlash(i+targetAddress, *((unsigned int *)(srcAddress+i)));

       if(i%0x10000==0xfffc) {
       Uart_Printf(" [%x]",(i+128)/0x10000);
       }
    }

// Strata_ProgFlash_Buffer(targetAddress, srcAdd0xress,targetSize);

    Uart_Printf("\nEnd of the data writing ");

    _RESET();
  udelay(10);  

    Uart_Printf("\nVerifying Start...");
    for (i=0; i<targetSize; i+=4) 
    {
        if (*((unsigned int *)(i+targetAddress)) != *((unsigned int *)(srcAddress+i))) 
        {   
            Uart_Printf("\n\rverify error  src %x = %x", srcAddress+i, *((unsigned int *)(srcAddress+i)));
                fpga_uart0_getchar();
                
            Uart_Printf("\n\rverify error  des %x = %x", targetAddress+i, *((unsigned int *)(targetAddress+i)));
                fpga_uart0_getchar();
            return;
        }
    }
    Uart_Printf("\nVerifying End(Passed)!!!");
}

//==========================================================================================
static void InputProgramSize(void)
{
     Uart_Printf("\n[ 28F320J3A Writing Program ]");

        Uart_Printf("\nInput target Progrma size with 0x [0x?] : ");
}


void Program28F320J3A(void)
{
    int i;
    Uart_Printf("\n[ 28F320J3A Flash Writing Program ]\n");

	Uart_Printf("\nflash fusing target (1:bootloader, 2:kernel, 3:ramdisk => ");
	i = get_hexnum();
    Uart_Printf("\ni  = %d",i);

	if ( i == 1) {
		targetSize = BLOB_FLASH_LEN;
		srcAddress = BLOB_RAM_BASE;
		targetAddress = BLOB_FLASH_BASE;
	}
    else if ( i == 2) {
		targetSize = KERNEL_FLASH_LEN;
		srcAddress = KERNEL_RAM_BASE;
		targetAddress = KERNEL_FLASH_BASE;
	}
	else if ( i == 3) {
		targetSize = RAMDISK_FLASH_LEN;
		srcAddress = RAMDISK_RAM_BASE;
		targetAddress = RAMDISK_FLASH_BASE;
	}
    else {
	    Uart_Printf("\n[flash map select Error...]\n");
	    return;
    }
    
    select_map_fusing();
}