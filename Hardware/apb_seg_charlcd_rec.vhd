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

entity APB_SEG_CHARLCD_REC is
      Port (     
        PCLK    : in    std_logic;
        PRESETn : in    std_logic;
        
        pPIN    : in    APB_SlaveIn_Type;
        pPOUT   : out   APB_SlaveOut_Type;

        LCD_RS   : out std_logic;                                                    
        LCD_RW   : out std_logic;                                                    
        LCD_EN   : out std_logic;                                                    
        LCD_DATA : out std_logic_vector(7 downto 0);                                                    
	                                                    
        SEGOUT   : out std_logic_vector(7 downto 0);                                                    
        SEGCOM   : out std_logic_vector(7 downto 0);
        LED_OUT  : out std_logic_vector(7 downto 0));           
end APB_SEG_CHARLCD_REC;

architecture STRUCTURAL of APB_SEG_CHARLCD_REC is


    component apb_seg_charlcd
      Port(
	    PRESETn  : in std_logic;
	    PADDR    : in std_logic_vector(31 downto 0);
	    PCLK     : in std_logic;
	    PENABLE  : in std_logic;
	    PSEL     : in std_logic;
	    PWRITE   : in std_logic;
	    PWDATA   : in std_logic_vector(31 downto 0);
	    PRDATA   : out std_logic_vector(31 downto 0);
	
        LCDCLK   : in std_logic;                                                    
        LCD_RS   : out std_logic;                                                    
        LCD_RW   : out std_logic;                                                    
        LCD_EN   : out std_logic;                                                    
        LCD_DATA : out std_logic_vector(7 downto 0);                                                    
	                                                    
        SEGOUT   : out std_logic_vector(7 downto 0);                                                    
        SEGCOM   : out std_logic_vector(7 downto 0);
        LED_OUT  : out std_logic_vector(7 downto 0));                                                     
    end component;


begin

   U0 : apb_seg_charlcd
        port map(   PRESETn  => PRESETn,		PADDR    => pPIN.paddr,
				    PCLK     => PCLK,		    PENABLE  => pPIN.penable,
				    PSEL     => pPIN.psel,		PWRITE   => pPIN.pwrite,
				    PWDATA   => pPIN.pwdata,	PRDATA   => pPOUT.prdata,
		
			        LCDCLK   => PCLK,	        LCD_RS   => LCD_RS,   
			        LCD_RW   => LCD_RW,   	    LCD_EN   => LCD_EN,   
			        LCD_DATA => LCD_DATA, 
		                                 
			        SEGOUT   => SEGOUT,   	    SEGCOM   => SEGCOM,
			        LED_OUT  => LED_OUT

                );

end STRUCTURAL;





