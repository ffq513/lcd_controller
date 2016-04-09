--------------------------------------------------------------------------------------
--  SDRAM Controller
--  This file is a part of SNU Base Platform Package
--
--  Date : 2005. 4. 1
--  Author : Pyoung-woo, Lee (System Design Lab, SoEE, SNU)
--  Modifier : Sung-won, Kim (Center for SoC Design Technology)
--  Modifier : Kisun Kim     (Center for SoC Design Technology)
--  Copyright 2004  Seoul National University(SNU)
--  ALL RIGHTS RESERVED
--------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library Work;
	use Work.AMBA.all;

-- synthesis translate_off
--library SoCBaseSim;
--use SoCBaseSim.amba.all;
-- synthesis translate_on

entity SDRAM_CTRL_REC is 
	
	port(
		-- Channel 0 Slave Interface
		CH0_HCLK      : in  std_logic;
		CH0_HRESETn   : in  std_logic;
		CH0_SIN       : in  AHB_SlaveIn_Type;
		CH0_SOUT      : out AHB_SlaveOut_Type;
                HSEL_CON      : in  std_logic;

                SDRAM_Clk      : out std_logic;
                SDRAM_Cke      : out std_logic;
                SDRAM_Cs_n     : out   std_logic;
                SDRAM_Ras_n    : out   std_logic;
                SDRAM_Cas_n    : out   std_logic;
                SDRAM_We_n     : out   std_logic;
                SDRAM_Ba       : out   std_logic_vector (1 downto 0);
                SDRAM_Addr     : out   std_logic_vector (12 downto 0);
                SDRAM_m_D      : OUT   STD_LOGIC_VECTOR (31 DOWNTO 0);
                SDRAM_m_q      : IN    STD_LOGIC_VECTOR (31 DOWNTO 0);
                SDRAM_m_outsel : OUT   STD_LOGIC;
                SDRAM_ODQM     : OUT   STD_LOGIC_VECTOR (3 DOWNTO 0)
    );	
end SDRAM_CTRL_REC;

architecture behavioral of SDRAM_CTRL_REC is

	component SDRAM_CTRL	
		
		port(
			-- ahb interface
			HCLK     : in std_logic;
			HRESETn  : in std_logic;
			HSEL     : in std_logic;
			HSEL_CON : in std_logic;
			HADDR    : in std_logic_vector(31 downto 0);
			HTRANS   : in std_logic_vector(1 downto 0);
			HSIZE    : in std_logic_vector(2 downto 0);
			HBURST   : in std_logic_vector(2 downto 0);
			HWRITE   : in std_logic;
			HWDATA   : in std_logic_vector(31 downto 0);
                        HREADYin : in std_logic;
			HRDATA   : out  std_logic_vector(31 downto 0);
			HREADY   : out  std_logic;
			HRESP    : out  std_logic_vector(1 downto 0);
--			HSPLIT   : out  std_logic_vector(15 downto 0);
			
			-- memctl
                        SDRAM_Clk       : OUT   STD_LOGIC;
                        SDRAM_Cke       : OUT   STD_LOGIC;
                        SDRAM_Cs_n      : OUT   STD_LOGIC;
                        SDRAM_Ras_n 	: OUT   STD_LOGIC;
                        SDRAM_Cas_n 	: OUT   STD_LOGIC;
                        SDRAM_We_n  	: OUT   STD_LOGIC;
                        SDRAM_Ba    	: OUT   STD_LOGIC_VECTOR (1 DOWNTO 0);
                        SDRAM_Addr  	: OUT   STD_LOGIC_VECTOR (12 DOWNTO 0);
                        SDRAM_D         : OUT   STD_LOGIC_VECTOR (31 DOWNTO 0);
      SDRAM_q           : IN    STD_LOGIC_VECTOR (31 DOWNTO 0);
      SDRAM_outsel			: OUT   STD_LOGIC;
      SDRAM_ODQM        : OUT   STD_LOGIC_vector (3 downto 0)
		);	
	end component;


begin

	CTRL0 : SDRAM_CTRL
		port map(
                          HCLK        => CH0_hclk,        HRESETn  => CH0_hresetn,
                          HSEL        => CH0_SIN.hsel,    HSEL_CON => HSEL_CON,
                          HADDR       => CH0_SIN.haddr,   HTRANS  => CH0_SIN.htrans,
                          HSIZE       => CH0_SIN.hsize,   HBURST  => CH0_SIN.hburst,
                          HWRITE      => CH0_SIN.hwrite,  HWDATA  => CH0_SIN.hwdata,
                          HRDATA      => CH0_SOUT.hrdata, HREADY  => CH0_SOUT.hready,
                          HRESP       => CH0_SOUT.hresp,  HREADYin => CH0_SIN.HREADYin, 
                          -- HSPLIT   => CH0_SOUT.hsplit,
                          SDRAM_Clk   => SDRAM_Clk,
                          SDRAM_Cke   => SDRAM_Cke,   SDRAM_Cs_n   => SDRAM_Cs_n, 		
                          SDRAM_Ras_n => SDRAM_Ras_n, SDRAM_Cas_n  => SDRAM_Cas_n, 	
                          SDRAM_We_n  => SDRAM_We_n,  SDRAM_Ba     => SDRAM_Ba,    	
                          SDRAM_Addr  => SDRAM_Addr,  SDRAM_D      => SDRAM_m_D,
                          SDRAM_q     => SDRAM_m_q,   SDRAM_outsel => SDRAM_m_outsel,
                          SDRAM_ODQM  => SDRAM_ODQM
		);                  

end behavioral;
