--------------------------------------------------------------
-- Guarded Reset Generator
-- This file is a part of SoC Base Platform
-- 
-- Date : 2004. 04. 25
-- Author : Sanggyu, Park (Ph.D Candidate, SoEE, SNU) 
-- Copyright 2004  Seoul National University, Seoul, Korea
-- ALL RIGHTS RESERVED
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;

library Work;
    use Work.AMBA.all;

-- synthesis translate_off

library SoCBaseSim;
    use SoCBaseSim.AMBA.all;

-- synthesis translate_on

entity RESETGEN_REC is

   port (   -- AHB Bus Clock & Reset 
            HCLK      : in    std_logic;
            HRESETn  : in    std_logic;
          
            -- AHB Bus Slave Interface
            pSIN :  in AHB_SlaveIn_Type;
            pSOUT:  out AHB_SlaveOut_Type;
          
            -- Generated Reset Signal
            nPRST : out std_logic
          );
end RESETGEN_REC;

architecture BEHAVIORAL of RESETGEN_REC is
    component RESETGEN
        port ( HCLK   : in    std_logic;
          HRESETn  : in    std_logic;
          HSEL    : in    std_logic; 
          HADDR   : in    std_logic_vector (31 downto 0); 
          HTRANS  : in    std_logic_vector (1 downto 0); 
          HWDATA  : in    std_logic_vector (31 downto 0); 
          HWRITE  : in    std_logic;
          nPRST   : out   std_logic;
          HREADY  : out   std_logic;
          HRESP   : out   std_logic_vector(1 downto 0);
          HRDATA  : out   std_logic_vector(31 downto 0));
    end component;
begin

    -- HSPLIT added by Jinhyun, Cho @2005.8.11
    pSOUT.hsplit <= (others => '0');

    R0 : RESETGEN
        port map(   HCLK => HCLK,   HRESETn => HRESETn,
                    HSEL => pSIN.hsel  ,    HADDR => pSIN.haddr ,
                    HTRANS => pSIN.htrans,  HWDATA => pSIN.hwdata,
                    HWRITE => pSIN.hwrite,  HREADY => pSOUT.hready,
                    HRESP => pSOUT.hresp ,  HRDATA => pSOUT.hrdata,
                    nPRST => nPRST);

end BEHAVIORAL;



