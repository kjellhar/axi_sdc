----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 05/19/2014 11:47:00 AM
-- Design Name: AXI_SDC 
-- Module Name: cmd_if_out - rtl
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cmd_if_out is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           sdc_cmd_out : out STD_LOGIC;
           cmd_in : in STD_LOGIC_VECTOR (39 downto 0);
           cmd_load : in STD_LOGIC;
           start : in STD_LOGIC;
           done : out STD_LOGIC
           );
end cmd_if_out;

architecture rtl of cmd_if_out is
    signal cmd_reg : std_logic_vector (39 downto 0) := (others=>'0');
    signal crc_reg : std_logic_vector (6 downto 0) := (others=>'0');
    
    signal shift_data : std_logic := '0';
    signal shift_crc : std_logic := '0';
    signal bit_counter : integer range 0 to 63 := 0;
    
    signal done_i : std_logic := '0';
    
begin

    sdc_cmd_out <= cmd_reg(39) when shift_data='1' else
                   crc_reg(6) when shift_crc='1' else
                   '0';

    done <= done_i;

    process (clk)
    begin
        if rising_edge(clk) then
            if enable='1' then
                if cmd_load='1' then
                    cmd_reg <= cmd_in;
                    bit_counter <= 0;
                    crc_reg <= (others => '0');
                    
                elsif shift_data='1' then
                    cmd_reg(cmd_reg'left downto 0) <= cmd_reg(cmd_reg'left-1 downto 0) & '0';
                    bit_counter <= bit_counter + 1;
 
                    crc_reg(0) <= crc_reg(6) xor cmd_reg(39);
                    crc_reg(1) <= crc_reg(0);
                    crc_reg(2) <= crc_reg(1);
                    crc_reg(3) <= crc_reg(2) xor crc_reg(6) xor cmd_reg(39);
                    crc_reg(4) <= crc_reg(3);
                    crc_reg(5) <= crc_reg(4);
                    crc_reg(6) <= crc_reg(5);
               
                elsif shift_crc='1' then
                    crc_reg(crc_reg'left downto 0) <= crc_reg(crc_reg'left-1 downto 0) & '0';
                    
                    if bit_counter=47 then
                        bit_counter <= 0;
                    else
                        bit_counter <= bit_counter + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if enable='1' then
                if start='1' and bit_counter=0 then
                    shift_data <= '1';
                    done_i <= '0';
                elsif bit_counter=39 then
                    shift_data <= '0';
                    shift_crc <= '1';
                elsif bit_counter=47 then
                    shift_crc <= '0';
                    done_i <= '1';
                end if;
            end if;
        end if;
    end process;
    
end rtl;
