library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library Work;
use Work.all;

library Work;
use Work.AMBA.all;


entity CIS_IF_REC	is
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
end CIS_IF_REC;

architecture cis_if_rec_arch of CIS_IF_REC is

	  component CIS_IF is
    port (
        
        HCLK	:	in std_logic;
        HRESETn	:   in std_logic;


				-- Controller AHB slave Interface
        HSEL 	:   in std_logic;
        HADDR 	:   in std_logic_vector(31 downto 0);
        HWRITE 	:   in std_logic;
        HTRANS 	:   in std_logic_vector(1 downto 0);
        HSIZE 	:   in std_logic_vector(2 downto 0);
        HBURST 	:   in std_logic_vector(2 downto 0);
        HWDATA 	:   in std_logic_vector(31 downto 0);
        HREADY 	:   out std_logic;
        HRDATA 	:   out std_logic_vector(31 downto 0);
        HRESP  	:   out std_logic_vector(1 downto 0);
        

			  --dpram interface
				CLKA			: OUT std_logic;
				DINA			: OUT std_logic_VECTOR(15 downto 0);
				ADDRA 			: OUT std_logic_VECTOR(16 downto 0);
				ENA				: OUT std_logic;
				WEA				: OUT std_logic;
				
				
			TFT_ENABLE	: out std_logic;
			TEST_LED		: out std_logic_vector(3 downto 0);
        
        -- Camera Interface
			CSCL    : inout std_logic;
			CSDA    : inout std_logic;        
			CMCLK : in std_logic;
			CVsync : in std_logic;
			CHsync : in std_logic;
			CDATA : in std_logic_vector(7 downto 0);
			CPCLK : out std_logic;
			CRESET : out std_logic;
			CPWEN : out std_logic
    ); end component;
  
begin

	ucis_if : cis_if
			port map(
			HCLK		=>  HCLK,
			HRESETn	=>  HRESETn,
			
      HSEL => pSIN.HSEL ,    		HADDR => pSIN.HADDR ,
      HWRITE => pSIN.HWRITE , 	HTRANS => pSIN.HTRANS ,
      HSIZE => pSIN.HSIZE ,    	HBURST => pSIN.HBURST ,
      HWDATA => pSIN.HWDATA , 	HREADY => pSOUT.HREADY ,
      HRDATA => pSOUT.HRDATA ,	HRESP  => pSOUT.HRESP  ,
			
				
			-- Camera Interface
			CMCLK 			=>  CVCLK,
			CVsync 			=>  CVSYNC,
			CHsync 			=>  CHSYNC,
			CDATA 			=>  CY,
			CPCLK 			=>  CMCLK,
			CRESET			=>  CRESETB,
			CPWEN 			=>  CENB,
			CSCL => CSCL,
			CSDA	=> CSDA,

			CLKA			=>  ram_clk,
			DINA			=>  ramdata,
			ADDRA 		=>  ramaddr,
			ENA				=>  ram_ce,
			WEA				=>  ram_we,

			TFT_ENABLE	=>  open ,
			TEST_LED		=>  test_led
			);

end cis_if_rec_arch;
