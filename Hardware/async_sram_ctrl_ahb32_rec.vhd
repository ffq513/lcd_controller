--------------------------------------------------------------
-- Asynchronous SRAM Bus Controller
-- This file is a part of SoC Base Platform
--
-- Date : 2004. 04. 25
-- Author : Junho Kwon (GCT Semiconductor)
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
--    use SoCBaseSim.AMBA.all;
-- synthesis translate_on

entity ASYNC_SRAM_CTRL_AHB32_REC is
      Port (
        -- Clock & Reset
        HCLK        : In std_logic;
        HRESETn    : In std_logic;

        -- AHB Slave for Data Access
        pSIN        : in AHB_SlaveIn_Type;
        pSOUT        : out AHB_SlaveOut_Type;

        -- AHB Slave for Control Access
        pSIN_CON    : in AHB_SlaveIn_Type;
        pSOUT_CON    : out AHB_SlaveOut_Type;

        -- Async SRAM Bus Interface
        ADDR        : Out std_logic_vector (22 downto 0);
        MEM_WAIT    : In std_logic;
        RDATA        : In std_logic_vector (31 downto 0);
        FLA_BAA    : Out std_logic;
        FLA_CLK    : Out std_logic;
        FLA_LBA    : Out std_logic;
        FLASH_CEN    : Out std_logic;
        IO0_CEN    : Out std_logic;
        IO1_CEN    : Out std_logic;
--        LBN        : Out std_logic;
--        UBN        : Out std_logic;
		  MEM_nBE			: out std_logic_vector(3 downto 0);
        OEN        : Out std_logic;
        SRAM_CEN    : Out std_logic;
        WDATA        : Out std_logic_vector (31 downto 0);
        WDATA_EN    : Out std_logic;
        WEN        : Out std_logic);
end ASYNC_SRAM_CTRL_AHB32_REC;

architecture BEHAVIORAL of ASYNC_SRAM_CTRL_AHB32_REC is

    component ASYNC_SRAM_CTRL_AHB32
      Port (
            -- Clock & Reset
            HCLK        : In std_logic;
            HRESETn    : In std_logic;

            -- AHB Slave for Data Access
            HADDR        : In std_logic_vector (31 downto 0);
            HBURST        : In std_logic_vector (2 downto 0);
            HSEL        : In std_logic;
            HSIZE        : In std_logic_vector (2 downto 0);
            HTRANS        : In std_logic_vector (1 downto 0);
            HWDATA        : In std_logic_vector (31 downto 0);
            HWRITE        : In std_logic;
            HRDATA        : Out std_logic_vector (31 downto 0);
            HREADY        : Out std_logic;
            HRESP        : Out std_logic_vector (1 downto 0);

            -- AHB Slave for Control Access
            HADDR_CON    : In std_logic_vector (31 downto 0);
            HSEL_CON    : In std_logic;
            HWDATA_CON    : In std_logic_vector (31 downto 0);
            HWRITE_CON    : In std_logic;
            HSIZE_CON    : In std_logic_vector (2 downto 0);
            HBURST_CON    : In std_logic_vector (2 downto 0);
            HTRANS_CON    : In std_logic_vector (1 downto 0);
            HRESP_CON    : Out std_logic_vector (1 downto 0);
            HRDATA_CON    : Out std_logic_vector (31 downto 0);
            HREADY_CON    : Out std_logic;

            -- Async SRAM Bus Interface
            ADDR        : Out std_logic_vector (22 downto 0);
            MEM_WAIT    : In std_logic;
            RDATA        : In std_logic_vector (31 downto 0);
            FLA_BAA    : Out std_logic;
            FLA_CLK    : Out std_logic;
            FLA_LBA    : Out std_logic;
            FLASH_CEN    : Out std_logic;
            IO0_CEN    : Out std_logic;
            IO1_CEN    : Out std_logic;
--            LBN        : Out std_logic;
--            UBN        : Out std_logic;
            OEN        : Out std_logic;
				MEM_nBE			: out std_logic_vector(3 downto 0);
            SRAM_CEN    : Out std_logic;
            WDATA        : Out std_logic_vector (31 downto 0);
            WDATA_EN    : Out std_logic;
            WEN        : Out std_logic);
    end component;

begin

    pSOUT.hsplit <= (others => '0');
    pSOUT_CON.hsplit <= (others => '0');

    C0 : ASYNC_SRAM_CTRL_AHB32
        port map(    HCLK => HCLK,            HRESETn => HRESETn,
                    HADDR  => pSIN.haddr,    HBURST => pSIN.hburst,
                    HSEL   => pSIN.hsel,    HSIZE  => pSIN.hsize,
                    HTRANS => pSIN.htrans,    HWDATA => pSIN.hwdata,
                    HWRITE => pSIN.hwrite,    HRDATA => pSOUT.hrdata,
                    HREADY => pSOUT.hready,    HRESP  => pSOUT.hresp,

                    HADDR_CON  => pSIN_CON.haddr,    HBURST_CON => pSIN_CON.hburst,
                    HSEL_CON   => pSIN_CON.hsel,    HSIZE_CON  => pSIN_CON.hsize,
                    HTRANS_CON => pSIN_CON.htrans,    HWDATA_CON => pSIN_CON.hwdata,
                    HWRITE_CON => pSIN_CON.hwrite,    HRDATA_CON => pSOUT_CON.hrdata,
                    HREADY_CON => pSOUT_CON.hready,    HRESP_CON  => pSOUT_CON.hresp,

                    MEM_WAIT  => MEM_WAIT,    ADDR      => ADDR,
                    FLA_BAA   => FLA_BAA,    FLA_CLK   => FLA_CLK,
                    FLA_LBA   => FLA_LBA,    FLASH_CEN => FLASH_CEN,
                    IO0_CEN   => IO0_CEN,    IO1_CEN   => IO1_CEN,
--                    LBN       => LBN,       UBN       => UBN,
							MEM_nBE	=> MEM_nBE,
                    SRAM_CEN  => SRAM_CEN,     OEN       => OEN,
                    WDATA     => WDATA,        WDATA_EN  => WDATA_EN,
                    WEN       => WEN,        RDATA => RDATA);

end BEHAVIORAL;



