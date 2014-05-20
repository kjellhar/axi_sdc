library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity axi_sdc_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI_Ctrl
		C_S00_AXI_Ctrl_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_Ctrl_ADDR_WIDTH	: integer	:= 6;

		-- Parameters of Axi Master Bus Interface M00_AXIS_DataIn
		C_M00_AXIS_DataIn_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_DataIn_START_COUNT	: integer	:= 32;

		-- Parameters of Axi Slave Bus Interface S00_AXIS_DataOut
		C_S00_AXIS_DataOut_TDATA_WIDTH	: integer	:= 32
	);
	port (
		-- Users to add ports here
		sdc_clk : out std_logic;
		sdc_cmd : inout std_logic;
		sdc_dat : inout std_logic_vector (3 downto 0);
		
		sdc_card_detect : in std_logic;
		sdc_card_en : out std_logic;
		
		intr : out std_logic;

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI_Ctrl
		s00_axi_ctrl_aclk	: in std_logic;
		s00_axi_ctrl_aresetn	: in std_logic;
		s00_axi_ctrl_awaddr	: in std_logic_vector(C_S00_AXI_Ctrl_ADDR_WIDTH-1 downto 0);
		s00_axi_ctrl_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_ctrl_awvalid	: in std_logic;
		s00_axi_ctrl_awready	: out std_logic;
		s00_axi_ctrl_wdata	: in std_logic_vector(C_S00_AXI_Ctrl_DATA_WIDTH-1 downto 0);
		s00_axi_ctrl_wstrb	: in std_logic_vector((C_S00_AXI_Ctrl_DATA_WIDTH/8)-1 downto 0);
		s00_axi_ctrl_wvalid	: in std_logic;
		s00_axi_ctrl_wready	: out std_logic;
		s00_axi_ctrl_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_ctrl_bvalid	: out std_logic;
		s00_axi_ctrl_bready	: in std_logic;
		s00_axi_ctrl_araddr	: in std_logic_vector(C_S00_AXI_Ctrl_ADDR_WIDTH-1 downto 0);
		s00_axi_ctrl_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_ctrl_arvalid	: in std_logic;
		s00_axi_ctrl_arready	: out std_logic;
		s00_axi_ctrl_rdata	: out std_logic_vector(C_S00_AXI_Ctrl_DATA_WIDTH-1 downto 0);
		s00_axi_ctrl_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_ctrl_rvalid	: out std_logic;
		s00_axi_ctrl_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXIS_DataIn
		m00_axis_datain_aclk	: in std_logic;
		m00_axis_datain_aresetn	: in std_logic;
		m00_axis_datain_tvalid	: out std_logic;
		m00_axis_datain_tdata	: out std_logic_vector(C_M00_AXIS_DataIn_TDATA_WIDTH-1 downto 0);
		m00_axis_datain_tstrb	: out std_logic_vector((C_M00_AXIS_DataIn_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_datain_tlast	: out std_logic;
		m00_axis_datain_tready	: in std_logic;

		-- Ports of Axi Slave Bus Interface S00_AXIS_DataOut
		s00_axis_dataout_aclk	: in std_logic;
		s00_axis_dataout_aresetn	: in std_logic;
		s00_axis_dataout_tready	: out std_logic;
		s00_axis_dataout_tdata	: in std_logic_vector(C_S00_AXIS_DataOut_TDATA_WIDTH-1 downto 0);
		s00_axis_dataout_tstrb	: in std_logic_vector((C_S00_AXIS_DataOut_TDATA_WIDTH/8)-1 downto 0);
		s00_axis_dataout_tlast	: in std_logic;
		s00_axis_dataout_tvalid	: in std_logic
	);
end axi_sdc_v1_0;

architecture arch_imp of axi_sdc_v1_0 is

	-- component declaration
	component axi_sdc_v1_0_S00_AXI_Ctrl is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
		);
		port (
		cmd_received : out std_logic;
        cmd_busy : in std_logic;   
        ctrl1_r : out std_logic_vector (31 downto 0);
        ctrl2_r : out std_logic_vector (31 downto 0);
        carg_r : out std_logic_vector (31 downto 0);
        cmd_r : out std_logic_vector (31 downto 0);
        evmask_r : out std_logic_vector (31 downto 0);
        resp0_r : in std_logic_vector (31 downto 0);
        resp1_r : in std_logic_vector (31 downto 0);
        resp2_r : in std_logic_vector (31 downto 0);
        resp3_r : in std_logic_vector (31 downto 0);
        event_r : in std_logic_vector (31 downto 0);
        resp_wr_en : in std_logic;
        event_wr_en : in std_logic;		
		
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
	end component axi_sdc_v1_0_S00_AXI_Ctrl;

	component axi_sdc_v1_0_M00_AXIS_DataIn is
		generic (
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M_START_COUNT	: integer	:= 32
		);
		port (
		M_AXIS_ACLK	: in std_logic;
		M_AXIS_ARESETN	: in std_logic;
		M_AXIS_TVALID	: out std_logic;
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		M_AXIS_TLAST	: out std_logic;
		M_AXIS_TREADY	: in std_logic
		);
	end component axi_sdc_v1_0_M00_AXIS_DataIn;

	component axi_sdc_v1_0_S00_AXIS_DataOut is
		generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
		);
		port (
		S_AXIS_ACLK	: in std_logic;
		S_AXIS_ARESETN	: in std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		S_AXIS_TLAST	: in std_logic;
		S_AXIS_TVALID	: in std_logic
		);
	end component axi_sdc_v1_0_S00_AXIS_DataOut;
	
    component sdc_clk_gen is
        Port ( clk : in std_logic;
               reset : in std_logic;
               sdc_clk : out std_logic;
               sdc_clockgen_en : in std_logic;
               fdiv : in std_logic_vector (15 downto 0);
               sdc_clk_redge : out std_logic;
               sdc_clk_fedge : out std_logic);
    end component;
    
    component sdc_ctrl is
        Port ( clk : in STD_LOGIC;
               reset : in std_logic;
               sdc_clk_en : out std_logic;
               cmd_written : in std_logic;
               cmd_busy : in std_logic;
               cmd_start : out std_logic;
               long_resp : out std_logic;
               cmd_done : in std_logic;
               command : in std_logic_vector (5 downto 0);
               crc_error : in std_logic;
               intr : out std_logic;
               event_reg : out std_logic_vector (31 downto 0);
               event_wr_en : out std_logic;
               evmask : in std_logic_vector (31 downto 0)
               );
    end component;    
	
	
    component cmd_if is
        Port ( 
            clk : in STD_LOGIC;
            reset : in std_logic;
            cmd_in_en : in std_logic;
            cmd_out_en : in std_logic;
            sdc_cmd : inout STD_LOGIC;
            
            sdc_dir_out : in std_logic;
            long_resp : in std_logic;
            start : in std_logic;
            done : out std_logic;
            
            cmd_in : in STD_LOGIC_VECTOR (39 downto 0);
            resp0_out : out STD_LOGIC_VECTOR (31 downto 0);
            resp1_out : out STD_LOGIC_VECTOR (31 downto 0);
            resp2_out : out STD_LOGIC_VECTOR (31 downto 0);
            resp3_out : out STD_LOGIC_VECTOR (31 downto 0);
            resp_wr_en : out std_logic;
            crc_error : out STD_LOGIC     
            
            );
    end component;	
	
	
	signal cmd_received : std_logic;
	signal cmd_busy : std_logic;
	signal ctrl1_r : std_logic_vector (31 downto 0);
	signal ctrl2_r : std_logic_vector (31 downto 0);
	signal carg_r : std_logic_vector (31 downto 0);
	signal cmd_r : std_logic_vector (31 downto 0);
	signal resp0_r : std_logic_vector (31 downto 0);
	signal resp1_r : std_logic_vector (31 downto 0);
	signal resp2_r : std_logic_vector (31 downto 0);
	signal resp3_r : std_logic_vector (31 downto 0);
	signal evmask_r : std_logic_vector (31 downto 0);
	signal event_r : std_logic_vector (31 downto 0);
	signal resp_wr_en : std_logic;
	signal event_wr_en : std_logic;
	
	signal sdc_dir_out : std_logic;
	signal long_resp : std_logic;
	signal cmd_start : std_logic;
	signal cmd_done : std_logic;
	signal cmd_parallell_in : std_logic_vector (39 downto 0);
	signal response : std_logic_vector (135 downto 0);
	signal crc_error : std_logic;
	
	signal sdc_clk_en : std_logic;
	signal sdc_clk_redge : std_logic;
	signal sdc_clk_fedge : std_logic;

	

begin

-- Instantiation of Axi Bus Interface S00_AXI_Ctrl
axi_sdc_v1_0_S00_AXI_Ctrl_inst : axi_sdc_v1_0_S00_AXI_Ctrl
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_Ctrl_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_Ctrl_ADDR_WIDTH
	)
	port map (
        cmd_received => cmd_received,
        cmd_busy => cmd_busy,
        ctrl1_r => ctrl1_r,
        ctrl2_r => ctrl2_r,
        carg_r => carg_r,
        cmd_r => cmd_r,
        evmask_r => evmask_r,
        resp0_r => resp0_r,
        resp1_r => resp1_r,
        resp2_r => resp2_r,
        resp3_r => resp3_r,
        event_r => event_r,
        resp_wr_en => resp_wr_en,
        event_wr_en => event_wr_en,	
	
		S_AXI_ACLK	=> s00_axi_ctrl_aclk,
		S_AXI_ARESETN	=> s00_axi_ctrl_aresetn,
		S_AXI_AWADDR	=> s00_axi_ctrl_awaddr,
		S_AXI_AWPROT	=> s00_axi_ctrl_awprot,
		S_AXI_AWVALID	=> s00_axi_ctrl_awvalid,
		S_AXI_AWREADY	=> s00_axi_ctrl_awready,
		S_AXI_WDATA	=> s00_axi_ctrl_wdata,
		S_AXI_WSTRB	=> s00_axi_ctrl_wstrb,
		S_AXI_WVALID	=> s00_axi_ctrl_wvalid,
		S_AXI_WREADY	=> s00_axi_ctrl_wready,
		S_AXI_BRESP	=> s00_axi_ctrl_bresp,
		S_AXI_BVALID	=> s00_axi_ctrl_bvalid,
		S_AXI_BREADY	=> s00_axi_ctrl_bready,
		S_AXI_ARADDR	=> s00_axi_ctrl_araddr,
		S_AXI_ARPROT	=> s00_axi_ctrl_arprot,
		S_AXI_ARVALID	=> s00_axi_ctrl_arvalid,
		S_AXI_ARREADY	=> s00_axi_ctrl_arready,
		S_AXI_RDATA	=> s00_axi_ctrl_rdata,
		S_AXI_RRESP	=> s00_axi_ctrl_rresp,
		S_AXI_RVALID	=> s00_axi_ctrl_rvalid,
		S_AXI_RREADY	=> s00_axi_ctrl_rready
	);

-- Instantiation of Axi Bus Interface M00_AXIS_DataIn
axi_sdc_v1_0_M00_AXIS_DataIn_inst : axi_sdc_v1_0_M00_AXIS_DataIn
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_DataIn_TDATA_WIDTH,
		C_M_START_COUNT	=> C_M00_AXIS_DataIn_START_COUNT
	)
	port map (
		M_AXIS_ACLK	=> m00_axis_datain_aclk,
		M_AXIS_ARESETN	=> m00_axis_datain_aresetn,
		M_AXIS_TVALID	=> m00_axis_datain_tvalid,
		M_AXIS_TDATA	=> m00_axis_datain_tdata,
		M_AXIS_TSTRB	=> m00_axis_datain_tstrb,
		M_AXIS_TLAST	=> m00_axis_datain_tlast,
		M_AXIS_TREADY	=> m00_axis_datain_tready
	);

-- Instantiation of Axi Bus Interface S00_AXIS_DataOut
axi_sdc_v1_0_S00_AXIS_DataOut_inst : axi_sdc_v1_0_S00_AXIS_DataOut
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_DataOut_TDATA_WIDTH
	)
	port map (
		S_AXIS_ACLK	=> s00_axis_dataout_aclk,
		S_AXIS_ARESETN	=> s00_axis_dataout_aresetn,
		S_AXIS_TREADY	=> s00_axis_dataout_tready,
		S_AXIS_TDATA	=> s00_axis_dataout_tdata,
		S_AXIS_TSTRB	=> s00_axis_dataout_tstrb,
		S_AXIS_TLAST	=> s00_axis_dataout_tlast,
		S_AXIS_TVALID	=> s00_axis_dataout_tvalid
	);

	-- Add user logic here
    u_clkgen : sdc_clk_gen
    Port map ( 
        clk => s00_axi_ctrl_aclk,
        reset => s00_axi_ctrl_aresetn,
        sdc_clk => sdc_clk,
        sdc_clockgen_en => sdc_clk_en,
        fdiv => ctrl2_r(15 downto 0),
        sdc_clk_redge => sdc_clk_redge,
        sdc_clk_fedge => sdc_clk_fedge);

    u_sdc_ctrl : sdc_ctrl
    Port map ( 
        clk => s00_axi_ctrl_aclk,
        reset => s00_axi_ctrl_aresetn,
        sdc_clk_en => sdc_clk_en,
        cmd_written => cmd_received,
        cmd_busy => cmd_busy,
        cmd_start => cmd_start,
        long_resp => long_resp,
        cmd_done => cmd_done,
        command => cmd_r(5 downto 0),
        crc_error => crc_error,
        intr => intr,
        event_reg => event_r,
        event_wr_en => event_wr_en,
        evmask => evmask_r);
  


    u_cmd_if : cmd_if 
    Port map ( 
        clk => s00_axi_ctrl_aclk,
        reset => s00_axi_ctrl_aresetn,
        cmd_in_en => sdc_clk_redge,
        cmd_out_en => sdc_clk_fedge,
        sdc_cmd => sdc_cmd,
        
        sdc_dir_out => sdc_dir_out,
        long_resp => long_resp,
        start => cmd_start,
        done => cmd_done,
        
        cmd_in => cmd_parallell_in,
        resp0_out => resp0_r,
        resp1_out => resp1_r,
        resp2_out => resp2_r,
        resp3_out => resp3_r,
        resp_wr_en => resp_wr_en,
        crc_error => crc_error);
        
    cmd_parallell_in <= "01" & cmd_r(5 downto 0) & carg_r;
	-- User logic ends

end arch_imp;
