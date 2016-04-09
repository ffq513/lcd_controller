#include "SocM3_reg.h"
#include "console.h"
#include "config.h"

extern void Uart_Printf(char *fmt,...);
extern int Uart_SendByte(char c);
extern void udelay(int time);

void sram_test(void)
{
	unsigned int i, value;


//	*(volatile unsigned int *)(SRAM_CNTR_ADDR) =0x01020102; 
	Uart_Printf("\r\n Starting SRAM Test..");
	Uart_Printf("\r\n Now Writing SRAM Test Pattern..");

	for(i = 0; i< 0x40000; i++){
		*(volatile unsigned int *)(SRAM_BASE_ADDR + i*4) = (unsigned int)i;
		FND_OUTPUT_REG = i;
	}
	
	udelay(100);
	Uart_Printf("\r\n Done Writing SRAM Test Pattern..");
	Uart_Printf("\r\n Now Reading SRAM Test Pattern..");	
	
	for(i = 0; i< 0x40000; i++){
		value = *(volatile unsigned int *)(SRAM_BASE_ADDR + i*4);
				FND_OUTPUT_REG = i;
		if(value != i ){
			Uart_Printf(BRED);
			Uart_Printf("\r\n SRAM Value Mismatch : addr = 0x%x,value1 = 0x%x,value2 = 0x%x",SRAM_BASE_ADDR + i*4,value,i);
			Uart_Printf(BLACK);
		}
	}
	Uart_Printf("\r\n SRAM[1MB] TEST OK..");
}
	