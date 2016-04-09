--------------------------------------------------------------------------------------
--  I2S Controller
--  This file is a part of SNU Base Platform Package
--
--  Date : 2005. 3. 10
--  Author : Kisun Kim (CoSoC, SNU)
--  Copyright 2004  Seoul National University(SNU)
--  ALL RIGHTS RESERVED
--------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_misc.all; 
use IEEE.std_logic_arith.all;

library Work;
use Work.all;

library Work;
use Work.AMBA.all;

-- synthesis translate_off   
library SoCBaseSim;
use SoCBaseSim.AMBA.all;
-- synthesis translate_on

entity I2S_REC is
    port (

        -- Control AHB Bus Clock & Reset
        PCLK 		: in	std_logic;
        PRESETn		: in    std_logic;

        -- Controller AHB Slave Interface
        pPIN 		: in    APB_SlaveIn_Type;
        pPOUT		: out   APB_SlaveOut_Type;

        -- I2S Interface
--      I2S_CLK : In std_logic;

        nI2SIRQ : Out std_logic;

        I2S_SD_I  : In std_logic;
        I2S_SCK_I : In std_logic;
        I2S_WS_I  : In std_logic;

        I2S_SD_O  : Out std_logic;
        I2S_SCK_O : Out std_logic;
        I2S_WS_O  : Out std_logic

    );
end I2S_REC;

architecture behavioral of I2S_REC is

component I2S 
     port  ( PWDATA  : In std_logic_vector(31 downto 0);
             PRDATA  : Out std_logic_vector(31 downto 0);
             PADDR   : In std_logic_vector(31 downto 0);
             PSELI2S : In std_logic;
             PWRITE  : In std_logic;
             PENABLE : In std_logic;
             PRESETn : In std_logic;
             PCLK    : In std_logic;

--             I2S_CLK : In std_logic;

             nI2SIRQ : Out std_logic;

             I2S_SD_I  : In std_logic;
             I2S_SCK_I : In std_logic;
             I2S_WS_I  : In std_logic;

             I2S_SD_O  : Out std_logic;
             I2S_SCK_O : Out std_logic;
             I2S_WS_O  : Out std_logic
           );

end component;


begin


I2SCTRL :  I2S
     port map ( 
             PWDATA=>pPIN.pwdata ,
             PRDATA=>pPOUT.prdata ,
             PADDR=>pPIN.paddr ,
             PSELI2S=>pPIN.psel ,
             PWRITE=>pPIN.pwrite ,
             PENABLE=>pPIN.penable ,
             PRESETn=>PRESETn ,
             PCLK => PCLK,

--           I2S_CLK 

             nI2SIRQ=>nI2SIRQ ,

             I2S_SD_I=>I2S_SD_I  ,
             I2S_SCK_I=>I2S_SCK_I ,
             I2S_WS_I=>I2S_WS_I  ,

             I2S_SD_O=>I2S_SD_O  ,
             I2S_SCK_O=>I2S_SCK_O ,
             I2S_WS_O=>I2S_WS_O  

             );

end behavioral;







