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
//--    File Name              : serialstream.v
//--    File Revision          : 1.0
//--  
//--    Release Information    : 
//--  
//--  ----------------------------------------------------------------------------
//--  ----------------------------------------------------------------------------
//--   Purpose : Serial stream for FPGA side of CT-GTC PLD configuration
//--             Implementation: XC2v6000
//--  ----------------------------------------------------------------------------
`define TERMVAL    5'b11000 //Divide by 24 *2 to get 500kHz

module serialstream(
  //Serial stream to/from PLD
  PLDCLK,
  PLDRESETn,
  PLDI,
  PLDO,
  //Global reset
  nSYSRST,
  nSYSPOR,
  CLK_24MHZ_FPGA,
  SYNC,
  //Statics
  CLKSEL,
  PWR_nSHDN,
  ZCTL,
  MAN_ID,
  PLD_ID,
  PGOOD,
  DMEMSIZE,
  IMEMSIZE,
  //DACs
  DAC_DINA,
  DAC_DINB,
  DAC_DINC,
  //ADC
  ADCSEL,
  ADC_DOUTA,
  ADC_DOUTB
);

//Serial stream to/from PLD
output PLDCLK;
output PLDRESETn;
output PLDI;
input  PLDO;
//Global reset
input  nSYSRST;
input  nSYSPOR;
input  CLK_24MHZ_FPGA;
output SYNC;
//Statics
input   [5:0] CLKSEL;
input   [2:0] PWR_nSHDN;
input   [3:0] ZCTL;
output  [3:0] MAN_ID;
output  [3:0] PLD_ID;
output        PGOOD;
input   [2:0] DMEMSIZE;
input   [2:0] IMEMSIZE;
//DACs
input   [7:0] DAC_DINA;
input   [7:0] DAC_DINB;
input   [7:0] DAC_DINC;    
//ADC
output  [2:0] ADCSEL;
output [11:0] ADC_DOUTA;
output [11:0] ADC_DOUTB;

reg  [4:0] CNT;

reg  [5:0] STAT;

reg  iPLDCLK;

wire iPLDRESETn;
reg  PLD_ResetFF1;
reg  PLD_ResetFF2;
reg  PLD_ResetFF3;

reg  [4:0] CLKDIV;
reg  Pulse;

//`define TERMVAL    5'b11000 //Divide by 24 *2 to get 500kHz

reg  [3:0] iMAN_ID;
reg  [3:0] iPLD_ID;
reg  iPGOOD;
wire iSYNC;
reg  [11:0] iADC_DOUTA;
reg  [11:0] iADC_DOUTB;
reg  iPLDI;
reg  [2:0] iADCSEL;

reg  [7:0] DAC_DIN;
reg  [7:0] old_DAC_DINA;
reg  [7:0] old_DAC_DINB;
reg  [7:0] old_DAC_DINC;
reg  SELA;
reg  SELB;
reg  SELC;

// Set up resets and PLD clocks for PLD serial stream domain --
//-------------------------------------------------------------

always @(posedge CLK_24MHZ_FPGA or negedge nSYSPOR)
begin
  if (~nSYSPOR) begin
    CLKDIV <= 5'b00000;
    Pulse  <= 1'b0;
  end else begin
    Pulse <= 1'b0;
    if (CLKDIV == `TERMVAL) begin
      CLKDIV <= 5'b00000;
      Pulse <= 1'b1;
    end else
      CLKDIV <= CLKDIV + 1;
  end
end

always @(posedge CLK_24MHZ_FPGA or negedge nSYSPOR)
begin
  if (~nSYSPOR)
    iPLDCLK <= 1'b0;
  else
    if (Pulse)
      iPLDCLK <= ~iPLDCLK;
end

assign PLDCLK = iPLDCLK;
 
always @(posedge iPLDCLK or negedge nSYSPOR)
// FFs are set asynchronously when but only
// cleared on the third clock edge AFTER it goes inactive
begin
  if (~nSYSPOR) begin
    PLD_ResetFF1 <= 1'b0;
    PLD_ResetFF2 <= 1'b0;
    PLD_ResetFF3 <= 1'b0;
  end else begin
    PLD_ResetFF1 <= nSYSRST;
    PLD_ResetFF2 <= PLD_ResetFF1;
    if (CNT == 5'b00000)
      PLD_ResetFF3 <= PLD_ResetFF2;
  end
end

// connect the FF to the (active low) port
assign iPLDRESETn = PLD_ResetFF3;
assign PLDRESETn = iPLDRESETn;

// Actual streaming of data (PLD -> FPGA) --
//------------------------------------------
	
always @(posedge iPLDCLK or negedge nSYSPOR)
begin
  if (~nSYSPOR) begin
  	iMAN_ID    <= 4'b0000;
  	iPLD_ID    <= 4'b0000;
    iPGOOD     <= 1'b0;
    iADC_DOUTA <= 12'h000;
    iADC_DOUTB <= 12'h000;
    STAT       <= 6'b000001;
    iADCSEL    <= 3'b000;
  end else begin
    iMAN_ID    <= iMAN_ID;
    iPLD_ID    <= iPLD_ID;
    iPGOOD     <= iPGOOD;
    iADC_DOUTA <= iADC_DOUTA;
    iADC_DOUTB <= iADC_DOUTB;
    STAT       <= STAT + 1;
    iADCSEL    <= iADCSEL;
    if (~iPLDRESETn)
      case (STAT[3:0])
        1 : ;
        2 : iMAN_ID[3] <= PLDO;
        3 : iMAN_ID[2] <= PLDO;
        4 : iMAN_ID[1] <= PLDO;
        5 : iMAN_ID[0] <= PLDO;
        6 : iPLD_ID[3] <= PLDO;
        7 : iPLD_ID[2] <= PLDO;
        8 : iPLD_ID[1] <= PLDO;
        9 : iPLD_ID[0] <= PLDO;
        default : begin
          iPGOOD     <= PLDO;
          STAT       <= 6'b000000;
        end
      endcase
    else
      case (STAT)
        0 : ;
        1, 2 : iADCSEL[2] <= PLDO;
        3, 4 : iADCSEL[1] <= PLDO;
        5, 6 : iADCSEL[0] <= PLDO;
        7, 8, 9, 10, 11, 12, 13, 14, 15, 16 : ;
        17, 18 : begin
          if (~PLDO)
            STAT <= STAT;
          else
            STAT <= STAT + 1;
          end
        19, 20 : ;
        21 : iADC_DOUTB[11] <= PLDO;
        23 : iADC_DOUTB[10] <= PLDO;
        25 : iADC_DOUTB[9] <= PLDO;
        27 : iADC_DOUTB[8] <= PLDO;
        29 : iADC_DOUTB[7] <= PLDO;
        31 : iADC_DOUTB[6] <= PLDO;
        33 : iADC_DOUTB[5] <= PLDO;
        35 : iADC_DOUTB[4] <= PLDO;
        37 : iADC_DOUTB[3] <= PLDO;
        39 : iADC_DOUTB[2] <= PLDO;
        41 : iADC_DOUTB[1] <= PLDO;
        43 : iADC_DOUTB[0] <= PLDO;
        22 : iADC_DOUTA[11] <= PLDO;
        24 : iADC_DOUTA[10] <= PLDO;
        26 : iADC_DOUTA[9] <= PLDO;
        28 : iADC_DOUTA[8] <= PLDO;
        30 : iADC_DOUTA[7] <= PLDO;
        32 : iADC_DOUTA[6] <= PLDO;
        34 : iADC_DOUTA[5] <= PLDO;
        36 : iADC_DOUTA[4] <= PLDO;
        38 : iADC_DOUTA[3] <= PLDO;
        40 : iADC_DOUTA[2] <= PLDO;
        42 : iADC_DOUTA[1] <= PLDO;
        44 : iADC_DOUTA[0] <= PLDO;
        45, 46, 47, 48, 49 : ;
        50 : begin
          iPGOOD        <= PLDO;
          STAT          <= 6'b000000;
        end
        default : STAT <= 6'b000000;
      endcase
  end
end

assign MAN_ID    = iMAN_ID;
assign PLD_ID    = iPLD_ID;
assign PGOOD     = iPGOOD;
assign iSYNC     = (STAT == 6'b000000) ? 1'b1 : 1'b0;
assign SYNC      = iSYNC;
assign ADC_DOUTA = iADC_DOUTA;
assign ADC_DOUTB = iADC_DOUTB;
assign ADCSEL    = iADCSEL;

// Actual streaming of data (FPGA -> PLD) --
//------------------------------------------

always @(posedge iPLDCLK or negedge nSYSPOR)
begin
  if (~nSYSPOR) begin
    iPLDI      <= 1'b0;
    CNT        <= 5'b00001;
  end else begin
    iPLDI      <= iPLDI;
    CNT        <= CNT + 1;
    if (~iPLDRESETn)
      case (CNT[4:0])
    	1 : iPLDI <= ZCTL[3];
        2 : iPLDI <= ZCTL[2];
    	3 : iPLDI <= ZCTL[1];
        4 : iPLDI <= ZCTL[0];
        5 : iPLDI <= CLKSEL[5];
        6 : iPLDI <= CLKSEL[4];
        7 : iPLDI <= CLKSEL[3];
        8 : iPLDI <= CLKSEL[2];
        9 : iPLDI <= CLKSEL[1];
        10 : iPLDI <= CLKSEL[0];
        11 : iPLDI <= DMEMSIZE[2];
        12 : iPLDI <= DMEMSIZE[1];
        13 : iPLDI <= DMEMSIZE[0];
        14 : iPLDI <= IMEMSIZE[2];
        15 : iPLDI <= IMEMSIZE[1];
        16 : iPLDI <= IMEMSIZE[0];
        default : CNT <= 5'b00000;
      endcase
    else
      case (CNT)
        0 : iPLDI <= ~SELC;
        1 : iPLDI <= ~SELB;
        2 : iPLDI <= ~SELA;
        3 : ;
        4 : iPLDI <= DAC_DIN[7];
        5 : iPLDI <= DAC_DIN[6];
        6 : iPLDI <= DAC_DIN[5];
        7 : iPLDI <= DAC_DIN[4];
        8 : iPLDI <= DAC_DIN[3];
        9 : iPLDI <= DAC_DIN[2];
        10 : iPLDI <= DAC_DIN[1];
        11 : iPLDI <= DAC_DIN[0];
        12 : iPLDI <= PWR_nSHDN[2];
        13 : iPLDI <= PWR_nSHDN[1];
        14 : iPLDI <= PWR_nSHDN[0];
        15 : ;
        default : CNT <= 5'b00000;
      endcase
  end
end

assign PLDI = iPLDI;

// DAC data generation --
//-----------------------
// This block checks if a new value is required for the DACs,
// and whether multiple DACs can be programmed simultaneously
always @(posedge iPLDCLK or negedge nSYSPOR)
begin
  if (~nSYSPOR) begin
    old_DAC_DINA    <= 8'b10000000;
    old_DAC_DINB    <= 8'b10000000;
    old_DAC_DINC    <= 8'b10000000;
    DAC_DIN         <= 8'b10000000;
    SELA            <= 1'b0;
    SELB            <= 1'b0;
    SELC            <= 1'b0;
  end else begin
    SELA            <= SELA;
    SELB            <= SELB;
    SELC            <= SELC;
    if ((CNT == 5'b00000) & (iPLDRESETn)) begin
      SELA          <= 1'b0;
      SELB          <= 1'b0;
      SELC          <= 1'b0;
      if (old_DAC_DINA != DAC_DINA) begin
      	SELA <= 1'b1;
        old_DAC_DINA <= DAC_DINA;
        DAC_DIN <= DAC_DINA;
      	if ((DAC_DINA == DAC_DINB) & (old_DAC_DINB != DAC_DINB)) begin
          SELB <= 1'b1;
          old_DAC_DINB <= DAC_DINB;
        end
        if ((DAC_DINA == DAC_DINC) & (old_DAC_DINC != DAC_DINC)) begin
          SELC <= 1'b1;
          old_DAC_DINC <= DAC_DINC;
        end
      end else if (old_DAC_DINB != DAC_DINB) begin
        SELB <= 1'b1;
        old_DAC_DINB <= DAC_DINB;
        DAC_DIN <= DAC_DINB;
        if ((DAC_DINB == DAC_DINC) & (old_DAC_DINC != DAC_DINC)) begin
          SELC <= 1'b1;
          old_DAC_DINC <= DAC_DINC;
        end
      end else if (old_DAC_DINC != DAC_DINC) begin
        SELC <= 1'b1;
        old_DAC_DINC <= DAC_DINC;
        DAC_DIN <= DAC_DINC;
      end
    end
  end
end

endmodule
