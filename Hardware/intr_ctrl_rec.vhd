--------------------------------------------------------------
-- Interrupt Controller
-- This file is a part of SoC Base Platform
-- 
-- Date : 2004. 04. 25
-- Author : Sanggyu, Park (Ph.D Candidate, SoEE, SNU) 
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

entity INTR_CTRL_REC is
    Port (   
            -- APB Bus Clock 
            PCLK    : in    std_logic;
            PRESETn : in    std_logic;
            
            -- APB Slave Interface
            pPIN    : in    APB_SlaveIn_Type;
            pPOUT   : out   APB_SlaveOut_Type;
              
            -- Interrupt control interface
            INT_REQn : in   std_logic_vector(23 downto 0);
            INT_ACKn : out  std_logic_vector(23 downto 0);
            INT_IRQ  : out  std_logic;
            INT_FIQ  : out  std_logic
      );
end INTR_CTRL_REC;

architecture BEHAVIORAL of INTR_CTRL_REC is

    component INTR_CTRL
        Port (   
                -- APB Interface 
                PADDR   : In    std_logic_vector (15 downto 0);
                PCLK    : In    std_logic;
                PENABLE : In    std_logic;
                PSEL    : In    std_logic;
                PWDATA  : In    std_logic_vector (31 downto 0);
                PWRITE  : In    std_logic;
                PRESETn : In    std_logic;
                PRDATA  : Out   std_logic_vector (31 downto 0);             
              
                -- Interrupt control interface
                INT_REQn : IN    std_logic_vector(23 downto 0);
                INT_ACKn  : OUT   std_logic_vector(23 downto 0);
                INT_IRQ  : OUT  std_logic;
                INT_FIQ  : OUT  std_logic
              );
    end component;  

begin

    I0 : INTR_CTRL
        port map(   PCLK => PCLK,   PRESETn => PRESETn,

                    PADDR   => pPIN.paddr(15 downto 0), PENABLE => pPIN.penable,
                    PSEL    => pPIN.psel,   PWDATA  => pPIN.pwdata,
                    PWRITE  => pPIN.pwrite, PRDATA => pPOUT.prdata,

                    INT_REQn => INT_REQn,   INT_ACKn => INT_ACKn,
                    INT_IRQ  => INT_IRQ,    INT_FIQ  => INT_FIQ); 
                

end BEHAVIORAL;



