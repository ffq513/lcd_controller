//--  ---------------------------------------------------------------------------
//--    This confidential and proprietary software may be used only as
//--    authorised by a licensing agreement from ARM Limited
//--      (C) COPYRIGHT 2003-2005 ARM Limited
//--          ALL RIGHTS RESERVED
//--    The entire notice above must be reproduced on all authorised
//--    copies and copies may only be made to the extent permitted
//--    by a licensing agreement from ARM Limited.
//--  ---------------------------------------------------------------------------
//--  
//--    Version and Release Control Information:
//--  
//--    File Name              : BRAMS.v
//--    File Revision          : 1.0
//--  
//--    Release Information    : 
//--  
//--  ----------------------------------------------------------------------------
//--  ----------------------------------------------------------------------------
//--   Purpose : This block calls 8 blocks, each of 8kbyte*32 wide memory blocks
//               This makes 256KBytes
//--  ----------------------------------------------------------------------------

`timescale 1ns/1ns

module BRAMs (/*AUTOARG*/
  // Inputs
  CLKA, CLKB, CSA, CSB, ADDRA, ADDRB, DIA, DIB, WEA, WEB, BWA, BWB, 
  // Outputs
  DOA, DOB
);

parameter ADR_WIDTH  = 16;
parameter DATA_WIDTH = 32;

input                       CLKA;   // Clock input    
input                       CLKB;   // Clock input    
input                       CSA;    // RAM enable (select)
input                       CSB;    // RAM enable (select)
input  [ADR_WIDTH-1:0]      ADDRA;  // Address input
input  [ADR_WIDTH-1:0]      ADDRB;  // Address input
input  [DATA_WIDTH-1:0]     DIA;    // Data input
input  [DATA_WIDTH-1:0]     DIB;    // Data input
input                       WEA;    // Write enable
input                       WEB;    // Write enable
input  [3:0]                BWA;    // Byte write
input  [3:0]                BWB;    // Byte write
output [DATA_WIDTH-1:0]     DOA;    // Data output
output [DATA_WIDTH-1:0]     DOB;    // Data output

wire [7:0] iCSA;
wire [7:0] iCSB;
wire [3:0] iBWA;
wire [3:0] iBWB;

reg [7:0]  BankRegA;
reg [7:0]  BankRegB;

wire [DATA_WIDTH-1:0]     DOA0;   // Data output
wire [DATA_WIDTH-1:0]     DOA1;   // Data output
wire [DATA_WIDTH-1:0]     DOA2;   // Data output
wire [DATA_WIDTH-1:0]     DOA3;   // Data output
wire [DATA_WIDTH-1:0]     DOA4;   // Data output
wire [DATA_WIDTH-1:0]     DOA5;   // Data output
wire [DATA_WIDTH-1:0]     DOA6;   // Data output
wire [DATA_WIDTH-1:0]     DOA7;   // Data output

wire [DATA_WIDTH-1:0]     DOB0;   // Data output
wire [DATA_WIDTH-1:0]     DOB1;   // Data output
wire [DATA_WIDTH-1:0]     DOB2;   // Data output
wire [DATA_WIDTH-1:0]     DOB3;   // Data output
wire [DATA_WIDTH-1:0]     DOB4;   // Data output
wire [DATA_WIDTH-1:0]     DOB5;   // Data output
wire [DATA_WIDTH-1:0]     DOB6;   // Data output
wire [DATA_WIDTH-1:0]     DOB7;   // Data output

wire [DATA_WIDTH-1:0]     DOA0M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOA1M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOA2M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOA3M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOA4M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOA5M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOA6M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOA7M;   // Masked Data output

wire [DATA_WIDTH-1:0]     DOB0M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOB1M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOB2M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOB3M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOB4M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOB5M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOB6M;   // Masked Data output
wire [DATA_WIDTH-1:0]     DOB7M;   // Masked Data output

assign      iBWA = BWA & {4{WEA}};
assign      iBWB = BWB & {4{WEB}};

assign iCSA [0] = (ADDRA[15:13] == 3'b000) & CSA;
assign iCSA [1] = (ADDRA[15:13] == 3'b001) & CSA;
assign iCSA [2] = (ADDRA[15:13] == 3'b010) & CSA;
assign iCSA [3] = (ADDRA[15:13] == 3'b011) & CSA;

assign iCSA [4] = (ADDRA[15:13] == 3'b100) & CSA;
assign iCSA [5] = (ADDRA[15:13] == 3'b101) & CSA;
assign iCSA [6] = (ADDRA[15:13] == 3'b110) & CSA;
assign iCSA [7] = (ADDRA[15:13] == 3'b111) & CSA;

assign iCSB [0] = (ADDRB[15:13] == 3'b000) & CSB;
assign iCSB [1] = (ADDRB[15:13] == 3'b001) & CSB;
assign iCSB [2] = (ADDRB[15:13] == 3'b010) & CSB;
assign iCSB [3] = (ADDRB[15:13] == 3'b011) & CSB;

assign iCSB [4] = (ADDRB[15:13] == 3'b100) & CSB;
assign iCSB [5] = (ADDRB[15:13] == 3'b101) & CSB;
assign iCSB [6] = (ADDRB[15:13] == 3'b110) & CSB;
assign iCSB [7] = (ADDRB[15:13] == 3'b111) & CSB;

DPRAM64K uBlockRAM0(/*AUTOINST*/
                    // Outputs
                    .DOA              (DOA0[31:0]),
                    .DOB              (DOB0[31:0]),
                    // Inputs
                    .CLKA             (CLKA),
                    .CLKB             (CLKB),
                    .CEA              (iCSA[0]),
                    .CEB              (iCSB[0]),
                    .WEA              (iBWA[3:0]),
                    .WEB              (iBWB[3:0]),
                    .ADDRA            (ADDRA[12:0]),
                    .ADDRB            (ADDRB[12:0]),
                    .DIA              (DIA[31:0]),
                    .DIB              (DIB[31:0])
                    );

DPRAM64K uBlockRAM1(/*AUTOINST*/
                    // Outputs
                    .DOA              (DOA1[31:0]),
                    .DOB              (DOB1[31:0]),
                    // Inputs
                    .CLKA             (CLKA),
                    .CLKB             (CLKB),
                    .CEA              (iCSA[1]),
                    .CEB              (iCSB[1]),
                    .WEA              (iBWA[3:0]),
                    .WEB              (iBWB[3:0]),
                    .ADDRA            (ADDRA[12:0]),
                    .ADDRB            (ADDRB[12:0]),
                    .DIA              (DIA[31:0]),
                    .DIB              (DIB[31:0])
                    );

DPRAM64K uBlockRAM2(/*AUTOINST*/
                    // Outputs
                    .DOA              (DOA2[31:0]),
                    .DOB              (DOB2[31:0]),
                    // Inputs
                    .CLKA             (CLKA),
                    .CLKB             (CLKB),
                    .CEA              (iCSA[2]),
                    .CEB              (iCSB[2]),
                    .WEA              (iBWA[3:0]),
                    .WEB              (iBWB[3:0]),
                    .ADDRA            (ADDRA[12:0]),
                    .ADDRB            (ADDRB[12:0]),
                    .DIA              (DIA[31:0]),
                    .DIB              (DIB[31:0])
                    );

DPRAM64K uBlockRAM3(/*AUTOINST*/
                    // Outputs
                    .DOA              (DOA3[31:0]),
                    .DOB              (DOB3[31:0]),
                    // Inputs
                    .CLKA             (CLKA),
                    .CLKB             (CLKB),
                    .CEA              (iCSA[3]),
                    .CEB              (iCSB[3]),
                    .WEA              (iBWA[3:0]),
                    .WEB              (iBWB[3:0]),
                    .ADDRA            (ADDRA[12:0]),
                    .ADDRB            (ADDRB[12:0]),
                    .DIA              (DIA[31:0]),
                    .DIB              (DIB[31:0])
                    );

DPRAM64K uBlockRAM4(/*AUTOINST*/
                    // Outputs
                    .DOA              (DOA4[31:0]),
                    .DOB              (DOB4[31:0]),
                    // Inputs
                    .CLKA             (CLKA),
                    .CLKB             (CLKB),
                    .CEA              (iCSA[4]),
                    .CEB              (iCSB[4]),
                    .WEA              (iBWA[3:0]),
                    .WEB              (iBWB[3:0]),
                    .ADDRA            (ADDRA[12:0]),
                    .ADDRB            (ADDRB[12:0]),
                    .DIA              (DIA[31:0]),
                    .DIB              (DIB[31:0])
                    );

DPRAM64K uBlockRAM5(/*AUTOINST*/
                    // Outputs
                    .DOA              (DOA5[31:0]),
                    .DOB              (DOB5[31:0]),
                    // Inputs
                    .CLKA             (CLKA),
                    .CLKB             (CLKB),
                    .CEA              (iCSA[5]),
                    .CEB              (iCSB[5]),
                    .WEA              (iBWA[3:0]),
                    .WEB              (iBWB[3:0]),
                    .ADDRA            (ADDRA[12:0]),
                    .ADDRB            (ADDRB[12:0]),
                    .DIA              (DIA[31:0]),
                    .DIB              (DIB[31:0])
                    );

DPRAM64K uBlockRAM6(/*AUTOINST*/
                    // Outputs
                    .DOA              (DOA6[31:0]),
                    .DOB              (DOB6[31:0]),
                    // Inputs
                    .CLKA             (CLKA),
                    .CLKB             (CLKB),
                    .CEA              (iCSA[6]),
                    .CEB              (iCSB[6]),
                    .WEA              (iBWA[3:0]),
                    .WEB              (iBWB[3:0]),
                    .ADDRA            (ADDRA[12:0]),
                    .ADDRB            (ADDRB[12:0]),
                    .DIA              (DIA[31:0]),
                    .DIB              (DIB[31:0])
                    );

DPRAM64K uBlockRAM7(/*AUTOINST*/
                    // Outputs
                    .DOA              (DOA7[31:0]),
                    .DOB              (DOB7[31:0]),
                    // Inputs
                    .CLKA             (CLKA),
                    .CLKB             (CLKB),
                    .CEA              (iCSA[7]),
                    .CEB              (iCSB[7]),
                    .WEA              (iBWA[3:0]),
                    .WEB              (iBWB[3:0]),
                    .ADDRA            (ADDRA[12:0]),
                    .ADDRB            (ADDRB[12:0]),
                    .DIA              (DIA[31:0]),
                    .DIB              (DIB[31:0])
                    );




//assign DOA3 = 32'hBAD0BAD0;
//assign DOB3 = 32'hBAD0BAD0;

always @(posedge CLKA)
begin
  BankRegA <= iCSA;
end

always @(posedge CLKB)
begin
  BankRegB <= iCSB;
end
  
assign DOA0M = BankRegA[0] ? DOA0 : 0;
assign DOA1M = BankRegA[1] ? DOA1 : 0;
assign DOA2M = BankRegA[2] ? DOA2 : 0;
assign DOA3M = BankRegA[3] ? DOA3 : 0;
assign DOA4M = BankRegA[4] ? DOA4 : 0;
assign DOA5M = BankRegA[5] ? DOA5 : 0;
assign DOA6M = BankRegA[6] ? DOA6 : 0;
assign DOA7M = BankRegA[7] ? DOA7 : 0;

assign DOA = DOA0M | DOA1M | DOA2M | DOA3M | DOA4M | DOA5M | DOA6M | DOA7M;

assign DOB0M = BankRegB[0] ? DOB0 : 0;
assign DOB1M = BankRegB[1] ? DOB1 : 0;
assign DOB2M = BankRegB[2] ? DOB2 : 0;
assign DOB3M = BankRegB[3] ? DOB3 : 0;
assign DOB4M = BankRegB[4] ? DOB4 : 0;
assign DOB5M = BankRegB[5] ? DOB5 : 0;
assign DOB6M = BankRegB[6] ? DOB6 : 0;
assign DOB7M = BankRegB[7] ? DOB7 : 0;

assign DOB = DOB0M | DOB1M | DOB2M | DOB3M | DOB4M | DOB5M | DOB6M | DOB7M;
  
endmodule // BlockRAMs
