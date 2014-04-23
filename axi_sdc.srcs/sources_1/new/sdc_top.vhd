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
--      reg_response0-3     : Response to commands. For short resposne, only 
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
        cmd_trig : in std_logic;    -- Triggers a new command cycle
        cmd_busy : out std_logic;   -- Unable to accept new command 
        int : out std_logic
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

    signal Frequency : std_logic_vector(1 downto 0);
    signal sdc_clk_level : std_logic;
    signal sdc_clk_redge : std_logic;
    signal sdc_clk_fedge : std_logic;    


begin
    u_sdc_clken_gen : sdc_clken_gen
    port map ( 
        Clk100 => Clk100,
        Enable  => Enable,
        Frequency => Frequency,
        sdc_clk_level => sdc_clk_level, 
        sdc_clk_redge => sdc_clk_redge, 
        sdc_clk_fedge => sdc_clk_fedge);

end rtl;
