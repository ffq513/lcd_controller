`define init_max 6

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
reg[4:0] data_sel;
reg[255:0] data_tmp;
reg[4:0] init;
reg line_change_1;
reg line_change_2;




//lcd controller
always @(posedge LCDCLK or negedge PRESETn) begin
	if (~PRESETn) begin
		LCD_RW <= 0;
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
	
	else if (init == `init_max && cnt == 2000) begin
		if (data_sel == 31) begin
			data_tmp <= data;
		end
		else if(~line_change_1 && ~line_change_2) begin
		   data_tmp <= {data_tmp[247:0] ,data_tmp[255:248]};
		end
	end
end

//lcd data selector manager
always @(posedge LCDCLK or negedge PRESETn) begin
	if (~PRESETn) begin
		data_sel <= 0;
		line_change_1 <= 0;
		line_change_2 <= 0;
	end
	else if (init == `init_max && cnt == 2000) begin
		if(data_sel == 31 && line_change_2 ) begin
			line_change_2 <= 0;
			data_sel <= 0;
		end
		else if(line_change_1) begin
			line_change_1 <= 0;
			data_sel <= data_sel + 1 ;
		end
		else if (data_sel == 15) begin
			line_change_1 <= 1;
		end
		else if (data_sel == 31) begin
			line_change_2 <= 1;
		end
		else begin
			data_sel <= data_sel + 1 ;
		end
	end
end

//lcd data writer
always @(posedge LCDCLK or negedge PRESETn) begin
	if (~PRESETn) begin
		LCD_DATA <= 0;
		LCD_RS <= 0;
		init <= 0;
	end
	else if (init != `init_max && cnt == 2000) begin
		case(init) 
			0 : begin init <=1; LCD_DATA <= set0; end
			1 : begin init <=2; LCD_DATA <= set1; end
			2 : begin init <=3; LCD_DATA <= set2; end
			3 : begin init <=4; LCD_DATA <= set3; end
			4 : begin init <=5; LCD_DATA <= set4; end
         5 : begin init <=6; LCD_DATA <= set5; end
		endcase
	end
	else if (init == `init_max && line_change_1) begin
		LCD_DATA <= set6;
		LCD_RS <= 0;
	end
	else if (init == `init_max && line_change_2) begin
		LCD_DATA <= set3;
		LCD_RS <= 0;
	end
	else begin
		LCD_DATA <= data_tmp[255: 248];
		LCD_RS <= 1;
	end
end

//counter
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
