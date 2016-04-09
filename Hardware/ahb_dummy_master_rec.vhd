--------------------------------------------------------------
-- AHB Dummy Master
-- This file is a part of AMBA package
-- 
-- Date : 2004. 04. 25
-- Author : Sanggyu, Park (Ph.D Candidate of SoEE, SNU)
-- Copyright 2004  Seoul National University, Seoul, Korea
-- ALL RIGHTS RESERVED
--------------------------------------------------------------

-- General Description
-- This component drives AHB Master Output signals to 
-- default values.


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;


library Work;
use Work.AMBA.all;

-- synthesis translate_off

---library SoCBaseSim;
--use SoCBaseSim.AMBA.all;

-- synthesis translate_on

entity AHB_DUMMY_MASTER_REC is      
    port (
            HCLK    :   in std_logic;
            HRESETn :   in std_logic;
            pMIN    :   in AHB_MasterIn_Type;                                   
            pMOUT   :   out AHB_MasterOut_Type                          
         );
end AHB_DUMMY_MASTER_REC;

architecture behavioral of AHB_DUMMY_MASTER_REC is
begin
    
    pMOUT.hlock <= '0';
    pMOUT.htrans <= "00";
    pMOUT.haddr <= (others => '0');
    pMOUT.hwrite <= '0';
    pMOUT.hsize <= "000";
    pMOUT.hburst <= "000";
    pMOUT.hprot <= "0000";
    pMOUT.hwdata <= (others => '0');
    pMOUT.hbusreq <= '0';
    
end behavioral;





