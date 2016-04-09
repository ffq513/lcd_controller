--------------------------------------------------------------------------------------
--  Single Master Direct Memory Access Controller
--  This file is a part of SNU Base Platform Package
--
--  Date : 2004. 4. 25
--  Author : Sanggyu, Park (System design lab, SoEE, SNU)
--  Copyright 2004  Seoul National University(SNU)
--  ALL RIGHTS RESERVED
--------------------------------------------------------------------------------------

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_arith.all;
    use IEEE.std_logic_misc.all;

library Work;
    use Work.all;


library Work;
use Work.AMBA.all;

-- synthesis translate_off

library SoCBaseSim;
use SoCBaseSim.AMBA.all;

-- synthesis translate_on

entity SMDMA_REC is

    port(
        HCLK	:    in		std_logic;
        HRESETn :    in    	std_logic;

        -- DMA Master Interface
        pMIN    :    in    	AHB_MasterIn_Type;
        pMOUT   :    out    AHB_MasterOut_Type;

        -- Slave Interface
        pSIN    :    in    	AHB_SlaveIn_Type;
        pSOUT   :    out    AHB_SlaveOut_Type;

        -- Interrupt Signals
        nIRQ    :    out    std_logic
    );

end SMDMA_REC;

architecture STRUCTURAL of SMDMA_REC is

    component SMDMA
        port(
            HCLK    :    in    std_logic;
            HRESETn    :    in    std_logic;

            -- Master Interface
            MHGRANT    :    in    std_logic;
            MHREADY    :    in    std_logic;
            MHRESP    :    in    std_logic_vector(1 downto 0);
            MHRDATA    :    in    std_logic_vector(31 downto 0);

            MHBUSREQ:    out    std_logic;
            MHLOCK    :    out std_logic;
            MHTRANS    :    out std_logic_vector(1 downto 0);
            MHADDR    :    out std_logic_vector(31 downto 0);
            MHWRITE    :    out std_logic;
            MHSIZE    :    out std_logic_vector(2 downto 0);
            MHBURST    :    out std_logic_vector(2 downto 0);
            MHPROT    :    out std_logic_vector(3 downto 0);
            MHWDATA    :    out std_logic_vector(31 downto 0);

            -- Control (Slave) Interface
            SHSEL   :    in std_logic;
            SHADDR  :    in std_logic_vector(31 downto 0);
            SHWRITE :    in std_logic;
            SHTRANS :    in std_logic_vector(1 downto 0);
            SHSIZE  :    in std_logic_vector(2 downto 0);
            SHBURST :    in std_logic_vector(2 downto 0);
            SHWDATA :    in std_logic_vector(31 downto 0);
            SHLOCK  :    in std_logic;
			SHREADYIN:	 in std_logic;
            SHREADY :    out std_logic;
            SHRESP  :    out std_logic_vector(1 downto 0);
            SHRDATA :    out std_logic_vector(31 downto 0);

            -- Interrupt Signal
            nIRQ    :    out std_logic    -- Negative sensitive Interrupt Request
        );
    end component;

begin

    DMA0 : SMDMA
        port map (  HCLK => HCLK, 				HRESETn => HRESETn,
                    MHGRANT => pMIN.hgrant,     MHREADY => pMIN.hready,
                    MHRESP => pMIN.hresp,       MHRDATA => pMIN.hrdata,
                    MHBUSREQ => pMOUT.hbusreq,  MHLOCK => pMOUT.hlock,
                    MHTRANS => pMOUT.htrans,    MHADDR => pMOUT.haddr,
                    MHWRITE => pMOUT.hwrite,    MHSIZE => pMOUT.hsize,
                    MHBURST => pMOUT.hburst,    MHPROT => pMOUT.hprot,
                    MHWDATA => pMOUT.hwdata,
                    SHSEL => pSIN.hsel,         SHADDR => pSIN.haddr,
                    SHWRITE => pSIN.hwrite,     SHTRANS => pSIN.htrans,
                    SHSIZE => pSIN.hsize,       SHBURST => pSIN.hburst,
                    SHWDATA => pSIN.hwdata,     SHLOCK => pSIN.hlock,
                    SHREADY => pSOUT.hready,    SHRESP => pSOUT.hresp,
                    SHRDATA => pSOUT.hrdata,	SHREADYIN => pSIN.hreadyin,
                    nIRQ => nIRQ);

    pSOUT.hsplit <= (others => '0');

end STRUCTURAL;




