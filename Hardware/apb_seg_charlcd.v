`define LCD_BLANK 8'b00100000
`define LCD_DASH 8'b00101101
`define LCD_COLON 8'b00111010
`define LCD_COMMA 8'b00101100
`define LCD_DOT 8'b00101110
`define LCD_0 8'b00110000
`define LCD_1 8'b00110001
`define LCD_2 8'b00110010
`define LCD_3 8'b00110011
`define LCD_4 8'b00110100
`define LCD_5 8'b00110101
`define LCD_6 8'b00110110
`define LCD_7 8'b00110111
`define LCD_8 8'b00111000
`define LCD_9 8'b00111001
`define LCD_A 8'b01000001
`define LCD_B 8'b01000010
`define LCD_C 8'b01000011
`define LCD_D 8'b01000100
`define LCD_E 8'b01000101
`define LCD_F 8'b01000110
`define LCD_G 8'b01000111
`define LCD_H 8'b01001000
`define LCD_I 8'b01001001
`define LCD_J 8'b01001010
`define LCD_K 8'b01001011
`define LCD_L 8'b01001100
`define LCD_M 8'b01001101
`define LCD_N 8'b01001110
`define LCD_O 8'b01001111
`define LCD_P 8'b01010000
`define LCD_Q 8'b01010001
`define LCD_R 8'b01010010
`define LCD_S 8'b01010011
`define LCD_T 8'b01010100
`define LCD_U 8'b01010101
`define LCD_V 8'b01010110
`define LCD_W 8'b01010111
`define LCD_X 8'b01011000
`define LCD_Y 8'b01011001
`define LCD_Z 8'b01011010
`define LCD_UNDER 8'b01011111
`define LCD_S_a 8'b01100001
`define LCD_S_b 8'b01100010
`define LCD_S_c 8'b01100011
`define LCD_S_d 8'b01100100
`define LCD_S_e 8'b01100101
`define LCD_S_f 8'b01100110
`define LCD_S_g 8'b01100111
`define LCD_S_h 8'b01101000
`define LCD_S_i 8'b01101001
`define LCD_S_j 8'b01101010
`define LCD_S_k 8'b01101011
`define LCD_S_l 8'b01101100
`define LCD_S_m 8'b01101101
`define LCD_S_n 8'b01101110
`define LCD_S_o 8'b01101111
`define LCD_S_p 8'b01110000
`define LCD_S_q 8'b01110001
`define LCD_S_r 8'b01110010
`define LCD_S_s 8'b01110011
`define LCD_S_t 8'b01110100
`define LCD_S_u 8'b01110101
`define LCD_S_v 8'b01110110
`define LCD_S_w 8'b01110111
`define LCD_S_x 8'b01111000
`define LCD_S_y 8'b01111001
`define LCD_S_z 8'b01111010
`define add_line_1 8'b10000000
`define add_line_2 8'b11000000
`define add_line_3 8'b10010100
`define add_line_4 8'b11010100
`define interval 34

module apb_seg_charlcd(
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
	LED_OUT,
	BLINK_FLAG,
	SHIFT_FLAG	
);

input PRESETn;
input [31:0] PADDR;
input PCLK;
input PENABLE;
input PSEL;
input PWRITE;
input [31:0] PWDATA;
input BLINK_FLAG;
input SHIFT_FLAG;

output [31:0] PRDATA;

input LCDCLK;
output LCD_RS;
output LCD_RW;
output LCD_EN;
output [7:0] LCD_DATA;

output [7:0] SEGOUT;
output [7:0] SEGCOM;
output [7:0] LED_OUT;

reg [31:0] reg_a;
reg [31:0] reg_b;
reg [31:0] reg_c;
reg [31:0] reg_d;
reg [31:0] reg_e;
reg [31:0] reg_f;
reg [31:0] reg_g;
reg [31:0] reg_h;
reg [31:0] reg_i;
reg [31:0] reg_j;
reg [31:0] RDATA;
reg [31:0] NextPRData;

wire [255:0]	text_lcd_input;
//reg [255:0] text_data = 256'h30333431313738204A6F20556A696E20_3034343033323120204B696D5375686E;
                 
reg shift;
reg blink;



reg [255:0] data;
reg [255:0] data_tmp;

assign PRDATA = RDATA;  

assign LED_OUT = reg_j[7:0];

always @(posedge PCLK or negedge PRESETn)
begin
	if (~PRESETn) 
	begin
        data <= {`LCD_2, 	`LCD_0, 	`LCD_0, 		`LCD_9,
				`LCD_1,  `LCD_4, 	`LCD_2, 		`LCD_1	 ,
				`LCD_2, 	`LCD_7,`LCD_BLANK,	`LCD_BLANK	,
				`LCD_BLANK, 	`LCD_BLANK, 	`LCD_BLANK, 	`LCD_BLANK	,
				`LCD_2, 	`LCD_0, 	`LCD_1, 	`LCD_0	,
				`LCD_1, `LCD_4, `LCD_7, 	`LCD_0	,
				`LCD_0, `LCD_6, `LCD_BLANK, `LCD_BLANK	,
				`LCD_BLANK, `LCD_BLANK, 	`LCD_BLANK, 	`LCD_BLANK};

        reg_i <= 32'h00000000; 
        reg_j <= 32'h00000081;
	end 
	else
	begin
	    if (PSEL & PWRITE & PENABLE)
	    begin
	    	case (PADDR[7:0])
				8'h00 : reg_a <= PWDATA;
				8'h04 : reg_b <= PWDATA;
				8'h08 : reg_c <= PWDATA;
				8'h0C : reg_d <= PWDATA;
				8'h10 : reg_e <= PWDATA;
				8'h14 : reg_f <= PWDATA;
				8'h18 : reg_g <= PWDATA;
				8'h1C : reg_h <= PWDATA;
				8'h20 : reg_i <= PWDATA;
				8'h24 : reg_j <= PWDATA;
			endcase
		end
	end
end

reg[11:0] cnt;
reg[3:0] data_sel;
reg[11:0] lcd_cnt;

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

always @(posedge LCDCLK or negedge PRESETn) begin
	if (~PRESETn) begin
		lcd_cnt <= 0;
	end
	else if (cnt == 2000) begin
		if (lcd_cnt == `interval) begin
			lcd_cnt <= 0;
		end
		else begin
			lcd_cnt <= lcd_cnt + 1;
		end
	end
end

reg is_on;

always @(posedge LCDCLK or negedge PRESETn) begin
	if (~PRESETn) begin
		shift <= SHIFT_FLAG;
      blink <= BLINK_FLAG;
		is_on <= 1;
		data_tmp <= 0;
	end
	else if (shift) begin
		if (lcd_cnt == `interval && cnt == 2000) begin
			data <= {data[247:0],data[255:248]};
		end
	end
	else if (blink) begin
		if (lcd_cnt == `interval && cnt == 2000) begin
			if (is_on) begin
				data_tmp <= data;
				data <= {`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,
					`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,
					`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,
					`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,
					`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,
					`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,
					`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,
					`LCD_BLANK,`LCD_BLANK,`LCD_BLANK,`LCD_BLANK};	
				is_on <= ~is_on;
			end
			else begin
			    if (data_tmp == 0) begin
			        data_tmp <= data;
			    end
			    else begin
			        data <= data_tmp;
			    end		
			    is_on <= ~is_on;
			end
			
		end
	end
end

always @(posedge PCLK or negedge PRESETn)
begin
  if (~PRESETn)
    RDATA <= 32'h00000000;
  else
    RDATA  <= NextPRData;
end

//Read registers
always @(PADDR or PSEL or PWRITE or reg_a or reg_b or reg_c or reg_d or reg_e or reg_f or reg_g or reg_h or reg_i)
begin
  NextPRData <= 32'h00000000;
  if (PSEL & (~PWRITE))
    case (PADDR[7:0])
		8'h00 : NextPRData <= reg_a;
		8'h04 : NextPRData <= reg_b;
		8'h08 : NextPRData <= reg_c;
		8'h0C : NextPRData <= reg_d;
		8'h10 : NextPRData <= reg_e;
		8'h14 : NextPRData <= reg_f;
		8'h18 : NextPRData <= reg_g;
		8'h1C : NextPRData <= reg_h;
		8'h20 : NextPRData <= reg_i; 
		8'h24 : NextPRData <= reg_j;
		default	: NextPRData <= 32'hFFFFFFFF;
    endcase
end



text_lcd utext_lcd(
					.LCDCLK(LCDCLK),
					.PRESETn(PRESETn),
					.data(data),
					.LCD_RS(LCD_RS),
					.LCD_RW(LCD_RW),
					.LCD_EN(LCD_EN),
					.LCD_DATA(LCD_DATA)
					);
endmodule

