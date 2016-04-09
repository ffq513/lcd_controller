--------------------------------------------------------------------------------------
--  TFT-LCD Controller
--  This file is a part of SNU Base Platform Package
--
--  Date : 2004. 7. 15
--  Author : Sanggyu, Park (System design lab, SoEE, SNU)
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

entity TFTLCDCTRL_REC is
    port (

        -- Control AHB Bus Clock & Reset
        HCLK 		: in	std_logic;
        HRESETn		: in    std_logic;

        -- Controller AHB Slave Interface
        pSIN 		: in    AHB_SlaveIn_Type;
        pSOUT		: out   AHB_SlaveOut_Type;

        -- DMA AHB Master Interface
        pMIN		: in    AHB_MasterIn_Type;
        pMOUT		: out 	AHB_MasterOut_Type;

        -- TFT LCD Interface
        LCD_D		: out 	std_logic_vector(15 downto 0);
        LCD_VSYNC	: out 	std_logic;
        LCD_HSYNC	: out 	std_logic;
        LCD_DE		: out 	std_logic;
        LCD_CLK		: out 	std_logic;
        LCD_LEND	: out 	std_logic

    );
end TFTLCDCTRL_REC;

architecture tftlcdctrl_arch of TFTLCDCTRL_REC is

    component TFTLCDCTRL
        port (
            -- Controller AHB slave Interface
            HCLK:        in std_logic;
            HRESETn:    in std_logic;

            HSEL :        in std_logic;
            HADDR :    in std_logic_vector(31 downto 0);
            HWRITE :    in std_logic;
            HTRANS :    in std_logic_vector(1 downto 0);
            HSIZE :    in std_logic_vector(2 downto 0);
            HBURST :    in std_logic_vector(2 downto 0);
            HWDATA :    in std_logic_vector(31 downto 0);
            HREADY :    out std_logic;
            HRDATA :    out std_logic_vector(31 downto 0);
            HRESP  :    out std_logic_vector(1 downto 0);            

            DGRANT:        in std_logic;
            DREADY:        in std_logic;
            DRESP :        in std_logic_vector(1 downto 0);
            DRDATA:        in std_logic_vector(31 downto 0);

            DBUSREQ:    out std_logic;
            DLOCK:        out std_logic;
            DTRANS:        out std_logic_vector(1 downto 0);
            DADDR:        out std_logic_vector(31 downto 0);
            DWRITE:        out std_logic;
            DSIZE:        out std_logic_vector(2 downto 0);
            DBURST:        out std_logic_vector(2 downto 0);
            DPROT:        out std_logic_vector(3 downto 0);
            -- DWRITE:        out std_logic_vector(31 downto 0);  -- DWRITE signal is not needed

            -- TFT LCD Interface
            LCD_D:        out std_logic_vector(15 downto 0);
            LCD_VSYNC:    out std_logic;
            LCD_HSYNC:    out std_logic;
            LCD_DE:        out std_logic;
            LCD_CLK:    out std_logic;
            LCD_LEND:    out std_logic

        );
    end component;


begin

    pSOUT.hsplit <= (others => '0');

    LCD0 : TFTLCDCTRL
        port map(
            HCLK => HCLK,            	HRESETn => HRESETn,

            HSEL => pSIN.HSEL ,    		HADDR => pSIN.HADDR ,
            HWRITE => pSIN.HWRITE , 	HTRANS => pSIN.HTRANS ,
            HSIZE => pSIN.HSIZE ,    	HBURST => pSIN.HBURST ,
            HWDATA => pSIN.HWDATA , 	HREADY => pSOUT.HREADY ,
            HRDATA => pSOUT.HRDATA ,	HRESP  => pSOUT.HRESP  ,
            
            DGRANT => pMIN.HGRANT,    	DREADY => pMIN.HREADY,
            DRESP => pMIN.HRESP ,    	DRDATA => pMIN.HRDATA,
            DBUSREQ => pMOUT.HBUSREQ,	DLOCK => pMOUT.HLOCK,
            DTRANS => pMOUT.HTRANS,    	DADDR => pMOUT.HADDR,
            DWRITE => pMOUT.HWRITE,    	DSIZE => pMOUT.HSIZE,
            DBURST => pMOUT.HBURST,    	DPROT => pMOUT.HPROT,

            LCD_D => LCD_D,            	LCD_VSYNC => LCD_VSYNC,
            LCD_HSYNC => LCD_HSYNC,    	LCD_DE => LCD_DE,
            LCD_CLK => LCD_CLK,        	LCD_LEND => LCD_LEND);

    pMOUT.HWDATA <= (others => '0');

end tftlcdctrl_arch;







