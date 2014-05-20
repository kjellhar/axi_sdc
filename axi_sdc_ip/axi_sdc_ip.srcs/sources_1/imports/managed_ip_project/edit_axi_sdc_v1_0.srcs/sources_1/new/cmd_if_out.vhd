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
           resetn : in std_logic;
           enable : in STD_LOGIC;
           sdc_cmd_out : out STD_LOGIC;
           cmd_in : in STD_LOGIC_VECTOR (39 downto 0);
           start : in STD_LOGIC;
           busy : out STD_LOGIC
           );
end cmd_if_out;

architecture rtl of cmd_if_out is
    signal cmd_reg : std_logic_vector (39 downto 0) := (others=>'0');
    signal crc_reg : std_logic_vector (6 downto 0) := (others=>'0');

    signal bit_counter : integer range 0 to 48 := 0;
 
    
    type state_t is (
        IDLE_S,
        SHIFT_CMD_S,
        SHIFT_CRC_S,
        CMD_DONE_S);
        
    signal state : state_t := IDLE_S;       
    
    
begin

    sdc_cmd_out <= cmd_reg(39) when state=SHIFT_CMD_S else
                   crc_reg(6) when state=SHIFT_CRC_S else
                   '0';

    with state select
        busy <= '0' when IDLE_S,
                '0' when CMD_DONE_S,
                '1' when others;

    process (clk)
    begin
        if rising_edge(clk) then
            if resetn = '0' then
                state <= IDLE_S;
                bit_counter <= 0;
                crc_reg <= (others => '0');
            else
                if enable='1' then
                    case state is
                        when IDLE_S =>       
                            bit_counter <= 0;
                            crc_reg <= (others => '0');
                                          
                            if start='1' then
                                cmd_reg <= cmd_in;
                                state <= SHIFT_CMD_S;
                            end if;
                           
                        when SHIFT_CMD_S =>
                            cmd_reg(cmd_reg'left downto 0) <= cmd_reg(cmd_reg'left-1 downto 0) & '0';
                                     
                            crc_reg(0) <= crc_reg(6) xor cmd_reg(39);
                            crc_reg(1) <= crc_reg(0);
                            crc_reg(2) <= crc_reg(1);
                            crc_reg(3) <= crc_reg(2) xor crc_reg(6) xor cmd_reg(39);
                            crc_reg(4) <= crc_reg(3);
                            crc_reg(5) <= crc_reg(4);
                            crc_reg(6) <= crc_reg(5);
                            
                            bit_counter <= bit_counter + 1;
                            
                            if bit_counter=39 then
                                state <= SHIFT_CRC_S;
                            end if;
                            
                        when SHIFT_CRC_S =>
                            crc_reg(crc_reg'left downto 0) <= crc_reg(crc_reg'left-1 downto 0) & '1';
                            
                            bit_counter <= bit_counter + 1;
                            
                            if bit_counter=47 then
                                state <= CMD_DONE_S;
                            end if;
                            
                        when CMD_DONE_S =>
                            bit_counter <= 0;
                            state <= IDLE_S;
                            
                    end case;
                end if;
            end if;
        end if;
    end process;   
end rtl;
