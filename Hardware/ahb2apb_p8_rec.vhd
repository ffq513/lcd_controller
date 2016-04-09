								--------------------------------------------------------------
-- AHB2APB_ Bridge
-- This file is a part of SNU AMBA package
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

entity AHB2APB_P8_REC is
      Port (  
            -- AHB Bus Clock Signal         
            HCLK : In    std_logic;
            HRESETn : In    std_logic;
                        
            -- AHB Bus Slave Interface
            pSIN    :   in  AHB_SlaveIn_Type;
            PSOUT   :   out AHB_SlaveOut_Type;
            
            -- APB Bus Slave Interface
            pPIN0   :   out APB_SlaveIn_Type;
            pPOUT0  :   in APB_SlaveOut_Type;
            
            pPIN1   :   out  APB_SlaveIn_Type;
            pPOUT1  :   in APB_SlaveOut_Type;
            
            pPIN2   :   out  APB_SlaveIn_Type;
            pPOUT2  :   in APB_SlaveOut_Type;
            
            pPIN3   :   out  APB_SlaveIn_Type;
            pPOUT3  :   in APB_SlaveOut_Type;
            
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
end AHB2APB_P8_REC;

architecture BEHAVIORAL of AHB2APB_P8_REC is

    component AHB2APB_P8
      Port ( HRESETn : In    std_logic;              
                HCLK : In    std_logic;
               HADDR : In    std_logic_vector (31 downto 0);
              HBURST : In    std_logic_vector (2 downto 0);
                HSEL : In    std_logic;
               HSIZE : In    std_logic_vector (2 downto 0);
              HTRANS : In    std_logic_vector (1 downto 0);
              HWDATA : In    std_logic_vector (31 downto 0);
              HWRITE : In    std_logic;
              HREADYIN : In    std_logic;
            PSLAVEOK : In    std_logic;  
             PSLAVEID: In    std_logic_vector(2 downto 0);
             PRDATA0X : In    std_logic_vector (31 downto 0);               
             PRDATA1X : In    std_logic_vector (31 downto 0);
             PRDATA2X : In    std_logic_vector (31 downto 0);
             PRDATA3X : In    std_logic_vector (31 downto 0);
             PRDATA4X : In    std_logic_vector (31 downto 0);
             PRDATA5X : In    std_logic_vector (31 downto 0);
             PRDATA6X : In    std_logic_vector (31 downto 0);
             PRDATA7X : In    std_logic_vector (31 downto 0);
              HRDATA : Out   std_logic_vector (31 downto 0);
              HREADY : Out   std_logic;
               HRESP : Out   std_logic_vector (1 downto 0);
               PADDR : Out   std_logic_vector (31 downto 0);
             PENABLE : Out   std_logic;
              PSEL0X : Out   std_logic;
              PSEL1X : Out   std_logic;
              PSEL2X : Out   std_logic;
              PSEL3X : Out   std_logic;
              PSEL4X : Out   std_logic;
              PSEL5X : Out   std_logic;
              PSEL6X : Out   std_logic;
              PSEL7X : Out   std_logic;
              PWDATA : Out   std_logic_vector (31 downto 0);
              PWRITE : Out   std_logic );
    end component;
     
    signal sig_penable : std_logic;
    signal sig_paddr : std_logic_vector(31 downto 0);
    signal sig_pwrite : std_logic;  
    signal sig_pwdata : std_logic_vector(31 downto 0);

                    
begin

    -- APB Slave Interface 0    
    pPIN0.penable <= sig_penable;
    pPIN0.paddr <= sig_paddr;   
    pPIN0.pwrite <= sig_pwrite;     
    pPIN0.pwdata <= sig_pwdata; 
    
    -- APB Slave Interface 1    
    pPIN1.penable <= sig_penable;
    pPIN1.paddr <= sig_paddr;   
    pPIN1.pwrite <= sig_pwrite;     
    pPIN1.pwdata <= sig_pwdata; 

    -- APB Slave Interface 2    
    pPIN2.penable <= sig_penable;
    pPIN2.paddr <= sig_paddr;   
    pPIN2.pwrite <= sig_pwrite;     
    pPIN2.pwdata <= sig_pwdata;     
    
    -- APB Slave Interface 3    
    pPIN3.penable <= sig_penable;
    pPIN3.paddr <= sig_paddr;   
    pPIN3.pwrite <= sig_pwrite;     
    pPIN3.pwdata <= sig_pwdata;     

    -- APB Slave Interface 4    
    pPIN4.penable <= sig_penable;
    pPIN4.paddr <= sig_paddr;   
    pPIN4.pwrite <= sig_pwrite;     
    pPIN4.pwdata <= sig_pwdata; 

    -- APB Slave Interface 5    
    pPIN5.penable <= sig_penable;
    pPIN5.paddr <= sig_paddr;   
    pPIN5.pwrite <= sig_pwrite;     
    pPIN5.pwdata <= sig_pwdata; 

    -- APB Slave Interface 6    
    pPIN6.penable <= sig_penable;
    pPIN6.paddr <= sig_paddr;   
    pPIN6.pwrite <= sig_pwrite;     
    pPIN6.pwdata <= sig_pwdata; 

    -- APB Slave Interface 7    
    pPIN7.penable <= sig_penable;
    pPIN7.paddr <= sig_paddr;   
    pPIN7.pwrite <= sig_pwrite;     
    pPIN7.pwdata <= sig_pwdata; 


    pSOUT.hsplit <= (others => '0');
    
    BR0 : AHB2APB_P8
        port map(
                HRESETn => HRESETn,         HCLK => HCLK,
                HADDR => pSIN.haddr,        HBURST => pSIN.hburst,
                HSEL => pSIN.hsel,          HSIZE => pSIN.hsize,
                HTRANS => pSIN.htrans,      HWDATA => pSIN.hwdata,
                HWRITE => pSIN.hwrite,      HREADYIN => pSIN.hreadyin,   
		HRDATA => pSOUT.hrdata,
                HREADY => pSOUT.hready,     HRESP => pSOUT.hresp,
                
                PRDATA0X => pPOUT0.prdata,  PRDATA1X => pPOUT1.prdata,  
                PRDATA2X => pPOUT2.prdata,  PRDATA3X => pPOUT3.prdata,  
                PRDATA4X => pPOUT4.prdata,  PRDATA5X => pPOUT5.prdata,
                PRDATA6X => pPOUT6.prdata,  PRDATA7X => pPOUT7.prdata,
                PADDR => sig_paddr,         PENABLE => sig_penable,
                PSEL0X => pPIN0.psel,       PSEL1X => pPIN1.psel, 
                PSEL2X => pPIN2.psel,       PSEL3X => pPIN3.psel,
                PSEL4X => pPIN4.psel,       PSEL5X => pPIN5.psel,
                PSEL6X => pPIN6.psel,       PSEL7X => pPIN7.psel,
                PWDATA => sig_pwdata,       PWRITE => sig_pwrite,
                PSLAVEID => PSLAVEID,       PSLAVEOK => PSLAVEOK
            );

end BEHAVIORAL;


