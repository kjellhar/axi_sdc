-- (c) Copyright 1995-2014 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: Oppfinneriet:user:axi_sdc_v1_0:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY xil_defaultlib;
USE xil_defaultlib.axi_sdc_v1_0;

ENTITY design_1_axi_sdc_v1_0_0_0 IS
  PORT (
    sdc_clk : OUT STD_LOGIC;
    sdc_cmd : INOUT STD_LOGIC;
    sdc_dat : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    sdc_card_detect : IN STD_LOGIC;
    sdc_card_en : OUT STD_LOGIC;
    intr : OUT STD_LOGIC;
    s00_axi_ctrl_aclk : IN STD_LOGIC;
    s00_axi_ctrl_aresetn : IN STD_LOGIC;
    s00_axi_ctrl_awaddr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    s00_axi_ctrl_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s00_axi_ctrl_awvalid : IN STD_LOGIC;
    s00_axi_ctrl_awready : OUT STD_LOGIC;
    s00_axi_ctrl_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s00_axi_ctrl_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s00_axi_ctrl_wvalid : IN STD_LOGIC;
    s00_axi_ctrl_wready : OUT STD_LOGIC;
    s00_axi_ctrl_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s00_axi_ctrl_bvalid : OUT STD_LOGIC;
    s00_axi_ctrl_bready : IN STD_LOGIC;
    s00_axi_ctrl_araddr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    s00_axi_ctrl_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s00_axi_ctrl_arvalid : IN STD_LOGIC;
    s00_axi_ctrl_arready : OUT STD_LOGIC;
    s00_axi_ctrl_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s00_axi_ctrl_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s00_axi_ctrl_rvalid : OUT STD_LOGIC;
    s00_axi_ctrl_rready : IN STD_LOGIC;
    m00_axis_datain_aclk : IN STD_LOGIC;
    m00_axis_datain_aresetn : IN STD_LOGIC;
    m00_axis_datain_tvalid : OUT STD_LOGIC;
    m00_axis_datain_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m00_axis_datain_tstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m00_axis_datain_tlast : OUT STD_LOGIC;
    m00_axis_datain_tready : IN STD_LOGIC;
    s00_axis_dataout_aclk : IN STD_LOGIC;
    s00_axis_dataout_aresetn : IN STD_LOGIC;
    s00_axis_dataout_tready : OUT STD_LOGIC;
    s00_axis_dataout_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s00_axis_dataout_tstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s00_axis_dataout_tlast : IN STD_LOGIC;
    s00_axis_dataout_tvalid : IN STD_LOGIC
  );
END design_1_axi_sdc_v1_0_0_0;

ARCHITECTURE design_1_axi_sdc_v1_0_0_0_arch OF design_1_axi_sdc_v1_0_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : string;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_axi_sdc_v1_0_0_0_arch: ARCHITECTURE IS "yes";

  COMPONENT axi_sdc_v1_0 IS
    GENERIC (
      C_S00_AXI_Ctrl_DATA_WIDTH : INTEGER;
      C_S00_AXI_Ctrl_ADDR_WIDTH : INTEGER;
      C_M00_AXIS_DataIn_TDATA_WIDTH : INTEGER;
      C_M00_AXIS_DataIn_START_COUNT : INTEGER;
      C_S00_AXIS_DataOut_TDATA_WIDTH : INTEGER
    );
    PORT (
      sdc_clk : OUT STD_LOGIC;
      sdc_cmd : INOUT STD_LOGIC;
      sdc_dat : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      sdc_card_detect : IN STD_LOGIC;
      sdc_card_en : OUT STD_LOGIC;
      intr : OUT STD_LOGIC;
      s00_axi_ctrl_aclk : IN STD_LOGIC;
      s00_axi_ctrl_aresetn : IN STD_LOGIC;
      s00_axi_ctrl_awaddr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      s00_axi_ctrl_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s00_axi_ctrl_awvalid : IN STD_LOGIC;
      s00_axi_ctrl_awready : OUT STD_LOGIC;
      s00_axi_ctrl_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s00_axi_ctrl_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s00_axi_ctrl_wvalid : IN STD_LOGIC;
      s00_axi_ctrl_wready : OUT STD_LOGIC;
      s00_axi_ctrl_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s00_axi_ctrl_bvalid : OUT STD_LOGIC;
      s00_axi_ctrl_bready : IN STD_LOGIC;
      s00_axi_ctrl_araddr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      s00_axi_ctrl_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s00_axi_ctrl_arvalid : IN STD_LOGIC;
      s00_axi_ctrl_arready : OUT STD_LOGIC;
      s00_axi_ctrl_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s00_axi_ctrl_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s00_axi_ctrl_rvalid : OUT STD_LOGIC;
      s00_axi_ctrl_rready : IN STD_LOGIC;
      m00_axis_datain_aclk : IN STD_LOGIC;
      m00_axis_datain_aresetn : IN STD_LOGIC;
      m00_axis_datain_tvalid : OUT STD_LOGIC;
      m00_axis_datain_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m00_axis_datain_tstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m00_axis_datain_tlast : OUT STD_LOGIC;
      m00_axis_datain_tready : IN STD_LOGIC;
      s00_axis_dataout_aclk : IN STD_LOGIC;
      s00_axis_dataout_aresetn : IN STD_LOGIC;
      s00_axis_dataout_tready : OUT STD_LOGIC;
      s00_axis_dataout_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s00_axis_dataout_tstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s00_axis_dataout_tlast : IN STD_LOGIC;
      s00_axis_dataout_tvalid : IN STD_LOGIC
    );
  END COMPONENT axi_sdc_v1_0;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF intr: SIGNAL IS "xilinx.com:signal:interrupt:1.0 signal_interrupt INTERRUPT";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 s00_axi_ctrl_signal_clock CLK";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 s00_axi_ctrl_signal_reset RST";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl AWPROT";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_arprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl ARPROT";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_rresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_ctrl_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 s00_axi_ctrl RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_datain_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 m00_axis_datain_signal_clock CLK";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_datain_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 m00_axis_datain_signal_reset RST";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_datain_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 m00_axis_datain TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_datain_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 m00_axis_datain TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_datain_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 m00_axis_datain TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_datain_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 m00_axis_datain TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_datain_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 m00_axis_datain TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_dataout_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 s00_axis_dataout_signal_clock CLK";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_dataout_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 s00_axis_dataout_signal_reset RST";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_dataout_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 s00_axis_dataout TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_dataout_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 s00_axis_dataout TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_dataout_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 s00_axis_dataout TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_dataout_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 s00_axis_dataout TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_dataout_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 s00_axis_dataout TVALID";
BEGIN
  U0 : axi_sdc_v1_0
    GENERIC MAP (
      C_S00_AXI_Ctrl_DATA_WIDTH => 32,
      C_S00_AXI_Ctrl_ADDR_WIDTH => 6,
      C_M00_AXIS_DataIn_TDATA_WIDTH => 32,
      C_M00_AXIS_DataIn_START_COUNT => 32,
      C_S00_AXIS_DataOut_TDATA_WIDTH => 32
    )
    PORT MAP (
      sdc_clk => sdc_clk,
      sdc_cmd => sdc_cmd,
      sdc_dat => sdc_dat,
      sdc_card_detect => sdc_card_detect,
      sdc_card_en => sdc_card_en,
      intr => intr,
      s00_axi_ctrl_aclk => s00_axi_ctrl_aclk,
      s00_axi_ctrl_aresetn => s00_axi_ctrl_aresetn,
      s00_axi_ctrl_awaddr => s00_axi_ctrl_awaddr,
      s00_axi_ctrl_awprot => s00_axi_ctrl_awprot,
      s00_axi_ctrl_awvalid => s00_axi_ctrl_awvalid,
      s00_axi_ctrl_awready => s00_axi_ctrl_awready,
      s00_axi_ctrl_wdata => s00_axi_ctrl_wdata,
      s00_axi_ctrl_wstrb => s00_axi_ctrl_wstrb,
      s00_axi_ctrl_wvalid => s00_axi_ctrl_wvalid,
      s00_axi_ctrl_wready => s00_axi_ctrl_wready,
      s00_axi_ctrl_bresp => s00_axi_ctrl_bresp,
      s00_axi_ctrl_bvalid => s00_axi_ctrl_bvalid,
      s00_axi_ctrl_bready => s00_axi_ctrl_bready,
      s00_axi_ctrl_araddr => s00_axi_ctrl_araddr,
      s00_axi_ctrl_arprot => s00_axi_ctrl_arprot,
      s00_axi_ctrl_arvalid => s00_axi_ctrl_arvalid,
      s00_axi_ctrl_arready => s00_axi_ctrl_arready,
      s00_axi_ctrl_rdata => s00_axi_ctrl_rdata,
      s00_axi_ctrl_rresp => s00_axi_ctrl_rresp,
      s00_axi_ctrl_rvalid => s00_axi_ctrl_rvalid,
      s00_axi_ctrl_rready => s00_axi_ctrl_rready,
      m00_axis_datain_aclk => m00_axis_datain_aclk,
      m00_axis_datain_aresetn => m00_axis_datain_aresetn,
      m00_axis_datain_tvalid => m00_axis_datain_tvalid,
      m00_axis_datain_tdata => m00_axis_datain_tdata,
      m00_axis_datain_tstrb => m00_axis_datain_tstrb,
      m00_axis_datain_tlast => m00_axis_datain_tlast,
      m00_axis_datain_tready => m00_axis_datain_tready,
      s00_axis_dataout_aclk => s00_axis_dataout_aclk,
      s00_axis_dataout_aresetn => s00_axis_dataout_aresetn,
      s00_axis_dataout_tready => s00_axis_dataout_tready,
      s00_axis_dataout_tdata => s00_axis_dataout_tdata,
      s00_axis_dataout_tstrb => s00_axis_dataout_tstrb,
      s00_axis_dataout_tlast => s00_axis_dataout_tlast,
      s00_axis_dataout_tvalid => s00_axis_dataout_tvalid
    );
END design_1_axi_sdc_v1_0_0_0_arch;
