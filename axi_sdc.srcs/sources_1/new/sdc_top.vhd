----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 04/22/2014 11:02:01 PM
-- Design Name: axi_sdc
-- Module Name: sdc_top - rtl
-- Project Name: axi_sdc
-- Target Devices: Artix7
-- Tool Versions: 
-- Description: 
--
--  This top module contains the SD controller core functionality.
--  There are no bus interfaces in this module. That must be added at the
--  level above.
--
--  The module requires a 100MHz system clock
-- 
--  Register definition
--      reg_argument        : Argument to command. Defined in the SD spec.
--      reg_command         : SD/MMC command 
--                              [31:6] Reserved
--                              [5:0]  Command index
--      reg_response0-3     : Response to commands. For short response, only 
--                              g_response0 is used.
--      reg_control         : Controls the behaviour of the SDC controller
--                              [31:0] Reserved
--      reg_timeout         : Timeout value in ms
--      reg_event           : Indicates the slource of a flagged event
--      reg_event_enable    : Enables individual event sources.
--                                    
--
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sdc_top is
    port (
        -- System signals
        Clk100 : in std_logic;      -- Must be 100MHz for the timing to be correct
        Enable : in std_logic;      -- Enables the clock in the core module
    
        -- SD Card external interface
        SDC_CLK : out std_logic;
        SDC_CMD : inout std_logic;
        SDC_DAT : inout std_logic_vector (3 downto 0);
        
        -- Internal register interfaces
        reg_argument : in std_logic_vector (31 downto 0);
        reg_command : in std_logic_vector (31 downto 0);
        reg_response0 : out std_logic_vector (31 downto 0);
        reg_response1 : out std_logic_vector (31 downto 0);
        reg_response2 : out std_logic_vector (31 downto 0);
        reg_response3 : out std_logic_vector (31 downto 0);
        reg_control : in std_logic_vector (31 downto 0);
        reg_timeout : in std_logic_vector (31 downto 0);
        reg_event : out std_logic_vector (31 downto 0);
        reg_event_enable : in std_logic_vector (31 downto 0);
        
        -- Register write enable signals
        reg_response0_w : out std_logic;
        reg_response1_w : out std_logic;
        reg_response2_w : out std_logic;
        reg_response3_w : out std_logic;
        reg_event_w     : out std_logic_vector (31 downto 0);
        
        -- Other internal control signals
        interrupt : out std_logic
    );

end sdc_top;

architecture rtl of sdc_top is
    component sdc_clken_gen is
    Port ( Clk100 : in std_logic;
           Enable : in std_logic;
           Frequency : in std_logic_vector (1 downto 0);
           sdc_clk_level : out std_logic;
           sdc_clk_redge : out std_logic;
           sdc_clk_fedge : out std_logic);
    end component;
    
    component sdc_clkgate is
    Port ( clk100 : in STD_LOGIC;
           sdc_clk_level : in STD_LOGIC;
           enable : in STD_LOGIC;
           sdc_clk : out STD_LOGIC);
    end component;    
    
    component sdc_cmd_if is
    Port ( clk100 : in STD_LOGIC;
        enable : in STD_LOGIC;
        sdc_cmd_io : inout std_logic;
        sdc_clk_redge : in std_logic;
        sdc_clk_fedge : in std_logic;
        tx_din : in STD_LOGIC_VECTOR (7 downto 0);
        tx_wr_en : in STD_LOGIC;
        tx_full : out STD_LOGIC;
        tx_empty : out STD_LOGIC;
        rx_dout : out STD_LOGIC_VECTOR (7 downto 0);
        rx_rd_en : in STD_LOGIC;
        rx_full : out STD_LOGIC;
        rx_empty : out STD_LOGIC;
        transmit : in STD_LOGIC;
        length : in std_logic;
        start : in STD_LOGIC;
        busy : out STD_LOGIC;
        ignore_crc : in std_logic;
        rx_crc_error : out std_logic);
    end component;

    
    -- Signals related to clock enable for the SDC clock
    signal Frequency : std_logic_vector(1 downto 0);
    signal sdc_clk_level : std_logic;
    signal sdc_clk_redge : std_logic;
    signal sdc_clk_fedge : std_logic;    
    signal sdc_clk_enable : std_logic;

    -- Command interface signals
    signal cmd_tx_din : std_logic_vector(7 downto 0);
    signal cmd_tx_wr_en : std_logic;
    signal cmd_tx_full : std_logic;
    signal cmd_tx_empty : std_logic;
    signal cmd_rx_dout : std_logic_vector(7 downto 0);
    signal cmd_rx_rd_en : std_logic;
    signal cmd_rx_full : std_logic;
    signal cmd_rx_empty : std_logic;
    signal cmd_transmit : std_logic;
    signal cmd_length : std_logic;
    signal cmd_start : std_logic;
    signal cmd_busy : std_logic;
    signal cmd_rx_crc_error : std_logic;
    signal cmd_ignore_crc : std_logic;

begin
    u_sdc_clken_gen : sdc_clken_gen
    port map ( 
        Clk100 => Clk100,
        Enable  => Enable,
        Frequency => Frequency,
        sdc_clk_level => sdc_clk_level, 
        sdc_clk_redge => sdc_clk_redge, 
        sdc_clk_fedge => sdc_clk_fedge);

    u_sdc_clkgate : sdc_clkgate
    port map (
        clk100 => clk100,
        sdc_clk_level => sdc_clk_level,
        enable => sdc_clk_enable,
        sdc_clk => SDC_CLK);

    u_sdc_cmd_if : sdc_cmd_if 
    port map  ( 
        clk100 => clk100,
        enable => enable,
        sdc_cmd_io => SDC_CMD,
        sdc_clk_redge => sdc_clk_redge,
        sdc_clk_fedge =>sdc_clk_fedge ,
        tx_din => cmd_tx_din,
        tx_wr_en => cmd_tx_wr_en,
        tx_full => cmd_tx_full,
        tx_empty => cmd_tx_empty,
        rx_dout => cmd_rx_dout,
        rx_rd_en => cmd_rx_rd_en,
        rx_full => cmd_rx_full,
        rx_empty => cmd_rx_empty,
        transmit => cmd_transmit,
        length => cmd_length,
        start => cmd_start,
        busy => cmd_busy,
        ignore_crc => cmd_ignore_crc,
        rx_crc_error => cmd_rx_crc_error);

end rtl;
