module text_lcd(
	LCDCLK,
	PRESETn,
	data,
	LCD_RS,
	LCD_RW,
	LCD_EN,
	LCD_DATA
);
input LCDCLK;
input PRESETn;
input [255:0] data;

output reg LCD_RW;
output reg LCD_RS;
output reg LCD_EN;
output reg [7:0]LCD_DATA;


parameter set0 = 8'h38;
parameter set1 = 8'h0e;
parameter set2 = 8'h06;
parameter set3 = 8'h02;
parameter set4 = 8'h01;
parameter set5 = 8'h80;
parameter set6 = 8'hc0;

reg[11:0] cnt;
reg[3:0] data_sel;
reg[255:0] data_tmp;

//lcd controller
always @(posedge LCDCLK or negedge PRESETn) begin
	if (~PRESETn) begin
		LCD_RW <= 0;
		LCD_RS <= 0;
		LCD_EN <= 0;
	end
	else if (cnt >= 0 && cnt <= 200) begin
		LCD_EN <= 0;
	end
	else if (cnt > 200 && cnt <= 1800) begin
		LCD_EN <= 1;
	end
	else begin
		LCD_EN <= 0;
	end
end

//lcd data selector manager
always @(posedge LCDCLK or negedge PRESETn) begin
	if (~PRESETn) begin
		data_tmp <= data;
	end
	else if (cnt == 2000) begin
		data_tmp <= {data_tmp[247:0] ,data_tmp[255:248]};
	end
end

//lcd data writer
always @(posedge LCDCLK or negedge PRESETn) begin
	if (~PRESETn) begin
		LCD_DATA <= 0;
	end
	else begin
		LCD_DATA <= data_tmp[255: 248];
	end
end

//counter manager
always @(posedge LCDCLK or negedge PRESETn) begin
	if (~PRESETn) begin
		cnt <= 0;
	end
	else if (cnt == 2000) begin
		cnt <= 0;
	end
	else begin
		cnt <= cnt + 1;
	end
end

endmodule
