--------------------------------------------------------------
-- 3 Channel Timer
-- This file is a part of SoC Base Platform
-- 
-- Date : 2004. 04. 25
-- Author : 
-- Copyright 2004  Seoul National University, Seoul, Korea
-- ALL RIGHTS RESERVED
--------------------------------------------------------------

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;
   

library Work;
use Work.AMBA.all;

-- synthesis translate_off

--library SoCBaseSim;
--use SoCBaseSim.AMBA.all;

-- synthesis translate_on

entity TIMER_REC is
      Port (    
                -- Clock & Reset Signals
                PCLK    :   in    std_logic;
                PRESETn :   in    std_logic;
                TIMER_CLK : in    std_logic;
                
                -- APB Slave Interface
                pPIN    :   in  APB_SlaveIn_Type;
                pPOUT   :   out APB_SlaveOut_Type;
                
                -- Interrupt Signals
                TIMER_INT : out   std_logic;
                TIMER_INT0 :out   std_logic;
                TIMER_INT1 :out   std_logic;
                TIMER_INT2 :out   std_logic      
                );
end TIMER_REC;


architecture STRUCTURAL of TIMER_REC is

    component TIMER
      Port (   PADDR : In    std_logic_vector (31 downto 0);
                PCLK : In    std_logic;
             PENABLE : In    std_logic;
              PRESETn : In    std_logic;
                PSEL : In    std_logic;
              PWDATA : In    std_logic_vector (31 downto 0);
              PWRITE : In    std_logic;
             TIMER_CLK : In    std_logic;
              PRDATA : Out   std_logic_vector (31 downto 0);
             TIMER_INT : Out   std_logic;
             TIMER_INT0 : Out   std_logic;
             TIMER_INT1 : Out   std_logic;
             TIMER_INT2 : Out   std_logic );
    end component;
        
begin
    
    T0 : TIMER
        port map(   PCLK => PCLK,   PRESETn => PRESETn,
                    TIMER_CLK => TIMER_CLK,
                    
                    PADDR => pPIN.paddr,    PENABLE => pPIN.penable,
                    PSEL => pPIN.psel,      PWDATA => pPIN.pwdata,
                    PWRITE => pPIN.pwrite,  PRDATA => pPOUT.prdata,
                    TIMER_INT => TIMER_INT, TIMER_INT0 => TIMER_INT0,
                    TIMER_INT1 => TIMER_INT1,   TIMER_INT2 => TIMER_INT2
                );
    

end STRUCTURAL;
