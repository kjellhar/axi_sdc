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

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT design_1_axi_sdc_v1_0_0_0
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
END COMPONENT;
ATTRIBUTE SYN_BLACK_BOX : BOOLEAN;
ATTRIBUTE SYN_BLACK_BOX OF design_1_axi_sdc_v1_0_0_0 : COMPONENT IS TRUE;
ATTRIBUTE BLACK_BOX_PAD_PIN : STRING;
ATTRIBUTE BLACK_BOX_PAD_PIN OF design_1_axi_sdc_v1_0_0_0 : COMPONENT IS "sdc_clk,sdc_cmd,sdc_dat[3:0],sdc_card_detect,sdc_card_en,intr,s00_axi_ctrl_aclk,s00_axi_ctrl_aresetn,s00_axi_ctrl_awaddr[5:0],s00_axi_ctrl_awprot[2:0],s00_axi_ctrl_awvalid,s00_axi_ctrl_awready,s00_axi_ctrl_wdata[31:0],s00_axi_ctrl_wstrb[3:0],s00_axi_ctrl_wvalid,s00_axi_ctrl_wready,s00_axi_ctrl_bresp[1:0],s00_axi_ctrl_bvalid,s00_axi_ctrl_bready,s00_axi_ctrl_araddr[5:0],s00_axi_ctrl_arprot[2:0],s00_axi_ctrl_arvalid,s00_axi_ctrl_arready,s00_axi_ctrl_rdata[31:0],s00_axi_ctrl_rresp[1:0],s00_axi_ctrl_rvalid,s00_axi_ctrl_rready,m00_axis_datain_aclk,m00_axis_datain_aresetn,m00_axis_datain_tvalid,m00_axis_datain_tdata[31:0],m00_axis_datain_tstrb[3:0],m00_axis_datain_tlast,m00_axis_datain_tready,s00_axis_dataout_aclk,s00_axis_dataout_aresetn,s00_axis_dataout_tready,s00_axis_dataout_tdata[31:0],s00_axis_dataout_tstrb[3:0],s00_axis_dataout_tlast,s00_axis_dataout_tvalid";

-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : design_1_axi_sdc_v1_0_0_0
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
-- INST_TAG_END ------ End INSTANTIATION Template ---------

