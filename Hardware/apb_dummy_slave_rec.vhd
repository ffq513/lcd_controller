--------------------------------------------------------------
-- AHB Dummy Slave
-- This file is a part of AMBA package
-- 
-- Date : 2004. 04. 25
-- Author : Sanggyu, Park (Ph.D Candidate of SoEE, SNU)
-- Copyright 2004  Seoul National University, Seoul, Korea
-- ALL RIGHTS RESERVED
--------------------------------------------------------------

-- General Description
-- This component drives AHB Slave Output signals to 
-- default values.


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

entity APB_DUMMY_SLAVE_REC is
        
    port (
            PCLK    :   in std_logic;
            PRESETn :   in std_logic;
            pPIN    :   in APB_SlaveIn_Type;
            pPOUT   :   out APB_SlaveOut_Type
         );
end APB_DUMMY_SLAVE_REC;

architecture behavioral of APB_DUMMY_SLAVE_REC is
begin   
    
    pPOUT.prdata <= (others => '0');    
        
end behavioral;



