--------------------------------------------------------------
-- AHB2AHB_SYNC_REC Bridge (Record Type Interface)
-- This file is a part of SNU AMBA package
-- 
-- Date : 2004. 04. 25
-- Author : Sanggyu, Park (Ph.D Candidate of SoEE, SNU)
-- Copyright 2004  Seoul National University, Seoul, Korea
-- ALL RIGHTS RESERVED
--------------------------------------------------------------

-- General Description
-- AHB to AHB Bridge (Pass through type)


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;


library Work;
use Work.AMBA.all;

-- synthesis translate_off

library SoCBaseSim;
use SoCBaseSim.AMBA.all;

-- synthesis translate_on

entity AHB2AHB_SYNC_REC is
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
end AHB2AHB_SYNC_REC;

architecture BEHAVIORAL of AHB2AHB_SYNC_REC is
    
    component AHB2AHB_SYNC
        port ( 
            -- Bus Clock/Reset
            HCLK     : in    std_logic; 
            HRESETn   : in    std_logic; 
                  
            -- Slave Interface to Master Bus (Bus A)            
            MHSEL    : in    std_logic;             
            MHADDR   : in    std_logic_vector (31 downto 0); 
            MHWRITE  : in    std_logic; 
            MHTRANS  : in    std_logic_vector (1 downto 0); 
            MHSIZE   : in    std_logic_vector (2 downto 0); 
            MHBURST  : in    std_logic_vector (2 downto 0);             
            MHWDATA  : in    std_logic_vector (31 downto 0); 
            MHMASTERID:in    std_logic_vector(3 downto 0);          
            MHLOCK   : in    std_logic;
            MHPROT   : in    std_logic_vector(3 downto 0);
            MHREADYIN: in    std_logic;                     
            MHREADY  : out   std_logic; 
            MHRESP   : out   std_logic_vector (1 downto 0);
            MHRDATA  : out   std_logic_vector (31 downto 0);            
            MHSPLIT  : out   std_logic_vector(15 downto 0);         
            
            -- Master Interface to Slave Bus (Bus B)
            SHGRANT  : in    std_logic; 
            SHREADY  : in    std_logic; 
            SHRESP   : in    std_logic_vector (1 downto 0); 
            SHRDATA  : in    std_logic_vector (31 downto 0);            
            
            SHBUSREQ : out   std_logic; 
            SHLOCK   : out   std_logic; 
            SHPROT   : out   std_logic_vector(3 downto 0);
            SHTRANS  : out   std_logic_vector (1 downto 0); 
            SHADDR   : out   std_logic_vector (31 downto 0); 
            SHWRITE  : out   std_logic; 
            SHSIZE   : out   std_logic_vector (2 downto 0); 
            SHBURST  : out   std_logic_vector (2 downto 0);         
            SHWDATA  : out   std_logic_vector (31 downto 0)
        );          
    end component;


begin
    
    Br0 : AHB2AHB_SYNC
        port map(       
            
            HCLK=>HCLK,    
            HRESETn=>HRESETn,                  
            
            MHSEL     => pAIN.hsel,     MHADDR    => pAIN.haddr,      
            MHWRITE   => pAIN.hwrite,   MHTRANS   => pAIN.htrans,    
            MHSIZE    => pAIN.hsize,    MHBURST   => pAIN.hburst,       
            MHWDATA   => pAIN.hwdata,   MHMASTERID=> pAIN.hmasterid,   
            MHLOCK    => pAIN.hlock,    MHPROT    => pAIN.hprot,        
            MHREADYIN => pAIN.hreadyin, MHREADY   => pAOUT.hready,
            MHRESP    => pAOUT.hresp,   MHRDATA   => pAOUT.hrdata,  
            MHSPLIT   => pAOUT.hsplit,          
            
            SHGRANT   => pBIN.hgrant,   SHREADY   => pBIN.hready, 
            SHRESP    => pBIN.hresp,    SHRDATA   => pBIN.hrdata,           
            SHBUSREQ  => pBOUT.hbusreq, SHLOCK    => pBOUT.hlock,   
            SHPROT    => pBOUT.hprot,   SHTRANS   => pBOUT.htrans,  
            SHADDR    => pBOUT.haddr,   SHWRITE   => pBOUT.hwrite,  
            SHSIZE    => pBOUT.hsize,   SHBURST   => pBOUT.hburst,      
            SHWDATA   => pBOUT.hwdata  
        );

end BEHAVIORAL;





