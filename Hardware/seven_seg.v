module seven_seg(
    clk,
    data,
	SEGOUT,
	SEGCOM
 );

input  clk;
input  [31:0] data;
output [7:0] SEGOUT;
output [7:0] SEGCOM;

wire [7:0] seg1;
wire [7:0] seg2;
wire [7:0] seg3;
wire [7:0] seg4;
wire [7:0] seg5;
wire [7:0] seg6;
wire [7:0] seg7;
wire [7:0] seg8;

bin2seg bin2seg_1(.bin_data(data[31:28]), .seg_data(seg1));
bin2seg bin2seg_2(.bin_data(data[27:24]), .seg_data(seg2));
bin2seg bin2seg_3(.bin_data(data[23:20]), .seg_data(seg3));
bin2seg bin2seg_4(.bin_data(data[19:16]), .seg_data(seg4));
bin2seg bin2seg_5(.bin_data(data[15:12]), .seg_data(seg5));
bin2seg bin2seg_6(.bin_data(data[11: 8]), .seg_data(seg6));               
bin2seg bin2seg_7(.bin_data(data[ 7: 4]), .seg_data(seg7));
bin2seg bin2seg_8(.bin_data(data[ 3: 0]), .seg_data(seg8));
	
	
	
reg [15:0] clk_cnt = 16'h0000;
reg [2:0] com_cnt = 3'b000;
	
	always @(posedge clk)
	begin
	     if (clk_cnt == 4000)
	     begin
	        clk_cnt <= 16'h0000;
	        if (com_cnt == 3'h7)
	        	com_cnt <= 3'h0;
	        else
	        	com_cnt <= com_cnt + 1;
	     end
	     else 
	        clk_cnt <= clk_cnt + 1;
	end
	
	assign SEGCOM = (com_cnt == 0) ? 8'b10000000 :
					(com_cnt == 1) ? 8'b01000000 :
					(com_cnt == 2) ? 8'b00100000 :
					(com_cnt == 3) ? 8'b00010000 :
					(com_cnt == 4) ? 8'b00001000 :
					(com_cnt == 5) ? 8'b00000100 :
					(com_cnt == 6) ? 8'b00000010 : 8'b00000001;

	assign SEGOUT = (com_cnt == 0) ? ~seg1 :
					(com_cnt == 1) ? ~seg2 :
					(com_cnt == 2) ? ~seg3 :
					(com_cnt == 3) ? ~seg4 :
					(com_cnt == 4) ? ~seg5 :
					(com_cnt == 5) ? ~seg6 :
					(com_cnt == 6) ? ~seg7 : ~seg8 ;
					 
endmodule

     


module bin2seg(bin_data, seg_data);

input   [3:0]    bin_data;
output  [7:0]    seg_data;

wire  [3:0]    bin_data;
wire  [7:0]    seg_data;


assign seg_data = (bin_data==0)? 8'b11111100:
				  (bin_data==1)? 8'b01100000:
				  (bin_data==2)? 8'b11011010:
				  (bin_data==3)? 8'b11110010:
				  (bin_data==4)? 8'b01100110:
				  (bin_data==5)? 8'b10110110:
				  (bin_data==6)? 8'b10111110:
				  (bin_data==7)? 8'b11100100:
				  (bin_data==8)? 8'b11111110: 8'b11110110;

endmodule
      



                   
