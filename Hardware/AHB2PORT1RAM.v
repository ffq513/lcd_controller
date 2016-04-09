//--  ---------------------------------------------------------------------------
//--    This confidential and proprietary software may be used only as
//--    authorised by a licensing agreement from ARM Limited
//--      (C) COPYRIGHT 2005 ARM Limited
//--          ALL RIGHTS RESERVED
//--    The entire notice above must be reproduced on all authorised
//--    copies and copies may only be made to the extent permitted
//--    by a licensing agreement from ARM Limited.
//--  ---------------------------------------------------------------------------
//--  
//--    Version and Release Control Information:
//--  
//--    File Name              : AHB2PORT1RAM.v
//--    File Revision          : 1.0
//--  
//--    Release Information    : 
//--  
//--  ----------------------------------------------------------------------------
//--  ----------------------------------------------------------------------------
//--   Purpose : AHB Xilinx Block SRAM controller
//--  ----------------------------------------------------------------------------

`timescale 1 ns / 1 ps

module AHB2PORT1RAM (
  HRESETn,
  BIGEND,
  PORT1HCLK,
  PORT1HSEL,
  PORT1HREADYIN,
  PORT1HTRANS,
  PORT1HSIZE,
  PORT1HWRITE,
  PORT1HWDATA,
  PORT1HRDATA,
  PORT1HADDR,
  PORT1HREADYOUT,
  PORT1HRESP,
  PORT2HCLK,
  port2addr,
  port2di,
  port2we,
  port2cs,
  port2bwe,
  port2do
);

// inputs and outputs
input         HRESETn;
input         BIGEND;

input         PORT1HCLK;
input         PORT1HSEL;
input         PORT1HREADYIN;
input   [1:0] PORT1HTRANS;
input   [1:0] PORT1HSIZE;
input         PORT1HWRITE;
input  [31:0] PORT1HWDATA;
input  [31:0] PORT1HADDR;


output [31:0] PORT1HRDATA;
output        PORT1HREADYOUT;
output  [1:0] PORT1HRESP;


input         PORT2HCLK;
input  [31:0] port2di;
input  [31:0] port2addr;
input   port2cs;
input port2we;
input [3:0] port2bwe;
output [31:0] port2do;

// -----------------------------------------------------------------------------
// Signal declaration

wire        HRESETn;

wire  [2:1] REQ;

reg   [1:0] PORT1HSIZEREG;
reg         PORT1HWRITEREG;
reg         PORT1HWRITEOLD;
reg         PORt1HREADYOLD;
reg  [31:0] PORT1HADDRREG;
reg   [1:0] PORT1HTRANSREG;
reg         PORT1HSELREG;

reg         P1HWRITEMUX;
wire [31:0] P1HADDRMUX; 

//


// -----------------------------------------------------------------------------
// start of main code  
     
//  register hsize,hwrite and haddr to create data phase signals PORT 1
always @ (posedge PORT1HCLK or negedge HRESETn)
begin 
  if (!HRESETn)
    begin 
      PORT1HSIZEREG    <= 2'b10;
      PORT1HWRITEREG   <= 1'b0 ;
      PORT1HADDRREG    <= 32'h00000000;
      PORT1HSELREG     <= 1'b0;
      PORT1HTRANSREG   <= 2'b00;
      PORT1HWRITEOLD   <= 1'b0;
      P1HWRITEMUX      <= 1'b0;
    end else begin
      PORT1HWRITEOLD   <= (PORT1HWRITE & PORT1HSEL & PORT1HTRANS[1]);
      P1HWRITEMUX      <= (PORT1HWRITE & PORT1HSEL & PORT1HTRANS[1] & PORT1HREADYIN);
      if (PORT1HREADYIN)
        begin
          PORT1HSIZEREG    <= PORT1HSIZE;
          PORT1HWRITEREG   <= PORT1HWRITE;
          PORT1HADDRREG    <= PORT1HADDR;
          PORT1HSELREG     <= PORT1HSEL;
          PORT1HTRANSREG   <= PORT1HTRANS;
        end 
    end 
end // always



//Only write to BRAM in Write data phase
//assign P1HWRITEMUX   = PORT1HWRITEOLD & PORT1HREADYIN;


//Delayed in Write Data Phase, else straight through
assign P1HADDRMUX    = P1HWRITEMUX ? PORT1HADDRREG : PORT1HADDR;


// CS on write data phase or read addr phase
assign REQ[1] = (PORT1HTRANSREG[1] & PORT1HWRITEREG & PORT1HSELREG) | (PORT1HTRANS[1] & ~PORT1HWRITE & PORT1HSEL);


// -----------------------------------------------------------------------------
// multiplexing hsize and hwrite and haddr and hwdata
assign PORT1HRESP     = 2'b00;


// Hready needs to be held off if a write was previously committed to DPRAM and
// now a read to DPRAM is required as the address/control phase will overlap.
assign PORT1HREADYOUT = ~(~PORT1HWRITE & PORT1HWRITEOLD & PORT1HTRANS[1]);


reg   [1:0] HADDR1Masked;  // Uses size and BIGEND

wire  [3:0] BWE1;

    
// Byte lane decoding for ssram    
// ----------------------------
// memory byte lane enables are decoded from transfer size, A1, A0 & endianness.

// Change the address so that :
// - The two bottom bits are inverted in BIGEND mode

always @ (P1HADDRMUX or BIGEND)
begin
  HADDR1Masked[1:0]   = PORT1HADDRREG[1:0] ^ {BIGEND, BIGEND};
end

// Decode byte write enables
// Only relevant for writes hence done in write data phase
assign BWE1[0] = (PORT1HSIZEREG == 2'b10) || 
  ((PORT1HSIZEREG == 2'b01) && !HADDR1Masked[1]) || 
  ((PORT1HSIZEREG == 2'b00 ) && (HADDR1Masked[1:0] == 2'b00));

assign BWE1[1] = (PORT1HSIZEREG == 2'b10) || 
  ((PORT1HSIZEREG == 2'b01) && !HADDR1Masked[1]) || 
  ((PORT1HSIZEREG == 2'b00 ) && (HADDR1Masked[1:0] == 2'b01));

assign BWE1[2] = (PORT1HSIZEREG == 2'b10) || 
  ((PORT1HSIZEREG == 2'b01) && HADDR1Masked[1]) || 
  ((PORT1HSIZEREG == 2'b00 ) && (HADDR1Masked[1:0] == 2'b10));

assign BWE1[3] = (PORT1HSIZEREG == 2'b10) || 
  ((PORT1HSIZEREG == 2'b01) && HADDR1Masked[1]) || 
  ((PORT1HSIZEREG == 2'b00 ) && (HADDR1Masked[1:0] == 2'b11));



BRAMs uBRAM1(
  // Inputs
  .CLKA   (PORT1HCLK),
  .CLKB   (PORT2HCLK),
  .CSA    (REQ[1]),
  .CSB    (port2cs),
  .ADDRA  (P1HADDRMUX[17:2]),
  .ADDRB  (port2addr),
  .DIA    (PORT1HWDATA),
  .DIB    (port2di),
  .WEA    (P1HWRITEMUX),
  .WEB    (port2we),
  .BWA    (BWE1),
  .BWB    (port2bwe), 
  // Outputs
  .DOA    (PORT1HRDATA),
  .DOB    (port2do)
);


endmodule
