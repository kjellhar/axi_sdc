----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2014 11:02:01 PM
-- Design Name: 
-- Module Name: sdc_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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
        Clk100 : in std_logic;
        Enable : in std_logic;
    
        SDC_CLK : out std_logic;
        SDC_CMD : inout std_logic;
        SDC_DAT : inout std_logic_vector (3 downto 0)
    );

end sdc_top;

architecture Behavioral of sdc_top is
    component sdc_clken_gen is
    Port ( Clk100 : in STD_LOGIC;
           Enable : in STD_LOGIC;
           Frequency : in STD_LOGIC_VECTOR (1 downto 0);
           sdc_clk_level : out STD_LOGIC;
           sdc_clk_redge : out STD_LOGIC;
           sdc_clk_fedge : out STD_LOGIC);
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

end Behavioral;
