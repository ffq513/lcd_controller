-------------------------------------------------------------
-- AC97
-- This file is a part of SoC Base Platform
-- 

-- Author : 
-- Copyright 2004  Seoul National University, Seoul, Korea
-- ALL RIGHTS RESERVED
--------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;


library Work;
use Work.AMBA.all;

-- synthesis translate_off

--library SoCBaseSim;
--use SoCBaseSim.AMBA.all;

-- synthesis translate_on

entity AC97_REC is
      Port (     
        PCLK    : in    std_logic;
        PRESETn : in    std_logic;
        
        pPIN    : in    APB_SlaveIn_Type;
        pPOUT   : out   APB_SlaveOut_Type;
              
        AC97IRQ : Out std_logic;

		  SUSPENDED_O : Out std_logic;

	     BIT_CLK_PAD_I : In std_logic;
        SYNC_PAD_O : Out std_logic;
        SDATA_PAD_O : Out std_logic;
        SDATA_PAD_I : In std_logic;
	     AC97_RESET_PAD_O : Out std_logic);
end AC97_REC;

architecture STRUCTURAL of AC97_REC is

    component AC97
      Port (
		  PWDATA  : In std_logic_vector(31 downto 0);
        PRDATA  : Out std_logic_vector(31 downto 0);
        PADDR   : In std_logic_vector(31 downto 0);
        PSELAC97 : In std_logic;
        PWRITE  : In std_logic;
        PENABLE : In std_logic;
        PRESETn : In std_logic;
        PCLK    : In std_logic;

        AC97IRQ : Out std_logic;

	     SUSPENDED_O : Out std_logic;

	     BIT_CLK_PAD_I : In std_logic;
        SYNC_PAD_O : Out std_logic;
        SDATA_PAD_O : Out std_logic;
        SDATA_PAD_I : In std_logic;
	     AC97_RESET_PAD_O : Out std_logic );
    end component;

begin

   uAC97: AC97
        port map(  
		  PWDATA	 => pPIN.pwdata,
        PRDATA	 => pPOUT.prdata,
        PADDR 	 => pPIN.paddr,
        PSELAC97 => pPIN.psel,
        PWRITE   => pPIN.pwrite,
        PENABLE  => pPIN.penable,
        PRESETn  => PRESETn,
        PCLK  =>  PCLK,

        AC97IRQ  => 	AC97IRQ,

		  SUSPENDED_O => SUSPENDED_O,

	     BIT_CLK_PAD_I =>  BIT_CLK_PAD_I,
        SYNC_PAD_O  => SYNC_PAD_O ,
        SDATA_PAD_O 	=>  SDATA_PAD_O,
        SDATA_PAD_I 	=> SDATA_PAD_I ,
		  AC97_RESET_PAD_O => AC97_RESET_PAD_O 
          );


end STRUCTURAL;
