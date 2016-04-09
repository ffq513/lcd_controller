--------------------------------------------------------------
-- AHB Slave Interface Template
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
    
entity EBI32_REC is

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
        EBI_SIZE:       in std_logic_vector(1 downto 0)     
    );
end EBI32_REC;  

architecture behavioral of EBI32_REC is

    component EBI32

        port(   
            -- AHB Bus Clock & Reset Signals
            HCLK    :       in  std_logic;
            HRESETn :       in  std_logic;
            
            -- AHB Control Slave Interface
            HSEL   :        in std_logic;
            HADDR  :        in std_logic_vector(31 downto 0);
            HWRITE :        in std_logic;
            HTRANS :        in std_logic_vector(1 downto 0);
            HSIZE  :        in std_logic_vector(2 downto 0);
            HBURST :        in std_logic_vector(2 downto 0);
            HWDATA :        in std_logic_vector(31 downto 0);
            HLOCK  :        in std_logic;
            HREADYIN:       in std_logic;
            HREADY :        out std_logic;
            HRESP  :        out std_logic_vector(1 downto 0);
            HRDATA :        out std_logic_vector(31 downto 0);
            HSPLIT :        out std_logic_vector(15 downto 0);
            
            -- AHB Data Bus Clock & Reset Signals
            DCLK    :       in  std_logic;
            DRESETn :       in  std_logic;
            
            -- AHB Data Slave Interface
            DSEL   :        in std_logic;
            DADDR  :        in std_logic_vector(31 downto 0);
            DWRITE :        in std_logic;
            DTRANS :        in std_logic_vector(1 downto 0);
            DSIZE  :        in std_logic_vector(2 downto 0);
            DBURST :        in std_logic_vector(2 downto 0);
            DWDATA :        in std_logic_vector(31 downto 0);
            DLOCK  :        in std_logic;
            DREADYIN:       in std_logic;
            DREADY :        out std_logic;
            DRESP  :        out std_logic_vector(1 downto 0);
            DRDATA :        out std_logic_vector(31 downto 0);
            DSPLIT :        out std_logic_vector(15 downto 0);
            
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
            EBI_SIZE:       in std_logic_vector(1 downto 0)     
        );
    end component;

begin   

    A0 : EBI32
        port map(   HCLK => HCLK,           HRESETn => HRESETn,
                    HSEL   => pSIN.hsel,    HADDR  => pSIN.haddr, 
                    HWRITE => pSIN.hwrite,  HTRANS => pSIN.htrans,
                    HSIZE  => pSIN.hsize,   HBURST => pSIN.hburst,
                    HWDATA => pSIN.hwdata,  HLOCK  => pSIN.hlock,
                    HREADYIN => pSIN.hreadyin,
                    HREADY => pSOUT.hready, HRESP  => pSOUT.hresp, 
                    HRDATA => pSOUT.hrdata, HSPLIT => pSOUT.hsplit,
                    
                    DCLK => DCLK,           DRESETn => DRESETn,
                    DSEL   => pDIN.hsel,    DADDR  => pDIN.haddr, 
                    DWRITE => pDIN.hwrite,  DTRANS => pDIN.htrans,
                    DSIZE  => pDIN.hsize,   DBURST => pDIN.hburst,
                    DWDATA => pDIN.hwdata,  DLOCK  => pDIN.hlock,
                    DREADYIN => pDIN.hreadyin,
                    DREADY => pDOUT.hready, DRESP  => pDOUT.hresp, 
                    DRDATA => pDOUT.hrdata, DSPLIT => pDOUT.hsplit,
                    
                    EBI_SOE => EBI_SOE,		EBI_DOUTSELn => EBI_DOUTSELn,
                    EBI_ADDR => EBI_ADDR,   
                    EBI_CS => EBI_CS,       EBI_OE => EBI_OE,       
                    EBI_WE => EBI_WE,       EBI_BWE => EBI_BWE, 
                    EBI_LD => EBI_LD,       EBI_ADV => EBI_ADV, 
                    EBI_DOUT => EBI_DOUT,   EBI_DIN => EBI_DIN, 
                    EBI_ACK => EBI_ACK,     EBI_ZZ => EBI_ZZ,
                    
                    EBI_SYNC => EBI_SYNC,   EBI_SIZE => EBI_SIZE
        );
        
end behavioral;

