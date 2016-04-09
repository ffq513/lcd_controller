--------------------------------------------------------------
-- socmaster3_socbase_top module
-- 
-- Date : 2005. 
-- Author : 
-- Copyright 2005  Seoul National University, Seoul, Korea
-- ALL RIGHTS RESERVED
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.ALL;
library unisim;
 use unisim.vcomponents.all;

--library Work;
--  use Work.AMBA.all;

-- synthesis translate_off
--library SoCBaseSim;
--use SoCBaseSim.AMBA.all;
-- synthesis translate_on

entity socmaster3_socbase_top is
   port (   -- CLK IN & OUT
            CLK2         : in std_logic;
            CLK_24MHZ    : in std_logic;
            
            -- HDRX/Y/Z/B
            XU           : inout std_logic_vector(179 downto 0);       
            PLDO         : in std_logic;
            DATACTL0x    : out std_logic;
            DATACTL1x    : out std_logic;
            DATACTL2x    : out std_logic;
            PLDI         : out std_logic;
            PLDCLK       : out std_logic;
           

            -- Ext.Async SRAM interface
            MEM_ADDR        : out std_logic_vector(23 downto 0);       
            MEM_F_0x        : out std_logic; --fixed to '1'
            MEM_FLASH_NBYTE : out std_logic;
            MEM_FLASH_nCS1  : out std_logic;
            MEM_nBE         : out std_logic_vector(3 downto 0);       
            MEM_OE          : out std_logic;
            MEM_SRAM_nCS0   : out std_logic;
            --MEM_DATA        : inout std_logic_vector(31 downto 0);       
            MEM_DATA        : inout std_logic_vector(31 downto 0);       
            MEM_WE          : out std_logic;

            -- USB
            USB_nCS		  : out std_logic; -- async io_cs0
            USB_nWR         : out std_logic; -- async wen
            USB_nRD         : out std_logic; -- async oen
            USB_INT         : in std_logic; -- irq(14)
            USB_WAKEUP      : out std_logic; -- '1'
            USB_DRQ         : out std_logic_vector(1 downto 0); -- "00"
            USB_DACK        : out std_logic_vector(1 downto 0); -- "11"
            USB_EPT         : out std_logic_vector(1 downto 0); -- "11"

            -- SDRAM interface
            SDRAM_Clk    : out std_logic_vector(1 downto 0);       
            SDRAM_Cke    : out std_logic;
            SDRAM_Csn    : out std_logic;
            SDRAM_Rasn   : out std_logic;
            SDRAM_Casn   : out std_logic;
            SDRAM_Wen    : out std_logic;
            SDRAM_Ba     : out std_logic_vector(1 downto 0);       
            SDRAM_Addr   : out std_logic_vector(12 downto 0);       
            SDRAM_ODQM   : out std_logic_vector(3 downto 0);       
            SDRAM_DATA   : inout std_logic_vector(31 downto 0);       


            -- Misc
            LEDS : out std_logic_vector(7 downto 0);       
            SW_in   : in std_logic_vector(7 downto 0);       

            -- UART
            RXD0  : in std_logic;
            CTS0  : in std_logic;
            RTS0  : out std_logic;
            TXD0  : out std_logic;

            RXD1  : in std_logic;
            CTS1  : in std_logic;
            RTS1  : out std_logic;
            TXD1  : out std_logic;

				LCD_D     : out std_logic_vector(15 downto 0);
            LCD_VSYNC : out std_logic;
            LCD_HSYNC : out std_logic;
            LCD_DE	 : out std_logic;
            LCD_CLK	 : out std_logic;
            LCD_LEND	 : out std_logic;
			 LCD_BK_ON : out std_logic;
			   -- LCD & 7SEGMENT

        LCD_RS   : out std_logic;
        LCD_RW   : out std_logic;
        LCD_EN   : out std_logic;
        LCD_DATA : out std_logic_vector(7 downto 0);
	
        SEGOUT   : out std_logic_vector(7 downto 0);
        SEGCOM   : out std_logic_vector(7 downto 0);

--ethernet interface
		  ETH_ADDR        : Out std_logic_vector (14 downto 0);
          ETH_DATA        : Inout std_logic_vector (15 downto 0);
		  ETH_nCS3	: out std_logic;
		  ETH_OE		: out	std_logic;
		  ETH_WE		: out	std_logic;
		  ETH_nRESET : out	std_logic;
		  ETH_LCLK : out	std_logic;
		  ETH_BE : out	std_logic_vector(1 downto 0);
		  ETH_IRQ   : in	std_logic;

		  		-- AC97
			 AC97_BCLK : in std_logic;
			 AC97_SYNC : out std_logic;
			 AC97_SDO : out std_logic;
			 AC97_SDI : in std_logic;
			 AC97_RST : out std_logic;

 			-- I2S
			 I2S_SD_I  : In std_logic;
          I2S_SCK_I : In std_logic;
          I2S_WS_I  : In std_logic;

          I2S_SD_O  : Out std_logic;
          I2S_SCK_O : Out std_logic;
          I2S_WS_O  : Out std_logic;

			 I2S_SD_I_1  : In std_logic;
          I2S_SCK_I_1 : In std_logic;
          I2S_WS_I_1  : In std_logic;

          I2S_SD_O_1  : Out std_logic;
          I2S_SCK_O_1 : Out std_logic;
          I2S_WS_O_1  : Out std_logic;

            -- Resets
            nSYSPOR_in : in std_logic;
            nSYSRST : inout std_logic;
            nRESET : in std_logic;

      		-- Camera Interface
			CMCLK   : out   std_logic;
			CRESETB : out   std_logic;
			CENB    : out   std_logic;
			CSCL    : inout std_logic;
			CSDA    : inout std_logic;
			CVCLK   : in    std_logic;
			CVSYNC  : in    std_logic;
			CHSYNC  : in    std_logic;
			CY      : in    std_logic_vector( 7 downto 0);
			
			CLK_PLL : in std_logic;
            DL_WIRE_in  : in std_logic;
            DL_WIRE_out : out std_logic
          );
end socmaster3_socbase_top;


architecture BEHAVIORAL of socmaster3_socbase_top is

    --------------------------------------------------
    -- components
    --------------------------------------------------

    -- Global Clk buffer
    component BUFG
        port ( 
               I : in std_logic;
               O : out std_logic
             );
    end component;

    -- Clock divider/shifter
    component DCM_BASE
        port ( 
               CLK0     : out std_logic;
               CLK180   : out std_logic;
               CLK270   : out std_logic;
               CLK2X    : out std_logic;
               CLK2X180 : out std_logic;
               CLK90    : out std_logic;
               CLKDV    : out std_logic;
               CLKFX    : out std_logic;
               CLKFX180 : out std_logic;
               LOCKED   : out std_logic;
               CLKFB    : in std_logic;
               CLKIN    : in std_logic;
               RST      : in std_logic
             );
    end component;

    -- SoCbase core
    component vpbGTC
        port ( 
               -- Test chip signals (CT)
               ARM_HWDATA     : in std_logic_vector(31 downto 0);
               ARM_HRDATA     : out std_logic_vector(31 downto 0);
               ARM_HCLKIN     : out std_logic;
               ARM_REFCLK     : out std_logic;
               ARM_HCLK       : in std_logic;
               ARM_HSIZE      : in std_logic_vector(2 downto 0);
               ARM_HTRANS     : in std_logic_vector(1 downto 0);
               ARM_HPROT      : in std_logic_vector(3 downto 0);
               ARM_HBURST     : in std_logic_vector(2 downto 0);
               ARM_HWRITE     : in std_logic;
               ARM_HBUSREQ    : in std_logic;
               ARM_HLOCK      : in std_logic;
               ARM_HREADY     : out std_logic;
               ARM_HGRANT     : out std_logic;
               ARM_HRESP      : out std_logic_vector(1 downto 0);
               ARM_BIGENDIN   : out std_logic;
               ARM_BIGENDOUT  : in std_logic;
               ARM_COMMRX     : in std_logic;
               ARM_COMMTX     : in std_logic;
               ARM_CONFIGINIT : out std_logic;
               ARM_DBGACK     : in std_logic;
               ARM_DBGEN      : out std_logic;
               ARM_nFIQ       : out std_logic;
               ARM_nIRQ       : out std_logic;
               ARM_nRESET     : out std_logic;
               ARM_nPORESET   : out std_logic;
               ARM_nCONFIGRST : out std_logic;
               ARM_ETMEXTIN   : out std_logic;
               ARM_ETMEXTOUT  : in std_logic;
               ARM_VINITHI    : out std_logic;
               ARM_PLLLOCK    : in std_logic;
               ARM_PLLBYPASS  : out std_logic;
               ARM_INITRAM    : out std_logic;
               ARM_HCLKDIV    : out std_logic_vector(2 downto 0);
               ARM_EDBGRQ     : out std_logic;
               ARM_DEWPT      : out std_logic;
               ARM_IEBKPT     : out std_logic;
               ARM_USERIN     : out std_logic_vector(5 downto 0);
               ARM_USEROUT    : in std_logic_vector(5 downto 0);
               ARM_PLLCTRL    : out std_logic_vector(1 downto 0);
               ARM_PLLREFDIV  : out std_logic_vector(3 downto 0);
               ARM_HADDR      : in std_logic_vector(31 downto 0);
               ARM_TESTSELECT : out std_logic;
               ARM_TICSELECT  : out std_logic;
               ARM_PLLFBDIV   : out std_logic_vector(7 downto 0);
               ARM_PLLOUTDIV  : out std_logic_vector(3 downto 0);
               ARM_EXTTRIG    : in std_logic;
               ARM_HRDATAEN   : out std_logic;

               -- CT PLD control
               PLDSET   : out std_logic_vector(36 downto 0);
               PLDREAD  : in std_logic_vector(28 downto 0);
               POWERCHN : inout std_logic_vector(2 downto 0);
               PLDSYNC  : in std_logic;

               -- Clock & Reset
               nSYSPOR     : in std_logic;
               nSYSRST     : in std_logic;
               CLK2        : in std_logic;
               CLK_24MHZ   : in std_logic;
               SW          : in std_logic_vector(4 downto 0);
               OSC0_VECTOR : out std_logic_vector(31 downto 0);
               OSC1_VECTOR : out std_logic_vector(31 downto 0);
               OSC2_VECTOR : out std_logic_vector(31 downto 0);
               LED         : out std_logic_vector(7 downto 0);
               MAN_ID      : in std_logic_vector(3 downto 0);


               -- Ext.Async Memory
               MEM_ADDR        : out std_logic_vector(23 downto 0);
               MEM_FLASH_NBYTE : out std_logic;
               MEM_FLASH_nCS1  : out std_logic;
               MEM_nBE         : out std_logic_vector(3 downto 0);
               MEM_OE          : out std_logic;
               MEM_SRAM_nCS0   : out std_logic;
               MEM_DATA        : inout std_logic_vector(31 downto 0);
               MEM_WE          : out std_logic;

               -- USB
               USB_nCS         : out std_logic; -- async io_cs0
               USB_nWR         : out std_logic; -- async wen
               USB_nRD         : out std_logic; -- async oen
               USB_INT         : in std_logic; -- irq(14)
               USB_WAKEUP      : out std_logic; -- '1'
               USB_DRQ         : out std_logic_vector(1 downto 0); -- "00"
               USB_DACK        : out std_logic_vector(1 downto 0); -- "11"
               USB_EPT         : out std_logic_vector(1 downto 0); -- "11"

			 HSLAVEID_out 			: out std_logic_vector(3 downto 0);
			 slave_hready : out std_logic_vector(9 downto 0);

               -- UART
               TXD0 : out std_logic;
               RTS0 : out std_logic;
               RXD0 : in std_logic;
               CTS0 : in std_logic;

               TXD1 : out std_logic;
               RTS1 : out std_logic;
               RXD1 : in std_logic;
               CTS1 : in std_logic;

               -- Timer
               Timer_Clk : in std_logic;

					          -- SDRAM 
          SDRAM_Clk  : out std_logic;
          SDRAM_Cke  : out std_logic;
          SDRAM_Csn  : out std_logic;
          SDRAM_Rasn : out std_logic;
          SDRAM_Casn : out std_logic;
          SDRAM_Wen  : out std_logic;
          SDRAM_Ba   : out std_logic_vector(1 downto 0);
          SDRAM_Addr : out std_logic_vector(12 downto 0);
          SDRAM_ODQM : out std_logic_vector(3 downto 0);
          SDRAM_DATA : inout std_logic_vector(31 downto 0);

			 -- LCD OUT
			 LCD_D     : out std_logic_vector(15 downto 0);
          LCD_VSYNC : out std_logic;
          LCD_HSYNC : out std_logic;
          LCD_DE	 : out std_logic;
          LCD_CLK	 : out std_logic;
          LCD_LEND	 : out std_logic;

		   -- EBI
          EBI_ADDR:       out std_logic_vector(31 downto 0);
          EBI_CS:         out std_logic_vector(3 downto 0);
          EBI_OE:         out std_logic;
          EBI_WE:         out std_logic_vector(3 downto 0);
          EBI_BWE:        out std_logic_vector(3 downto 0);
          EBI_DATA :       inout std_logic_vector(31 downto 0);
   		 EBI_IRQ :	in std_logic;


			 -- LCD & 7SEGMENT
        LCD_RS   : out std_logic;
        LCD_RW   : out std_logic;
        LCD_EN   : out std_logic;
        LCD_DATA : out std_logic_vector(7 downto 0);
	
        SEGOUT   : out std_logic_vector(7 downto 0);
        SEGCOM   : out std_logic_vector(7 downto 0);

			-- AC97
			 AC97_BCLK : in std_logic;
			 AC97_SYNC : out std_logic;
			 AC97_SDO : out std_logic;
			 AC97_SDI : in std_logic;
			 AC97_RST : out std_logic;

			-- I2S
			 I2S_SD_I  : In std_logic;
          I2S_SCK_I : In std_logic;
          I2S_WS_I  : In std_logic;

          I2S_SD_O  : Out std_logic;
          I2S_SCK_O : Out std_logic;
          I2S_WS_O  : Out std_logic;
			 I2S_SD_I_1  : In std_logic;
          I2S_SCK_I_1 : In std_logic;
          I2S_WS_I_1  : In std_logic;

          I2S_SD_O_1  : Out std_logic;
          I2S_SCK_O_1 : Out std_logic;
          I2S_WS_O_1  : Out std_logic;

		-- gen reset
			 gen_reset : out std_logic;


      		-- Camera Interface
      		

			CMCLK   : out   std_logic;
			CRESETB : out   std_logic;
			CENB    : out   std_logic;
			CSCL    : inout std_logic;
			CSDA    : inout std_logic;
			CVCLK   : in    std_logic;
			CVSYNC  : in    std_logic;
			CHSYNC  : in    std_logic;
			CY      : in    std_logic_vector( 7 downto 0)

             );
    end component;

    -- Serial stream for FPGA side of CT-GTC PLD config.
    component serialstream
        port ( 
               -- Serial stream to/from PLD
               PLDCLK         : out std_logic;
               PLDRESETn      : out std_logic;
               PLDI           : out std_logic;
               PLDO           : in std_logic;
               -- Global reset
               nSYSRST        : in std_logic;
               nSYSPOR        : in std_logic;
               CLK_24MHZ_FPGA : in std_logic;
               SYNC           : out std_logic;
               -- Statics
               CLKSEL    : in std_logic_vector(5 downto 0);
               PWR_nSHDN : in std_logic_vector(2 downto 0);
               ZCTL      : in std_logic_vector(3 downto 0);
               MAN_ID    : out std_logic_vector(3 downto 0);
               PLD_ID    : out std_logic_vector(3 downto 0);
               PGOOD     : out std_logic;
               DMEMSIZE  : in std_logic_vector(2 downto 0);
               IMEMSIZE  : in std_logic_vector(2 downto 0);
               -- DACs
               DAC_DINA : in std_logic_vector(7 downto 0);
               DAC_DINB : in std_logic_vector(7 downto 0);
               DAC_DINC : in std_logic_vector(7 downto 0);
               -- ADCs
               ADCSEL    : out std_logic_vector(2 downto 0);
               ADC_DOUTA : out std_logic_vector(11 downto 0);
               ADC_DOUTB : out std_logic_vector(11 downto 0)
             );
    end component;

    --------------------------------------------------
    -- signals
    --------------------------------------------------
    signal PLDSET : std_logic_vector(36 downto 0);
    signal PLDREAD : std_logic_vector(28 downto 0);
    signal POWERCHN : std_logic_vector(2 downto 0);
    signal PLDSYNC : std_logic;
    signal MAN_ID : std_logic_vector(3 downto 0);
    signal DMEMSIZE : std_logic_vector(2 downto 0);
    signal IMEMSIZE_in : std_logic_vector(2 downto 0);

    signal OSC0_VECTOR : std_logic_vector(31 downto 0);
    signal OSC1_VECTOR : std_logic_vector(31 downto 0);
    signal OSC2_VECTOR : std_logic_vector(31 downto 0);

    signal iHCLK : std_logic;
    signal HCLKDLLOUT : std_logic;
	 signal nSYSPOR : std_logic;

    signal DLLRESET : std_logic;
    signal DLLLOCKED : std_logic;
    signal delDLLLOCKED : std_logic;
    signal DLLRSTPULSE : std_logic;
    signal LED : std_logic_vector(7 downto 0);
    signal DIMMDLLOUT : std_logic;

    signal Timer_Clk : std_logic;

    signal iARM_HRDATAEN : std_logic;
    signal ARM_HRDATA : std_logic_vector(31 downto 0);

    signal CountFor100ms : std_logic_vector(20 downto 0);
    signal inSYSRST : std_logic;
    signal iARM_HSIZE : std_logic_vector(2 downto 0);
    signal oSDRAM_Clk : std_logic;
	 signal ARM_HRDATAEN : std_logic;

	 signal  out_MEM_ADDR   :  std_logic_vector(23 downto 0);
    signal  out_MEM_FLASH_NBYTE :  std_logic;
    signal  out_MEM_FLASH_nCS1  :  std_logic;
    signal  out_MEM_nBE         :  std_logic_vector(3 downto 0);
    signal  out_MEM_OE          :  std_logic;
    signal  out_MEM_SRAM_nCS0   :  std_logic;
    signal  out_MEM_WE          :  std_logic;

    signal  SDRAM_ADDR_out : std_logic_vector(12 downto 0);
	 signal SDRAM_Clk_out : std_logic_vector(1 downto 0);
	 signal SDRAM_ba_out : std_logic_vector(1 downto 0);
	 signal SDRAM_Cke_out : std_logic;
	 signal SDRAM_Csn_out  :  std_logic;
    signal SDRAM_Rasn_out :  std_logic;
    signal SDRAM_Casn_out :  std_logic;
    signal SDRAM_Wen_out  :  std_logic;
    signal SDRAM_ODQM_out :  std_logic_vector(3 downto 0);



    signal HSLAVEID_out : std_logic_vector( 3 downto 0);
	 signal slave_hready_out : std_logic_vector( 9 downto 0);




	 signal EBI_ADDR_OUT:   std_logic_vector(31 downto 0);
    signal EBI_CS_OUT:     std_logic_vector(3 downto 0);
    signal EBI_OE_OUT:     std_logic;
    signal EBI_WE_OUT:     std_logic_vector(3 downto 0);
    signal EBI_BWE_OUT:    std_logic_vector(3 downto 0);
    signal EBI_DATA_OUT :  std_logic_vector(31 downto 0);
    signal EBI_IRQ_OUT :	std_logic;
    signal ETH_nIRQ : std_logic;

	 signal gen_reset : std_logic;
	 signal CMCLK_t : std_logic;



begin

    --------------------------------------------------
    -- process
    --------------------------------------------------

    MEM_F_0x <= '1';
    nSYSPOR <= nSYSPOR_in and gen_reset and not SW_in(0);
    nSYSRST <= nSYSPOR;
	CMCLK <= CLK_PLL when (SW_in(7) = '1') else CMCLK_t;
           
    DL_WIRE_out <= DL_WIRE_in and nRESET;

    -- Reassert DLL Reset if DLL loses lock to set DLL to relock
    process (CLK_24MHz) begin
       if rising_edge (CLK_24MHz) then
          delDLLLOCKED <= DLLLOCKED;
       end if;
    end process;

    DLLRESET <= DLLRSTPULSE OR (not nSYSPOR);
    DLLRSTPULSE <= (not DLLLOCKED) and delDLLLOCKED;

    DATACTL0x <= '0'; 
    DATACTL1x <= '1';
    DATACTL2x <= '1';

--    DATACTL0x <= '1'; 
--   DATACTL1x <= '1';
--   DATACTL2x <=  ARM_HRDATAEN;
--   XU (31 downto 0) <= ARM_HRDATA when (ARM_HRDATAEN='1') else (others=>'Z');

    DMEMSIZE <= "100";
    IMEMSIZE_in <= "100";
  
-- TFT-LCD BL ON
	 LCD_BK_ON <= '1';


--  tp_sram_addr <= HSLAVEID_out(3 downto 2);
--	 tp_sram_data <= HSLAVEID_out(1 downto 0);

	 	
    MEM_OE	<= out_MEM_OE;				
    MEM_WE <= out_MEM_WE;
    MEM_SRAM_nCS0 <= out_MEM_SRAM_nCS0;	
    MEM_nBE	 <= out_MEM_nBE;
	 MEM_ADDR <= out_MEM_ADDR;
	 MEM_FLASH_NBYTE <= out_MEM_FLASH_NBYTE;
	 MEM_FLASH_nCS1 <= out_MEM_FLASH_nCS1;

--    tp_sram_addr <= SDRAM_Clk_out;
--    tp_sram_data <= SDRAM_Ba_out;
--    tp_sram_oe	<= 	SDRAM_Cke_out;				
--    tp_sram_we <= SDRAM_Wen_out;
--    tp_sram_cs <= SDRAM_Csn_out;
--    tp_sram_be	 <= SDRAM_Rasn_out & SDRAM_Casn_out;
--    tp_sdram_ODQM	 <= SDRAM_ODQM_out;  	 

	 SDRAM_Clk <= SDRAM_Clk_out;
    SDRAM_Ba <= SDRAM_Ba_out;
    SDRAM_Cke <= SDRAM_Cke_out;				
    SDRAM_Wen <= SDRAM_Wen_out;
    SDRAM_Csn <= SDRAM_Csn_out;
    SDRAM_Rasn <= SDRAM_Rasn_out;
	 SDRAM_Casn <= SDRAM_Casn_out;
    SDRAM_ODQM <= SDRAM_ODQM_out;  	 
	 SDRAM_Addr <= SDRAM_Addr_out;

    process (CLK_24MHz, nSYSPOR) begin
       if (nSYSPOR='0') then
          CountFor100ms <= (others=>'0');
       elsif rising_edge(CLK_24MHz) then 
          if (inSYSRST='0') then
            CountFor100ms <= CountFor100ms + B"0_0000_0000_0000_0000_0001";
          end if;
       end if;
    end process;

    inSYSRST <= '1' when (CountFor100ms(20)='1') else '0';

    LEDS <= not LED;
--	 LEDS(7 downto 4) <= SW_in(7 downto 4);

   -- ethernet reset
	 ETH_nRESET <= not((XU(63)) and not SW_in(7));

    Timer_Clk <= CLK2; --iHCLK;

	 SDRAM_Clk_out <= oSDRAM_Clk & oSDRAM_Clk;

    ETH_ADDR <= EBI_ADDR_OUT(15 downto 1);
	 ETH_nCS3 <= EBI_CS_OUT(0);
    ETH_OE <= EBI_OE_OUT;
    ETH_WE <= EBI_WE_OUT(0);
    ETH_DATA <=	EBI_DATA_OUT(15 downto 0);
	 ETH_LCLK <= '1';
	ETH_nIRQ <= not ETH_IRQ;


    ETH_BE <= "00" when EBI_CS_OUT(0) = '0' and EBI_ADDR_OUT(0) = '0' and (iARM_HSIZE = "001" or iARM_HSIZE = "010")	else
	 				"10" when EBI_CS_OUT(0) = '0' and EBI_ADDR_OUT(0) = '0' and iARM_HSIZE = "000" else
					"01" when EBI_CS_OUT(0) = '0' and EBI_ADDR_OUT(0) = '1' and iARM_HSIZE = "000" else
					"11";
--		ETH_BE <= "00";




	 iARM_HSIZE(2) <= XU(35);
	 iARM_HSIZE(1 downto 0) <=  XU(39 downto 38);
    --------------------------------------------------
    -- port mapping
    --------------------------------------------------

    uBUFG : BUFG
        port map( I => DIMMDLLOUT, --HCLKDLLOUT,
                  O => iHCLK
                );
--    iHCLK <= XU(34);

    uCLKDLL1P : DCM_BASE
        port map( CLK0     => HCLKDLLOUT, --iHCLK, --HCLKDLLOUT,
                  CLK180   => open,
                  CLK270   => DIMMDLLOUT, --iHCLK, --open, --DIMMDLLOUT,
                  CLK2X    => open,
                  CLK2X180 => open,
                  CLK90    => open,
                  CLKDV    => open,
                  CLKFX    => open,
                  CLKFX180 => open,
                  LOCKED   => DLLLOCKED,
                  CLKFB    => HCLKDLLOUT, --iHCLK,
                  CLKIN    => XU(34),
                  RST      => DLLRESET
                );

    

    uvpbGTC : vpbGTC
        port map(
		            ARM_HRDATA      => XU(31 downto 0),
                  ARM_HWDATA      => XU(179 downto 148),
--					   ARM_HRDATA      => ARM_HRDATA,
--                  ARM_HWDATA      => XU(31 downto 0),
                  ARM_HCLKIN      => open , --XU(32),
                  ARM_REFCLK      => XU(33),
                  ARM_HCLK        => iHCLK,
                  ARM_HSIZE       => iARM_HSIZE,
                  ARM_HTRANS      => XU(37 downto 36),
                  ARM_HPROT       => XU(43 downto 40),
                  ARM_HBURST      => XU(46 downto 44),
                  ARM_HWRITE      => XU(47),
                  ARM_HBUSREQ     => XU(48),
                  ARM_HLOCK       => XU(49),
                  ARM_HREADY      => XU(50),
                  ARM_HGRANT      => XU(51),
                  ARM_HRESP       => XU(53 downto 52),
                  ARM_BIGENDIN    => XU(54),
                  ARM_BIGENDOUT   => XU(55),
                  ARM_COMMRX      => XU(56),
                  ARM_COMMTX      => XU(57),
                  ARM_CONFIGINIT  => XU(58),
                  ARM_DBGACK      => XU(59),
                  ARM_DBGEN       => XU(60),
                  ARM_nFIQ        => XU(61),
                  ARM_nIRQ        => XU(62),
                  ARM_nRESET      => XU(63),
                  ARM_nPORESET    => XU(64),
                  ARM_nCONFIGRST  => XU(65),
                  ARM_ETMEXTIN    => XU(66),
                  ARM_ETMEXTOUT   => XU(67),
                  ARM_VINITHI     => XU(68),
                  ARM_PLLLOCK     => XU(69),
                  ARM_PLLBYPASS   => XU(70),
                  ARM_INITRAM     => XU(71),
                  ARM_HCLKDIV     => XU(74 downto 72),
                  ARM_EDBGRQ      => XU(75),
                  ARM_DEWPT       => XU(76),
                  ARM_IEBKPT      => XU(77),
                  ARM_USERIN      => XU(83 downto 78),
                  ARM_USEROUT     => XU(89 downto 84),
                  ARM_PLLCTRL     => XU(91 downto 90),
                  ARM_PLLREFDIV   => XU(95 downto 92),
                  ARM_HADDR       => XU(127 downto 96),
                  ARM_TESTSELECT  => XU(128),
                  ARM_TICSELECT   => XU(129),
                  ARM_PLLFBDIV    => XU(137 downto 130),
                  ARM_PLLOUTDIV   => XU(141 downto 138),
                  ARM_EXTTRIG     => XU(142),
                  ARM_HRDATAEN    => ARM_HRDATAEN,

                  PLDSET          => PLDSET,
                  PLDREAD         => PLDREAD,
                  POWERCHN        => POWERCHN,
                  PLDSYNC         => PLDSYNC,

                  nSYSPOR	  => nSYSPOR,
                  nSYSRST         => inSYSRST,
                  CLK2            => CLK2,
                  CLK_24MHZ       => CLK_24MHZ,

                  SW              => SW_in(4 downto 0),
                  OSC0_VECTOR     => OSC0_VECTOR,
                  OSC1_VECTOR     => OSC1_VECTOR,
                  OSC2_VECTOR     => OSC2_VECTOR,
                  LED             => LED,
                  MAN_ID          => MAN_ID,

--SDRAM
                  SDRAM_Clk       => oSDRAM_Clk,
                  SDRAM_Cke       => SDRAM_Cke_out,
                  SDRAM_Csn       => SDRAM_Csn_out,
                  SDRAM_Rasn      => SDRAM_Rasn_out,
                  SDRAM_Casn      => SDRAM_Casn_out,
                  SDRAM_Wen       => SDRAM_Wen_out,
                  SDRAM_Ba        => SDRAM_Ba_out,
                  SDRAM_Addr      => SDRAM_Addr_out,
                  SDRAM_ODQM      => SDRAM_ODQM_out,
                  SDRAM_DATA      => SDRAM_DATA,

--TFT_LCD
						LCD_D  =>  LCD_D,
          			LCD_VSYNC  => LCD_VSYNC,
          			LCD_HSYNC  => LCD_HSYNC,
          			LCD_DE	  => LCD_DE,
          			LCD_CLK	  => LCD_CLK,
          			LCD_LEND	  => LCD_LEND,

			 			-- LCD & 7SEGMENT

			        LCD_RS   => LCD_RS,
			        LCD_RW   => LCD_RW,
			        LCD_EN   => LCD_EN,
			        LCD_DATA => LCD_DATA,

			        SEGOUT   => SEGOUT,
			        SEGCOM   => SEGCOM,

			         HSLAVEID_out => HSLAVEID_out,
						slave_hready =>  slave_hready_out,

-- async SRAM

                  MEM_ADDR        => out_MEM_ADDR,
                  MEM_FLASH_NBYTE => out_MEM_FLASH_NBYTE,
                  MEM_FLASH_nCS1  => out_MEM_FLASH_nCS1, 
                  MEM_nBE         => out_MEM_nBE,        
                  MEM_OE          => out_MEM_OE,         
                  MEM_SRAM_nCS0   => out_MEM_SRAM_nCS0,  
                  MEM_WE          => out_MEM_WE,
                  MEM_DATA        => MEM_DATA,
                  
          -- USB
          USB_nCS	 => USB_nCS,
          USB_nWR    => USB_nWR,
          USB_nRD    => USB_nRD,
          USB_INT    => USB_INT,
          USB_WAKEUP => USB_WAKEUP,
          USB_DRQ    => USB_DRQ,
          USB_DACK   => USB_DACK,
          USB_EPT    => USB_EPT,

--ethernet interface
		   
          			EBI_ADDR => EBI_ADDR_OUT,
          			EBI_CS => EBI_CS_OUT,
          			EBI_OE => EBI_OE_OUT,
          			EBI_WE  => EBI_WE_OUT,
          			EBI_BWE =>  EBI_BWE_OUT,
          			EBI_DATA	=>	EBI_DATA_OUT,
   		 			EBI_IRQ => 	ETH_nIRQ,


--UART
                  TXD0	          => TXD0,
                  RXD0		  => RXD0,
                  CTS0		  => CTS0,
                  RTS0            => RTS0,
                  TXD1	          => TXD1,
                  RXD1		  => RXD1,
                  CTS1		  => CTS1,
                  RTS1            => RTS1,

-- AC97
			 			AC97_BCLK =>   AC97_BCLK,
			 			AC97_SYNC =>   AC97_SYNC,
			 			AC97_SDO  =>   AC97_SDO,
			 			AC97_SDI  =>   AC97_SDI,
			 			AC97_RST  =>   AC97_RST,


--TIMER
                  Timer_Clk 	  => Timer_Clk,


					   I2S_SD_I 			=>     I2S_SD_I,
        				I2S_SCK_I			=>     I2S_SCK_I,
        				I2S_WS_I 			=>     I2S_WS_I,

				      I2S_SD_O 			=>     I2S_SD_O,
        				I2S_SCK_O			=>     I2S_SCK_O,
        				I2S_WS_O 			=>     I2S_WS_O,

					   I2S_SD_I_1 			=>     I2S_SD_I_1,
        				I2S_SCK_I_1			=>     I2S_SCK_I_1,
        				I2S_WS_I_1 			=>     I2S_WS_I_1,

				      I2S_SD_O_1 			=>     I2S_SD_O_1,
        				I2S_SCK_O_1			=>     I2S_SCK_O_1,
        				I2S_WS_O_1 			=>     I2S_WS_O_1,


						gen_reset     => gen_reset,

						-- Camera Interface

						CMCLK  	=>   CMCLK_t,
						CRESETB 	=>   CRESETB,
						CENB  	=>   CENB,
						CSCL   	=>   CSCL,
						CSDA   	=>   CSDA,
						CVCLK  	=>   CVCLK,
						CVSYNC 	=>   CVSYNC,
						CHSYNC   =>   CHSYNC,
						CY     	=>   CY
						);

    USerStr : serialstream
        port map( PLDCLK         => PLDCLK,
                  PLDRESETn      => open,
                  PLDI           => PLDI,
                  PLDO           => PLDO,
                  nSYSRST        => inSYSRST,
                  nSYSPOR        => nSYSPOR,
                  CLK_24MHZ_FPGA => CLK_24MHZ,
                  SYNC           => PLDSYNC,
                  CLKSEL         => PLDSET(36 downto 31),
                  PWR_nSHDN      => PLDSET(26 downto 24),
                  ZCTL           => PLDSET(30 downto 27),
                  MAN_ID         => MAN_ID,
                  PLD_ID         => PLDREAD(27 downto 24),
                  PGOOD          => PLDREAD(28),
                  DMEMSIZE       => DMEMSIZE,
                  IMEMSIZE       => IMEMSIZE_in,
                  DAC_DINA       => PLDSET(7 downto 0),
                  DAC_DINB       => PLDSET(15 downto 8),
                  DAC_DINC       => PLDSET(23 downto 16),
                  ADCSEL         => POWERCHN(2 downto 0),
                  ADC_DOUTA      => PLDREAD(11 downto 0),
                  ADC_DOUTB      => PLDREAD(23 downto 12)
                );
    
end BEHAVIORAL;



