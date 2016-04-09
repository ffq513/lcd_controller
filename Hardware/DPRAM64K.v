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
//--    File Name              : DPRAM64K.v
//--    File Revision          : 1.0
//--  
//--    Release Information    : 
//--  
//--  ----------------------------------------------------------------------------
//--  ----------------------------------------------------------------------------
//--   Purpose : Dual Port RAM for a 64k I/D Bus. 
//--             Since there are 16 blocks, this is a 8192 
//--             words of 32 bits. Implements Xilinx RAM
//--  ----------------------------------------------------------------------------

`timescale 1ns/1ns

module DPRAM64K (
  // Outputs
  DOA, DOB,
  // Inputs
  CLKA, CLKB, ADDRA, ADDRB, DIA, DIB, CEA, CEB, WEA, WEB
);

output [31:0]  DOA;	// Read data from PORT A
output [31:0]  DOB;	// Read data from PORT B
input 	 CLKA;	// Clock for PORT A
input 	 CLKB;	// Clock for PORT B
input 	 CEA;	// Chip enable for PORT A
input 	 CEB;	// Chip enable for PORT B
input [3:0] 	 WEA;	// Write enable for PORT A
input [3:0] 	 WEB;	// Write enable for PORT B
input [12:0] 	 ADDRA;	// Address for PORT A
input [12:0] 	 ADDRB;	// Address for PORT B
input [31:0] 	 DIA;	// Write data for PORT A
input [31:0] 	 DIB;	// Write data for PORT B

wire [31:0]    DOA;
wire [31:0]    DOB;

// Note that the INIT values set up the code to be initialized in memory at startup.

RAMB16_S2_S2 BlockRam00 (
  .DOA		(DOA[1:0]),
  .CLKA		(CLKA),
  .WEA		(WEA[0]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[1:0]),
   // PORT B
  .DOB		(DOB[1:0]),
  .CLKB		(CLKB),
  .WEB		(WEB[0]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[1:0])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E4000500AAAA"*/
;
//synthesis translate_off 
defparam BlockRam00.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E4000500AAAA;
//synthesis translate_on

RAMB16_S2_S2 BlockRam01 (
  .DOA		(DOA[3:2]),
  .CLKA		(CLKA),
  .WEA		(WEA[0]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[3:2]),
   // PORT B
  .DOB		(DOB[3:2]),
  .CLKB		(CLKB),
  .WEB		(WEB[0]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[3:2])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E4300020FFFD"*/
;
//synthesis translate_off 
defparam BlockRam01.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E4300020FFFD;
//synthesis translate_on

RAMB16_S2_S2 BlockRam02 (
  .DOA		(DOA[5:4]),
  .CLKA		(CLKA),
  .WEA		(WEA[0]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[5:4]),
   // PORT B
  .DOB		(DOB[5:4]),
  .CLKB		(CLKB),
  .WEB		(WEB[0]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[5:4])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E4C00010FFFC"*/
;
//synthesis translate_off 
defparam BlockRam02.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E4C00010FFFC;
//synthesis translate_on

RAMB16_S2_S2 BlockRam03 (
  .DOA		(DOA[7:6]),
  .CLKA		(CLKA),
  .WEA		(WEA[0]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[7:6]),
   // PORT B
  .DOB		(DOB[7:6]),
  .CLKB		(CLKB),
  .WEB		(WEB[0]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[7:6])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E4001004FFFC"*/
;
//synthesis translate_off 
defparam BlockRam03.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E4001004FFFC;
//synthesis translate_on
  
RAMB16_S2_S2 BlockRam10 (
  .DOA		(DOA[9:8]),
  .CLKA		(CLKA),
  .WEA		(WEA[1]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[9:8]),
   // PORT B
  .DOB		(DOB[9:8]),
  .CLKB		(CLKB),
  .WEB		(WEB[1]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[9:8])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E400100CFFFC"*/
;
//synthesis translate_off 
defparam BlockRam10.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E400100CFFFC;
//synthesis translate_on

RAMB16_S2_S2 BlockRam11 (
  .DOA		(DOA[11:10]),
  .CLKA		(CLKA),
  .WEA		(WEA[1]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[11:10]),
   // PORT B
  .DOB		(DOB[11:10]),
  .CLKB		(CLKB),
  .WEB		(WEB[1]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[11:10])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E4001008FFFC"*/
;
//synthesis translate_off 
defparam BlockRam11.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E4001008FFFC;
//synthesis translate_on

RAMB16_S2_S2 BlockRam12 (
  .DOA		(DOA[13:12]),
  .CLKA		(CLKA),
  .WEA		(WEA[1]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[13:12]),
   // PORT B
  .DOB		(DOB[13:12]),
  .CLKB		(CLKB),
  .WEB		(WEB[1]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[13:12])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E40CF0E4FFFC"*/
;
//synthesis translate_off 
defparam BlockRam12.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E40CF0E4FFFC;
//synthesis translate_on

RAMB16_S2_S2 BlockRam13 (
  .DOA		(DOA[15:14]),
  .CLKA		(CLKA),
  .WEA		(WEA[1]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[15:14]),
   // PORT B
  .DOB		(DOB[15:14]),
  .CLKB		(CLKB),
  .WEB		(WEB[1]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[15:14])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E40C0000FFFC"*/
;
//synthesis translate_off 
defparam BlockRam13.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E40C0000FFFC;
//synthesis translate_on

RAMB16_S2_S2 BlockRam20 (
  .DOA		(DOA[17:16]),
  .CLKA		(CLKA),
  .WEA		(WEA[2]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[17:16]),
   // PORT B
  .DOB		(DOB[17:16]),
  .CLKB		(CLKB),
  .WEB		(WEB[2]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[17:16])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E40CB0B0FFFC"*/
;
//synthesis translate_off 
defparam BlockRam20.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E40CB0B0FFFC;
//synthesis translate_on

RAMB16_S2_S2 BlockRam21 (
  .DOA		(DOA[19:18]),
  .CLKA		(CLKA),
  .WEA		(WEA[2]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[19:18]),
   // PORT B
  .DOB		(DOB[19:18]),
  .CLKB		(CLKB),
  .WEB		(WEB[2]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[19:18])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E40C0030FFFC"*/
;
//synthesis translate_off 
defparam BlockRam21.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E40C0030FFFC;
//synthesis translate_on

RAMB16_S2_S2 BlockRam22 (
  .DOA		(DOA[21:20]),
  .CLKA		(CLKA),
  .WEA		(WEA[2]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[21:20]),
   // PORT B
  .DOB		(DOB[21:20]),
  .CLKB		(CLKB),
  .WEB		(WEB[2]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[21:20])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E406045AFFFC"*/
;
//synthesis translate_off 
defparam BlockRam22.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E406045AFFFC;
//synthesis translate_on

RAMB16_S2_S2 BlockRam23 (
  .DOA		(DOA[23:22]),
  .CLKA		(CLKA),
  .WEA		(WEA[2]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[23:22]),
   // PORT B
  .DOB		(DOB[23:22]),
  .CLKB		(CLKB),
  .WEB		(WEB[2]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[23:22])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E41AA6AAFFFC"*/
;
//synthesis translate_off 
defparam BlockRam23.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E41AA6AAFFFC;
//synthesis translate_on

RAMB16_S2_S2 BlockRam30 (
  .DOA		(DOA[25:24]),
  .CLKA		(CLKA),
  .WEA		(WEA[3]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[25:24]),
   // PORT B
  .DOB		(DOB[25:24]),
  .CLKB		(CLKB),
  .WEB		(WEB[3]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[25:24])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E407665FAAAA"*/
;
//synthesis translate_off 
defparam BlockRam30.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E407665FAAAA;
//synthesis translate_on

RAMB16_S2_S2 BlockRam31 (
  .DOA		(DOA[27:26]),
  .CLKA		(CLKA),
  .WEA		(WEA[3]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[27:26]),
   // PORT B
  .DOB		(DOB[27:26]),
  .CLKB		(CLKB),
  .WEB		(WEB[3]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[27:26])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E4044050AAAA"*/
;
//synthesis translate_off 
defparam BlockRam31.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E4044050AAAA;
//synthesis translate_on

RAMB16_S2_S2 BlockRam32 (
  .DOA		(DOA[29:28]),
  .CLKA		(CLKA),
  .WEA		(WEA[3]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[29:28]),
   // PORT B
  .DOB		(DOB[29:28]),
  .CLKB		(CLKB),
  .WEB		(WEB[3]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[29:28])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E4180AAAAAAA"*/
;
//synthesis translate_off 
defparam BlockRam32.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E4180AAAAAAA;
//synthesis translate_on

RAMB16_S2_S2 BlockRam33 (
  .DOA		(DOA[31:30]),
  .CLKA		(CLKA),
  .WEA		(WEA[3]),
  .ENA		(CEA),
  .SSRA     (1'b0),
  .ADDRA	(ADDRA[12:0]),
  .DIA		(DIA[31:30]),
   // PORT B
  .DOB		(DOB[31:30]),
  .CLKB		(CLKB),
  .WEB		(WEB[3]),
  .ENB		(CEB),
  .SSRB     (1'b0),
  .ADDRB	(ADDRB[12:0]),
  .DIB		(DIB[31:30])
)
/*synthesis xc_props = "INIT_00=256'h0000000000000000000000000000000000000000000000000000E40C0FFFFFFF"*/
;
//synthesis translate_off 
defparam BlockRam33.INIT_00 = 256'h0000000000000000000000000000000000000000000000000000E40C0FFFFFFF;
//synthesis translate_on

endmodule // DPRAM64k
