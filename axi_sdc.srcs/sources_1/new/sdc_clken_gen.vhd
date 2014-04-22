----------------------------------------------------------------------------------
-- Company: Oppfinneriet.no
-- Engineer: Kjell H Andersen
--
-- Create Date: 04/22/2014 10:38:08 PM
-- Design Name: axi_sdc
-- Module Name: sdc_clken_gen - rtl
-- Project Name: axi_sdc
-- Target Devices: Artix7
-- Tool Versions:
-- Description:
--  Generates clock enable signals for the SDC output The 100MHz system clock
--  is divided by using these clock enable signals.
--
--  The Frequency parameter is:
--      "00" :  400kHz
--      "01" :  25MHz
--      "10" :  50MHz
--      "11" :  Undefined
--
--  The clk ouput signals are meant to be used as inputs to the output registers.
--      sdc_clk_level : The ouput clock level on the next rising clk100 edge
--      sdc_clk_redge : The output clock will get a rising edge on the next rising
--                      clk100 edge
--      sdc_clk_fedge : The output clock will get a falling edge on the next rising
--                      clk100 edge
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

entity sdc_clken_gen is
    Port ( Clk100 : in STD_LOGIC;
           Enable : in STD_LOGIC;
           Frequency : in STD_LOGIC_VECTOR (1 downto 0);
           sdc_clk_level : out STD_LOGIC;
           sdc_clk_redge : out STD_LOGIC;
           sdc_clk_fedge : out STD_LOGIC);
end sdc_clken_gen;

architecture rtl of sdc_clken_gen is
    constant F400K_DIV : integer := 125;
    constant F25M_DIV : integer := 2;
    constant F50M_DIV : integer := 1;


begin

    clockdiv_counter : process (Clk100)
        variable counter : integer range 0 to 127 := 0;
        variable clk_level : std_logic := '0';

    begin
        if rising_edge(Clk100) then
            if Enable = '1' then
                if counter = 0 then
                    if clk_level = '0' then
                        sdc_clk_redge <= '1';
                        sdc_clk_fedge <= '0';
                        clk_level := '1';
                    else
                        sdc_clk_redge <= '0';
                        sdc_clk_fedge <= '1';
                        clk_level := '0';
                    end if;

                    case Frequency is
                        when "00" => counter := F400K_DIV-1;
                        when "01" => counter := F25M_DIV-1;
                        when "10" => counter := F50M_DIV-1;
                        when others => counter := F400K_DIV-1;
                    end case;
                else
                    sdc_clk_redge <= '0';
                    sdc_clk_fedge <= '0';

                    counter := counter - 1;
                end if;

            else
                sdc_clk_redge <= '0';
                sdc_clk_fedge <= '0';

                counter := 0;

            end if;

            sdc_clk_level <= clk_level;
        end if;
    end process;
end rtl;
