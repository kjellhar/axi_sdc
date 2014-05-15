library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.sdc_defines_pkg.all;


entity sdc_axi4 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= AXI_ADR_WIDTH+2
	);
	port (
		-- Users to add ports here
        -- System signals
        clk100 : in std_logic;      -- Must be 100MHz for the timing to be correct
        intr : out std_logic;
    
        -- SD Card external interface
        sdc_clk : out std_logic;
        sdc_cmd : inout std_logic;
        sdc_dat : inout std_logic_vector (3 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end sdc_axi4;

architecture arch_imp of sdc_axi4 is

	-- component declaration
	component sdc_axi4_v1_0_S00_AXI_cmdif is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= AXI_ADR_WIDTH+2
		);
		port (
        Clk100 : in std_logic;
        intr : out std_logic;

        i_ctrl1 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        i_ctrl2 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        i_carg : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        i_cmd : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        i_resp0 : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        i_resp1 : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        i_resp2 : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        i_resp3 : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        i_event : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

        i_resp_wr : in std_logic;
        i_event_wr : in std_logic;
        i_resp_wr_ack : out std_logic;
        i_event_wr_ack : out std_logic;
        i_cmd_wr : out std_logic;		
		
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component sdc_axi4_v1_0_S00_AXI_cmdif;
	
    component sdc_top is
        port (
            -- System signals
            Clk100 : in std_logic;      -- Must be 100MHz for the timing to be correct
            Enable : in std_logic;      -- Enables the clock in the core module
        
            -- SD Card external interface
            SDC_CLK : out std_logic;
            SDC_CMD : inout std_logic;
            SDC_DAT : inout std_logic_vector (3 downto 0);
            
            -- Internal register interfaces
            i_ctrl1 : in std_logic_vector (31 downto 0);
            i_ctrl2 : in std_logic_vector (31 downto 0);
            i_carg : in std_logic_vector (31 downto 0);
            i_cmd : in std_logic_vector (31 downto 0);
            reg_resp0 : out std_logic_vector (31 downto 0);
            reg_resp1 : out std_logic_vector (31 downto 0);
            reg_resp2 : out std_logic_vector (31 downto 0);
            reg_resp3 : out std_logic_vector (31 downto 0);
            reg_event : out std_logic_vector (31 downto 0);
            
            -- Register write enable signals
            cmd_wr : in std_logic;
            resp_wr : out std_logic;
            event_wr : out std_logic;
            resp_wr_ack : in std_logic;
            event_wr_ack : in std_logic
        );
    end component;	
    
    
    signal reg_ctrl1 : std_logic_vector(31 downto 0);
    signal reg_ctrl2 : std_logic_vector(31 downto 0);
    signal reg_carg : std_logic_vector(31 downto 0);
    signal reg_cmd : std_logic_vector(31 downto 0);
    signal reg_resp0 : std_logic_vector(31 downto 0);
    signal reg_resp1 : std_logic_vector(31 downto 0);
    signal reg_resp2 : std_logic_vector(31 downto 0);
    signal reg_resp3 : std_logic_vector(31 downto 0);
    signal reg_emask : std_logic_vector(31 downto 0);
    signal reg_event : std_logic_vector(31 downto 0);
	
	signal cmd_wr : std_logic;
	signal resp_wr : std_logic;
	signal event_wr : std_logic;
	signal resp_wr_ack : std_logic;
	signal event_wr_ack : std_logic;

begin

-- Instantiation of Axi Bus Interface S00_AXI
sdc_axi4_v1_0_S00_AXI_cmdif_inst : sdc_axi4_v1_0_S00_AXI_cmdif
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
        Clk100 => Clk100,
        intr => intr,
  
        i_ctrl1 => reg_ctrl1,
        i_ctrl2 => reg_ctrl2,
        i_carg => reg_carg,
        i_cmd => reg_cmd,
        i_resp0 => reg_resp0,
        i_resp1 => reg_resp1,
        i_resp2 => reg_resp2,
        i_resp3 => reg_resp3,
        i_event => reg_event,
    
        i_resp_wr => resp_wr,
        i_event_wr => event_wr,
        i_resp_wr_ack => resp_wr_ack,
        i_event_wr_ack => event_wr_ack,
        i_cmd_wr => cmd_wr,	
	
	
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
    u_sdc : sdc_top
        port map (
            -- System signals
            Clk100 => clk100,
            Enable => '1',
        
            -- SD Card external interface
            SDC_CLK => sdc_clk,
            SDC_CMD => sdc_cmd,
            SDC_DAT => sdc_dat,
            
            -- Internal register interfaces
            i_ctrl1 => reg_ctrl1,
            i_ctrl2 => reg_ctrl2,
            i_carg => reg_carg,
            i_cmd => reg_cmd,
            reg_resp0 => reg_resp0,
            reg_resp1 => reg_resp1,
            reg_resp2 => reg_resp2,
            reg_resp3 => reg_resp3,
            reg_event => reg_event,
            
            -- Register write enable signals
            cmd_wr => cmd_wr,
            resp_wr => resp_wr,
            event_wr => event_wr,
            resp_wr_ack => resp_wr_ack,
            event_wr_ack => event_wr_ack
        );  

	-- User logic ends

end arch_imp;
