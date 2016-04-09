--------------------------------------------------------------
-- UART (Universal Asynchronous Receiver/Transmitter
-- This file is a part of SoC Base Platform
-- 
-- Date : 2004. 04. 25
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

entity UART_REC is
      Port (     
        PCLK    : in    std_logic;
        PRESETn : in    std_logic;
        
        pPIN    : in    APB_SlaveIn_Type;
        pPOUT   : out   APB_SlaveOut_Type;
              
        CTS     : in    std_logic;               
        RXD     : in    std_logic;
        RTS     : out   std_logic;
        TXD     : out   std_logic;
        UARTR   : out   std_logic;
        UARTT   : out   std_logic );
end UART_REC;

architecture STRUCTURAL of UART_REC is

    component UART
      Port (     PCLK : In    std_logic;
                 CTS : In    std_logic;
               PADDR : In    std_logic_vector (31 downto 0);
             PENABLE : In    std_logic;
                PSEL : In    std_logic;
              PWDATA : In    std_logic_vector (31 downto 0);
              PWRITE : In    std_logic;
               PRESETn: In    std_logic;
                 RXD : In    std_logic;
              PRDATA : Out   std_logic_vector (31 downto 0);
                 RTS : Out   std_logic;
                 TXD : Out   std_logic;
               UARTR : Out   std_logic;
               UARTT : Out   std_logic );
    end component;

begin

   U0 : UART
        port map(   PCLK => PCLK,               PRESETn => PRESETn,                 
                    PADDR => pPIN.paddr,        PENABLE => pPIN.penable,
                    PSEL => pPIN.psel,          PWDATA => pPIN.pwdata,
                    PWRITE => pPIN.pwrite,      PRDATA => pPOUT.prdata,
                    CTS => CTS,                 RXD => RXD,
                    RTS => RTS,                 TXD => TXD, 
                    UARTR => UARTR,             UARTT => UARTT
                );


end STRUCTURAL;





