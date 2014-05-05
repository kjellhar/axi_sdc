----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 05/05/2014 06:27:09 AM
-- Design Name: axi_sdc 
-- Module Name: sdc_clk - rtl
-- Project Name: axi_sdc
-- Target Devices: Artix7
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

entity sdc_clk is
    Port ( clk100 : in STD_LOGIC;
           sdc_clk_level : in STD_LOGIC;
           enable : in STD_LOGIC;
           sdc_clk : in STD_LOGIC);
end sdc_clk;

architecture rtl of sdc_clk is

begin

    process (clk100)
    begin
        if rising_edge(clk100) then
            if enabel='1' then
                sdc_clk <= sdc_clk_level;
            end if;
        end if;
    end process;
end rtl;
