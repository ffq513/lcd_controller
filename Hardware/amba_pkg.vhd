--------------------------------------------------------------
-- AMBA Package
-- This file is a part of AHB-TVM package
-- 
-- Date : 2004. 04. 25
-- Author : Sanggyu, Park (Ph.D Candidate of SoEE, SNU)
-- Copyright 2004  Seoul National University, Seoul, Korea
-- ALL RIGHTS RESERVED
--------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package AMBA is

    --%% AHB Netregated Signal Type Definition
    subtype AHB_MasterIn_Net is std_logic_vector(35 downto 0);
    subtype AHB_MasterOut_Net is std_logic_vector(78 downto 0);
    subtype AHB_SlaveIn_Net is std_logic_vector(83 downto 0);
    subtype AHB_SlaveOut_Net is std_logic_vector(50 downto 0);
    subtype APB_SlaveIn_Net is std_logic_vector(66 downto 0);
    subtype APB_SlaveOut_Net is std_logic_vector(31 downto 0);
    
    type MST_INTARRAY is array (NATURAL range <>) of integer;
    type SLV_INTARRAY is array (NATURAL range <>) of integer;
    type INTARRAY is array (NATURAL range <>) of integer;
    
    --%% AHB Structured Signal Type Definition
    -- AHB Master Inputs
    type AHB_MasterIn_Type is record
        HREADY: std_logic;
        HRESP: std_logic_vector(1 downto 0);
        HRDATA : std_logic_vector(31 downto 0);
        HGRANT : std_logic;        
    end record;
    
    -- AHB Master Outputs
    type AHB_MasterOut_Type is record
        HLOCK : std_logic;
        HTRANS : std_logic_vector(1 downto 0);
        HADDR : std_logic_vector(31 downto 0);
        HWRITE : std_logic;
        HSIZE : std_logic_vector(2 downto 0);
        HBURST : std_logic_vector(2 downto 0);
        HPROT : std_logic_vector(3 downto 0);
        HWDATA : std_logic_vector(31 downto 0);
        HBUSREQ : std_logic;
    end record;
    
    -- AHB Slave Inputs
    type AHB_SlaveIn_Type is record
        HLOCK : std_logic;
        HTRANS : std_logic_vector(1 downto 0);
        HADDR : std_logic_vector(31 downto 0);
        HWRITE : std_logic;
        HSIZE : std_logic_vector(2 downto 0);
        HBURST : std_logic_vector(2 downto 0);
        HPROT : std_logic_vector(3 downto 0);
        HWDATA : std_logic_vector(31 downto 0);
        HSEL : std_logic;
        HMASTERID : std_logic_vector(3 downto 0);
        HREADYIN : std_logic;
    end record;
    
    type AHB_SlaveOut_Type is record
        HREADY: std_logic;
        HRESP: std_logic_vector(1 downto 0);
        HRDATA : std_logic_vector(31 downto 0);
        HSPLIT : std_logic_vector(15 downto 0);
    end record;
    
    type AHB_ARBITER_OUT is record      
        HBUSREQ:    std_logic_vector(15 downto 0);
        HTRANS:     std_logic_vector(1 downto 0);
        HBURST:     std_logic_vector(2 downto 0);
        HLOCK:      std_logic;
        HREADY:     std_logic;
        HRESP:      std_logic_vector(1 downto 0);
        HSPLIT:     std_logic_vector(15 downto 0);  -- ORd Split signal     
    end record;
    
    type AHB_REC is record
        HADDR:      std_logic_vector(31 downto 0);
        HTRANS:     std_logic_vector(1 downto 0);
        HBURST:     std_logic_vector(2 downto 0);
        HSIZE:      std_logic_vector(2 downto 0);
        HPROT:      std_logic_vector(3 downto 0);
        HLOCK:      std_logic;
        HWDATA:     std_logic_vector(31 downto 0);
        HWRITE:     std_logic;
        HRDATA:     std_logic_vector(31 downto 0);
        HREADY:     std_logic;
        HRESP:      std_logic_vector(1 downto 0);
        HBUSREQ:    std_logic_vector(15 downto 0);      
        HGRANT:     std_logic_vector(15 downto 0);
        HLOCKVEC:   std_logic_vector(15 downto 0);
        HSEL:       std_logic_vector(15 downto 0);
        HSPLIT:     std_logic_vector(15 downto 0);
        HMASTER:    std_logic_vector(3 downto 0);       
    end record;
    
    type APB_SLAVEIN_TYPE is record
        PSEL:       std_logic;
        PENABLE:    std_logic;
        PADDR:      std_logic_vector(31 downto 0);
        PWRITE:     std_logic;      
        PWDATA:     std_logic_vector(31 downto 0);
    end record;
    
    type APB_SLAVEOUT_TYPE is record
        PRDATA:     std_logic_vector(31 downto 0);
    end record;
    
    type AHB_MASTERIN_Net_ARRAY is array (NATURAL range <>) of AHB_MasterIn_Net;
    type AHB_MASTEROUT_Net_ARRAY is array (NATURAL range <>) of AHB_MasterOut_Net;
    type AHB_SLAVEIN_Net_ARRAY is array (NATURAL range <>) of AHB_SlaveIn_Net;  
    type AHB_SLAVEOUT_Net_ARRAY is array (NATURAL range <>) of AHB_SlaveOut_Net;
    
    type AHB_MASTERIN_ARRAY is array (NATURAL range <>) of AHB_MasterIn_Type;
    type AHB_MASTEROUT_ARRAY is array (NATURAL range <>) of AHB_MasterOut_Type;
    type AHB_SLAVEIN_ARRAY is array (NATURAL range <>) of AHB_SlaveIn_Type; 
    type AHB_SLAVEOUT_ARRAY is array (NATURAL range <>) of AHB_SlaveOut_Type;
    type APB_SLAVEIN_ARRAY is array (NATURAL range <>) of APB_SlaveIn_Type; 
    type APB_SLAVEOUT_ARRAY is array (NATURAL range <>) of APB_SlaveOut_Type;

    --%% General Constants Definition  
    -- constants for HTRANS (transition type, slave output)
    constant HTRANS_IDLE:   Std_Logic_Vector(1 downto 0) := "00";
    constant HTRANS_BUSY:   Std_Logic_Vector(1 downto 0) := "01";
    constant HTRANS_NONSEQ: Std_Logic_Vector(1 downto 0) := "10";
    constant HTRANS_SEQ:    Std_Logic_Vector(1 downto 0) := "11";
    
    -- constants for HBURST (burst type, master output)
    constant HBURST_SINGLE: Std_Logic_Vector(2 downto 0) := "000";
    constant HBURST_INCR:   Std_Logic_Vector(2 downto 0) := "001";
    constant HBURST_WRAP4:  Std_Logic_Vector(2 downto 0) := "010";
    constant HBURST_INCR4:  Std_Logic_Vector(2 downto 0) := "011";
    constant HBURST_WRAP8:  Std_Logic_Vector(2 downto 0) := "100";
    constant HBURST_INCR8:  Std_Logic_Vector(2 downto 0) := "101";
    constant HBURST_WRAP16: Std_Logic_Vector(2 downto 0) := "110";
    constant HBURST_INCR16: Std_Logic_Vector(2 downto 0) := "111";
    
    -- constants for HSIZE (transfer size, master output)
    constant HSIZE_BYTE:    Std_Logic_Vector(2 downto 0) := "000";
    constant HSIZE_HWORD:   Std_Logic_Vector(2 downto 0) := "001";
    constant HSIZE_WORD:    Std_Logic_Vector(2 downto 0) := "010";
    constant HSIZE_DWORD:   Std_Logic_Vector(2 downto 0) := "011";
    constant HSIZE_4WORD:   Std_Logic_Vector(2 downto 0) := "100";
    constant HSIZE_8WORD:   Std_Logic_Vector(2 downto 0) := "101";
    constant HSIZE_16WORD:  Std_Logic_Vector(2 downto 0) := "110";
    constant HSIZE_32WORD:  Std_Logic_Vector(2 downto 0) := "111";
    
    -- constants for HRESP (response, slave output)
    constant HRESP_OKAY:    Std_Logic_Vector(1 downto 0) := "00";
    constant HRESP_ERROR:   Std_Logic_Vector(1 downto 0) := "01";
    constant HRESP_RETRY:   Std_Logic_Vector(1 downto 0) := "10";
    constant HRESP_SPLIT:   Std_Logic_Vector(1 downto 0) := "11";
    
    --%% Conversion Functions 
    
    -- From Structured Type to Netregated Type
    
    function AHB_MASTERIN_REC_TO_NET(V : AHB_MasterIn_Type) 
        return AHB_MasterIn_Net;
    
    function AHB_MASTEROUT_REC_TO_NET(V : AHB_MasterOut_Type) 
        return AHB_MasterOut_Net;
    
    function AHB_SLAVEOUT_REC_TO_NET(V : AHB_SlaveOut_Type) 
        return AHB_SlaveOut_Net;
    
    function AHB_SLAVEIN_REC_TO_NET(V : AHB_SlaveIn_Type) 
        return AHB_SlaveIn_Net; 
        
    function APB_SLAVEOUT_REC_TO_NET(V : APB_SlaveOut_Type) 
        return APB_SlaveOut_Net;
    
    function APB_SLAVEIN_REC_TO_NET(V : APB_SlaveIn_Type) 
        return APB_SlaveIn_Net; 
    
    -- From Netregated Type to Structured Type
    
    function AHB_MASTERIN_REC_FROM_NET(ahbsig : AHB_MasterIn_Net) 
        return AHB_MasterIn_Type;
    
    function AHB_MASTEROUT_REC_FROM_NET(ahbsig : AHB_MasterOut_Net) 
        return AHB_MasterOut_Type;
    
    function AHB_SLAVEOUT_REC_FROM_NET(ahbsig : AHB_SlaveOut_Net) 
        return AHB_SlaveOut_Type;
    
    function AHB_SLAVEIN_REC_FROM_NET(ahbsig : AHB_SlaveIn_Net) 
        return AHB_SlaveIn_Type;
        
    function APB_SLAVEOUT_REC_FROM_NET(APBsig : APB_SlaveOut_Net) 
        return APB_SlaveOut_Type;
    
    function APB_SLAVEIN_REC_FROM_NET(APBsig : APB_SlaveIn_Net) 
        return APB_SlaveIn_Type;
        
    function conv_from_std_logic(a : std_logic) return integer;

    function conv_from_std_logic_vector(a : std_logic_vector) return integer;

    procedure AHB_MASTEROUT_FROM_NET(ahbsig : in AHB_MasterOut_Net;
                                    HLOCK   : out std_logic;
                                    HTRANS  : out std_logic_vector(1 downto 0);
                                    HADDR     : out std_logic_vector(31 downto 0);
                                    HWRITE  : out std_logic;
                                    HSIZE   : out std_logic_vector(2 downto 0);
                                    HBURST  : out std_logic_vector(2 downto 0);
                                    HPROT   : out std_logic_vector(3 downto 0);
                                    HWDATA  : out std_logic_vector(31 downto 0);
                                    HBUSREQ : out std_logic);
    
    procedure AHB_SLAVEOUT_FROM_NET(ahbsig : in AHB_SlaveOut_Net;
                                    HREADY : out std_logic;
                                    HRESP  : out std_logic_vector(1 downto 0);
                                    HRDATA : out std_logic_vector(31 downto 0);
                                    HSPLIT : out std_logic_vector(15 downto 0));
    
    procedure AHB_MASTERIN_FROM_NET(ahbsig : in AHB_MasterIn_Net;
                                    HREADY : out std_logic;
                                    HRESP  : out std_logic_vector(1 downto 0);
                                    HRDATA : out std_logic_vector(31 downto 0);
                                    HGRANT : out std_logic);
    
    procedure AHB_SLAVEIN_FROM_NET(ahbsig : in AHB_SlaveIn_Net; 
                                    HLOCK  : out std_logic;
                                    HTRANS : out std_logic_vector(1 downto 0);
                                    HADDR  : out std_logic_vector(31 downto 0);
                                    HWRITE : out std_logic;
                                    HSIZE  : out std_logic_vector(2 downto 0);
                                    HBURST : out std_logic_vector(2 downto 0);
                                    HPROT  : out std_logic_vector(3 downto 0);
                                    HWDATA : out std_logic_vector(31 downto 0);
                                    HSEL   : out std_logic;
                                    HMASTERID: out std_logic_vector(3 downto 0);
                                    HREADYIN : out std_logic);
    
    
    procedure AHB_MASTEROUT_FROM_REC(ahbsig : in AHB_MasterOut_Type;
                                    HLOCK   : out std_logic;
                                    HTRANS  : out std_logic_vector(1 downto 0);
                                    HADDR     : out std_logic_vector(31 downto 0);
                                    HWRITE  : out std_logic;
                                    HSIZE   : out std_logic_vector(2 downto 0);
                                    HBURST  : out std_logic_vector(2 downto 0);
                                    HPROT   : out std_logic_vector(3 downto 0);
                                    HWDATA  : out std_logic_vector(31 downto 0);
                                    HBUSREQ : out std_logic);
    
    procedure AHB_SLAVEOUT_FROM_REC(ahbsig : in AHB_SlaveOut_Type;
                                    HREADY : out std_logic;
                                    HRESP  : out std_logic_vector(1 downto 0);
                                    HRDATA : out std_logic_vector(31 downto 0);
                                    HSPLIT : out std_logic_vector(15 downto 0));
    
    procedure AHB_MASTERIN_FROM_REC(ahbsig : in AHB_MasterIn_Type;
                                    HREADY : out std_logic;
                                    HRESP  : out std_logic_vector(1 downto 0);
                                    HRDATA : out std_logic_vector(31 downto 0);
                                    HGRANT : out std_logic);
    
    procedure AHB_SLAVEIN_FROM_REC(ahbsig : in AHB_SlaveIn_Type; 
                                    HLOCK  : out std_logic;
                                    HTRANS : out std_logic_vector(1 downto 0);
                                    HADDR  : out std_logic_vector(31 downto 0);
                                    HWRITE : out std_logic;
                                    HSIZE  : out std_logic_vector(2 downto 0);
                                    HBURST : out std_logic_vector(2 downto 0);
                                    HPROT  : out std_logic_vector(3 downto 0);
                                    HWDATA : out std_logic_vector(31 downto 0);
                                    HSEL   : out std_logic;
                                    HMASTERID: out std_logic_vector(3 downto 0);
                                    HREADYIN : out std_logic);
    
    procedure APB_SLAVEIN_FROM_REC(apbsig : in APB_SlaveIn_Type;
                                    PSEL   : out std_logic;
                                    PENABLE: out std_logic;
                                    PADDR  : out std_logic_vector(31 downto 0);
                                    PWRITE:  out std_logic;
                                    PWDATA : out std_logic_vector(31 downto 0));                                    

    procedure APB_SLAVEOUT_FROM_REC(apbsig: in APB_SlaveOut_Type;
                                    PRDATA : out std_logic_vector(31 downto 0));
                                    
    

end AMBA;


package body AMBA is

-- From Structured Type to Netregated Type
    
    function AHB_MASTERIN_REC_TO_Net(V : AHB_MasterIn_Type) 
        return AHB_MasterIn_Net is
        variable ahbsig : AHB_MasterIn_Net;
    begin
        ahbsig(0) := V.HREADY;
        ahbsig(2 downto 1) := V.HRESP;
        ahbsig(34 downto 3) := V.HRDATA;
        ahbsig(35) := V.HGRANT;
        return ahbsig;
    end AHB_MASTERIN_REC_TO_Net;
    
    function AHB_MASTEROUT_REC_TO_Net(V : AHB_MasterOut_Type) 
        return AHB_MasterOut_Net is
        variable ahbsig : AHB_MasterOut_Net;
    begin
        ahbsig(0) := V.HLOCK;
        ahbsig(2 downto 1) := V.HTRANS;
        ahbsig(34 downto 3) := V.HADDR;     
        ahbsig(35) := V.HWRITE;
        ahbsig(38 downto 36) := V.HSIZE;
        ahbsig(41 downto 39) := V.HBURST;
        ahbsig(45 downto 42) := V.HPROT;
        ahbsig(77 downto 46) := V.HWDATA;
        ahbsig(78) := V.HBUSREQ;
        return ahbsig;
    end AHB_MASTEROUT_REC_TO_Net;
    
    function AHB_SLAVEOUT_REC_TO_Net(V : AHB_SlaveOut_Type) 
        return AHB_SlaveOut_Net is
        variable ahbsig : AHB_SlaveOut_Net;
    begin
        ahbsig(0) := V.HREADY;
        ahbsig(2 downto 1) := V.HRESP;
        ahbsig(34 downto 3) := V.HRDATA;
        ahbsig(50 downto 35) := V.HSPLIT;
        return ahbsig;
    end AHB_SLAVEOUT_REC_TO_Net;
    
    function AHB_SLAVEIN_REC_TO_Net(V : AHB_SlaveIn_Type) 
        return AHB_SlaveIn_Net is
        variable ahbsig : AHB_SlaveIn_Net;
    begin
        ahbsig(0) := V.HLOCK;
        ahbsig(2 downto 1) := V.HTRANS;
        ahbsig(34 downto 3) := V.HADDR;     
        ahbsig(35) := V.HWRITE;
        ahbsig(38 downto 36) := V.HSIZE;
        ahbsig(41 downto 39) := V.HBURST;
        ahbsig(45 downto 42) := V.HPROT;
        ahbsig(77 downto 46) := V.HWDATA;
        ahbsig(78) := V.HSEL;
        ahbsig(82 downto 79) := V.HMASTERID;
        ahbsig(83) := V.HREADYIN;
        return ahbsig;
    end AHB_SLAVEIN_REC_TO_Net;
    
    function APB_SLAVEOUT_REC_TO_Net(V : APB_SlaveOut_Type) 
        return APB_SlaveOut_Net is
        variable APBsig : APB_SlaveOut_Net;
    begin
        APBsig(31 downto 0) := V.PRDATA;        
        return APBsig;
    end APB_SLAVEOUT_REC_TO_Net;
    
    function APB_SLAVEIN_REC_TO_Net(V : APB_SlaveIn_Type) 
        return APB_SlaveIn_Net is
        variable APBsig : APB_SlaveIn_Net;
    begin
        APBsig(0) := V.PSEL;
        APBSig(1) := V.PENABLE;
        APBSig(33 downto 2) := V.PADDR;
        APBSig(34) := V.PWRITE;
        APBSig(66 downto 35) := V.PWDATA;       
        return APBsig;
    end APB_SLAVEIN_REC_TO_Net;
    
    
    -- From Netregated Type to Structured Type
    
    function AHB_MASTERIN_REC_FROM_Net(ahbsig : AHB_MasterIn_Net) 
        return AHB_MasterIn_Type is
        variable V : AHB_MasterIn_Type;
    begin
        V.HREADY := ahbsig(0);
        V.HRESP  := ahbsig(2 downto 1);
        V.HRDATA := ahbsig(34 downto 3);    
        V.HGRANT := ahbsig(35);
        return V;
    end AHB_MASTERIN_REC_FROM_Net;
                                    
    
    function AHB_MASTEROUT_REC_FROM_Net(ahbsig : AHB_MasterOut_Net) 
        return AHB_MasterOut_Type is
        variable V : AHB_MasterOut_Type;
    begin
        V.HLOCK   := ahbsig(0);
        V.HTRANS  := ahbsig(2 downto 1);
        V.HADDR   := ahbsig(34 downto 3);   
        V.HWRITE  := ahbsig(35);
        V.HSIZE   := ahbsig(38 downto 36);
        V.HBURST  := ahbsig(41 downto 39);
        V.HPROT   := ahbsig(45 downto 42);
        V.HWDATA  := ahbsig(77 downto 46);
        V.HBUSREQ := ahbsig(78);
        return V;
    end AHB_MASTEROUT_REC_FROM_Net;
    
    function AHB_SLAVEOUT_REC_FROM_Net(ahbsig : AHB_SlaveOut_Net) 
        return AHB_SlaveOut_Type is
        variable V : AHB_SlaveOut_Type;
    begin
        V.HREADY := ahbsig(0);
        V.HRESP  := ahbsig(2 downto 1);
        V.HRDATA := ahbsig(34 downto 3);
        V.HSPLIT := ahbsig(50 downto 35);
        return V;
    end AHB_SLAVEOUT_REC_FROM_Net;
    
    function AHB_SLAVEIN_REC_FROM_Net(ahbsig : AHB_SlaveIn_Net) 
        return AHB_SlaveIn_Type is
        variable V : AHB_SlaveIn_Type;
    begin
        V.HLOCK  := ahbsig(0);              
        V.HTRANS := ahbsig(2 downto 1);         
        V.HADDR  := ahbsig(34 downto 3);    
        V.HWRITE := ahbsig(35);                 
        V.HSIZE  := ahbsig(38 downto 36);   
        V.HBURST := ahbsig(41 downto 39);   
        V.HPROT  := ahbsig(45 downto 42);   
        V.HWDATA := ahbsig(77 downto 46);   
        V.HSEL   := ahbsig(78);                 
        V.HMASTERID:= ahbsig(82 downto 79);     
        V.HREADYIN :=  ahbsig(83);  
        return V;           
    end AHB_SLAVEIN_REC_FROM_Net;
    
    function APB_SLAVEOUT_REC_FROM_Net(APBsig : APB_SlaveOut_Net) 
        return APB_SlaveOut_Type is
        variable V : APB_SlaveOut_Type;
    begin
        V.PRDATA := APBsig(31 downto 0);        
        return V;
    end APB_SLAVEOUT_REC_FROM_Net;
    
    function APB_SLAVEIN_REC_FROM_Net(APBsig : APB_SlaveIn_Net) 
        return APB_SlaveIn_Type is
        variable V : APB_SlaveIn_Type;
    begin
        V.PSEL := APBsig(0);
        V.PENABLE := APBsig(1);
        V.PADDR := APBsig(33 downto 2);
        V.PWRITE := APBsig(34);
        V.PWDATA := APBsig(66 downto 35);
        return V;           
    end APB_SLAVEIN_REC_FROM_Net;
    
    procedure AHB_MASTEROUT_FROM_Net(ahbsig : in AHB_MasterOut_Net;
                                    HLOCK   : out std_logic;
                                    HTRANS  : out std_logic_vector(1 downto 0);
                                    HADDR     : out std_logic_vector(31 downto 0);
                                    HWRITE  : out std_logic;
                                    HSIZE   : out std_logic_vector(2 downto 0);
                                    HBURST  : out std_logic_vector(2 downto 0);
                                    HPROT   : out std_logic_vector(3 downto 0);
                                    HWDATA  : out std_logic_vector(31 downto 0);
                                    HBUSREQ : out std_logic) is
    begin
        HLOCK   := ahbsig(0);
        HTRANS  := ahbsig(2 downto 1);
        HADDR   := ahbsig(34 downto 3);     
        HWRITE  := ahbsig(35);
        HSIZE   := ahbsig(38 downto 36);
        HBURST  := ahbsig(41 downto 39);
        HPROT   := ahbsig(45 downto 42);
        HWDATA  := ahbsig(77 downto 46);
        HBUSREQ := ahbsig(78);
    end AHB_MASTEROUT_FROM_Net;
    
    procedure AHB_SLAVEOUT_FROM_Net(ahbsig : in AHB_SlaveOut_Net;
                                    HREADY : out std_logic;
                                    HRESP  : out std_logic_vector(1 downto 0);
                                    HRDATA : out std_logic_vector(31 downto 0);
                                    HSPLIT : out std_logic_vector(15 downto 0)) is
    begin
        HREADY := ahbsig(0);
        HRESP  := ahbsig(2 downto 1);
        HRDATA := ahbsig(34 downto 3);
        HSPLIT := ahbsig(50 downto 35);
    end AHB_SLAVEOUT_FROM_Net;
    
    procedure AHB_MASTERIN_FROM_Net(ahbsig : in AHB_MasterIn_Net;
                                    HREADY : out std_logic;
                                    HRESP  : out std_logic_vector(1 downto 0);
                                    HRDATA : out std_logic_vector(31 downto 0);
                                    HGRANT : out std_logic) is
    begin
        HREADY := ahbsig(0);
        HRESP  := ahbsig(2 downto 1);
        HRDATA := ahbsig(34 downto 3);  
        HGRANT := ahbsig(35);
    end AHB_MASTERIN_FROM_Net;
    
    procedure AHB_SLAVEIN_FROM_Net(ahbsig : in AHB_SlaveIn_Net; 
                                    HLOCK  : out std_logic;
                                    HTRANS : out std_logic_vector(1 downto 0);
                                    HADDR  : out std_logic_vector(31 downto 0);
                                    HWRITE : out std_logic;
                                    HSIZE  : out std_logic_vector(2 downto 0);
                                    HBURST : out std_logic_vector(2 downto 0);
                                    HPROT  : out std_logic_vector(3 downto 0);
                                    HWDATA : out std_logic_vector(31 downto 0);
                                    HSEL   : out std_logic;
                                    HMASTERID: out std_logic_vector(3 downto 0);
                                    HREADYIN : out std_logic) is
    begin
        HLOCK  := ahbsig(0);                
        HTRANS := ahbsig(2 downto 1);       
        HADDR  := ahbsig(34 downto 3);  
        HWRITE := ahbsig(35);               
        HSIZE  := ahbsig(38 downto 36);     
        HBURST := ahbsig(41 downto 39);     
        HPROT  := ahbsig(45 downto 42);     
        HWDATA := ahbsig(77 downto 46);     
        HSEL   := ahbsig(78);               
        HMASTERID:= ahbsig(82 downto 79);   
        HREADYIN :=  ahbsig(83);    
        
    end AHB_SLAVEIN_FROM_Net;   
    
    procedure AHB_MASTEROUT_FROM_REC(ahbsig : in AHB_MasterOut_Type;
                                    HLOCK   : out std_logic;
                                    HTRANS  : out std_logic_vector(1 downto 0);
                                    HADDR     : out std_logic_vector(31 downto 0);
                                    HWRITE  : out std_logic;
                                    HSIZE   : out std_logic_vector(2 downto 0);
                                    HBURST  : out std_logic_vector(2 downto 0);
                                    HPROT   : out std_logic_vector(3 downto 0);
                                    HWDATA  : out std_logic_vector(31 downto 0);
                                    HBUSREQ : out std_logic) is
    begin
        HLOCK   := ahbsig.HLOCK;   
        HTRANS  := ahbsig.HTRANS;  
        HADDR   := ahbsig.HADDR;        
        HWRITE  := ahbsig.HWRITE;  
        HSIZE   := ahbsig.HSIZE;   
        HBURST  := ahbsig.HBURST;  
        HPROT   := ahbsig.HPROT;   
        HWDATA  := ahbsig.HWDATA;  
        HBUSREQ := ahbsig.HBUSREQ; 
    end AHB_MASTEROUT_FROM_REC;
    
    procedure AHB_SLAVEOUT_FROM_REC(ahbsig : in AHB_SlaveOut_Type;
                                    HREADY : out std_logic;
                                    HRESP  : out std_logic_vector(1 downto 0);
                                    HRDATA : out std_logic_vector(31 downto 0);
                                    HSPLIT : out std_logic_vector(15 downto 0)) is
    begin
        HREADY := ahbsig.HREADY; 
        HRESP  := ahbsig.HRESP;  
        HRDATA := ahbsig.HRDATA; 
        HSPLIT := ahbsig.HSPLIT; 
    end AHB_SLAVEOUT_FROM_REC;
    
    procedure AHB_MASTERIN_FROM_REC(ahbsig : in AHB_MasterIn_Type;
                                    HREADY : out std_logic;
                                    HRESP  : out std_logic_vector(1 downto 0);
                                    HRDATA : out std_logic_vector(31 downto 0);
                                    HGRANT : out std_logic) is
    begin
        HREADY := ahbsig.HREADY;
        HRESP  := ahbsig.HRESP; 
        HRDATA := ahbsig.HRDATA;    
        HGRANT := ahbsig.HGRANT;
    end AHB_MASTERIN_FROM_REC;
        
        
    procedure AHB_SLAVEIN_FROM_REC(ahbsig : in AHB_SlaveIn_Type; 
                                    HLOCK  : out std_logic;
                                    HTRANS : out std_logic_vector(1 downto 0);
                                    HADDR  : out std_logic_vector(31 downto 0);
                                    HWRITE : out std_logic;
                                    HSIZE  : out std_logic_vector(2 downto 0);
                                    HBURST : out std_logic_vector(2 downto 0);
                                    HPROT  : out std_logic_vector(3 downto 0);
                                    HWDATA : out std_logic_vector(31 downto 0);
                                    HSEL   : out std_logic;
                                    HMASTERID: out std_logic_vector(3 downto 0);
                                    HREADYIN : out std_logic) is
    begin
        
        HLOCK  := ahbsig.HLOCK; 
        HTRANS := ahbsig.HTRANS;
        HADDR  := ahbsig.HADDR; 
        HWRITE := ahbsig.HWRITE;
        HSIZE  := ahbsig.HSIZE; 
        HBURST := ahbsig.HBURST;
        HPROT  := ahbsig.HPROT; 
        HWDATA := ahbsig.HWDATA;
        HSEL   := ahbsig.HSEL;  
        HMASTERID:= ahbsig.HMASTERID;
        HREADYIN := ahbsig.HREADYIN; 
            
    end AHB_SLAVEIN_FROM_REC;
    
    procedure APB_SLAVEIN_FROM_REC(apbsig : in APB_SlaveIn_Type;
                                    PSEL   : out std_logic;
                                    PENABLE: out std_logic;
                                    PADDR  : out std_logic_vector(31 downto 0);
                                    PWRITE:  out std_logic;
                                    PWDATA : out std_logic_vector(31 downto 0)) is
    begin
        PSEL := apbsig.PSEL;
        PENABLE := apbsig.PENABLE;
        PADDR := apbsig.PADDR;
        PWRITE := apbsig.PWRITE;
        PWDATA := apbsig.PWDATA;
    end APB_SLAVEIN_FROM_REC;

    procedure APB_SLAVEOUT_FROM_REC(apbsig: in APB_SlaveOut_Type;
                                    PRDATA : out std_logic_vector(31 downto 0)) is
    begin
        PRDATA := apbsig.PRDATA;
    end APB_SLAVEOUT_FROM_REC;
        
    function conv_from_std_logic(a : std_logic) return integer is
        variable val : integer;
    begin
        if(a = '1') then
            val := 1;
        else
            val := 0;
        end if;
        return val;
    end conv_from_std_logic;

    function conv_from_std_logic_vector(a : std_logic_vector) return integer is
        variable val : integer;     
    begin       
        val := 0;       
        for i in 0 to a'high loop
            if(a(i) = '1') then
                val := val + (2**i);                
            end if;         
        end loop;
        return val;
    end conv_from_std_logic_vector;
        
end AMBA;




