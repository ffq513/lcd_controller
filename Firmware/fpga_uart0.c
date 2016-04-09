#include "SocM3_reg.h"
#include "config.h"

#define DEFAULT_BAUD	38400
//#define UART_CLK		40750000	// 40.75MHz
#define UART_CLK		25000000	// 

 
extern void udelay(int time);
void fpga_uart_init(int uart_num,int baudrate);
int  Uart_SendByte(char c);
extern void Uart_Printf(char *fmt,...);
unsigned char fpga_uart0_getchar(void);

void fpga_uart_init(int uart_num,int baudrate)
{
int temp_baudrate;
	temp_baudrate = baudrate;
			
	if(temp_baudrate == 0) temp_baudrate = DEFAULT_BAUD;
		
	switch(uart_num){
		case UART0 : 
				FPGA_UART0_REG(UARTLCR) = 0x60;	//date 8bit,not fifo(16byte) mode,none parity,1 stop bit
#if 1
				FPGA_UART0_REG(UARTBRD) = ((UART_CLK)/temp_baudrate) & 0x3fff;	// set baud rate
//				FPGA_UART0_REG(UARTBRD) = 0x162;
				FPGA_UART0_REG(UARTCR) = 0x02;	//error frame discard				
				FPGA_UART0_REG(UARTCR) |= 0x01;	//uart enable											
#else
				FPGA_UART0_REG(UARTBRD) = 0xD6D;	// set baud rate
				FPGA_UART0_REG(UARTCR) = 0x03;	//  error frame discard,uart enable							
#endif									

				
				break;
		case UART1 : 

				break;				
		default :	
				break;
	}
}

int Uart_SendByte(char c)
{

   /* Wait for transmit ready bit */
   
//
    int i;
	udelay(1);
	for (i=0;i<1;i++);
  	while(*(volatile unsigned int *)(0x60001014) & 0x01);

   if(c == '\n') FPGA_UART0_REG(UARTDR) = '\r';		   	
		FPGA_UART0_REG(UARTDR) = c;
		udelay(1);					

    
    return((int)c);
}

unsigned char fpga_uart0_getchar(void)
{
    char    c;
    
    int i;


	for (i=0;i<2;i++);
    while((FPGA_UART0_REG(UARTFR) & 0x02)){
    }    
   	
    c = FPGA_UART0_REG(UARTDR);
//    udelay(100);

    return(c);
}					


unsigned int get_hexnum(void)
{
  unsigned int t = 0;
  int i=0;
  char c;
  

  while (   (c = fpga_uart0_getchar()) != 13){
	Uart_SendByte(c);
  	t = (t << 4) + (c - 0x30);
  	i ++;
  	}
	Uart_Printf("\n\r");  
  return  t;
}

void fpga_uart_test(void)
{
	unsigned char c;	


//	fpga_uart_init(UART0,38400);
	
	Uart_Printf("\n\r Enter test character :");
	do {
		c = fpga_uart0_getchar();
		Uart_SendByte(c);
		} while (c != 13);
		
	Uart_Printf("\r\n UART Test OK!! ") ;
//	udelay(10000);
//	*(volatile unsigned long *)FPGA_UART0_BASE_ADDR = 0x30;
//	udelay(10000);
}



