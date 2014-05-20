----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 05/20/2014 05:48:38 AM
-- Design Name: AXI_SDC
-- Module Name: sdc_clockgen_en - rtl
-- Project Name: AXI SDC
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
use work.sdc_defines_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sdc_clk_gen is
    Port ( clk : in std_logic;
           reset : in std_logic;
           sdc_clk : out std_logic;
           sdc_clockgen_en : in std_logic;
           fdiv : in std_logic_vector (15 downto 0);
           sdc_clk_redge : out std_logic;
           sdc_clk_fedge : out std_logic);
end sdc_clk_gen;

architecture rtl of sdc_clk_gen is

    signal sdc_clk_level : std_logic := '0';

begin

    clockdiv_counter : process (clk)
        variable counter : integer range 0 to 65535 := 0;
        variable clk_level : std_logic := '1';

    begin
        if rising_edge(clk) then
            if reset = '1' then
                sdc_clk_redge <= '0';
                sdc_clk_fedge <= '0';
                counter := 0;                
            else        
                if counter = 0 then
                    if clk_level = '0' then
                        sdc_clk_redge <= '1';
                        sdc_clk_fedge <= '0';
                        clk_level := '1';
                    else
                        if sdc_clockgen_en='1' then
                            sdc_clk_redge <= '0';
                            sdc_clk_fedge <= '1';
                            clk_level := '0';
                        else
                            sdc_clk_redge <= '0';
                            sdc_clk_fedge <= '0';
                            clk_level := '1';
                        end if;                           
                    end if;                  
                    counter := TO_INTEGER(unsigned(fdiv));
                else
                    sdc_clk_redge <= '0';
                    sdc_clk_fedge <= '0';

                    counter := counter - 1;
                end if;
            end if;

            sdc_clk_level <= clk_level;
        end if;
    end process;
    
    process (clk)
    begin
        if rising_edge(clk) then
            sdc_clk <= sdc_clk_level;
        end if;
    end process;
end rtl;