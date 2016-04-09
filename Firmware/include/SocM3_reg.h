// pjk 050707 : fpga uart ip test

// uart ip
#define FPGA_UART0_BASE_ADDR	0x60001000
#define FPGA_UART0_REG(_x_)		*(volatile unsigned int *)(FPGA_UART0_BASE_ADDR + _x_)
#define UARTDR			0x0
#define UARTRSR			0x4
#define UARTECR			0x4
#define UARTLCR			0x8
#define UARTBRD			0xC
#define UARTCR			0x10
#define UARTFR			0x14
#define UARTIIR			0x18
#define UARTICR			0x18

#define SDRAM_BASE_ADDR		0x50000000
#define SRAM_BASE_ADDR		0x40000000
//#define SRAM_CNTR_ADDR		0x50000004
       
// led control port
#define LED8_BASE_ADDR	0x6000000c
#define LED8_OUTPUT_REG		*(volatile unsigned int *)(LED8_BASE_ADDR)

//FND control port
#define FND_BASE_ADDR	0x70000004
#define FND_OUTPUT_REG		*(volatile unsigned int *)(FND_BASE_ADDR)
#define LCD_BASE_ADDR	0x70000104


#define TARGET_ADDR_28F320      0x00000000  // 32MB area
//#define SOURCE_ADDR_FOR_28F320  0x30100000 // SRAM Preload Flash program buffer base address(bank2)
#define SOURCE_ADDR_FOR_28F320  0x50000000 // SRAM Preload Flash program buffer base address(bank2)
 