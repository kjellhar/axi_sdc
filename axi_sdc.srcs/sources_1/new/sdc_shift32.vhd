----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2014 05:43:48 AM
-- Design Name: 
-- Module Name: sdc_shift32 - rtl
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

entity sdc_shift32 is
    Port ( Clk : in STD_LOGIC;
           shift_en : in STD_LOGIC;
           load_en : in STD_LOGIC;
           sdata_in : in STD_LOGIC;
           sdata_out : out STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end sdc_shift32;

architecture rtl of sdc_shift32 is
    signal shift_reg : std_logic_vector (31 downto 0) := (others => '0');

begin
    
    data_out <= shift_reg;
    sdata_out <= shift_reg'high;

    process (Clk)
    begin
        if rising_edge(Clk) then
            if load_en = '1' then
                shift_reg <= data_in;
                
            elsif shift_en = '1' then
                shift_reg (31 downto 0) <= shift_reg (30 downto 0) & sdata_in;
            end if;
        end if;
    end process;
end rtl;
