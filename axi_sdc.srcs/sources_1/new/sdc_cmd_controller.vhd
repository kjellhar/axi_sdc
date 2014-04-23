----------------------------------------------------------------------------------
-- Company: Oppfinneriet   
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 04/23/2014 04:04:48 AM
-- Design Name: axi_sdc
-- Module Name: sdc_cmd_controller - rtl
-- Project Name: axi_sdc
-- Target Devices: Artix7
-- Tool Versions: 
-- Description: 
--  The main state machine. This state machine runs at 100MHz and controls
--  all the higher level funcitons. It leaves the low level bit pushing to
--  specific controllers for each interface, sending them a strobe when they
--  should start, and wait until they are no longer busy.
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sdc_cmd_controller is
    Port ( clk100 : in std_logic;
           sdc_clk_redge : in std_logic;
           sdc_clk_fedge : in std_logic;
           Enable : in std_logic;
           cmd_strobe : in std_logic;
           cmd_index : in std_logic_vector (5 downto 0));
end sdc_cmd_controller;

architecture rtl of sdc_cmd_controller is
    type cmd_state_t is (
        IDLE,
        WRITE_CMD_INIT,
        WRITE_CMD_WAIT,
        DECODE_CMD,
        CMD_READ_SHORTR_INIT,
        CMD_READ_SHORTR_WAIT,
        CMD_READ_LONGR_INIT,
        CMD_READ_LONGR_WAIT);
        
    signal cmd_state : cmd_state_t := IDLE;
    
    signal Crc7_clr : std_logic;
    signal crc7_data_stream : std_logic;
    signal Crc7 : std_logic_vector (6 downto 0);
    signal Crc7_en : std_logic;
    
    signal cmd_shift_reg : std_logic_vector (31 downto 0) := (others => '0');
    
begin
    cmd_state_machine : process (clk100)
    begin
        if rising_edge(Clk100) then
            if Enable = '1' then
                case cmd_state is
                    when IDLE =>
                        if cmd_strobe = '1' then
                            cmd_state <= WRITE_CMD_INIT;
                        end if;
                        
                    when WRITE_CMD_INIT =>
                        write_cmd_strobe <= '1';
                        cmd_state <= WRITE_CMD_WAIT;
                        
                    when WRITE_CMD_WAIT =>
                        write_cmd_strobe <= '0';
                        
                        if cmd_busy = '0' then
                            cmd_state <= DECODE_CMD;
                        end if;
                        
                    when DECODE_CMD =>
                        case cmd_index is
                            -- Commands with no response
                            when CMD0 | CMD4 | CMD15=>
                                cmd_state <= IDLE;
                                
                            -- Commands with short response
                            when CMD3 | CMD7 | CMD8 | CMD12 | CMD12 =>
                                cmd_state <= CMD_READ_SHORTR_INIT;
                                
                            -- Commands with long response
                            when CMD2 | CMD9 | CMD10 => 
                                cmd_state <= CMD_READ_LONGR_INIT; 
                            
                            -- Read data commands
                            
                            -- Write data commands
                            
                            when others =>
                        end case;
                
                    when CMD_READ_SHORTR_INIT =>
                        read_short_strobe <= '1';
                        cmd_state <= CMD_READ_SHORTR_WAIT;
                        
                    when CMD_READ_SHORTR_WAIT =>
                         read_short_strobe <= '0';
                    
                        if cmd_busy = '0' then
                            cmd_state <= IDLE;
                        end if;                
                               
                    when CMD_READ_LONGR_INIT =>
                        read_long_strobe <= '1';
                        cmd_state <= CMD_READ_LONGR_WAIT;
                        
                    when CMD_READ_LONGR_WAIT =>
                        read_long_strobe <= '0';
                    
                        if cmd_busy = '0' then
                            cmd_state <= IDLE;
                        end if;                                                           
                    when others =>
                end case;
            end if;
        end if;
    end process;
end rtl;