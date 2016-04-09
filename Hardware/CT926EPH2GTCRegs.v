//--  ---------------------------------------------------------------------------
//--    This confidential and proprietary software may be used only as
//--    authorised by a licensing agreement from ARM Limited
//--      (C) COPYRIGHT 1999-2005 ARM Limited
//--          ALL RIGHTS RESERVED
//--    The entire notice above must be reproduced on all authorised
//--    copies and copies may only be made to the extent permitted
//--    by a licensing agreement from ARM Limited.
//--  ---------------------------------------------------------------------------
//--  
//--    Version and Release Control Information:
//--  
//--    File Name              : CT926EPH2GTCRegs.v
//--    File Revision          : 1.0
//--  
//--    Release Information    : 
//--  
//--  ----------------------------------------------------------------------------
//--  ----------------------------------------------------------------------------
//--   Purpose : cmGTC Integrator Core Module control & status registers
//--  ----------------------------------------------------------------------------
//--  ----------------------------------------------------------------------------
//     Limitation : None
//--  ----------------------------------------------------------------------------
//     Known Deficiencies : None
//--  ----------------------------------------------------------------------------
//
// Overview
// ========
// 
//CM_BASE           0x10000000
//CM_ID             CM_BASE         r       static
//CM_PROC           CM_BASE+0x4     r       static
//CM_OSC            CM_BASE+0x8     r/w     POR
//CM_CTRL           CM_BASE+0xC     r/w     RESET
//CM_STAT           CM_BASE+0x10    r       RESET
//CM_LOCK           CM_BASE+0x14    r/w     RESET
//CM_COUNTER        CM_BASE+0x18    r       RESET
//CM_AUXOSC         CM_BASE+0x1C    r/w     POR
//CM_INIT           CM_BASE+0x24    r/w     POR
//CM_REFCNT         CM_BASE+0x28    r       RESET
//-- flags registers
//CM_FLAGS          CM_BASE_0x30    r       RESET
//CM_FLAGSS         CM_BASE_0x30    w       RESET
//CM_FLAGSC         CM_BASE_0x34    w       RESET
//CM_NVFLAGS        CM_BASE_0x38    r       POR
//CM_NVFLAGSS       CM_BASE_0x38    w       POR
//CM_NVFLAGSC       CM_BASE_0x3C    w       POR
//-- interrupt controller
//CM_IRQ_STATUS     CM_BASE+0x40    r       RESET
//CM_IRQ_RAW        CM_BASE+0x44    r       RESET
//CM_IRQ_ENABLE     CM_BASE+0x48    r       RESET
//CM_IRQ_ENABLES    CM_BASE+0x48    w       RESET
//CM_IRQ_ENABLEC    CM_BASE+0x4c    w       RESET
//CM_SOFT_INT       CM_BASE+0x50    r       RESET
//CM_SOFT_INTS      CM_BASE+0x50    w       RESET
//CM_SOFT_INTC      CM_BASE+0x54    w       RESET
//CM_FIQ_STATUS     CM_BASE+0x60    r       RESET
//CM_FIQ_RAW        CM_BASE+0x64    r       RESET
//CM_FIQ_ENABLE     CM_BASE+0x68    r       RESET
//CM_FIQ_ENABLES    CM_BASE+0x68    w       RESET
//CM_FIQ_ENABLEC    CM_BASE+0x6C    w       RESET
// voltage and power management
//CM_VOLTAGE_CTL0   CM_BASE+0x80    r/w     POR
//CM_VOLTAGE_CTL1   CM_BASE+0x84    r/w     POR
//CM_VOLTAGE_CTL2   CM_BASE+0x88    r/w     POR
//CM_VOLTAGE_CTL3   CM_BASE+0x8C    r/w     POR
//CT_PLD            CM_BASE+0x94    r/w     POR
//CM_VOLTAGE_CTL4   CM_BASE+0xA0    r/w     POR
//CM_VOLTAGE_CTL5   CM_BASE+0xA4    r/w     POR
//CM_VOLTAGE_CTL6   CM_BASE+0xA8    r/w     POR
//CM_VOLTAGE_CTL7   CM_BASE+0xAC    r/w     POR
//
// 0x107fffff  reserved for future header card registers
// 0x10000200  reserved for future header card registers
//  
// *** See parameter declarations for bit field definitions ***
//
//-----------------------------------------------------------------------------

// Frequencies set to CPU 170MHz, HCLKI 85MHz, HCLKE 28MHz

module cpGTCRegs(
  PORESETn,
  // APB interface
  PCLK, PRESETn, PSEL, PENABLE, PADDR, PWRITE, PWDATA, PRDATA,
  // reference clock for real-time cycle count register
  CLKREF24MHZ, CLKREF24MHZRESETn,
  // status inputs to registers:
  ID, MBDET, MAN_ID,
  // control signals from registers:
  ARM_PLLREFDIV, ARM_PLLCTRL, ARM_PLLFBDIV, ARM_PLLOUTDIV, ARM_HCLKDIV,
  ARM_PLLBYPASS, ARM_INITRAM, ARM_USERIN, ARM_VINITHI,
  // onboard pll control
  OSC0_VECTOR, OSC1_VECTOR, OSC2_VECTOR,
  // onboard ADC control
  PLDSET, PLDREAD, POWERCHN, PLDSYNC, LED, SW, HRDATACONFIG,
  // ARM interrupt control
  COMMRX, COMMTX, IRQ, FIQ, ARMMAILBOXFULL, VPBREGINT,
  // VPB interrupt control
  VPBMAILBOXEMPTY
);

input         PORESETn;      // reset for 'sticky' registers
// APB interface
input         PCLK;          // APB bus clock
input         PRESETn;       // APB bus reset
input         PSEL;          // APB device select
input         PENABLE;       // identifies APB active cycle
input   [7:2] PADDR;         // APB address
input         PWRITE;        // APB transfer direction
input  [31:0] PWDATA;        // APB write data
output [31:0] PRDATA;        // APB read data
// reference clock for real-time cycle count register
input         CLKREF24MHZ;   // 24MHz reference clock
input         CLKREF24MHZRESETn; // ... and associated reset
// status inputs to registers:
input   [3:0] ID;            // Core Module position
input         MBDET;         // motherboard detect
input   [3:0] MAN_ID;        // TestChip/Partner identification inputs
// control signals from registers:
output  [3:0] ARM_PLLREFDIV; // TC PLL reference divider
output  [1:0] ARM_PLLCTRL;   // TC PLL control
output  [7:0] ARM_PLLFBDIV;  // TC PLL feedback divider
output  [3:0] ARM_PLLOUTDIV; // TC PLL output divider
output  [2:0] ARM_HCLKDIV;   //
output        ARM_PLLBYPASS; //
output        ARM_INITRAM;   //
output  [5:0] ARM_USERIN;    //
output        ARM_VINITHI;   // ARM control signal
// onboard pll control
output [31:0] OSC0_VECTOR;
output [31:0] OSC1_VECTOR;
output [31:0] OSC2_VECTOR;
// onboard ADC control
output [36:0] PLDSET;
input  [28:0] PLDREAD;
input   [2:0] POWERCHN;
input         PLDSYNC;
output  [7:0] LED;
input   [3:0] SW;
output [31:0] HRDATACONFIG;
// ARM interrupt control
input         COMMRX;        // interrupt source from ARM
input         COMMTX;        // interrupt source from ARM
output        IRQ;           // interrupt to ARM
output        FIQ;           // interrupt to ARM
input         ARMMAILBOXFULL; // indicates outbound Mailbox emptied
input         VPBREGINT;     // indicates software interrupt generated from M1 master
// VPB interrupt control
input         VPBMAILBOXEMPTY; // indicates inbound Mailbox filled

// ID register default values
`define CM_MANUFACTURER   8'h41    // 0x41  ARM
`define CM_PROCBUS        2'b10    // 00  ASB, 01  7TDMI, 10  AHB
`define CM_SYSTEMBUS      2'b10    // 00  ASB, 10  AHB
`define CM_SDRAMWIDTH     1'b0     // 0  32-bit, 1  64-bit
`define CM_SDRAMBURST     3'b000   // 000  4 words
`define CM_ARCHITECTURE   {`CM_SDRAMBURST, `CM_SDRAMWIDTH, `CM_SYSTEMBUS, `CM_PROCBUS}
`define CM_FPGATYPE       4'h7     // 7  XC2V2000
`define CM_BUILD          8'h01    // build 1 (BCD)
`define CM_REVISION       4'b0001  // 1RevB (AHB)

// Identification string
// bit 31:24 Manufacturer
// bit 23:16 Architecture
// bit 15:12 FPGA type
// bit 11:4  Build
// bit  3:0  Revision
`define CM_ID_VAL         {`CM_MANUFACTURER, `CM_ARCHITECTURE, `CM_FPGATYPE, `CM_BUILD, `CM_REVISION}

// Processor ID, read from CP15 r0 
`define CM_PROC_VAL       32'h00000000

// Oscillator register reset value
// CPU Oscillator register reset value
// f(CPUCLK) is claculated from: (with an input frecuency of 24MHz)
// VDW+8 MHz (as R and OD are set to respectively 22 and 2)

// CPU_CLKCTRL(8..0)   --> CPU_VDW(8..0)
//   20 < VDW < 192
// the ICS307 resets to 24MHz but is soon to be reprogrammed 

// Minimum Fcore with HCLKDIV1+1 is 50MHz to get FHCLK25MHz needed by the DLLs to lock
`define CM_CPU_VDW_VAL    9'b000100000

`define CM_CPU_RDW_VAL    7'b0010110
`define CM_CPU_OD_VAL     3'b001

`define CM_OSC_VAL        {`CM_CPU_OD_VAL, `CM_CPU_RDW_VAL, `CM_CPU_VDW_VAL}

// Aux Oscillator register reset value CM_AUXOSC
// f(AUXCLK) is calculated from:
//   48 x (VDW+8) / ( (RDW+2) x OD' )
//
// AUXCLKCTRL(18..16) --> AUX_OD(2..0) 
//   OD {0,1,2,3,4,5,6,7} --> OD' {10,2,8,4,5,7,3,6}
//   Default is 001 which is OD2
`define CM_AUX_OD_VAL     3'b001
// AUXCLKCTRL(15..9)  --> AUX_RDW(6..0)
//   1 < RDW < 127
`define CM_AUX_RDW_VAL    7'b0101110
// AUXCLKCTRL(8..0)   --> AUX_VDW(8..0)
//   4 < VDW < 511
`define CM_AUX_VDW_VAL    9'b000001100

`define CM_AUXOSC_VAL     {`CM_AUX_OD_VAL, `CM_AUX_RDW_VAL, `CM_AUX_VDW_VAL}

// The CM_AUxOSC register also defines the control signals of the
// TC's PLL (with the exception of PLLFBDIV which is controlled 
// by CM_INIT) 
//   PLL control signals
`define CM_PLLCTRL_VAL    2'b00
//   PLL reference divider
`define CM_PLLREFDIV_VAL  4'b0011
//   PLL output divider 
`define CM_PLLOUTDIV_VAL  4'b0000

// Control register reset values
// bit 31:5  Reserved
//        4  High vectors (not dynamically changeable on this device)
//        3  Soft reset
//        2  Remap
//        1  Motherboard detect
//        0  LED          

// Status register reset values
// bit 31:24 Reserved
//     23:16 SSRAM size, 0x10  1MB
//     15:8  Reserved
//      7:0  ID
`define CM_SSRAM_VAL      8'h40

// Initialisation register reset values CM_INIT
// *** SPECIFIC TO CM-GTC ***
// bit 31:30  Reserved 
//     29:24  USERIN[5:0]
//     23:17  Reserved
//        16  TCM enable (0disabled)
//      15:8  PLLFBDIV
//         7  Reserved
//       6:4  HCLK divider
//         3  Reserved
//         2  VINITHI
//         1  PLL bypass (actual value at pin, takes effect after reset)
//         0  PLL bypass register
`define CM_USERIN_VAL     6'b101000 // all 0 for first TC except EPHEMEnable and EPHEMDIV2
`define CM_INITRAM_VAL    1'b0     // internal RAM OFF at reset
`define CM_PLLFBDIV_VAL   8'b00001011 // min feedback divider for max frequency
`define CM_HCLKDIV_VAL    3'b010   // HCLKCLK/2 org_vlaue 010
`define CM_VINITHI_VAL    1'b0     // vector base00000000.
`define CM_PLLBYPASS_VAL  1'b0     // PLL bypassed so CLKREFCLK.

// Lock register key 0xA05F
`define LOCK_KEY         16'hA05F

// Address decoding
`define CM_ID            6'b000000  // read only  0x00
`define CM_PROC          6'b000001  // read only  0x04
`define CM_OSC           6'b000010  // read/write 0x08
`define CM_CTRL          6'b000011  // read/write 0x0C
`define CM_STAT          6'b000100  // read only  0x10
`define CM_LOCK          6'b000101  // read/write 0x14
`define CM_COUNTER       6'b000110  // read/write 0x18
`define CM_AUXOSC        6'b000111  // read/write 0x1C
`define CM_INIT          6'b001001  // read/write 0x24
`define CM_RTCOUNTER     6'b001010  // read only  0x28
`define CM_FLAGS         6'b001100  // read       0x30 
`define CM_FLAGSSET      6'b001100  // write      0x30 
`define CM_FLAGSCLR      6'b001101  // write only 0x34 
`define CM_NVFLAGS       6'b001110  // read       0x38 
`define CM_NVFLAGSSET    6'b001110  // write      0x38 
`define CM_NVFLAGSCLR    6'b001111  // write only 0x3C 
`define IRQ_STATUS       6'b010000  // read only  0x40
`define RAW_INTA         6'b010001  // read only  0x44
`define IRQ_ENABLE       6'b010010  // read       0x48
`define IRQ_ENABLES      6'b010010  // write      0x48
`define IRQ_ENABLEC      6'b010011  // write      0x4C
`define SOFT_INT         6'b010100  // read       0x50
`define SOFT_INTS        6'b010100  // write      0x54
`define SOFT_INTC        6'b010101  // write      0x58
`define FIQ_STATUS       6'b011000  // read only  0x60
`define RAW_INTB         6'b011001  // read only  0x64
`define FIQ_ENABLE       6'b011010  // read       0x68
`define FIQ_ENABLES      6'b011010  // write      0x68
`define FIQ_ENABLEC      6'b011011  // write      0x6C
`define CM_VOLTAGE_CTL0  6'b100000  // read/write 0x80 
`define CM_VOLTAGE_CTL1  6'b100001  // read only  0x84 
`define CM_VOLTAGE_CTL2  6'b100010  // read only  0x88 
`define CM_VOLTAGE_CTL3  6'b100011  // read only  0x8C 
`define CT_PLD           6'b100101  // read only  0x94 
`define CM_VOLTAGE_CTL4  6'b101000  // read/write 0xA0 
`define CM_VOLTAGE_CTL5  6'b101001  // read only  0xA4 
`define CM_VOLTAGE_CTL6  6'b101010  // read only  0xA8 
`define CM_VOLTAGE_CTL7  6'b101011  // read only  0xAC 

wire [31:0] CMIdReg;         // Identification register
wire [31:0] CMProcReg;       // Processor identification register
reg  [18:0] CMOscReg;        // Oscillator register
reg  [22:0] PreResetCMOscReg; // Oscillator register Pre Reset
reg   [9:0] CMCtrlReg;       // Control register
wire [31:0] CMStatReg;       // Status register
reg  [31:0] CMCounterReg;    // Cycle counter register
reg  [15:0] CMLockReg;       // Lock register
reg  [31:0] CMAuxOscReg;     // Aux Oscillator register and TC PLL control signals
reg  [9:0]  PreResetCMAuxOscReg; // need an intermediate version for the TC PLL signals
reg  [20:0] CMInitReg;       // Initialisation register (not all bits used)
reg  [19:0] PreResetCMInitReg; // Pre-Reset version of the init register
wire [31:0] CMRTCounterReg;  // Real-Time Cycle counter register
reg  [31:0] CMFlagsReg;      // software signalling flags (normal reset)
reg  [31:0] CMNVFlagsReg;    // software signalling flags (power-on reset)
reg  [31:0] CMVoltageCtl0;
reg  [31:0] CMVoltageCtl1;
reg  [31:0] CMVoltageCtl2;
reg  [31:0] CMVoltageCtl3;
reg  [31:8] CMVoltageCtl4;
reg  [31:8] CMVoltageCtl5;
reg  [31:8] CMVoltageCtl6;
reg  [31:8] CMVoltageCtl7;
reg   [9:0] CTPLDReg;
  
wire        Locked;          // Registers are locked
wire        iPLLBYPASS;      // internal PLLBYPASS
reg   [7:0] CmId;            // module id
reg  [31:0] NextPRData;      // read data
reg  [31:0] PRDATA;
reg         IRQ;
reg         FIQ;

// real-time cycle counter and sampling registers used to cross clock domains
reg  [31:0] CMRTCounter;
reg  [31:0] CMRTC_Reg1;      // Clk1 domain
reg  [31:0] CMRTC_Reg2;      // Clk2 domain

// control signals for the sampling between clock domains
reg         CMRTC_SampleNum1;  // control register in Clk1 domain
reg         CMRTC_SampleNum1_Clk2;  // ... and copy of it in Clk2 domain
reg         CMRTC_SampleNum2;  // control register in Clk2 domain
reg         CMRTC_SampleNum2_Clk1;  // ... and copy of it in Clk1 domain
wire        CMRTC_SampleEna1;  // control signal in Clk1 domain
wire        CMRTC_SampleEna2;  // control signal in Clk2 domain

// ICS307 signals (Aux, Bus, Core)
wire        PRGEN_A;
wire        PRGACK_A;  
wire        PRGEN_C;  
wire        PRGACK_C;

// Signals used to for the updates of the clock registers
reg         Update;
reg         NewVal;
reg         ClrUpdate;	
reg   [2:0] iARM_HCLKDIV;
reg         iAWAITICSDONE;

wire  [2:0] POWERCNT;

// State machine
reg [2:0] state_hclkdiv;
`define idle        3'b000
`define immed       3'b001
`define delay       3'b010
`define finish      3'b011

//----------------------------------------------------------------------------
// Purpose :  Integrator Core Module Interrupt Controller
//----------------------------------------------------------------------------
// register declaration
reg   [5:1] RawIntReg;
reg         SoftIntReg;

reg   [5:0] IRQEnableReg;
reg   [5:0] FIQEnableReg;
wire  [5:0] IRQStatusReg;
wire  [5:0] FIQStatusReg;

wire        IRQi;
wire        FIQi;

// Add HRDATACONFIG configuration for compatability with ARM11+ cores
`define iPLLCONFIG       32'h00000000

// Identification, processor and status registers are read only
assign CMIdReg   = `CM_ID_VAL;
assign CMProcReg = `CM_PROC_VAL;

// Decode ID into core module number
always @(ID)
begin
  case (ID)
    4'b1101 : CmId <= 8'h03;
    4'b1011 : CmId <= 8'h02;
    4'b0111 : CmId <= 8'h01;
    4'b1110 : CmId <= 8'h00;
    default : CmId <= 8'hFF;
  endcase
end

// TestChip Manufacturer Id bits are inverted so that old boards (no PCB 
// resistors, so pulled UP in FPGA pads) read the same as old FPGAs (all zeroes).
assign CMStatReg = {SW, 4'b0000, `CM_SSRAM_VAL, 4'b0000, ~(MAN_ID), CmId};

// Lock register is read/write, general reset
always @(posedge PCLK or negedge PRESETn)
begin
  if (~PRESETn)
    CMLockReg  <= 16'h0000;
  else
    if (PSEL & PWRITE & PENABLE)
      if (PADDR == `CM_LOCK)
        CMLockReg <= PWDATA[15:0];
end

//------------------------------------
// CLOCKS 
//------------------------------------

// CP Specific code added
// **********************
//
// As the clock scheme involves DLLs that are
// controlled by the reset controller, the only
// safe way to change the clocks is to change them
// only on reset. This is why a "PreReset" version
// of certain bits in the CM_OSC, CM_AUC, CM_INIT
// registers have been added.
//
// Note that you can theoritically increment the
// frequency by small increments without unlocking
// the DLL. Therefore, a way of changing the clocks
// without having to perform a reset is provided to.

// Locked signal protects registers that could be accidentally changed
assign Locked = ~(CMLockReg == `LOCK_KEY);

always @(posedge PCLK or posedge ClrUpdate)
begin
  if (ClrUpdate) begin
	Update <=1'b0;
	NewVal <=1'b0;
  end else
    if (PSEL & PWRITE & PENABLE & ~Locked)
      if (PADDR == `CM_OSC) begin
        NewVal <= 1'b1;
        Update <= PWDATA[26];
      end
end

//------------------------------------
// Power Control
//------------------------------------

// Set Core voltage DAC value in CM_VOLTAGE_CTL0. Read/write, reset at power on
// Set Core voltage DAC value in CM_VOLTAGE_CTL1. Read/write, reset at power on
// Set Core voltage DAC value in CM_VOLTAGE_CTL2. Read/write, reset at power on
// Set Core voltage on/off in CM_VOLTAGE_CTL3. Read/write, general reset
always @(posedge PCLK or negedge PORESETn)
begin
  if (~PORESETn) begin
    CMVoltageCtl0[7:0] <= 8'b10000000; // the DAC resets to half of its scale
    CMVoltageCtl1[7:0] <= 8'b10000000; // the DAC resets to half of its scale
    CMVoltageCtl2[7:0] <= 8'b10000000; // the DAC resets to half of its scale
    CMVoltageCtl3[7:0] <= 8'b00000111; // the system starts with all power on
  end else begin
    CMVoltageCtl3[7:3] <= 5'b00000; // Reserved
    if (PSEL & PWRITE & PENABLE & ~Locked) begin
      case (PADDR)
        `CM_VOLTAGE_CTL0 : CMVoltageCtl0[7:0] <= PWDATA[7:0];
        `CM_VOLTAGE_CTL1 : CMVoltageCtl1[7:0] <= PWDATA[7:0];
        `CM_VOLTAGE_CTL2 : CMVoltageCtl2[7:0] <= PWDATA[7:0];
        `CM_VOLTAGE_CTL3 : CMVoltageCtl3[2:0] <= PWDATA[2:0];
      endcase
    end
  end
end

// Set CT PLD configuration information
always @(posedge PCLK or negedge PORESETn)
begin
  if (~PORESETn) begin
    CTPLDReg[3:0] <= 4'b0000;   // the system starts with all Z routed through
    CTPLDReg[9:4] <= 6'b111100; // the system starts up with this clock config
  end else
    if (PSEL & PWRITE & PENABLE & ~Locked)
      if (PADDR == `CT_PLD) begin
        CTPLDReg[9:0] <= PWDATA[9:0];
      end 
end

assign PLDSET[30:27] = CTPLDReg[3:0];
assign PLDSET[36:31] = CTPLDReg[9:4];

// Oscillator registers are read/write, protected by lock register, reset at power on
always @(posedge PCLK or negedge PORESETn) begin
  if (~PORESETn) begin
    // CM_OSC REGISTER
    PreResetCMOscReg[18:0]   <= `CM_OSC_VAL;
    // CM_AUX REGISTER
    CMAuxOscReg[18:0]        <= `CM_AUXOSC_VAL;    // Auxiliary board pll
    PreResetCMAuxOscReg[1:0] <= `CM_PLLCTRL_VAL;   // TC pll control
    PreResetCMAuxOscReg[5:2] <= `CM_PLLREFDIV_VAL; // TC pll reference divider
    PreResetCMAuxOscReg[9:6] <= `CM_PLLOUTDIV_VAL; // TC pll outpout divider
  end
  else begin
     if (PSEL & PWRITE & PENABLE & ~Locked) begin
        // CM_OSC REGISTER
        if (PADDR == `CM_OSC)
           PreResetCMOscReg[18:0] <= PWDATA[18:0];
        // CM_AUX REGISTER
        if (PADDR == `CM_AUXOSC) begin
           // the AUX freq. can be changed immediately
           CMAuxOscReg[18:0]   <= PWDATA[18:0];// Auxiliary board pll
  	   // but the TC PLL will be changed on reset only
           PreResetCMAuxOscReg[1:0] <= PWDATA[21:20];// TC pll control
           PreResetCMAuxOscReg[5:2] <= PWDATA[27:24];// TC pll reference divider
           PreResetCMAuxOscReg[9:6] <= PWDATA[31:28];// TC pll outpout divider
        end
     end
  end
end

// NOTE that bits 30..31, 18..23, 7, 3 of CMInitReg are declared but never used.
// The synthesiser will optimise away those signals.
// Initialisation register is read/write, protected by lock register, reset at power on
always @(posedge PCLK or negedge PORESETn)
begin
  if (~PORESETn) begin
    PreResetCMInitReg[19:14] <= `CM_USERIN_VAL;
    PreResetCMInitReg[13]    <= `CM_INITRAM_VAL;
    PreResetCMInitReg[12:5]  <= `CM_PLLFBDIV_VAL;
    PreResetCMInitReg[4:2]   <= `CM_HCLKDIV_VAL;
    PreResetCMInitReg[1]     <= `CM_VINITHI_VAL;
    PreResetCMInitReg[0]     <= `CM_PLLBYPASS_VAL;
  end else begin
    if (PSEL & PWRITE & PENABLE & ~Locked)
      if (PADDR == `CM_INIT) begin
        PreResetCMInitReg[19:14] <= PWDATA[29:24];  // USERIN 
        PreResetCMInitReg[13]    <= PWDATA[16];     // INITRAM 
        PreResetCMInitReg[12:5]  <= PWDATA[15:8];   // PLLFBDIV 
        PreResetCMInitReg[4:2]   <= PWDATA[6:4];    // HCLKDIV 
        PreResetCMInitReg[1]     <= PWDATA[2];      // VINITHI
        PreResetCMInitReg[0]     <= PWDATA[0];      // PLLBYPASS
      end
   end
end

// Process to update the bits of CM_OSC, CM_AUX, CM_INIT
// related to clock configuration during reset only
always @(posedge CLKREF24MHZ or negedge PORESETn)
begin
  if (~PORESETn) begin
    CMInitReg[20:15] <= `CM_USERIN_VAL;
    CMInitReg[14]    <= `CM_INITRAM_VAL;
    CMInitReg[13:6]  <= `CM_PLLFBDIV_VAL;
    CMInitReg[5:3]   <= `CM_HCLKDIV_VAL;
    CMInitReg[2]     <= `CM_VINITHI_VAL;
    CMInitReg[1]     <= 1'b0;
    CMInitReg[0]     <= `CM_PLLBYPASS_VAL;
    CMAuxOscReg[31:19] <= 13'b0000000000000;
    CMOscReg[18:0]   <= `CM_OSC_VAL;
    ClrUpdate        <= 1'b0;
  end else begin // have to use a clock that is there all the time even when PORESETn=0
    // bit 1 always reads status of PLLBYPASS pin
    CMInitReg[1] <= iPLLBYPASS;
    CMAuxOscReg[19] <= 1'b0; // Reserved
    CMAuxOscReg[23:22] <= 2'b00; //Reserved
    ClrUpdate <= 1'b0;
    if ((PRESETn==1'b0) | (Update==1'b1)) begin
      // CM_INIT
      CMInitReg[20:15] <= PreResetCMInitReg[19:14];
      CMInitReg[14]    <= PreResetCMInitReg[13];
      CMInitReg[13:6]  <= PreResetCMInitReg[12:5];
      CMInitReg[5:3]   <= PreResetCMInitReg[4:2];
      CMInitReg[2]     <= PreResetCMInitReg[1];
      CMInitReg[0]     <= PreResetCMInitReg[0];
	  // CM_OSC
      CMOscReg[18:0]   <= PreResetCMOscReg[18:0];
	  // CM_AUX
      CMAuxOscReg[21:20] <= PreResetCMAuxOscReg[1:0];
      CMAuxOscReg[27:24] <= PreResetCMAuxOscReg[5:2];
      CMAuxOscReg[31:28] <= PreResetCMAuxOscReg[9:6];
      // MISC
  	  ClrUpdate        <= 1'b1;
    end
  end
end

// CM_InitReg is only updated on reset so PLLBYPASS is updated on reset.
// This echoes the internal operation of the ARM9X6 testchip.
assign iPLLBYPASS = CMInitReg[0]; 

assign ARM_USERIN    = CMInitReg[20:15];
assign ARM_INITRAM   = CMInitReg[14];      
assign ARM_VINITHI   = CMInitReg[2];      
assign ARM_PLLBYPASS = CMInitReg[1];
assign ARM_PLLFBDIV  = CMInitReg[13:6];
assign ARM_PLLREFDIV = CMAuxOscReg[27:24];
assign ARM_PLLCTRL   = CMAuxOscReg[21:20];
assign ARM_PLLOUTDIV = CMAuxOscReg[31:28];

always @(posedge CLKREF24MHZ or negedge PORESETn)
begin
  if (~PORESETn)
  	iARM_HCLKDIV <= `CM_HCLKDIV_VAL;
  else
    if (iAWAITICSDONE)
      iARM_HCLKDIV   <= CMInitReg[5:3];
end

always @(posedge CLKREF24MHZ or negedge PORESETn)
begin
  if (~PORESETn) begin
    state_hclkdiv <= `idle;
    iAWAITICSDONE <= 1'b0;
  end else
    case (state_hclkdiv)
      `idle : begin
          iAWAITICSDONE <= 1'b0;
          if ((PRESETn==1'b0) | (Update==1'b1))
            if (~NewVal)
              state_hclkdiv <= `immed;
            else
              state_hclkdiv <= `delay;
        end
      `immed : begin
          state_hclkdiv <= `finish;
          iAWAITICSDONE <= 1'b1;
        end
      `delay : begin
          state_hclkdiv <= `finish;
          iAWAITICSDONE <= 1'b1;
        end
	  `finish : state_hclkdiv <= `idle;
      default : state_hclkdiv <= `idle;
    endcase
end

assign ARM_HCLKDIV = iARM_HCLKDIV;

// Control register has some bits read/write and some read only, general reset
// When no motherboard, REMAP bit is always 1 and can't be changed, but when
// attached to motherboard resets to 0 and can be updated by register write. 
always @(posedge PCLK or negedge PRESETn)
begin
  if (~PRESETn) begin
    CMCtrlReg[0] <= 1'b0;     // Reserved
    CMCtrlReg[1] <= 1'b0;
	CMCtrlReg[9:2] <= 8'h00; // LEDs off
  end else begin
    CMCtrlReg[1] <= ~MBDET; // bit 1 is read-only copy of MBDET
    if (PSEL & PWRITE & PENABLE)
      if (PADDR == `CM_CTRL) begin
        CMCtrlReg[0] <= PWDATA[0];
        CMCtrlReg[9:2] <= PWDATA[31:24];
      end
  end
end

// CP specific:
assign LED         = CMCtrlReg[9:2];

// Cycle Counter register (counts cycles of PCLK)
always @(posedge PCLK or negedge PRESETn)
begin                                       
  if (~PRESETn)
    CMCounterReg <= 32'h00000000;
  else
    CMCounterReg <= CMCounterReg + 1; 
end

// Cycle Counter register (counts cycles of real-time reference clock)
always @(posedge CLKREF24MHZ or negedge CLKREF24MHZRESETn)
begin
  if (~CLKREF24MHZRESETn)
    CMRTCounter <= 32'h00000000;
  else
    CMRTCounter <= CMRTCounter + 1;
end

//-------------------------------------------
// Control logic for Real-Time Cycle Counter 
//-------------------------------------------
// The RTCounter is in the ClkRef24MHz clock domain and must be sampled
// into the PCLK domain to be read via the APB.  For clarity, the signal
// names in this control logic identify the two clock domains as Clk1 (ClkRef24MHz)
// and Clk2 (PCLK).  the sequence of operations is:
// * CMRTC_SampleEna1 will be true for ONE Clk1 cycle and enables sampling of the
//   counter itself (CMRTCounter) into CMRTC_Reg1.
// * CMRTC_SampleNum1 is the number of counter sampling events that have occurred
//   in the Clk1 domain and is Gray-code incremented when this sampling occurs.
// * At the next Clk2 edge, the new SampleNum1 value is copied into the Clk2
//   domain as CMRTC_SampleNum1_Clk2.  This is a safe operation because SampleNum1
//   counts in Gray code.
// * CMRTC_SampleNum2 is the number of counter sampling events that have occurred
//   in the Clk2 domain, and will currently be one behind CMRTC_SampleNum1.  Because
//   SampleNum1_Clk2 and SampleNum2 are different, CMRTC_SampleEna2 will be active.
// * SampleEna2 enables sampling of the (currently static) CMRTC_Reg1 into CMRTC_Reg2.
// * SampleNum2 is Gray-code incremented when this sampling occurs.
// * After this ONE cycle, SampleNum1_Clk2 and SampleNum2 are now equal so SampleEna2
//   will be turned off, having caused ONE Clk2 sample event.
// * At the next Clk1 edge, the new SampleNum2 value is copied into the Clk1
//   domain as CMRTC_SampleNum2_Clk1.  This is a safe operation because SampleNum2
//   counts in Gray code.
// * CMRTC_SampleNum1 is the number of counter sampling events that have occurred
//   in the Clk1 domain, and SampleNum2_Clk1 will now have caught up with it.  Because
//   SampleNum1 and SampleNum2_Clk1 are equal, CMRTC_SampleEna1 will be active.
// * This returns to the starting point, and SampleEna1 will be true for ONE Clk1 edge.
//
// NOTE that for simplicity, SampleNum1 and SampleNum2 are reduced to ONE-bit Gray
// code counters, which reduce to just T-type FFs.  The NOT-EQUAL and EQUAL comparisons
// used to produce SampleEna2 and SampleEna1 then reduce to XOR and XNOR respectively.
//

assign CMRTC_SampleEna1 = (CMRTC_SampleNum1 == CMRTC_SampleNum2_Clk1);
// NOTE that one-bit "=" is actually:
// CMRTC_SampleEna1 <= NOT (CMRTC_SampleNum1 XOR CMRTC_SampleNum2_Clk1);

always @(posedge CLKREF24MHZ or negedge CLKREF24MHZRESETn)
begin
  if (~CLKREF24MHZRESETn) begin
    CMRTC_Reg1            <= 32'h00000000;
    CMRTC_SampleNum1      <= 1'b0;        // one-bit Gray code zero
    CMRTC_SampleNum2_Clk1 <= 1'b0;        // copy of one-bit Gray code zero
  end else begin
    CMRTC_SampleNum2_Clk1 <= CMRTC_SampleNum2;  // move SampleNum2 into Clk1 domain
    if (CMRTC_SampleEna1) begin
      CMRTC_Reg1       <= CMRTCounter;       // sample the counter and ...
      CMRTC_SampleNum1 <= ~CMRTC_SampleNum1; // increment one-bit Gray code counter
    end
  end
end

assign CMRTC_SampleEna2 = (CMRTC_SampleNum2 != CMRTC_SampleNum1_Clk2);
// NOTE that one-bit "!=" is actually:
// CMRTC_SampleEna2 <= (CMRTC_SampleNum2 XOR CMRTC_SampleNum1_Clk2);

always @(posedge PCLK or negedge PRESETn)
begin
  if (~PRESETn) begin
    CMRTC_Reg2            <= 32'h00000000;
    CMRTC_SampleNum2      <= 1'b0;        // one-bit Gray code zero
    CMRTC_SampleNum1_Clk2 <= 1'b0;        // copy of one-bit Gray code zero
  end else begin
    CMRTC_SampleNum1_Clk2 <= CMRTC_SampleNum1;  // move SampleNum1 into Clk2 domain
    if (CMRTC_SampleEna2) begin
      CMRTC_Reg2       <= CMRTC_Reg1;           // sample the Clk1 register and ...
      CMRTC_SampleNum2 <= ~CMRTC_SampleNum2; // increment one-bit Gray code counter
    end
  end
end

// copy the safely sampled Counter value into the signal that's readable from the APB:
assign CMRTCounterReg = CMRTC_Reg2;

//-----------------------------------
// CM_FLAGS and CM_NVFLAGS registers 
//-----------------------------------
// There are two 32-bit wide flags registers for software communication.
// CM_FLAGS is cleared to all zeroes at every reset.
// CM_NVFLAGS is "non-volatile" in that it is only cleared at power-on reset.
// * READING from the register address gives the current state of the flags,
// * WRITING to the 'SET' address sets all bits with a 1 in the write data mask,
// * WRITING to the 'CLR' address clears all bits with a 1 in the write data mask.
// This mechanism avoids the need for read-modify-write code when the flags are
// shared between multiple, interruptible, software processes.

// CM_FLAGS register read/set/clear, reset normally
always @(posedge PCLK or negedge PRESETn)
begin
  if (~PRESETn)
    CMFlagsReg <= 32'h00000000;
  else
    if (PSEL & PWRITE & PENABLE) begin
      // the synthesiser can calculate that set and clear are mutually exclusive
      // so no priority encoding is required here.
      if (PADDR==`CM_FLAGSSET)
        // set bits that are selected by the mask
        CMFlagsReg <= CMFlagsReg | PWDATA;
      if (PADDR==`CM_FLAGSCLR)
        // clear bits that are selected by the mask
        CMFlagsReg <= CMFlagsReg & (~PWDATA);
    end
end

// CM_NVFLAGS register read/set/clear, reset only at power-on
always @(posedge PCLK or negedge PORESETn)
begin
  if (~PORESETn)
    CMNVFlagsReg <= 32'h00000000;
  else
    if (PSEL & PWRITE & PENABLE) begin
      // the synthesiser can calculate that set and clear are mutually exclusive
      // so no priority encoding is required here.
      if (PADDR==`CM_NVFLAGSSET)
        // set bits that are selected by the mask
        CMNVFlagsReg <= CMNVFlagsReg | PWDATA;
      if (PADDR==`CM_NVFLAGSCLR)
        // clear bits that are selected by the mask
        CMNVFlagsReg <= CMNVFlagsReg & (~PWDATA);
    end
end

//Read registers
always @(PADDR or PSEL or PWRITE or CMIdReg or CMProcReg or CMOscReg or CMCtrlReg or CMStatReg or CMAuxOscReg or
         CMLockReg or Locked or CMInitReg or CMRTCounterReg or CMFlagsReg or CMNVFlagsReg or
         CMVoltageCtl0 or CMVoltageCtl1 or CMVoltageCtl2 or CMVoltageCtl3 or CTPLDReg or PLDREAD or
         CMVoltageCtl4 or CMVoltageCtl5 or CMVoltageCtl6 or CMVoltageCtl7 or
         IRQStatusReg or FIQStatusReg or RawIntReg or SoftIntReg or NewVal or Update or
         IRQEnableReg or FIQEnableReg or CMCounterReg)
begin
  NextPRData <= 32'h00000000;
  if (PSEL & (~PWRITE))
    case (PADDR)
      `CM_ID         : NextPRData[31:0] <= CMIdReg;
      `CM_PROC       : NextPRData[31:0] <= CMProcReg;
      `CM_OSC        : NextPRData[31:0] <= {4'h0, NewVal, Update, 7'b0000000, CMOscReg[18:0]};
      `CM_CTRL       : NextPRData[31:0] <= {CMCtrlReg[9:2], 20'h00000, 2'b00, CMCtrlReg[1:0]};
      `CM_STAT       : NextPRData[31:0] <= CMStatReg;
      `CM_LOCK       : NextPRData[31:0] <= {15'b000000000000000, Locked, CMLockReg};
      `CM_COUNTER    : NextPRData[31:0] <= CMCounterReg;
      `CM_AUXOSC     : NextPRData[31:0] <= CMAuxOscReg;
      `CM_INIT       : NextPRData[31:0] <= {2'b00, CMInitReg[20:15], 7'b0000000, CMInitReg[14:6], 1'b0, CMInitReg[5:3], 1'b0, CMInitReg[2:0]};
      `CM_RTCOUNTER  : NextPRData[31:0] <= CMRTCounterReg;
      `CM_FLAGS      : NextPRData[31:0] <= CMFlagsReg;
      `CM_NVFLAGS    : NextPRData[31:0] <= CMNVFlagsReg;
      `CM_VOLTAGE_CTL0 : NextPRData[31:0] <= CMVoltageCtl0;
      `CM_VOLTAGE_CTL1 : NextPRData[31:0] <= CMVoltageCtl1;
      `CM_VOLTAGE_CTL2 : NextPRData[31:0] <= CMVoltageCtl2;
      `CM_VOLTAGE_CTL3 : NextPRData[31:0] <= CMVoltageCtl3;
      `CM_VOLTAGE_CTL4 : NextPRData[31:0] <= {CMVoltageCtl4, 8'h00};
      `CM_VOLTAGE_CTL5 : NextPRData[31:0] <= {CMVoltageCtl5, 8'h00};
      `CM_VOLTAGE_CTL6 : NextPRData[31:0] <= {CMVoltageCtl6, 8'h00};
      `CM_VOLTAGE_CTL7 : NextPRData[31:0] <= {CMVoltageCtl7, 8'h00};
      `CT_PLD        : NextPRData[31:0] <= {PLDREAD[27:24], 15'b000000000000001, PLDREAD[28], 2'b00, CTPLDReg[9:0]};
      `RAW_INTA, `RAW_INTB : NextPRData[31:0] <= {24'h000000, 2'b00, RawIntReg, SoftIntReg};
      `IRQ_STATUS    : NextPRData[31:0] <= {24'h000000, 2'b00, IRQStatusReg};
      `FIQ_STATUS    : NextPRData[31:0] <= {24'h000000, 2'b00, FIQStatusReg};
      `IRQ_ENABLE    : NextPRData[31:0] <= {24'h000000, 2'b00, IRQEnableReg};
      `FIQ_ENABLE    : NextPRData[31:0] <= FIQEnableReg;
      `SOFT_INT      : NextPRData[31:0] <= {28'h0000000, 3'b000, SoftIntReg};
      default	    : NextPRData[31:0] <= 32'h00000000;
    endcase
end

//------------------------------------------------------------------------------
// When the peripheral is not being accessed, '0's are driven
// on the Read Databus (PRDATA) so as not to place any restrictions
// on the method of external bus connection. The external data buses of the
// peripherals on the APB may then be connected to the AxB-to-APB bridge using
// Muxed or ORed bus connection method.
//------------------------------------------------------------------------------
                            
always @(posedge PCLK or negedge PRESETn)
begin
  if (~PRESETn)
    PRDATA <= 32'h00000000;
  else
    PRDATA  <= NextPRData;
end

//------------------------------------
// CLOCKS       ----------------------
//------------------------------------

// There are 3 clock onboard clock generators.
// A - Auxiliary
// B - Bus
// C - Core

// The 3 clock devices share the data and clock lines
// (only the strobe in independant). Therefore, we must
// ensure an arbitration.

// Auxiliary clock control         
//------------------------
assign OSC0_VECTOR = {13'b0000000000000, CMAuxOscReg[18:0]};

assign OSC1_VECTOR = 32'h00000000;

// Core clock control
//-------------------
assign OSC2_VECTOR = {13'b0000000000000, CMOscReg[18:0]};

//------------------------------------
// POWER SUPPLY ----------------------
//------------------------------------

// *****************************************************************************************************
// *   MAPPING OF THE REGISTERS                                                                        *
// *****************************************************************************************************
// *                               *31                    20*19                     8*7               0*
// *****************************************************************************************************
// * CM_VOLTAGE_CTL7, CM_BASE+0xAC *  reads VDDTP           *    reads VDDIO         *    reserved     *
// *****************************************************************************************************
// * CM_VOLTAGE_CTL6, CM_BASE+0xA8 *  reads VDDPLL2         *    reads VDDPLL1       *    reserved     *
// *****************************************************************************************************
// * CM_VOLTAGE_CTL5, CM_BASE+0xA4 *  reads VDDCORE_DIFF6   *    reads VDDCORE6      *    reserved     *
// *****************************************************************************************************
// * CM_VOLTAGE_CTL4, CM_BASE+0xA0 *  reads VDDCORE_DIFF5   *    reads VDDCORE5      *    reserved     *
// *****************************************************************************************************
// * CM_VOLTAGE_CTL3, CM_BASE+0x8C *  reads VDDCORE_DIFF4   *    reads VDDCORE4      *    reserved     *
// *****************************************************************************************************
// * CM_VOLTAGE_CTL2, CM_BASE+0x88 *  reads VDDCORE_DIFF3   *    reads VDDCORE3      *   Sets VDDCOREC *
// *****************************************************************************************************
// * CM_VOLTAGE_CTL1, CM_BASE+0x84 *  reads VDDCORE_DIFF2   *    reads VDDCORE2      *   Sets VDDCOREB *
// *****************************************************************************************************
// * CM_VOLTAGE_CTL0, CM_BASE+0x80 *  reads VDDCORE_DIFF1   *    reads VDDCORE1      *   Sets VDDCOREA *
// *****************************************************************************************************

assign PLDSET[7:0]   = CMVoltageCtl0[7:0];
assign PLDSET[15:8]  = CMVoltageCtl1[7:0];
assign PLDSET[23:16] = CMVoltageCtl2[7:0];
assign PLDSET[26:24] = CMVoltageCtl3[2:0];

// process to read all of ADC channels (long total cycle time)
// Vector current channel into correct register
// Set Core voltage DAC value in CM_VOLTAGE_CTL4/5/6/7. Read only, not used
always @(posedge CLKREF24MHZ or negedge PRESETn)
begin
  if (~PRESETn)	begin
    CMVoltageCtl0[31:8] <= 24'h000000;
    CMVoltageCtl1[31:8] <= 24'h000000;
    CMVoltageCtl2[31:8] <= 24'h000000;
    CMVoltageCtl3[31:8] <= 24'h000000;
    CMVoltageCtl4[31:8] <= 24'h000000;
    CMVoltageCtl5[31:8] <= 24'h000000;
    CMVoltageCtl6[31:8] <= 24'h000000;
    CMVoltageCtl7[31:8] <= 24'h000000;
  end else
    if (PLDSYNC)
      case (POWERCNT)
        3'b000 : begin
            CMVoltageCtl0[31:20] <= PLDREAD[11:0];  //VDDCORE1_DIFF
            CMVoltageCtl3[31:20] <= PLDREAD[23:12]; //VDDCORE4_DIFF
          end
        3'b001 : begin
            CMVoltageCtl1[31:20] <= PLDREAD[11:0];  //VDDCORE2_DIFF
            CMVoltageCtl4[31:20] <= PLDREAD[23:12]; //VDDCORE5_DIFF
          end
        3'b010 : begin
            CMVoltageCtl2[31:20] <= PLDREAD[11:0];  //VDDCORE3_DIFF
            CMVoltageCtl5[31:20] <= PLDREAD[23:12]; //VDDCORE6_DIFF
          end
        3'b011 : begin
            CMVoltageCtl0[19:8]  <= PLDREAD[11:0];  //VDDCORE1_SENSE
            CMVoltageCtl3[19:8]  <= PLDREAD[23:12]; //VDDCORE4_SENSE
          end
        3'b100 : begin
            CMVoltageCtl1[19:8]  <= PLDREAD[11:0];  //VDDCORE2_SENSE
            CMVoltageCtl4[19:8]  <= PLDREAD[23:12]; //VDDCORE5_SENSE
          end
        3'b101 : begin
            CMVoltageCtl2[19:8]  <= PLDREAD[11:0];  //VDDCORE3_SENSE
            CMVoltageCtl5[19:8]  <= PLDREAD[23:12]; //VDDCORE6_SENSE
          end
        3'b110 : begin
            CMVoltageCtl6[19:8]  <= PLDREAD[11:0];  //VDDPLL_SENSE
            CMVoltageCtl6[31:20] <= PLDREAD[23:12]; //VDDPLL2_SENSE
          end
        default : begin
            CMVoltageCtl7[19:8]  <= PLDREAD[11:0];  //VDDIO_SENSE
            CMVoltageCtl7[31:20] <= PLDREAD[23:12]; //TP_SENSE
          end
      endcase
end

assign POWERCNT = POWERCHN[2:0];

//----------------------------------------------------------------------------
// Purpose :  Integrator Core Module Interrupt Controller (APB peripheral)
//----------------------------------------------------------------------------

//---------------------------------------------------------------------------
//  Address offset parameters - see Reference Peripheral specification
//---------------------------------------------------------------------------
// bits 4:2 register
// bit  5   irq/fiq

// IRQ and FIQ outputs are the logical OR of all enabled interrupt sources
assign IRQi = (IRQStatusReg[0] | IRQStatusReg[1] | IRQStatusReg[2] | IRQStatusReg[3] | IRQStatusReg[4] | IRQStatusReg[5]);
assign FIQi = (FIQStatusReg[0] | FIQStatusReg[1] | FIQStatusReg[2] | FIQStatusReg[3] | FIQStatusReg[4] | FIQStatusReg[5]);

// Synchronise IRQi and FIQi to the rising edge of the clock and
// ensure interrupts are cleared during reset
always @(posedge PCLK or negedge PRESETn)
begin
  if (~PRESETn) begin
    IRQ <= 1'b0;
    FIQ <= 1'b0;
  end else begin
    IRQ <= IRQi;
    FIQ <= FIQi;
  end
end

// Status registers are the logical AND of the pending interrupts
// and the appropriate enable register
assign IRQStatusReg = ({RawIntReg, SoftIntReg} & IRQEnableReg);
assign FIQStatusReg = ({RawIntReg, SoftIntReg} & FIQEnableReg);

// Raw interrupts are registered on the rising edge of the clock
always @(posedge PCLK)
begin
  RawIntReg <= {VPBREGINT, VPBMAILBOXEMPTY, ARMMAILBOXFULL, COMMTX, COMMRX};
end

// Enable registers have seperate set and clear operations
always @(posedge PCLK or negedge PRESETn)
begin
  if (~PRESETn) begin
    IRQEnableReg <= 6'b000000;
    FIQEnableReg <= 6'b000000;
    SoftIntReg   <= 1'b0;
  end else
    if (PSEL & PWRITE & PENABLE) begin
      if (PADDR == `IRQ_ENABLES) // set IRQ enable bits
        IRQEnableReg <= PWDATA[5:0] | IRQEnableReg;

      if (PADDR == `FIQ_ENABLES) // set FIQ enable bits
        FIQEnableReg <= PWDATA[5:0] | FIQEnableReg;

      if (PADDR == `SOFT_INTS) // set soft interrupt bits
        SoftIntReg <= PWDATA[0] | SoftIntReg;

      if (PADDR == `IRQ_ENABLEC) // clear IRQ enable bits
        IRQEnableReg <= (~PWDATA[5:0]) & IRQEnableReg;

      if (PADDR == `FIQ_ENABLEC) // clear FIQ enable bits
        FIQEnableReg <= (~PWDATA[5:0]) & FIQEnableReg;

      if (PADDR == `SOFT_INTC) // clear soft interrupt bits
        SoftIntReg <= (~PWDATA[0]) & SoftIntReg;

    end
end

//------------------------------------------------------------------------------
// When the peripheral is not being accessed, '0's are driven
// on the Read Databus (PRDATA) so as not to place any restrictions
// on the method of external bus connection. The external data buses of the
// peripherals on the APB may then be connected to the ASB-to-APB bridge using
// Muxed or ORed bus connection method.
//------------------------------------------------------------------------------

assign HRDATACONFIG = `iPLLCONFIG;

endmodule
