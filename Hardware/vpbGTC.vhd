--------------------------------------------------------------
-- vpbGTC module
-- 
-- Date : 2005. 07. 30
-- Author : Jinhyun, Cho (Ph.D Candidate, SoEE, SNU) 
-- Copyright 2005  Seoul National University, Seoul, Korea
-- ALL RIGHTS RESERVED
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

library Work;
use Work.AMBA.all;

-- synthesis translate_off
-- library SoCBaseSim;
-- use SoCBaseSim.AMBA.all;
-- synthesis translate_on

entity vpbGTC is
   port ( -- Test chip signals (CT)  
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



			 --HSLAVEID

			 HSLAVEID_out 			: out std_logic_vector(3 downto 0);

			 slave_hready : out std_logic_vector(9 downto 0);

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
          USB_nCS		  : out std_logic; -- async io_cs0
          USB_nWR         : out std_logic; -- async wen
          USB_nRD         : out std_logic; -- async oen
          USB_INT         : in std_logic; -- irq(14)
          USB_WAKEUP      : out std_logic; -- '1'
          USB_DRQ         : out std_logic_vector(1 downto 0); -- "00"
          USB_DACK        : out std_logic_vector(1 downto 0); -- "11"
          USB_EPT         : out std_logic_vector(1 downto 0); -- "11"

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
    end vpbGTC;


architecture BEHAVIORAL of vpbGTC is

    --------------------------------------------------
    -- components
    --------------------------------------------------

    -- AHB matrix (4 master & 10 slave)
    component ahb_matrix_m4s10r 
        port (
               HCLK    : in std_logic;
               HRESETn : in std_logic;
                                    
               -- Master/Slave Component Interface
               MASTEROUT : in AHB_MASTEROUT_ARRAY(0 to 3);
               SLAVEOUT  : in AHB_SLAVEOUT_ARRAY(0 to 9);              
               MASTERIN : out AHB_MASTERIN_ARRAY(0 to 3);
               SLAVEIN  : out AHB_SLAVEIN_ARRAY(0 to 9);
            
               -- Decoder Interface
               HSLAVEID : in std_logic_vector(3 downto 0);
               DECADDR  : out std_logic_vector(31 downto 0);
            
               -- Global Bus State
               BUSSTATE : out AHB_REC
             );
    end component;

    -- AHB dummy master
    component AHB_DUMMY_MASTER_REC 
        port (
               HCLK    :   in std_logic;
               HRESETn :   in std_logic;
               pMIN    :   in AHB_MasterIn_Type;
               pMOUT   :   out AHB_MasterOut_Type
             );
    end component;

    -- AHB dummy slave
    component AHB_DUMMY_SLAVE_REC 
        port (
               HCLK    :   in std_logic;
               HRESETn :   in std_logic;
               pSIN    :   in AHB_SlaveIn_Type;
               pSOUT   :   out AHB_SlaveOut_Type
             );
    end component;



   -- AHB MATRIX 2M 4S

	component ahb_matrix_m2s4r

    port (
            HCLK    :   in std_logic;
            HRESETn :   in std_logic;
                                    
            -- Master/Slave Component Interface
            MASTEROUT:  in AHB_MASTEROUT_ARRAY(0 to 1);
            SLAVEOUT:   in AHB_SLAVEOUT_ARRAY(0 to 3);
                                    
            MASTERIN:   out AHB_MASTERIN_ARRAY(0 to 1);
            SLAVEIN:    out AHB_SLAVEIN_ARRAY(0 to 3);
            
            -- Decoder Interface
            HSLAVEID :  in std_logic_vector(3 downto 0);
            DECADDR:    out std_logic_vector(31 downto 0);
            
            -- Global Bus State
            BUSSTATE:   out AHB_REC

				);

	end component;





	     -- Ext.Async SRAM controller
    component ASYNC_SRAM_CTRL_AHB32_REC
        Port (
               -- Clock & Reset
               HCLK    : in std_logic;
               HRESETn : in std_logic;

               -- AHB Slave for Data Access
               pSIN  : in AHB_SlaveIn_Type;
               pSOUT : out AHB_SlaveOut_Type;

               -- AHB Slave for Control Access
               pSIN_CON  : in AHB_SlaveIn_Type;
               pSOUT_CON : out AHB_SlaveOut_Type;

               -- Async SRAM Bus Interface
               ADDR      : out std_logic_vector (22 downto 0);
               MEM_WAIT  : in std_logic;
               RDATA     : in std_logic_vector (31 downto 0);
               FLA_BAA   : out std_logic;
               FLA_CLK   : out std_logic;
               FLA_LBA   : out std_logic;
               FLASH_CEN : out std_logic;
               IO0_CEN   : out std_logic;
               IO1_CEN   : out std_logic;
--               LBN       : out std_logic;
--               UBN       : out std_logic;
					MEM_nBE : out std_logic_vector(3 downto 0);
               OEN       : out std_logic;
               SRAM_CEN  : out std_logic;

               WDATA     : out std_logic_vector (31 downto 0);
               WDATA_EN  : out std_logic;
               WEN       : out std_logic
             );
    end component;




	component AHB2AHB_SYNC_REC 
   port ( 
            -- Bus Clock/Reset
            HCLK     : in    std_logic; 
            HRESETn   : in    std_logic; 
                  
            -- Slave Interface to Master Bus (Bus A)            
            pAIN    :  in   AHB_SlaveIn_Type;
            pAOUT   :  out  AHB_SlaveOut_Type;
            
            -- Master Interface to Slave Bus (Bus B)
            pBIN     : in    AHB_MasterIn_Type;     
            pBOUT    : out   AHB_MasterOut_Type
        );          
	end component;


    -- AHB to APB Bridge
    component AHB2APB_P8_REC
        Port (  
               -- AHB Bus Clock Signal         
               HCLK     : In std_logic;
               HRESETn  : In std_logic;
                        
               -- AHB Bus Slave Interface
               pSIN     : in AHB_SlaveIn_Type;
               PSOUT    : out AHB_SlaveOut_Type;
            
               -- APB Bus Slave Interface
               pPIN0    : out APB_SlaveIn_Type;
               pPOUT0   : in APB_SlaveOut_Type;
            
               pPIN1    : out APB_SlaveIn_Type;
               pPOUT1   : in APB_SlaveOut_Type;
            
               pPIN2    : out APB_SlaveIn_Type;
               pPOUT2   : in APB_SlaveOut_Type;
            
               pPIN3    : out APB_SlaveIn_Type;
               pPOUT3   : in APB_SlaveOut_Type;



            pPIN4   :   out  APB_SlaveIn_Type;
            pPOUT4  :   in APB_SlaveOut_Type;
            
            pPIN5   :   out  APB_SlaveIn_Type;
            pPOUT5  :   in APB_SlaveOut_Type;
            
            pPIN6   :   out  APB_SlaveIn_Type;
            pPOUT6  :   in APB_SlaveOut_Type;
            
            pPIN7   :   out  APB_SlaveIn_Type;
            pPOUT7  :   in APB_SlaveOut_Type;
            
            PSLAVEOK:   in std_logic;
            PSLAVEID:   in std_logic_vector(2 downto 0)

            
             );
    end component;

    -- TIMER
    component TIMER_REC 
        Port (    
               -- Clock & Reset Signals
               PCLK      : in std_logic;
               PRESETn   : in std_logic;
               TIMER_CLK : in std_logic;
                
               -- APB Slave Interface
               pPIN  : in APB_SlaveIn_Type;
               pPOUT : out APB_SlaveOut_Type;
                
               -- Interrupt Signals
               TIMER_INT  : out std_logic;
               TIMER_INT0 : out std_logic;
               TIMER_INT1 : out std_logic;
               TIMER_INT2 : out std_logic      
             );
    end component;

    -- UART Controller
    component UART_REC 
        Port (     
               PCLK    : in std_logic;
               PRESETn : in std_logic;
        
               pPIN    : in APB_SlaveIn_Type;
               pPOUT   : out APB_SlaveOut_Type;
              
               CTS     : in std_logic;               
               RXD     : in std_logic;
               RTS     : out std_logic;
               TXD     : out std_logic;
               UARTR   : out std_logic;
               UARTT   : out std_logic 
             );
    end component;

    -- Interrupt Controller
    component INTR_CTRL_REC 
        Port (   
               -- APB Bus Clock 
               PCLK    : in std_logic;
               PRESETn : in std_logic;
            
               -- APB Slave Interface
               pPIN  : in APB_SlaveIn_Type;
               pPOUT : out APB_SlaveOut_Type;
              				
               -- Interrupt control interface
               INT_REQn : in std_logic_vector(23 downto 0);
               INT_ACKn : out std_logic_vector(23 downto 0);
               INT_IRQ  : out std_logic;
               INT_FIQ  : out std_logic
             );
    end component;

    -- Core Tile control/status register
    component cpGTCRegs 
        Port (   
               PORESETn : in std_logic;

               -- APB interface
               PCLK    : in std_logic;
               PRESETn : in std_logic;
               PSEL    : in std_logic;
               PENABLE : in std_logic;
               PADDR   : in std_logic_vector(7 downto 2);
               PWRITE  : in std_logic;
               PWDATA  : in std_logic_vector(31 downto 0);
               PRDATA  : out std_logic_vector(31 downto 0);

               -- reference clock
               CLKREF24MHZ       : in std_logic;
               CLKREF24MHZRESETn : in std_logic;

               -- status inputs to registers
               ID     : in std_logic_vector(3 downto 0);
               MBDET  : in std_logic;
               MAN_ID : in std_logic_vector(3 downto 0);

               -- control signals from registers
               ARM_PLLREFDIV : out std_logic_vector(3 downto 0);
               ARM_PLLCTRL   : out std_logic_vector(1 downto 0);
               ARM_PLLFBDIV  : out std_logic_vector(7 downto 0);
               ARM_PLLOUTDIV : out std_logic_vector(3 downto 0);
               ARM_HCLKDIV   : out std_logic_vector(2 downto 0);
               ARM_PLLBYPASS : out std_logic;
               ARM_INITRAM   : out std_logic;
               ARM_USERIN    : out std_logic_vector(5 downto 0);
               ARM_VINITHI   : out std_logic;

               -- onboard pll control
               OSC0_VECTOR : out std_logic_vector(31 downto 0);
               OSC1_VECTOR : out std_logic_vector(31 downto 0);
               OSC2_VECTOR : out std_logic_vector(31 downto 0);
 
               -- onboard ADC control
               PLDSET       : out std_logic_vector(36 downto 0);
               PLDREAD      : in std_logic_vector(28 downto 0);
               POWERCHN     : in std_logic_vector(2 downto 0);
               PLDSYNC      : in std_logic;
               LED          : out std_logic_vector(7 downto 0);
               SW           : in std_logic_vector(3 downto 0);
               HRDATACONFIG : out std_logic_vector(31 downto 0);

               -- ARM interrupt control
               COMMRX          : in std_logic;
               COMMTX          : in std_logic;
               IRQ             : out std_logic;
               FIQ             : out std_logic;
               ARMMAILBOXFULL  : in std_logic;
               VPBREGINT       : in std_logic;
               VPBMAILBOXEMPTY : in std_logic
             );
    end component;

    
    -- DP_RAM 256KB
    component AHB2PORT1RAM 
        port (   
               HRESETn  : in std_logic;              
               BIGEND  : in std_logic;              

               PORT1HCLK  : in std_logic;              
               PORT1HSEL  : in std_logic;              
               PORT1HREADYIN  : in std_logic;              
               PORT1HTRANS  : in std_logic_vector(1 downto 0);
               PORT1HSIZE  : in std_logic_vector(1 downto 0);
               PORT1HWRITE  : in std_logic;              
               PORT1HWDATA  : in std_logic_vector(31 downto 0);
               PORT1HADDR  : in std_logic_vector(31 downto 0);
               
               PORT1HRDATA  : out std_logic_vector(31 downto 0);
               PORT1HREADYOUT  : out std_logic;              
               PORT1HRESP  : out std_logic_vector(1 downto 0);
               
							 PORT2HCLK : in std_logic;
							 port2di : in std_logic_vector(31 downto 0);
							 port2addr : in std_logic_vector(31 downto 0);
							 port2cs : in std_logic;
							 port2we : in std_logic;
							 port2bwe : in std_logic_vector(3 downto 0);
							 port2do : out std_logic_vector(31 downto 0)               
             );
    end component;


    -- APB Dummy Slave
    component APB_DUMMY_SLAVE_REC 
        port (
               PCLK    : in std_logic;
               PRESETn : in std_logic;
               pPIN    : in APB_SlaveIn_Type;
               pPOUT   : out APB_SlaveOut_Type
             );
    end component;



    -- Sdram controller

    component SDRAM_CTRL_REC 

	port(

		CH0_HCLK	: 	in std_logic;
		CH0_HRESETn	: 	in std_logic;
		CH0_SIN		:	in	AHB_SlaveIn_Type;
		CH0_SOUT	:	out	AHB_SlaveOut_Type;
    HSEL_CON	:	in std_logic;

    SDRAM_Clk            : out   std_logic;
    SDRAM_Cke  		 : out   std_logic;
    SDRAM_Cs_n 		 : out   std_logic;
    SDRAM_Ras_n 	 : out   std_logic;
    SDRAM_Cas_n 	 : out   std_logic;
    SDRAM_We_n  	 : out   std_logic;
    SDRAM_Ba    	 : out   std_logic_vector (1 downto 0);
    SDRAM_Addr  	 : out   std_logic_vector (12 downto 0);
    SDRAM_m_D      : OUT   STD_LOGIC_VECTOR (31 DOWNTO 0);
    SDRAM_m_q      : IN    STD_LOGIC_VECTOR (31 DOWNTO 0);
    SDRAM_m_outsel : OUT   STD_LOGIC;
    SDRAM_ODQM     : OUT   STD_LOGIC_VECTOR (3 DOWNTO 0)


	    );	

    end component;







   -- TFT LCD controller
    component TFTLCDCTRL_REC 
        port (
               -- Control AHB Bus Clock & Reset
               HCLK    : in std_logic;
               HRESETn : in std_logic;

               -- Controller AHB Slave Interface
               pSIN  : in AHB_SlaveIn_Type;
               pSOUT : out AHB_SlaveOut_Type;

               -- DMA AHB Master Interface
               pMIN  : in AHB_MasterIn_Type;
               pMOUT : out AHB_MasterOut_Type;

               -- TFT LCD Interface
               LCD_D     : out std_logic_vector(15 downto 0);
               LCD_VSYNC : out std_logic;
               LCD_HSYNC : out std_logic;
               LCD_DE	 : out std_logic;
               LCD_CLK	 : out std_logic;
               LCD_LEND	 : out std_logic
             );
    end component;





    -- Single Master DMA

    component SMDMA_REC 

        port(

              HCLK    : in std_logic;

              HRESETn : in std_logic;



              -- DMA Master Interface

              pMIN  : in AHB_MasterIn_Type;

              pMOUT : out AHB_MasterOut_Type;



              -- Slave Interface

              pSIN  : in AHB_SlaveIn_Type;

              pSOUT : out AHB_SlaveOut_Type;



              -- Interrupt Signals

              nIRQ : out std_logic

            );

    end component;



    component APB_SEG_CHARLCD_REC 
      Port (     
        -- APB Bus Clock & Reset
        PCLK    : in    std_logic;
        PRESETn : in    std_logic;
        
        -- APB Slave Interface
        pPIN    : in    APB_SlaveIn_Type;
        pPOUT   : out   APB_SlaveOut_Type;

        -- Character LCD & Segment
        LCD_RS   : out std_logic;                                                    
        LCD_RW   : out std_logic;                                                    
        LCD_EN   : out std_logic;                                                    
        LCD_DATA : out std_logic_vector(7 downto 0);                                                    
	                                                    
        SEGOUT   : out std_logic_vector(7 downto 0);                                                    
        SEGCOM   : out std_logic_vector(7 downto 0);
        LED_OUT  : out std_logic_vector(7 downto 0)
    );           
    end component;


	-- DCT
	component DCT_AHB_REC
    port (  -- AHB Bus Clock & Reset
            HCLK : In    std_logic;             
            HRESETn : In    std_logic;
            
            -- AHB Slave Interface
            pSIN  : in  AHB_SlaveIn_Type;
            pSOUT : out AHB_SlaveOut_Type;
            
            -- Interrupt Request Signal
            DCT_INTR : Out   std_logic;



           -- SRAM Memory Interface
            SRAM_DOUT : In    std_logic_vector (15 downto 0);             
            SRAM_ADDR : Out   std_logic_vector (10 downto 0);
            SRAM_CSN : Out   std_logic;
            SRAM_DI : Out   std_logic_vector (15 downto 0);
            SRAM_WEN : Out   std_logic

				);
	 end component;





	component ONCHIP_SSRAM_CTRL_VDP_REC 
      port (
            ADDR        : in    std_logic_vector(19 downto 0);
            CSN         : in    std_logic;
            WDATA       : in    std_logic_vector(15 downto 0);
            OEN         : in   std_logic;
            WEN         : in    std_logic;
            RDATA       : out   std_logic_vector(15 downto 0);

            -- AHB Bus Clock & Reset Signals
            HCLK :      In  std_logic;
            HRESETn :   In  std_logic;

            -- AHB Slave Interface
            pSIN    :   in  AHB_SlaveIn_Type;
            pSOUT   :   out AHB_SlaveOut_Type
        );
	end component;





	component EBI32_REC is
    port(   
        HCLK    :   in  std_logic;
        HRESETn :   in  std_logic;
        
        -- Control (Slave) Interface
        pSIN    :   in  AHB_SlaveIn_Type;
        pSOUT   :   out AHB_SlaveOut_Type;
        
        DCLK    :   in  std_logic;
        DRESETn :   in  std_logic;
        
        -- Data (Slave) Interface
        pDIN    :   in  AHB_SlaveIn_Type;
        pDOUT   :   out AHB_SlaveOut_Type;
        
        -- EBI Interface
        EBI_DOUTSELn:   out std_logic_vector(3 downto 0);        
        EBI_ADDR:       out std_logic_vector(31 downto 0);
        EBI_CS:         out std_logic_vector(3 downto 0);
        EBI_OE:         out std_logic;
        EBI_SOE:        out std_logic_vector(3 downto 0);       
        EBI_WE:         out std_logic_vector(3 downto 0);
        EBI_BWE:        out std_logic_vector(3 downto 0);
        EBI_LD:         out std_logic;
        EBI_ADV:        out std_logic;
        EBI_DOUT:       out std_logic_vector(31 downto 0);
        EBI_DIN:        in  std_logic_vector(31 downto 0);
        EBI_ACK:        in  std_logic;
        EBI_ZZ:         out std_logic;
        
        -- EBI_CONFIG
        EBI_SYNC:       in std_logic;
        EBI_SIZE:       in std_logic_vector(1 downto 0)        );
   end component;



	component RESETGEN_REC is
   port (   -- AHB Bus Clock & Reset 
            HCLK      : in    std_logic;
            HRESETn  : in    std_logic;
          
            -- AHB Bus Slave Interface
            pSIN :  in AHB_SlaveIn_Type;
            pSOUT:  out AHB_SlaveOut_Type;
          
            -- Generated Reset Signal
            nPRST : out std_logic
          );
	end component;





	component CIS_REC is
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





	component AC97_REC is
      Port (     
        PCLK    : in    std_logic;
        PRESETn : in    std_logic;
        
        pPIN    : in    APB_SlaveIn_Type;
        pPOUT   : out   APB_SlaveOut_Type;
              
        AC97IRQ : Out std_logic;

		  SUSPENDED_O : Out std_logic;

	     BIT_CLK_PAD_I : In std_logic;
        SYNC_PAD_O : Out std_logic;
        SDATA_PAD_O : Out std_logic;
        SDATA_PAD_I : In std_logic;
	     AC97_RESET_PAD_O : Out std_logic);
	end component;





	component I2C_REC is
      Port (  -- APB Bus Clock & Reset Signals    
                PCLK : In    std_logic;
              PRESETn: In    std_logic;
              
              -- APB Slave Interface
              pPIN   : In    APB_SlaveIn_Type;
              pPOUT  : Out   APB_SlaveOut_Type;               
               
              -- I2C Bus Interface
              SCL_IN : In    std_logic;
              SDA_IN : In    std_logic;              
             SCL_OUT : Out   std_logic;
             SDA_OUT : Out   std_logic );
	end component;


	component I2S_REC is
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
        I2S_WS_O  : Out std_logic   	 );
	end component;


	component CIS_IF_REC is
    port (

        -- Control AHB Bus Clock & Reset
        HCLK 		: in	std_logic;
        HRESETn		: in    std_logic;
        -- Controller AHB Slave Interface
        pSIN 		: in    AHB_SlaveIn_Type;
        pSOUT		: out   AHB_SlaveOut_Type;
  		-- SRAM interface
			  ramaddr : out std_logic_vector(16 downto 0);
	  		ramdata : out std_logic_vector (15 downto 0);
	  		ram_ce : out  std_logic;
	  		ram_we : out std_logic;
	  		ram_clk : out std_logic;
	  		test_led : out std_logic_vector(3 downto 0);

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


    --------------------------------------------------
    -- signals
    --------------------------------------------------
    -- process signals
    constant PORCountMax:integer range 0 to 15 := 15;
    constant CONFIGRSTCount:integer range 0 to 15 := 4;
    constant CONFIGINITCount:integer range 0 to 15 := 8;

    signal HSLAVEID : std_logic_vector(3 downto 0);
--    signal HSEL_CON : std_logic;
    signal PSLAVEOK : std_logic;
    signal PSLAVEID : std_logic_vector(2 downto 0);

    signal PSLAVE_2ndOK : std_logic;                   
    signal PSLAVE_2ndID : std_logic_vector(2 downto 0);

    signal DECADDR : std_logic_vector(31 downto 0);
    signal sub_DECADDR : std_logic_vector(31 downto 0);

    signal sub_HSLAVEID : std_logic_vector(3 downto 0);

    signal IRQ_Req : std_logic_vector(23 downto 0);
    signal IRQ_Ack : std_logic_vector(23 downto 0);

--    signal MEM_WAIT : std_logic;
    signal MEM_RDATA : std_logic_vector(31 downto 0);
    signal MEM_WDATA_EN : std_logic;
    signal MEM_WDATA_EN_1d : std_logic;
    signal iMEM_WE : std_logic;
    signal iMEM_OE : std_logic;
    signal iMEM_SRAM_nCS0 : std_logic;
    signal iUSB_nCS : std_logic;
    signal MEM_WE_1d : std_logic;
    signal MEM_WDATA : std_logic_vector(31 downto 0);
    signal MEM_WDATA_1d : std_logic_vector(31 downto 0);
    signal MEM_LBN : std_logic;
    signal MEM_UBN : std_logic;

	 signal MEM_WDATA2, MEM_RDATA2 : std_logic_vector(31 downto 0);

	  

-- SDRAM signal

    signal SDRAM_m_D : std_logic_vector(31 downto 0);

    signal SDRAM_m_q : std_logic_vector(31 downto 0);

    signal SDRAM_m_outsel : std_logic;

    signal HClkResetFF1 : std_logic;
    signal HClkResetFF2 : std_logic;
    signal HClkResetFF3 : std_logic;
    signal ARM_HRESETn : std_logic;

    signal PORCount : integer range 0 to 15;
    signal PORCountEnd : std_logic;

    signal sig_min : AHB_MASTERIN_ARRAY(0 to 3);
    signal sig_mout : AHB_MASTEROUT_ARRAY(0 to 3);
    
    signal sig_sin : AHB_SLAVEIN_ARRAY(0 to 9);
    signal sig_sout : AHB_SLAVEOUT_ARRAY(0 to 9);
    
    signal sig_pin : APB_SLAVEIN_ARRAY(0 to 7);
    signal sig_pout : APB_SLAVEOUT_ARRAY(0 to 7);   

    signal sig_2ndpin : APB_SLAVEIN_ARRAY(0 to 7);
    signal sig_2ndpout : APB_SLAVEOUT_ARRAY(0 to 7);  


    signal sig_sub_min : AHB_MASTERIN_ARRAY(0 to 3);
    signal sig_sub_mout : AHB_MASTEROUT_ARRAY(0 to 3);
    
    signal sig_sub_sin : AHB_SLAVEIN_ARRAY(0 to 9);
    signal sig_sub_sout : AHB_SLAVEOUT_ARRAY(0 to 9);



    signal DCT_SRAM_DOUT :  std_logic_vector (15 downto 0);             
    signal DCT_SRAM_ADDR : std_logic_vector (10 downto 0);
    signal DCT_SRAM_CSN : std_logic;
    signal DCT_SRAM_DI : std_logic_vector (15 downto 0);
    signal DCT_SRAM_WEN : std_logic;
    
    signal ARM_FIQ : std_logic;
    signal ARM_IRQ : std_logic;
    signal IRQ_Uartr0 : std_logic;
    signal IRQ_Uartt0 : std_logic;
    signal IRQ_Uartr1 : std_logic;
    signal IRQ_Uartt1 : std_logic;


    signal IRQ_Timer : std_logic;
    signal IRQ_Timer0 : std_logic;
    signal IRQ_Timer1 : std_logic;
    signal IRQ_Timer2 : std_logic;

	 signal IRQ_DMA : std_logic;

	 signal IRQ_DCT : std_logic;

	 signal IRQ_AC97 : std_logic;
	 signal IRQ_I2S : std_logic;





    signal iARM_HRDATACONFIG : std_logic_vector(31 downto 0);

    signal PORT1HSIZE : std_logic_vector(1 downto 0);
    signal PORT2HCLK : std_logic;
    signal PORT2HSEL : std_logic;
    signal PORT2HREADYIN : std_logic;
    signal PORT2HTRANS : std_logic_vector(1 downto 0);
    signal PORT2HSIZE : std_logic_vector(1 downto 0);
    signal PORT2HWRITE : std_logic;
    signal PORT2HWDATA : std_logic_vector(31 downto 0);
    signal PORT2HADDR : std_logic_vector(31 downto 0);
    signal MEM_WAIT : std_logic;					  

	 signal t_MEM_ADDR : std_logic_vector(23 downto 0);

	 signal ID : std_logic_vector(3 downto 0);
    signal MBDET : std_logic;
    signal ARMMAILBOXFULL : std_logic;
    signal VPBREGINT : std_logic;
    signal VPBMAILBOXEMPTY : std_logic;





	 signal DPRAM_PORT2HCLK : std_logic;
    signal DPRAM_PORT2HSEL : std_logic;
    signal DPRAM_PORT2HREADYIN : std_logic;
    signal DPRAM_PORT2HTRANS : std_logic_vector(1 downto 0);
    signal DPRAM_PORT2HSIZE : std_logic_vector(1 downto 0);
    signal DPRAM_PORT2HWRITE : std_logic;
    signal DPRAM_PORT2HWDATA : std_logic_vector(31 downto 0);

	 signal DPRAM_PORT2HRDATA : std_logic_vector(31 downto 0);
    signal DPRAM_PORT2HADDR : std_logic_vector(31 downto 0);



	 signal On_Chip_ssram_addr : std_logic_vector(19 downto 0);

	 signal EBI_DOUT : std_logic_vector(31 downto 0);

	 signal EBI_DIN : std_logic_vector(31 downto 0);

	 signal EBI_DOUTSELn : std_logic_vector(3 downto 0);

	 signal EBI_BWE_OUT : std_logic_vector(3 downto 0);


    		-- SRAM interface
	  signal ramaddr :  std_logic_vector(16 downto 0);
	  signal ramaddr_in :  std_logic_vector(31 downto 0);
	  signal ramdata_t :  std_logic_vector (15 downto 0);
	  signal ram_data_in :  std_logic_vector (31 downto 0);
	  signal ram_ce :   std_logic;
	  signal ram_we :  std_logic;
	  signal ram_clk :  std_logic;
	  signal ram_bwe :  std_logic_vector(3 downto 0);


	 

begin
    --------------------------------------------------
    -- process
    --------------------------------------------------
    PORT2HCLK <= '0';
    PORT2HSEL <= '0';
    PORT2HREADYIN <= '1';
    PORT2HTRANS <= "00";
    PORT2HSIZE <= "10";
    PORT2HWRITE <= '0';
    PORT2HWDATA <= X"00000000";
    PORT2HADDR <= X"00000000";

    MEM_WAIT <= '1';

    ID <= not "0001";
    MBDET <= '1';
    ARMMAILBOXFULL <= '0';
    VPBREGINT <= '0';
    VPBMAILBOXEMPTY <= '0';

    -- ARM CT AHB interface
    sig_mout(0).HLOCK <= ARM_HLOCK;
    sig_mout(0).HTRANS <= ARM_HTRANS;
    sig_mout(0).HADDR <= ARM_HADDR;
    sig_mout(0).HWRITE <= ARM_HWRITE;
    sig_mout(0).HSIZE <= ARM_HSIZE;
    sig_mout(0).HBURST <= ARM_HBURST;
    sig_mout(0).HPROT <= ARM_HPROT;
    sig_mout(0).HWDATA <= ARM_HWDATA;
    sig_mout(0).HBUSREQ <= ARM_HBUSREQ;

    ARM_HREADY <= sig_min(0).HREADY; 
    ARM_HRESP <= sig_min(0).HRESP; 
    ARM_HRDATA <= sig_min(0).HRDATA; 
    ARM_HGRANT <= sig_min(0).HGRANT; 

    -- control for ARM tri-state bus
process (ARM_HCLK, ARM_HRESETn) begin
    if (ARM_HRESETn='0') then
         ARM_HRDATAEN <= '1';
      elsif rising_edge(ARM_HCLK) then
        if (sig_min(0).HREADY='1') then
            ARM_HRDATAEN <= not ARM_HWRITE;
         end if;
       end if;
    end process;						  





    -- Slave ID of main AHB bus
    AHB_BUS_DEC : process (DECADDR) begin
       case DECADDR(31 downto 28) is
			 when "0000"  => HSLAVEID <= "0001"; -- Async SRAM
			 when "0100"  => HSLAVEID <= "0000"; -- DPRAM in sub_matrix
			 when "0101"  => HSLAVEID <= "0011"; -- SDRAM
			 when "0110"  => HSLAVEID <= "0100"; -- APB if
			 when "0111"  =>
			 		case DECADDR(27 downto 24) is
						when "0001" => HSLAVEID <= "0101"; --Async SRAM16
						when others => HSLAVEID <= "0000"; -- sub AHB
					end case;
          when others => HSLAVEID <= "0000"; --default slave (sub matrix)
       end case;
    end process;


    AHB_SUB_BUS_DEC : process (sub_DECADDR) begin
       case sub_DECADDR(31 downto 28) is

			 when "0100"  => sub_HSLAVEID <= "1001"; -- DPRAM
			 when "0111"  => 
			 	    case sub_DECADDR(27 downto 24) is
						  when "0000" =>
			 				case sub_DECADDR(15 downto 12) is
							   	when "0000"  => sub_HSLAVEID <= "0001"; -- 7SEG & text-LCD
			 					  	when "0001"  => sub_HSLAVEID <= "0010"; -- Async Sram cntr reg
			 					  	when "0010"  => sub_HSLAVEID <= "0011"; -- SDRAM cntr reg
			 						when "0011"  => sub_HSLAVEID <= "0100"; -- TFT-LCD ctrl reg
			 						when "0100"  => sub_HSLAVEID <= "0101"; -- SDMA ctrl reg
							   	when "0101"  => sub_HSLAVEID <= "0110"; -- EBI32 reg
							   	when "0110"  => sub_HSLAVEID <= "0111"; -- RESET gen.
							   	when "0111"  => sub_HSLAVEID <= "1000"; -- CIS control
									when others => sub_HSLAVEID <= "0000";	 --default slave 
						   end case;
						  when others => sub_HSLAVEID <= "0000"; --default slave 
						  end case;
          when others => sub_HSLAVEID <= "0000"; --default slave 
       end case;
    end process;

    -- Slave ID of APB bus
    PSLAVEOK <= '1' when (HSLAVEID="0100") else '0';

    APB_BUS_DEC : process (DECADDR) begin
       case DECADDR(15 downto 12) is
          when "0000"   => PSLAVEID <= "000"; --cpGTCRegs
          when "0001"   =>
			 			case DECADDR(11 downto 8) is
			  					when "0000" => PSLAVEID <= "001"; --UART
								when "0001" => PSLAVEID <= "100"; --UART2
								when others => PSLAVEID <= "111";
						end case;
          when "0010"   => PSLAVEID <= "010"; --INTR
          when "0011"   => PSLAVEID <= "011"; --TIMER
			 when "0100"   => PSLAVEID <= "101"; --AC97
			 when "0101"   => PSLAVEID <= "110"; --I2S
			 when "0110"   => PSLAVEID <= "111"; --I2S
          when others => PSLAVEID <= "111"; --default slave 
       end case;
    end process;

    -- IRQ mapping
   IRQ_Req(0) <= not ARM_FIQ;
 	 IRQ_Req(1) <= not ARM_IRQ;
	 IRQ_Req(2) <= '1';
	 IRQ_Req(3) <= '1';
   IRQ_Req(4) <= IRQ_Uartr0 and IRQ_Uartt0;
   IRQ_Req(5) <= IRQ_Uartr1 and IRQ_Uartt1;
   IRQ_Req(6) <= IRQ_Timer0;
	 IRQ_Req(7) <= IRQ_Timer1;
	 IRQ_Req(8) <= IRQ_Timer2;
	 IRQ_Req(9) <= IRQ_DMA;
	 IRQ_Req(10) <= '1'; --IRQ_DCT;
	 IRQ_Req(11) <=  EBI_IRQ;
	 IRQ_Req(12) <=  not IRQ_AC97;
	 IRQ_Req(13) <=  IRQ_I2S;
	 IRQ_Req(14) <= USB_INT;
   IRQ_Req(23 downto 15) <= (others=>'1');
	    


    -- SDRAM data bus direction control
    SDRAM_DATA <= SDRAM_m_D when SDRAM_m_outsel='0' else (others=>'Z');
    SDRAM_m_q <= SDRAM_DATA;

	HSLAVEID_out <= HSLAVEID;
  slave_hready(0) <= sig_sout(0).HREADY;
	slave_hready(1) <= sig_sout(1).HREADY;
	slave_hready(2) <= sig_sout(2).HREADY;
	slave_hready(3) <= sig_sout(3).HREADY;
	slave_hready(4) <= sig_sout(4).HREADY;
	slave_hready(5) <= sig_sout(5).HREADY;
	slave_hready(6) <= sig_sout(6).HREADY;
	slave_hready(7) <= sig_sout(7).HREADY;
	slave_hready(8) <= sig_sout(8).HREADY;
	slave_hready(9) <= sig_sout(9).HREADY;

	sig_sub_sout(3).HREADY <= '1';

    -- Ext. Async memory bus direction control
--	MEM_DATA <= MEM_WDATA when MEM_WDATA_EN = '1' else (others => 'Z');
--	MEM_RDATA <= MEM_DATA;

--    MEM_nBE <= MEM_UBN & MEM_LBN & MEM_UBN & MEM_LBN;

    MEM_RDATA <= MEM_DATA;
    MEM_WE <= iMEM_WE;
    MEM_OE <= iMEM_OE;

    process (ARM_HCLK, nSYSRST) begin
      if (nSYSRST='0') then
          MEM_WDATA_EN_1d <= '0';
          MEM_WE_1d <= '1';
          MEM_WDATA_1d <= (others => '0');
       elsif rising_edge(ARM_HCLK) then
          MEM_WDATA_EN_1d <= MEM_WDATA_EN;
          MEM_WE_1d <= iMEM_WE;
          MEM_WDATA_1d <= MEM_WDATA;
       end if;
    end process;
    MEM_DATA <= MEM_WDATA_1d when MEM_WDATA_EN_1d='1' and MEM_WE_1d='0' else (others => 'Z'); 

	USB_nWR <= iMEM_WE;
	USB_nRD <= iMEM_OE;
	USB_WAKEUP <= '0'; -- Suspend mode OFF
	USB_DRQ <= "00"; -- 6MHz Crystal Oscillator
	USB_DACK <= "11"; -- DMA is not used.
	USB_EPT <= "11"; -- DMA is not used.


    -- ARM CT connection
    ARM_nRESET <= nSYSRST;
    ARM_HCLKIN <= CLK2; --CLK_24MHZ; --CLK2;	
    ARM_REFCLK <= CLK2; --CLK_24MHZ; --CLK2;
    ARM_BIGENDIN <= '0';
    ARM_DBGEN <= '1';
    ARM_ETMEXTIN <= ARM_EXTTRIG;
    ARM_DEWPT <= '0';
    ARM_IEBKPT <= '0';
    ARM_TESTSELECT <= '0';
    ARM_TICSELECT <= '0';
    ARM_EDBGRQ <= '0';

    -- Sync RESET to ARM_HCLK
    process (ARM_HCLK, nSYSRST) begin
       if (nSYSRST='0') then
          HClkResetFF1 <= '0';
          HClkResetFF2 <= '0';
          HClkResetFF3 <= '0';
       elsif rising_edge (ARM_HCLK) then
          HClkResetFF1 <= nSYSRST;
          HClkResetFF2 <= HClkResetFF1;
          HClkResetFF3 <= HClkResetFF2;
       end if;
    end process;

    ARM_HRESETn <= HClkResetFF3; -- hw reset + sw reset

    -- power-on reset delay counter
--    process (CLK_24MHZ, nSYSRST) begin--> ?RST?
--       if (nSYSRST='0') then
--             PORCount <= 0;
--       elsif rising_edge (CLK_24MHZ) then
--          if (PORCountEnd='0') then
--             PORCount <= PORCount + 1;
--          end if;
--       end if;
--    end process;
    process (CLK_24MHZ) begin
       if rising_edge (CLK_24MHZ) then
          if (PORCountEnd='0') then
             PORCount <= PORCount + 1;
          end if;
       end if;
    end process;

    PORCountEnd <= '1' when PORCount=PORCountMax else '0';
    
    ARM_nPORESET <= nSYSPOR;

    ARM_nCONFIGRST <= '1' when (PORCount /= CONFIGRSTCount) else '0';
    ARM_CONFIGINIT <= '1' when (PORCount = CONFIGINITCount) else '0';



    PORT1HSIZE <= sig_sub_sin(9).HSIZE(1 downto 0);

--    sig_sout(2).HSPLIT <= (others => '0'); --DPSRAM split

    sig_sub_sout(9).HSPLIT <= (others => '0'); --DPSRAM split



    DPRAM_PORT2HCLK <= '0';
    DPRAM_PORT2HSEL <= '0';
    DPRAM_PORT2HREADYIN <= '1';
    DPRAM_PORT2HTRANS <= "00";
    DPRAM_PORT2HSIZE <= "10";
    DPRAM_PORT2HWRITE <= '0';
    DPRAM_PORT2HWDATA <= "00000000000000000000000000000000";
    DPRAM_PORT2HADDR <= "00000000000000000000000000000000";



	 

	 --------------------------------------------------
    -- port mapping
    --------------------------------------------------
    -----------------
    -- AHB matrixs --
    -----------------
    -- AHB matrix (4 master & 10 slave)
    uahb_matrix_m4s10r : ahb_matrix_m4s10r
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,

                  MASTEROUT(0) => sig_mout(0),
                  MASTEROUT(1) => sig_mout(1),
                  MASTEROUT(2) => sig_mout(2),
                  MASTEROUT(3) => sig_mout(3),
                  SLAVEOUT(0) => sig_sout(0),
                  SLAVEOUT(1) => sig_sout(1),
                  SLAVEOUT(2) => sig_sout(2),
                  SLAVEOUT(3) => sig_sout(3),
                  SLAVEOUT(4) => sig_sout(4),
                  SLAVEOUT(5) => sig_sout(5),
                  SLAVEOUT(6) => sig_sout(6),
                  SLAVEOUT(7) => sig_sout(7),

                  SLAVEOUT(8) => sig_sout(8),

                  SLAVEOUT(9) => sig_sout(9),


                  MASTERIN(0) => sig_min(0),
                  MASTERIN(1) => sig_min(1),
                  MASTERIN(2) => sig_min(2),
                  MASTERIN(3) => sig_min(3),
                  SLAVEIN(0) => sig_sin(0),
                  SLAVEIN(1) => sig_sin(1),
                  SLAVEIN(2) => sig_sin(2),
                  SLAVEIN(3) => sig_sin(3),
                  SLAVEIN(4) => sig_sin(4),
                  SLAVEIN(5) => sig_sin(5),
                  SLAVEIN(6) => sig_sin(6),
                  SLAVEIN(7) => sig_sin(7),
                  SLAVEIN(8) => sig_sin(8),
                  SLAVEIN(9) => sig_sin(9),
                  HSLAVEID => HSLAVEID,
                  DECADDR => DECADDR,

                  BUSSTATE => open
                );


    ------------------------
    -- AHB 4M 8S main bus --
    ------------------------


        -- AHB dummy master (Master 3)
    uAHB_DUMMY_MASTER_REC_main3 : AHB_DUMMY_MASTER_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,
                  pMIN => sig_min(3),
                  pMOUT => sig_mout(3)
                );



        -- AHB dummy master (Master 1)
    uAHB_DUMMY_MASTER_REC_main1 : AHB_DUMMY_MASTER_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,
                  pMIN => sig_min(1),
                  pMOUT => sig_mout(1)
                );



       -- LCD controller slave (Slave 8, Master 1)

    uTFTLCDCTRL_REC : TFTLCDCTRL_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,

                  pSIN => sig_sub_sin(4), 
                  pSOUT => sig_sub_sout(4),

                  pMIN => sig_sub_min(2), 
                  pMOUT => sig_sub_mout(2),
                  -- should be connedted later.
                  LCD_D => LCD_D,
                  LCD_VSYNC => LCD_VSYNC, 
                  LCD_HSYNC => LCD_HSYNC, 
                  LCD_DE => LCD_DE, 
                  LCD_CLK => LCD_CLK, 
                  LCD_LEND => LCD_LEND 
                );


    -- DMA master & slave (Slave 9, Master 2)
    uSMDMA_REC : SMDMA_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,

                  pMIN => sig_min(2), 
                  pMOUT => sig_mout(2),

                  pSIN => sig_sub_sin(5), 
                  pSOUT => sig_sub_sout(5),

                  nIRQ => IRQ_DMA 
                );


    -- AHB dummy slave (Slave 2)
    uAHB_DUMMY_SLAVE_REC2 : AHB_DUMMY_SLAVE_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,
                  pSIN => sig_sin(2),
                  pSOUT => sig_sout(2)
                );


    -- AHB dummy slave (Slave 6)
    uAHB_DUMMY_SLAVE_REC6 : AHB_DUMMY_SLAVE_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,
                  pSIN => sig_sin(6),
                  pSOUT => sig_sout(6)
                );


    -- AHB dummy slave (Slave 7)
    uAHB_DUMMY_SLAVE_REC7 : AHB_DUMMY_SLAVE_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,
                  pSIN => sig_sin(7),
                  pSOUT => sig_sout(7)
                );

    -- AHB dummy slave (Slave 8)
    uAHB_DUMMY_SLAVE_REC8 : AHB_DUMMY_SLAVE_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,
                  pSIN => sig_sin(8),
                  pSOUT => sig_sout(8)
                );

    -- AHB dummy slave (Slave 9)
    uAHB_DUMMY_SLAVE_REC9 : AHB_DUMMY_SLAVE_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,
                  pSIN => sig_sin(9),
                  pSOUT => sig_sout(9)
                );


    -- Ext.Async SRAM controller/SRAM (Slave 1,6)
    uASYNC_SRAM_CTRL_AHB32_REC : ASYNC_SRAM_CTRL_AHB32_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,

                  pSIN => sig_sin(1), 
                  pSOUT => sig_sout(1),

                  pSIN_CON => sig_sub_sin(2), 
                  pSOUT_CON => sig_sub_sout(2),

                  ADDR => t_MEM_ADDR(22 downto 0),
                  MEM_WAIT => MEM_WAIT,
                  RDATA => MEM_RDATA,
                  FLA_BAA => t_MEM_ADDR(23),
                  FLA_CLK => open,
                  FLA_LBA => MEM_FLASH_NBYTE,
                  FLASH_CEN => MEM_FLASH_nCS1,
                  IO0_CEN => open,
                  IO1_CEN => open,
--                 LBN => MEM_LBN,

--                   UBN => MEM_UBN,

						MEM_nBE => MEM_nBE,
                  OEN => iMEM_OE,
                  SRAM_CEN => iMEM_SRAM_nCS0,

                  WDATA => MEM_WDATA,
                  WDATA_EN => MEM_WDATA_EN,
                  WEN => iMEM_WE
                );
	MEM_ADDR <= (t_MEM_ADDR(21 downto 0) & "00") when (iUSB_nCS = '0') else t_MEM_ADDR(23 downto 0);
	USB_nCS <= iUSB_nCS;
	iUSB_nCS      <= iMEM_SRAM_nCS0 or (not t_MEM_ADDR(19)) or (not t_MEM_ADDR(18));
	MEM_SRAM_nCS0 <= iMEM_SRAM_nCS0 or (t_MEM_ADDR(19) and t_MEM_ADDR(18));

    -- SDRAM controller (Slave 3)
    uSDRAM_CTRL_REC : SDRAM_CTRL_REC
        port map( CH0_HCLK => ARM_HCLK,
                  CH0_HRESETn => ARM_HRESETn,

                  CH0_SIN => sig_sin(3),
                  CH0_SOUT => sig_sout(3),
					  
					   HSEL_CON	=> sig_sub_sin(3).hsel,

                  SDRAM_Clk => SDRAM_Clk,
                  SDRAM_Cke => SDRAM_Cke,
                  SDRAM_Cs_n => SDRAM_Csn,
                  SDRAM_Ras_n => SDRAM_Rasn,
                  SDRAM_Cas_n => SDRAM_Casn,
                  SDRAM_We_n => SDRAM_Wen,
                  SDRAM_Ba => SDRAM_Ba,
                  SDRAM_Addr => SDRAM_Addr,
                  SDRAM_m_D => SDRAM_m_D,
                  SDRAM_m_q => SDRAM_m_q,
                  SDRAM_m_outsel => SDRAM_m_outsel,
                  SDRAM_ODQM => SDRAM_ODQM
                );

    -- CT DP RAM 
    uAHB2PORT1RAM : AHB2PORT1RAM
        port map( HRESETn => ARM_HRESETn,
                  BIGEND => ARM_BIGENDOUT,

                  PORT1HCLK => ARM_HCLK,
                  PORT1HSEL => sig_sub_sin(9).HSEL,
                  PORT1HREADYIN => sig_sub_sin(9).HREADYIN,
                  PORT1HTRANS => sig_sub_sin(9).HTRANS,
                  PORT1HSIZE => sig_sub_sin(9).HSIZE(1 downto 0),
                  --PORT1HSIZE => PORT1HSIZE,
                  PORT1HWRITE => sig_sub_sin(9).HWRITE,
                  PORT1HWDATA => sig_sub_sin(9).HWDATA,
						PORT1HADDR => sig_sub_sin(9).HADDR,
                  PORT1HRDATA => sig_sub_sout(9).HRDATA,
                  PORT1HREADYOUT => sig_sub_sout(9).HREADY,
                  PORT1HRESP => sig_sub_sout(9).HRESP,

                 PORT2HCLK =>  ram_clk,
  							 port2addr =>  ramaddr_in,
  							 port2di =>  ram_data_in,
  								  port2we =>  ram_we,
  								  port2cs =>  ram_ce,
  								  port2bwe =>  ram_bwe,
  								  port2do => open --"00000000000000000000000000000000" 

	  
--                  PORT2HCLK => DPRAM_PORT2HCLK,
--                  PORT2HSEL => DPRAM_PORT2HSEL,
--                 PORT2HREADYIN => DPRAM_PORT2HREADYIN,
--                  PORT2HTRANS => DPRAM_PORT2HTRANS,
--                  PORT2HSIZE => DPRAM_PORT2HSIZE,
--                  PORT2HWRITE => DPRAM_PORT2HWRITE,
--                  PORT2HWDATA => DPRAM_PORT2HWDATA,
----                  PORT2HRDATA => DPRAM_PORT2HRDATA,
--                  PORT2HRDATA => open,
--                  PORT2HADDR => DPRAM_PORT2HADDR,
--                  PORT2HREADYOUT => open,
--                  PORT2HRESP => open
                );



    -- AHB to APB Bridge (Slave 4)
    uAHB2APB_P8_REC : AHB2APB_P8_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,

                  pSIN => sig_sin(4), 
                  pSOUT => sig_sout(4),

                  pPIN0 => sig_pin(0),
                  pPOUT0 => sig_pout(0),
                  pPIN1 => sig_pin(1),
                  pPOUT1 => sig_pout(1),
                  pPIN2 => sig_pin(2),
                  pPOUT2 => sig_pout(2),
                  pPIN3 => sig_pin(3),
                  pPOUT3 => sig_pout(3),

                  pPIN4 => sig_pin(4),
                  pPOUT4 => sig_pout(4),

                  pPIN5 => sig_pin(5),
                  pPOUT5 => sig_pout(5),

                  pPIN6 => sig_pin(6),
                  pPOUT6 => sig_pout(6),

                  pPIN7 => sig_pin(7),
                  pPOUT7 => sig_pout(7),

					   PSLAVEOK => PSLAVEOK,
            		PSLAVEID => PSLAVEID


                );



-- APB 추가합니다.
    u2AHB2APB_P8_REC : AHB2APB_P8_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,

                  pSIN   => sig_sub_sin(1), 
                  pSOUT  => sig_sub_sout(1),

                  pPIN0  => sig_2ndpin(0),
                  pPOUT0 => sig_2ndpout(0),
                  pPIN1  => sig_2ndpin(1),
                  pPOUT1 => sig_2ndpout(1),
                  pPIN2  => sig_2ndpin(2),
                  pPOUT2 => sig_2ndpout(2),
                  pPIN3  => sig_2ndpin(3),
                  pPOUT3 => sig_2ndpout(3),
                  pPIN4  => sig_2ndpin(4),
                  pPOUT4 => sig_2ndpout(4),
                  pPIN5  => sig_2ndpin(5),
                  pPOUT5 => sig_2ndpout(5),
                  pPIN6  => sig_2ndpin(6),
                  pPOUT6 => sig_2ndpout(6),
                  pPIN7  => sig_2ndpin(7),
                  pPOUT7 => sig_2ndpout(7),

				  PSLAVEOK => PSLAVE_2ndOK,
            	  PSLAVEID => PSLAVE_2ndID


                );

    uAPB_SEG_CHARLCD_REC : APB_SEG_CHARLCD_REC 
      port map(     
        PCLK     => ARM_HCLK,
        PRESETn  => ARM_HRESETn,

        pPIN     => sig_2ndpin(0),
        pPOUT    => sig_2ndpout(0),

        LCD_RS   => LCD_RS,
        LCD_RW   => LCD_RW,
        LCD_EN   => LCD_EN,
        LCD_DATA => LCD_DATA,
                    
        SEGOUT   => SEGOUT,
        SEGCOM   => SEGCOM,

        LED_OUT  => LED
        );           



    -- 2nd APB dummy slave (Slave 0)
--    uAPB_DUMMY_SLAVE_REC_2nd_p0 : APB_DUMMY_SLAVE_REC
--        port map( PCLK => ARM_HCLK,
--                  PRESETn => ARM_HRESETn,
--                  pPIN => sig_2ndpin(0),
--                  pPOUT => sig_2ndpout(0)
--                );

    -- 2nd APB dummy slave (Slave 1)
    uAPB_DUMMY_SLAVE_REC_2nd_p1 : APB_DUMMY_SLAVE_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,
                  pPIN => sig_2ndpin(1),
                  pPOUT => sig_2ndpout(1)
                );

    -- 2nd APB dummy slave (Slave 2)
    uAPB_DUMMY_SLAVE_REC_2nd_p2 : APB_DUMMY_SLAVE_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,
                  pPIN => sig_2ndpin(2),
                  pPOUT => sig_2ndpout(2)
                );

    -- 2nd APB dummy slave (Slave 3)
    uAPB_DUMMY_SLAVE_REC_2nd_p3 : APB_DUMMY_SLAVE_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,
                  pPIN => sig_2ndpin(3),
                  pPOUT => sig_2ndpout(3)
                );

    -- 2nd APB dummy slave (Slave 4)
    uAPB_DUMMY_SLAVE_REC_2nd_p4 : APB_DUMMY_SLAVE_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,
                  pPIN => sig_2ndpin(4),
                  pPOUT => sig_2ndpout(4)
                );

    -- 2nd APB dummy slave (Slave 5)
    uAPB_DUMMY_SLAVE_REC_2nd_p5 : APB_DUMMY_SLAVE_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,
                  pPIN => sig_2ndpin(5),
                  pPOUT => sig_2ndpout(5)
                );

    -- 2nd APB dummy slave (Slave 6)
    uAPB_DUMMY_SLAVE_REC_2nd_p6 : APB_DUMMY_SLAVE_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,
                  pPIN => sig_2ndpin(6),
                  pPOUT => sig_2ndpout(6)
                );

    -- 2nd APB dummy slave (Slave 7)
    uAPB_DUMMY_SLAVE_REC_2nd_p7 : APB_DUMMY_SLAVE_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,
                  pPIN => sig_2ndpin(7),
                  pPOUT => sig_2ndpout(7)
                );


    -- Slave ID of APB bus
    PSLAVE_2ndOK <= '1' when (sub_HSLAVEID="0001") else '0';

    APB_BUS_DEC2 : process (DECADDR) begin
       case DECADDR(11 downto 8) is
          when "0000"   => PSLAVE_2ndID <= "000"; -- 7Segment, Character LCD
          when others => PSLAVE_2ndID <= "111"; --default slave 
       end case;
    end process;




	     
    -- FND & 7SEGMENT
--	 uSEG_SLAVE	: SEG_SLAVE
--	 		port map(
--						HSEL =>  sig_sub_sin(1).HSEL ,
--						HWRITE => sig_sub_sin(1).HWRITE  ,
--						HRESETn => ARM_HRESETn ,
--						HCLOCK =>  ARM_HCLK ,
--						HADDRESS => sig_sub_sin(1).HADDR  ,
--						HBURST =>  sig_sub_sin(1).HBURST ,
--						HSIZE => sig_sub_sin(1).HSIZE(1 downto 0)  ,
--						HTRANS =>  sig_sub_sin(1).HTRANS ,
--						HWDATA => sig_sub_sin(1).HWDATA  ,
--						HREADY => sig_sub_sout(1).HREADY  ,
--						HRESP => sig_sub_sout(1).HRESP  ,
--						read_reg => sig_sub_sout(1).HRDATA  ,
--						lcd_en => lcd_en  ,
--						phase => open  ,
--						cnt8 => open  ,
--						data_out => data_out  ,
--						mode =>  mode ,
--						rd_address => open  ,
--						seg_data => open  ,
--						seg_gnd => seg_gnd  ,
--						seg_out => seg_out  
--					);



   
    --------------------
    -- APB Bus Slaves --
    --------------------
    -- cpGTCRegs slave (Slave 0)
    ucpGTCRegs : cpGTCRegs
        port map( 

		  				PORESETn => nSYSPOR,
                  PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,
                  PSEL => sig_pin(0).PSEL,
                  PENABLE => sig_pin(0).PENABLE,
                  PADDR => sig_pin(0).PADDR(7 downto 2),
                  PWRITE => sig_pin(0).PWRITE,
                  PWDATA => sig_pin(0).PWDATA,
                  PRDATA => sig_pout(0).PRDATA,
                  CLKREF24MHZ => CLK_24MHZ,
                  CLKREF24MHZRESETn => nSYSRST,
                  ID => ID,
                  MBDET => MBDET,
                  MAN_ID => MAN_ID,
                  ARM_PLLREFDIV => ARM_PLLREFDIV,
                  ARM_PLLCTRL => ARM_PLLCTRL,
                  ARM_PLLFBDIV => ARM_PLLFBDIV,
                  ARM_PLLOUTDIV => ARM_PLLOUTDIV,
                  ARM_HCLKDIV => ARM_HCLKDIV,
                  ARM_PLLBYPASS => ARM_PLLBYPASS,
                  ARM_INITRAM => ARM_INITRAM,
                  ARM_USERIN => ARM_USERIN,
                  ARM_VINITHI => ARM_VINITHI,
                  OSC0_VECTOR => OSC0_VECTOR,
                  OSC1_VECTOR => OSC1_VECTOR,
                  OSC2_VECTOR => OSC2_VECTOR,
                  PLDSET => PLDSET,
                  PLDREAD => PLDREAD,
                  POWERCHN => POWERCHN,
                  PLDSYNC => PLDSYNC,
                  LED => open,
                  SW => SW(3 downto 0),
                  --HRDATACONFIG => open, -- ARM11 ?
                  HRDATACONFIG => iARM_HRDATACONFIG,
                  COMMRX => ARM_COMMRX,
                  COMMTX => ARM_COMMTX,
                  IRQ => ARM_IRQ,
                  FIQ => ARM_FIQ,
                  ARMMAILBOXFULL => ARMMAILBOXFULL,
                  VPBREGINT => VPBREGINT,
                  VPBMAILBOXEMPTY => VPBMAILBOXEMPTY
                );

    -- UART (Slave 1)
    uUART_REC0 : UART_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,

                  pPIN => sig_pin(1),
                  pPOUT => sig_pout(1),

                  CTS => CTS0,
                  RXD => RXD0,
                  RTS => RTS0,
                  TXD => TXD0,
                  UARTR => IRQ_Uartr0,
                  UARTT => IRQ_Uartt0
                );

    uUART_REC1 : UART_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,

                  pPIN => sig_pin(4),
                  pPOUT => sig_pout(4),

                  CTS => CTS1,
                  RXD => RXD1,
                  RTS => RTS1,
                  TXD => TXD1,
                  UARTR => IRQ_Uartr1,
                  UARTT => IRQ_Uartt1
                );

    -- Interrupt Controller (Slave 2)
    uINTR_CTRL_REC : INTR_CTRL_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,

                  pPIN => sig_pin(2),
                  pPOUT => sig_pout(2),

                  INT_REQn => IRQ_Req,
                  INT_ACKn => IRQ_Ack,
                  INT_IRQ => ARM_nIRQ,
                  INT_FIQ => ARM_nFIQ
                );


    -- Timer (Slave 3)
    uTIMER_REC : TIMER_REC
        port map( PCLK => ARM_HCLK,
                  PRESETn => ARM_HRESETn,
                  TIMER_CLK => Timer_Clk,

                  pPIN => sig_pin(3),
                  pPOUT => sig_pout(3),

                  TIMER_INT => IRQ_Timer,
                  TIMER_INT0 => IRQ_Timer0,
                  TIMER_INT1 => IRQ_Timer1,
                  TIMER_INT2 => IRQ_Timer2
                );
 



	uAC97_REC : AC97_REC
      Port map (     
        PCLK   	=>	  ARM_HCLK,
        PRESETn	=>	  ARM_HRESETn,
        
        pPIN   	=>	  sig_pin(5),
        pPOUT  	=>	  sig_pout(5),
              
        AC97IRQ 	  =>	IRQ_AC97 ,

		  SUSPENDED_O =>	open ,

	     BIT_CLK_PAD_I =>	AC97_BCLK,
        SYNC_PAD_O 	 =>	AC97_SYNC,
        SDATA_PAD_O 	 =>	AC97_SDO,
        SDATA_PAD_I 	 =>	AC97_SDI,
	     AC97_RESET_PAD_O =>	AC97_RST 

		  );



    -- APB dummy slave (Slave 5)
--    uAPB_DUMMY_SLAVE_REC_p5 : APB_DUMMY_SLAVE_REC
--        port map( PCLK => ARM_HCLK,
--                  PRESETn => ARM_HRESETn,
--                  pPIN => sig_pin(5),
--                  pPOUT => sig_pout(5)
--                );


	uI2S_REC0 : I2S_REC 
    port MAP(
        -- Control AHB Bus Clock & Reset
        PCLK 				=>	  ARM_HCLK,	
        PRESETn			=>   ARM_HRESETn  ,

        -- Controller AHB Slave Interface
        pPIN 				=>    sig_pin(6) ,
        pPOUT				=>    sig_pout(6) ,

        -- I2S Interface
--      I2S_CLK : In std_logic;

        nI2SIRQ  			=>   	 IRQ_I2S,

        I2S_SD_I 			=>     I2S_SD_I,
        I2S_SCK_I			=>     I2S_SCK_I,
        I2S_WS_I 			=>     I2S_WS_I,

        I2S_SD_O 			=>     I2S_SD_O,
        I2S_SCK_O			=>     I2S_SCK_O,
        I2S_WS_O 			=>     I2S_WS_O
   	 );

	uI2S_REC1 : I2S_REC 
    port MAP(
        -- Control AHB Bus Clock & Reset
        PCLK 				=>	  ARM_HCLK,	
        PRESETn			=>   ARM_HRESETn  ,

        -- Controller AHB Slave Interface
        pPIN 				=>    sig_pin(7) ,
        pPOUT				=>    sig_pout(7) ,

        -- I2S Interface
--      I2S_CLK : In std_logic;

        nI2SIRQ  			=>   	 open, --IRQ_I2S,

        I2S_SD_I 			=>     I2S_SD_I_1,
        I2S_SCK_I			=>     I2S_SCK_I_1,
        I2S_WS_I 			=>     I2S_WS_I_1,

        I2S_SD_O 			=>     I2S_SD_O_1,
        I2S_SCK_O			=>     I2S_SCK_O_1,
        I2S_WS_O 			=>     I2S_WS_O_1
   	 );


   -- APB dummy slave (Slave 6)
--    uAPB_DUMMY_SLAVE_REC_p6 : APB_DUMMY_SLAVE_REC
--        port map( PCLK => ARM_HCLK,
--                  PRESETn => ARM_HRESETn,
--                  pPIN => sig_pin(6),
--                  pPOUT => sig_pout(6)
--                );


   -- APB dummy slave (Slave 7)
--    uAPB_DUMMY_SLAVE_REC_p7 : APB_DUMMY_SLAVE_REC
--        port map( PCLK => ARM_HCLK,
--                  PRESETn => ARM_HRESETn,
--                  pPIN => sig_pin(7),
--                  pPOUT => sig_pout(7)
--                );


	-- AHB2AHB
	uAHB2AHB : AHB2AHB_sync_rec
   port map ( 
            -- Bus Clock/Reset
            HCLK   => ARM_HCLK,
            HRESETn => ARM_HRESETn,
                  
            -- Slave Interface to Master Bus (Bus A)            
            pAIN  => sig_sin(0),
            pAOUT =>	sig_sout(0),
            
            -- Master Interface to Slave Bus (Bus B)
            pBIN  =>	sig_sub_min(0),
            pBOUT =>	sig_sub_mout(0)
        );          
	



	-- sub AHB
	usub_AHB_MATRIX : ahb_matrix_m4s10r
    port map (
            HCLK  => ARM_HCLK,  
            HRESETn => ARM_HRESETn,
                                    
            -- Master/Slave Component Interface
            MASTEROUT(0) => sig_sub_mout(0),
            MASTEROUT(1) => sig_sub_mout(1),
            MASTEROUT(2) => sig_sub_mout(2),
            MASTEROUT(3) => sig_sub_mout(3),

            MASTERIN(0) =>	sig_sub_min(0),
						MASTERIN(1) =>	sig_sub_min(1),
            MASTERIN(2) =>	sig_sub_min(2),
						MASTERIN(3) =>	sig_sub_min(3),

            SLAVEOUT(0) =>	sig_sub_sout(0),
						SLAVEOUT(1) =>	sig_sub_sout(1),
						SLAVEOUT(2) => sig_sub_sout(2),
						SLAVEOUT(3) => sig_sub_sout(3),
						SLAVEOUT(4) => sig_sub_sout(4),
						SLAVEOUT(5) => sig_sub_sout(5),
						SLAVEOUT(6) => sig_sub_sout(6),
						SLAVEOUT(7) => sig_sub_sout(7),
						SLAVEOUT(8) => sig_sub_sout(8),
						SLAVEOUT(9) => sig_sub_sout(9),
                                    
            SLAVEIN(0) => sig_sub_sin(0),
						SLAVEIN(1) => sig_sub_sin(1),
						SLAVEIN(2) => sig_sub_sin(2),
						SLAVEIN(3) => sig_sub_sin(3),
						SLAVEIN(4) => sig_sub_sin(4),
						SLAVEIN(5) => sig_sub_sin(5),
						SLAVEIN(6) => sig_sub_sin(6),
						SLAVEIN(7) => sig_sub_sin(7),
						SLAVEIN(8) => sig_sub_sin(8),
						SLAVEIN(9) => sig_sub_sin(9),
            
            -- Decoder Interface
            HSLAVEID  => sub_HSLAVEID,
            DECADDR	 => sub_DECADDR,
            
            -- Global Bus State
            BUSSTATE => open
				);


       -- sub AHB dummy master (sub Master 1)
    uAHB_DUMMY_MASTER_REC_sub1 : AHB_DUMMY_MASTER_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,
                  pMIN => sig_sub_min(1),
                  pMOUT => sig_sub_mout(1)
                );



       -- sub AHB dummy master (sub Master 2)
--    uAHB_DUMMY_MASTER_REC_sub2 : AHB_DUMMY_MASTER_REC
--        port map( HCLK => ARM_HCLK,
--                  HRESETn => ARM_HRESETn,
--                  pMIN => sig_sub_min(2),
--                  pMOUT => sig_sub_mout(2)
--                );



       -- sub AHB dummy master (sub Master 3)
    uAHB_DUMMY_MASTER_REC_sub3 : AHB_DUMMY_MASTER_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,
                  pMIN => sig_sub_min(3),
                  pMOUT => sig_sub_mout(3)
                );

    -- sub AHB dummy slave (Slave 0)
    uAHB_DUMMY_SLAVE_REC_sub0 : AHB_DUMMY_SLAVE_REC
        port map( HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,
                  pSIN => sig_sub_sin(0),
                  pSOUT => sig_sub_sout(0)
                );

    -- sub AHB dummy slave (Slave 8)
--    uAHB_DUMMY_SLAVE_REC_sub8 : AHB_DUMMY_SLAVE_REC
--        port map( HCLK => ARM_HCLK,
--                  HRESETn => ARM_HRESETn,
--                  pSIN => sig_sub_sin(8),
--                  pSOUT => sig_sub_sout(8)
--                );



    -- sub AHB dummy slave (Slave 9)
--   uAHB_DUMMY_SLAVE_REC_sub9 : AHB_DUMMY_SLAVE_REC
--        port map( HCLK => ARM_HCLK,
--                  HRESETn => ARM_HRESETn,
--                  pSIN => sig_sub_sin(9),
--                  pSOUT => sig_sub_sout(9)
--                );

  	 EBI_DATA(7 downto 0) <= EBI_DOUT(7 downto 0) when (EBI_DOUTSELn(0) = '0') else (others => 'Z');
	 EBI_DATA(15 downto 8) <= EBI_DOUT(15 downto 8) when (EBI_DOUTSELn(1) = '0') else (others => 'Z');
	 EBI_DATA(7 downto 0) <= EBI_DOUT(23 downto 16) when (EBI_DOUTSELn(2) = '0') else (others => 'Z');
	 EBI_DATA(15 downto 8) <= EBI_DOUT(31 downto 24) when (EBI_DOUTSELn(3) = '0') else (others => 'Z');

	 EBI_DIN <= EBI_DATA(15 downto 0) & EBI_DATA(15 downto 0);
	 
	 EBI_BWE <= EBI_BWE_OUT;

 	uEBI32_REC : EBI32_REC
    port map (   
        HCLK    => ARM_HCLK,
        HRESETn => ARM_HRESETn,
        
        -- Control (Slave) Interface
        pSIN    =>  sig_sub_sin(6),
        pSOUT   =>  sig_sub_sout(6),
        
        DCLK    => ARM_HCLK,
        DRESETn => ARM_HRESETn,
        
        -- Data (Slave) Interface
        pDIN    =>  sig_sin(5),
        pDOUT   =>  sig_sout(5),
        
        -- EBI Interface
        EBI_DOUTSELn => EBI_DOUTSELn,
        EBI_ADDR  =>  EBI_ADDR,
        EBI_CS  => EBI_CS,
        EBI_OE  => EBI_OE,
        EBI_SOE  =>  open,
        EBI_WE	 =>  EBI_WE,
        EBI_BWE  => EBI_BWE_OUT,
        EBI_LD	  => open,
        EBI_ADV  => open,
        EBI_DOUT => EBI_DOUT,
        EBI_DIN  => EBI_DIN,
        EBI_ACK  => '1',
        EBI_ZZ	  => open,
        
        -- EBI_CONFIG
        EBI_SYNC => '0',
        EBI_SIZE => "01" );



   reset_gen : RESETGEN_REC
   port map(  -- AHB Bus Clock & Reset 
            HCLK   => ARM_HCLK,
            HRESETn => ARM_HRESETn,
          
            -- AHB Bus Slave Interface
            pSIN 	 =>  sig_sub_sin(7),
            pSOUT	 =>  sig_sub_sout(7),
          
            -- Generated Reset Signal
            nPRST  => gen_reset
          );


   ramaddr_in <=  "0000000000000000" & ramaddr(16 downto 1);
   ram_data_in <= ramdata_t & ramdata_t;
   ram_bwe <= "0011" when ramaddr(0) = '0' else "1100";


	CIS_IF_REC0 : CIS_IF_REC 
	 port map(

  	  HCLK => ARM_HCLK,
                  HRESETn => ARM_HRESETn,

		pSIN => sig_sub_sin(8),
    pSOUT => sig_sub_sout(8),                  
                  

		-- SRAM interface
	  ramaddr =>  ramaddr,
	  ramdata => ramdata_t , 
	  ram_ce  => ram_ce ,
	  ram_we => ram_we ,
	  ram_clk =>  ram_clk,
	  test_led => open, --test_led,
	  
	  

						CMCLK  	=>   CMCLK,
						CRESETB 	=>   CRESETB,
						CENB  	=>   CENB,
						CSCL   	=>  CSCL,
						CSDA   	=>  CSDA,
						CVCLK  	=>   CVCLK,
						CVSYNC 	=>   CVSYNC,
						CHSYNC   =>   CHSYNC,
						CY     	=>   CY
					 );

  


end BEHAVIORAL;



