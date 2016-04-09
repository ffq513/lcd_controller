`timescale 1ns/1ps
module tb_apb_seg_charlcd;

reg PRESETn;
reg PADDR;
reg PCLK;
reg PENABLE;
reg PSEL;
reg PWRITE;
reg PWDATA;
reg PRDATA;
reg LCDCLK;
reg LCD_RS;
reg LCD_RW;
reg LCD_EN;
reg LCD_DATA;
reg SEGOUT;
reg SEGCOM;
reg LED_OUT;

conv_encoder apb_seg_charlcd(rst_n, clk10M, conv_en, sd, puncturer_en, cd1, cd2);
//VITERBI_TOP VITERBI_TOP$0(rst_n, clk10M, CLR, V_EN, cd1, cd2,D_OUT, VITERBI_EN) ;

apb apb_seg_charlcd(
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
)

initial
begin
	conv_en = 1'b0;
	sd = 1'b0;
end


initial
begin
	LCDCLK = 1'b0;
	forever #50 LCDCLK = ~LCDCLK;
end

initial
begin
	PRESETn = 1'b0;
	#100 PRESETn = 1'b1;
	#10000000000 $finish;
end

endmodule