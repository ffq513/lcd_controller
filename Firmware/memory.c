#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "SocM3_reg.h"
#include "config.h"
#include "console.h"

extern int udelay(int time);
extern unsigned char fpga_uart0_getchar(void);
extern void Uart_Printf(char *fmt,...);
extern int Uart_SendByte(char c);


/******** ASCII Special Code Define *******/
#define CR   	0x0D   /* Carrige Return  */
#define LF		0x0A   /* Line Feed       */
#define SP		0x20   /* SPace           */
#define BSP		0x08   /* Back SPace      */
#define TAB  	0x09   /* TAB             */
#define HOME 	0x0C   /* HOME            */
#define ESC		0x1B
#define BELL 	0x07   /* BELL            */
#define ENT  	0x0FE  /* ENTer           */ 


unsigned char ascii2hex(unsigned char);
unsigned long get_addr(const char *);

/* convert ascii code to hex data */
unsigned char ascii2hex(unsigned char c)
{
	if(c >= 'A') {
		if(c >='a') c -= 'a';
		else c -= 'A';
		c += 10;
	}
	else c -= '0';
	return c;
}


unsigned long get_addr(const char *msg)
{
	unsigned long dat;
	unsigned char i, c;

	Uart_Printf("%s", msg);

	for ( i = 0, dat = 0; i < 8 ; ) {
		c = fpga_uart0_getchar();
		switch(c) {
			case CR: return dat;
			case ESC: return 0;
			case BSP:
				Uart_SendByte(c);
				dat >>= 4;
				i--;
			break;
			default:
				Uart_SendByte(c);
				dat <<= 4;
				dat |= ascii2hex(c);
				i++;
		}
	}
	
	return dat;
}


void Edit_Memory(void)
{
	unsigned long *addr, *tmp, dat;
	char i, j, k, c;
	unsigned char *to, from[16];
	
	Uart_Printf("\n ##### Edit the system memory ##### ");
	
	Uart_Printf("\n !!CAUTION!! - enter address on only RAM area) ");
	dat = get_addr("\n Enter RAM address : 0x");
	
	i = (unsigned char)(dat & 0x0f);
	if (i < 4) addr = (unsigned long *)(dat & 0xfffffff0);
	if ((i >= 4) && (i < 8)) addr = (unsigned long *)(dat & 0xfffffff0 + 4);
	if ((i >= 8) && (i < 12)) addr = (unsigned long *)(dat & 0xfffffff0 + 8);
	if (i >= 12) addr = (unsigned long *)(dat & 0xfffffff0 + 12);
	
	i = (unsigned char)((unsigned long)addr & 0x0f);
		
	Uart_Printf("\n ===========================================================");
	Uart_Printf("\n address   00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F ");
	Uart_Printf("\n ===========================================================");
	Uart_Printf("\n\n\n %x : ", (unsigned long)addr & 0xfffffff0);
	
	for ( j = 0, tmp = (unsigned long *)((unsigned long)addr&0xfffffff0); j < 4; j++) {
		dat = (unsigned long)*tmp;

#ifndef _big_endian	/* switching display rule according to byte sex */
		for ( k = 0; k < 4; k++) {
			c = (unsigned char)(dat &0xff);
			dat >>= 8;
			Uart_Printf("%x ", c);
		}
#else

		for ( k = 7; k  > 3; k--) {
			c = (unsigned char)(dat >> ((k%4)*8));
			Uart_Printf("%x ", c);
		}
#endif
		tmp ++;
	}
	
	for (; i <= 0x0f; i++) { Uart_SendByte(BSP); Uart_SendByte(BSP); Uart_SendByte(BSP); }

	to = (unsigned char *)addr; 

	for (j = 0;;) {

		for (i = 0, k = 0; i < 2;) {
			c = fpga_uart0_getchar();
			switch (c) {
				case CR: 
					if (j > 0) {
						for (i = 0; i < j; i++)
							*to++ = from[i];
					}
				return;
				case ESC: 
				return;
				case BSP: 
					Uart_SendByte(c);
					k >>= 4;
					if (i == 0) i = 0;
					else i--;
				break;
				default:
					Uart_SendByte(c);
					k <<= 4;
					k |= ascii2hex(c);
					i++;
				break;
			}
		}
		from[j++] = k;
		Uart_SendByte(' ');
	}
}

/* display memory from input address to user break */
void Dump_Memory(void)
{
	unsigned long *addr, *tmp, dat;
	unsigned char i, j, c;
	char k;

	Uart_Printf("\r\n ##### Display the system memory ##### ");

	addr = (unsigned long *)(get_addr("\r\n Enter start address :0x")&0xffffff00);

	do{
		Uart_Printf("\r\n =============================================================================");
		Uart_Printf("\r\n  address   00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F      ascii code   ");
		Uart_Printf("\r\n =============================================================================");
		for ( i = 0; i < 0x10; i++ ) {
			tmp = addr;
			Uart_Printf("\r\n  %x : ",addr);
			
			for ( j = 0; j < 4; j++) {
				dat = (unsigned long)*tmp;
#ifndef _big_endian /* switching display rule according to byte sex */
				for ( k = 0; k < 4; k++) {
					c = (unsigned char) (dat &0xff);
					dat >>= 8;
					Uart_Printf("%x ", c);
				}
#else

				for ( k = 7; k  > 3; k--) {
					c = (unsigned char) (dat >> ((k%4)*8));
					Uart_Printf("%x ", c );
				}
#endif
				tmp ++;
			}

			Uart_SendByte(' ');

			for ( j = 0; j < 4; j++) {
				dat = (unsigned long)*tmp;
#ifndef _big_endian
				for ( k = 0; k < 4; k++) {
					c = (unsigned char) (dat & 0xff);
					dat >>= 8;
					if ((c&0xff) < 0x20 || (c&0xff) > 0x7f) Uart_SendByte('.');
					else Uart_SendByte(c&0xff);
				}
#else
				for ( k = 7; k > 3; k--) {
					c = (unsigned char) (dat >> ((k%4)*8));
					if ((c&0xff) < 0x20 || (c&0xff) > 0x7f) Uart_SendByte('.');
					else Uart_SendByte(c&0xff);
				}
#endif
				tmp ++;
			}

			if((unsigned long)addr == 0x3ffffff) {
				Uart_Printf("\r\n ============================================================================");
				return;
			}
			addr += 4;
		}
		Uart_Printf("\r\n =============================================================================");
		Uart_Printf("\r\n Display next page : TAB key....");
	} while(fpga_uart0_getchar() == 0x09); /* check TAB key */
}
