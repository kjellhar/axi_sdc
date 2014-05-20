--Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2014.1 (lin64) Build 881834 Fri Apr  4 14:00:25 MDT 2014
--Date        : Tue May 20 13:45:16 2014
--Host        : localhost.localdomain running 64-bit unknown
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    pulse : out STD_LOGIC;
    clock_rtl : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    sdc_card_detect : in STD_LOGIC;
    sdc_card_en : out STD_LOGIC;
    sdc_clk : out STD_LOGIC;
    sdc_cmd : inout STD_LOGIC;
    sdc_dat : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    uart_rtl_rxd : in STD_LOGIC;
    uart_rtl_txd : out STD_LOGIC
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    uart_rtl_rxd : in STD_LOGIC;
    uart_rtl_txd : out STD_LOGIC;
    clock_rtl : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    sdc_clk : out STD_LOGIC;
    sdc_cmd : inout STD_LOGIC;
    sdc_dat : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    sdc_card_en : out STD_LOGIC;
    sdc_card_detect : in STD_LOGIC;
    Interrupt : out STD_LOGIC;
    clk100 : out STD_LOGIC
  );
  end component design_1;
  
  signal pulse_i : std_logic := '0';
  signal clk100 : std_logic;
  signal Interrupt : std_logic;
  
begin
design_1_i: component design_1
    port map (
      Interrupt => Interrupt,
      clk100 => clk100,
      clock_rtl => clock_rtl,
      reset_rtl => reset_rtl,
      sdc_card_detect => sdc_card_detect,
      sdc_card_en => sdc_card_en,
      sdc_clk => sdc_clk,
      sdc_cmd => sdc_cmd,
      sdc_dat(3 downto 0) => sdc_dat(3 downto 0),
      uart_rtl_rxd => uart_rtl_rxd,
      uart_rtl_txd => uart_rtl_txd
    );
    
    process (clk100)
    begin
        if rising_edge(clk100) then
            if Interrupt='1' then
                pulse_i <= not pulse_i;
            end if;
        end if;
    end process;
    pulse <= pulse_i;
    
end STRUCTURE;
