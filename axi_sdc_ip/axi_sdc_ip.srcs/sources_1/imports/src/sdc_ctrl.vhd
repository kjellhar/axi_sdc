----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 05/20/2014 04:52:28 AM
-- Design Name: AXI_SDC
-- Module Name: sdc_ctrl - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sdc_ctrl is
    Port ( clk : in STD_LOGIC;
           resetn : in std_logic;
           sdc_clk_en : out std_logic;
           sdc_card_en : out std_logic;
           cmd_written : in std_logic;
           cmd_busy : in std_logic;
           cmd_start : out std_logic;
           sdc_cmd_dir : out std_logic;
           long_resp : out std_logic;
           command : in std_logic_vector (5 downto 0);
           crc_error : in std_logic;
           intr : out std_logic;
           ctrl1_reg : in std_logic_vector (31 downto 0);
           ctrl2_reg : in std_logic_vector (31 downto 0);
           event_reg : out std_logic_vector (31 downto 0);
           event_wr_en : out std_logic;
           evmask : in std_logic_vector (31 downto 0)
           );
end sdc_ctrl;

architecture rtl of sdc_ctrl is

    type state_t is (
        IDLE_S,
        START_CMD_S,
        WAIT_CMD_S,
        RESP1_S,
        RESP2_S,
        RESP3_S,
        WAIT_RESP_S,
        WAIT_RESP_NOCRC_S,
        CRC_ERROR_S,
        CMD_DONE_S,
        ILLEGAL_CMD_S);        

    signal state : state_t := IDLE_S;
    
    signal command_reg : std_logic_vector (5 downto 0) := (others => '0');
    
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if resetn = '0' then
                state <= IDLE_S;
                command_reg <= (others => '0');
            else
                case state is
                    when IDLE_S =>
                        if cmd_written='1' and cmd_busy='0' then
                            state <= START_CMD_S;
                            command_reg <= command;
                         end if;
                     
                    when START_CMD_S =>
                        if cmd_busy='1' then
                            state <= WAIT_CMD_S;
                        end if;
                    
                    when WAIT_CMD_S =>
                        if cmd_busy='0' then
                            case command_reg is
                                when CMD0 =>
                                    state <= IDLE_S;
                                when CMD2 =>
                                    state <= RESP2_S;
                                when CMD3 =>
                                    state <= RESP1_S;
                                when CMD4 =>
                                    state <= IDLE_S;
                                when CMD7 =>
                                    state <= RESP1_S;
                                when CMD8 =>
                                    state <= RESP1_S;
                                when CMD9 =>
                                    state <= RESP2_S;
                                when CMD10 =>
                                    state <= RESP2_S;
                                when CMD12 =>
                                    state <= RESP1_S;
                                when CMD13 =>
                                    state <= RESP1_S;
                                when CMD15 =>
                                    state <= IDLE_S;
                                when others =>
                                    state <= ILLEGAL_CMD_S;
                            end case;                            
                        end if;
                        
                    when RESP1_S => 
                        if cmd_busy='1' then
                            state <= WAIT_RESP_S;
                        end if;
                        
                    when RESP2_S => 
                        if cmd_busy='1' then
                            state <= WAIT_RESP_S;
                        end if;
                        
                    when RESP3_S =>
                        if cmd_busy='1' then
                            state <= WAIT_RESP_NOCRC_S;
                        end if;                    
                        
                    when WAIT_RESP_S =>
                        if cmd_busy='0' then
                            if crc_error='0' then
                                state <= CMD_DONE_S;
                            else
                                state <= CRC_ERROR_S;
                            end if;
                        end if;                        
                                            
                    when WAIT_RESP_NOCRC_S =>
                        if cmd_busy='0' then
                            state <= CMD_DONE_S;
                        end if;
                    
                    when CRC_ERROR_S =>
                        state <= CMD_DONE_S;
                    
                    when CMD_DONE_S =>
                        state <= IDLE_S;
                    
                    when ILLEGAL_CMD_S =>
                        state <= IDLE_S;
                     
                end case;
            end if;
        end if;
    end process;
    
    with state select
        cmd_start <= '1' when START_CMD_S,
                     '1' when RESP1_S,
                     '1' when RESP2_S,
                     '1' when RESP3_S,
                     '0' when others;
                     
    with state select
        long_resp <= '1' when RESP2_S,
                     '0' when others;
                     
    with state select
        sdc_cmd_dir <= '0' when START_CMD_S,
                       '0' when WAIT_CMD_S,
                       '1' when others; 
                     
    intr <= '0';
    event_wr_en <= '0';
    event_reg <= (others => '0');
    
    sdc_clk_en <= ctrl1_reg(0);       
    sdc_card_en <= ctrl1_reg(0);      

end rtl;
