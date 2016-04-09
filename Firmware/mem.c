#include "SocM3_reg.h"
#include "console.h"

extern void Uart_Printf(char *fmt,...);
extern int Uart_SendByte(char c);
extern void udelay(int time);

void sdram_test(void)
{
	unsigned int i, value;

	Uart_Printf("\r\n Starting SDRAM Test..");
	Uart_Printf("\r\n Now Writing SDRAM Test Pattern..");
	for(i = 0; i< 0x1000000; i++){
		*(volatile unsigned int *)(SDRAM_BASE_ADDR + i*4) = i;
	}
	
	udelay(100);
	Uart_Printf("\r\n Done Writing SDRAM Test Pattern..");
	Uart_Printf("\r\n Now Reading SDRAM Test Pattern..");	
	
	for(i = 0; i< 0x1000000; i++){
		value = *(volatile unsigned int *)(SDRAM_BASE_ADDR + i*4);
		if(value != i){
			Uart_Printf(BRED);
			Uart_Printf("\r\n sdaram value mismatch : addr = 0x%x,value1 = 0x%x,value2 = 0x%x",SDRAM_BASE_ADDR + i*4,value,i);
			Uart_Printf(BLACK);
		}
	}
	Uart_Printf("\r\n SDRAM[64MB] TEST OK..");
}
	