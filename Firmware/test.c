
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <rt_misc.h>

#include "SocM3_reg.h"
#include "config.h"
#include "console.h"


int udelay(int time);
extern void fpga_uart_test(void);
extern void logo_display(char *ver);
extern unsigned char fpga_uart0_getchar(void);
extern void Uart_Printf(char *fmt,...);
extern int Uart_SendByte(char c);
//extern int __rt_lib_init(void);
void test_led(void);
extern void sdram_test(void);
extern void sram_test(void);
extern void Edit_Memory(void);
extern void Dump_Memory(void);
extern unsigned int Strata_CheckID(unsigned int targetAddr);
extern void Program28F320J3A(void);
extern void fpga_uart_init(int uart_num,int baudrate);
static void test_mem(unsigned int* src, unsigned int* dest, int n);
void byte_test(void);

void test_led(void);
void test_7segment(void);
//User define --------------------------------------------------------------------
void test_text_lcd(void);
void blinking(void);
void shift_left(void);

//--------------------------------------------------------------------------------

void arm926ejs_main(void)
{
	/* Library : This library was located at ADS Tool's */
//	__rt_lib_init();				

	unsigned char c;
    unsigned int man_Id,dev_Id;
    
	fpga_uart_init(UART0,115200);
	
	
    logo_display(MONITOR_VER);
    
    	
   while(1) {

	Uart_Printf("\r\n ======================================= ");
    	Uart_Printf("\r\n [1] FPGA UART Test                      ");
    	Uart_Printf("\r\n [2] FPGA SDRAM Test                     ");
    	Uart_Printf("\r\n [3] FPGA SRAM Test                      ");
    	Uart_Printf("\r\n [4] FPGA LED TEST          		 ");
    	Uart_Printf("\r\n [5] FPGA 7SEG TEST                      ");
    	Uart_Printf("\r\n [6] FPGA TEXT LCD TEST                ");
    	Uart_Printf("\r\n [7] TEXT LCD pop1                      ");
    	Uart_Printf("\r\n [8] TEXT LCD pop2                  ");
    	Uart_Printf("\r\n [9]                       ");
    	Uart_Printf("\r\n [a] BYTE_test                           ");
    	Uart_Printf("\r\n [b] function_call test                  ");    	    	
    	Uart_Printf("\r\n ======================================= ");
    	Uart_Printf("\r\n Enter Your Test Number =>");

    	c = fpga_uart0_getchar();
    	Uart_SendByte(c);
    	udelay(1);
    	   		
    	switch (c) {
    		case '1' :
    				fpga_uart_test();
    				break;
    		case '2' :
    				sdram_test();
    				break;
    		case '3' :
    				sram_test();		
    				break;
		    case '4' :
		    		test_led();
			  		break;
    		case '5' :
    				test_7segment();		
    				break;
    		case '6' :
    				test_text_lcd();		
    				break;
    		case '7' :
    				pop_one();
	
    				break;
    		case '8' :
    				pop_two();

    				break;
    		case '9' :
    				
    				break;	
    		case 'a' :
    				byte_test();
    				break;	
    		case 'b' :
    				function_call();
    				break;	    				
    													
    		default :
    				Uart_Printf("\r\n Your Selection Number is Wrong.");
    				break;
    	}
    	udelay(1);			
	}
}


int udelay(int time) 
{
	unsigned int iCount;

	for( iCount = 0; iCount < time; iCount++ );

	return 0;
}        


int mdelay(int time) 
{
	unsigned int iCount, iCount2;

	for( iCount = 0; iCount < time; iCount++ )
		for( iCount2 = 0; iCount2 < time; iCount2++ );

	return 0;
}


void byte_test(void)
{
	unsigned int k[100], j[100],i;
	unsigned int tar_size, *tarAddr, *srcAddr; 
	
	tarAddr = 0x0;
	srcAddr = (unsigned int *)0x50000000;
	
    for (i=0; i<tar_size; i+=4) 
    {
//       Uart_Printf("%x -- %x   ",*tarAddr,*srcAddr);
       if(i%0x1000==0xffc)  Uart_Printf(" [%x]",(i+128)/0x1000);
      if (*tarAddr != *srcAddr) Uart_Printf(" ~~~ s:%x, d:%x \n\r",*tarAddr,*srcAddr);
        tarAddr++;
        srcAddr++;
//    if (*((unsigned int *)(i+tarAddr)) != *((unsigned int *)(srcAddr+i))) 
//        {
//        Uart_Printf("\n\rverify error  src %x = %x", srcAddr+i, *((unsigned int *)(srcAddr+i)));
//        Uart_Printf("\n\rverify error  des %x = %x", tarAddr+i, *((unsigned int *)(tarAddr+i)));
//         }
    }
    Uart_Printf("\nVerifying End(Passed)!!!");

	
	test_mem(k,j,100);
    
 }
 
 
 
static void test_mem(unsigned int* src, unsigned int* dest, int n) 
{
    int i;
    unsigned char* addr_8;
    unsigned short* addr_16;
    unsigned int*  addr_32;
    unsigned int   val;
 
 
    
    Uart_Printf("\n\r[mem test] from 0x%x to 0x%x, %d times\n", src, dest, n);
    
    /* byte simple test */
    addr_8 = (unsigned char *)src;
    for (i = 0; i < 8; i++) {
        *addr_8 = (unsigned char)0x1 << i;        
        if (*addr_8 != ((unsigned char)0x1 << i)) {
            Uart_Printf("[mem err8] 0x%x -> 0x%x\n", ((unsigned char)0x1 << i), *addr_8);
        }        
    }
    
    /* 16bit simple test */
    addr_16 = (unsigned short *)src;
    for (i = 0; i < 16; i++) {
        *addr_16 = ((unsigned short)0x1 << i);        
        if (*addr_16 != ((unsigned short)0x1 << i)) {
            Uart_Printf("[mem err16] 0x%x -> 0x%x\n", ((unsigned short)0x1 << i), *addr_16);
        }        
    }
    
    
    
    /* 32bit intensive test */
    for (i = 0; i < n; i++) {
        addr_32 = src;
        while(addr_32++ < dest) {
            if (i % 2 == 0) {
                *addr_32 = (unsigned int)addr_32;
            } else {
                *addr_32 = ~(unsigned int)addr_32;
            }
        }
        
        addr_32 = src;
        while(addr_32++ < dest) {
            val = *addr_32;
            if (i % 2 == 0) {
                if (val != (unsigned int)addr_32) {
                    Uart_Printf("[mem err32] 0x%x -> 0x%x\n", (unsigned int)addr_32, val);
                }
            } else {
                if (val != ~(unsigned int)addr_32) {
                    Uart_Printf("[mem err32] 0x%x -> 0x%x\n", ~(unsigned int)addr_32, val);
                }
            }
        }
    }
    fpga_uart0_getchar();
}

void test_led( void )
{


}
//User define ---------------------------------------------------------------------
void test_7segment( void )
{
	unsigned char c = 0;
	unsigned int SEG_DATA = 0x00000000;
	volatile unsigned int * SEG_ADDR;
	
	SEG_ADDR = (volatile unsigned int *) (0x70000024);
	Uart_Printf( "\t\r\n Input 7 segment value : " );
	c = fpga_uart0_getchar();
	Uart_SendByte(c);
	SEG_DATA = (SEG_DATA << 4) | ((unsigned int)c & 0x0f);
	c = fpga_uart0_getchar();
	Uart_SendByte(c);
	SEG_DATA = (SEG_DATA << 4) | ((unsigned int)c & 0x0f);
	c = fpga_uart0_getchar();
	Uart_SendByte(c);
	SEG_DATA = (SEG_DATA << 4) | ((unsigned int)c & 0x0f);
	c = fpga_uart0_getchar();
	Uart_SendByte(c);
	SEG_DATA = (SEG_DATA << 4 )| ((unsigned int)c & 0x0f);
	c = fpga_uart0_getchar();
	Uart_SendByte(c);
	SEG_DATA = (SEG_DATA << 4) | ((unsigned int)c & 0x0f);
	c = fpga_uart0_getchar();
	Uart_SendByte(c);
	SEG_DATA = (SEG_DATA << 4) | ((unsigned int)c & 0x0f);
	c = fpga_uart0_getchar();
	Uart_SendByte(c);
	SEG_DATA = (SEG_DATA << 4) | ((unsigned int)c & 0x0f);
	c = fpga_uart0_getchar();
	Uart_SendByte(c);
	SEG_DATA = (SEG_DATA << 4) | ((unsigned int)c & 0x0f);
	*SEG_ADDR = SEG_DATA;
}

void test_text_lcd( void )
{
	unsigned char c = 0;
	unsigned char blank = 32;
	unsigned char t=0;
	unsigned int i,j,l,m;
			 int k;
	unsigned int SEG_DATA = 0;
	volatile unsigned int * SEG_ADDR;
	volatile unsigned int * SEG_ADDR_temp;
	unsigned int SEG_ADDR_TEMP;
	
	SEG_ADDR = (volatile unsigned int *) (0x70000020);
	SEG_DATA = 0;
	*SEG_ADDR = SEG_DATA;
	
	SEG_ADDR = (volatile unsigned int *) (0x70000000);
	Uart_Printf( "\t\r\n Input Text : " );
	
	
	for(i=0;i<8;i++)
	{
		for(j=0;j<4;j++)
		{
	
			c = fpga_uart0_getchar();
			Uart_SendByte(c);
			SEG_DATA = (SEG_DATA << 8) | ((unsigned int)c & 0x00ff);
			
		}
		*SEG_ADDR = SEG_DATA;
		SEG_ADDR +=1;
		
				
	}
		
}
void pop_one(){
	volatile unsigned int * SEG_ADDR;
	unsigned int SEG_DATA;
	SEG_ADDR = (volatile unsigned int *) (0x70000020);
	SEG_DATA = 1;
	*SEG_ADDR = SEG_DATA;
}
void pop_two(){
	volatile unsigned int * SEG_ADDR;
	unsigned int SEG_DATA;
	SEG_ADDR = (volatile unsigned int *) (0x70000020);
	SEG_DATA = 2;
	*SEG_ADDR = SEG_DATA;
}
