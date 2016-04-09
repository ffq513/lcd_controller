`timescale 1ns/1ps
module tb_apb_seg_charlcd;

reg PRESETn;
reg PADDR;
reg PCLK;
reg PENABLE;
reg PSEL;
reg PWRITE;
reg PWDATA;
wire PRDATA;
reg LCDCLK;

wire LCD_RS;
wire LCD_RW;
wire LCD_EN;
wire LCD_DATA;
wire SEGOUT;
wire SEGCOM;
wire LED_OUT;


apb_seg_charlcd apbdd(
	PRESETn,
	PADDR,
	PCLK,
	PENABLE,
	PSEL,
	PWRITE,
	PWDATA,
	PRDATA,
	
	LCDCLK,
	LCD_RS,
	LCD_RW,
	LCD_EN,
	LCD_DATA,

	SEGOUT,
	SEGCOM,
	LED_OUT	
);



initial
begin
	LCDCLK = 1'b0;
	forever #50 LCDCLK = ~LCDCLK;
end

initial
begin
	PRESETn = 1'b0;
	#100 PRESETn = 1'b1;
	#100000000 $finish;
end

endmodule