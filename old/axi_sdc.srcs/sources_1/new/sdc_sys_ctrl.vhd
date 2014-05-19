----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 05/08/2014 06:07:26 AM
-- Design Name: axi_sdc
-- Module Name: sdc_sys_ctrl - rtl
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
use work.sdc_defines_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sdc_sys_ctrl is
    Port ( clk100 : in STD_LOGIC;
           enable : in STD_LOGIC;
           
           sdc_clockgen_en : out std_logic;
           sdc_clk_enable : in std_logic;
           
           transaction_start : in std_logic;
           sdc_busy : out std_logic;
           
           cmd_start : out std_logic;
           cmd_busy : in std_logic;
           cmd_rlength : out std_logic;
           cmd_transmit : out std_logic;
           cmd_ignore_crc : out std_logic;
           cmd_crc_error : in std_logic;
           
           command : in std_logic_vector(5 downto 0);
           cmd_argument : in std_logic_vector (31 downto 0);          
           tx_fifo_data : out std_logic_vector (7 downto 0);
           tx_fifo_wr_en : out std_logic
           );
end sdc_sys_ctrl;

architecture rtl of sdc_sys_ctrl is

    type sysctrl_state_t is (
        IDLE,
        LOAD_CMD,
        INIT_CMD,
        START_CMD,
        SEL_RESP,
        RESP1,
        RESP2,
        RESP3,
        WAIT_RESP,
        RESP_CRC_ERROR,
        END_CMD,
        ILLEGAL_CMD);
        
    signal sc_state : sysctrl_state_t := IDLE;
    signal count : integer range 0 to 7 := 0;    
    
    signal write_mode : std_logic := '0';

    
begin


    sc_state_register : process (clk100)
        
    begin
        if rising_edge(clk100) then
            if enable='1' then
                case sc_state is
                    when IDLE =>
                        if transaction_start='1' then
                            sc_state <= LOAD_CMD;
                        end if;
                        
                    when LOAD_CMD =>
                        if count=4 then
                            count <= 0;
                            sc_state <= INIT_CMD;
                        else
                            count <= count + 1;
                        end if;
                    
                    when INIT_CMD =>
                        if cmd_busy='0' then
                            sc_state <= START_CMD;
                        end if;
                        
                    when START_CMD =>
                        if cmd_busy='1' then
                            sc_state <= SEL_RESP;
                        end if;
                    
                    when SEL_RESP =>
                        if cmd_busy='0' then
                            case command is
                                when CMD0 =>
                                    sc_state <= IDLE;
                                when CMD2 =>
                                    sc_state <= RESP2;
                                when CMD3 =>
                                    sc_state <= RESP1;
                                when CMD4 =>
                                    sc_state <= IDLE;
                                when CMD7 =>
                                    sc_state <= RESP1;
                                when CMD8 =>
                                    sc_state <= RESP1;
                                when CMD9 =>
                                    sc_state <= RESP2;
                                when CMD10 =>
                                    sc_state <= RESP2;
                                when CMD12 =>
                                    sc_state <= RESP1;
                                when CMD13 =>
                                    sc_state <= RESP1;
                                when CMD15 =>
                                    sc_state <= IDLE;
                                when others =>
                                    sc_state <= ILLEGAL_CMD;
                            end case;
                        end if;
                    
                    when RESP1 =>
                        if cmd_busy='1' then
                            sc_state <= WAIT_RESP;
                        end if;                    
                    when RESP2 =>
                        if cmd_busy='1' then
                            sc_state <= WAIT_RESP;
                        end if;                    
                    when RESP3 =>
                        if cmd_busy='1' then
                            sc_state <= WAIT_RESP;
                        end if;                    
                    
                    when WAIT_RESP =>
                        if cmd_busy='0' then
                            if cmd_crc_error='1' then
                                sc_state <= RESP_CRC_ERROR;
                            else
                                sc_state <= END_CMD;
                            end if;
                        end if;                           
                    
                    when END_CMD =>
                        if sdc_clk_enable='1' then
                            if count = 7 then
                                sc_state <= IDLE;
                                count <= 0;
                            else
                                count <= count + 1;
                            end if;
                        end if;
                         
                    when RESP_CRC_ERROR =>
                        sc_state <= IDLE;
                        
                    when ILLEGAL_CMD =>
                        sc_state <= IDLE;
                end case;
            end if;
        end if;
    end process;
    
    -- Output logic
    output_logic : process (sc_state, count)
    begin
        if sc_state=IDLE then
            sdc_busy <= '0';
        else
            sdc_busy <= '1';
        end if;
    
        if sc_state=INIT_CMD or
           sc_state=START_CMD or
           sc_state=SEL_RESP or
           sc_state=RESP1 or
           sc_state=RESP2 or
           sc_state=RESP3 or
           sc_state=WAIT_RESP or
           sc_state=END_CMD then
           
            sdc_clockgen_en <= '1';
        else
            sdc_clockgen_en <= '0';
        end if;
    
        if sc_state=START_CMD or
           sc_state=RESP1 or
           sc_state=RESP2 or
           sc_state=RESP3 then
            cmd_start <= '1';
        else
            cmd_start <= '0';
        end if;
        
        
        if sc_state=START_CMD then
            cmd_transmit <= '1';
        else
            cmd_transmit <= '0';
        end if;
        
        
        if sc_state=RESP2 then
            cmd_rlength <= '1';
        else
            cmd_rlength <= '0';
        end if;
        
        
        if sc_state=RESP3 then
            cmd_ignore_crc <= '1';
        else
            cmd_ignore_crc <= '0';
        end if;
        
        
        if sc_state=LOAD_CMD then
            case count is 
                when 0 =>
                    tx_fifo_data <= "01" & command;
                when 1 =>
                    tx_fifo_data <= cmd_argument(31 downto 24);
                when 2 =>
                    tx_fifo_data <= cmd_argument(23 downto 16);
                when 3 =>
                    tx_fifo_data <= cmd_argument(15 downto 8);
                when 4 => 
                    tx_fifo_data <= cmd_argument(7 downto 0);
                when others =>
                    tx_fifo_data <= X"00";
            end case;
             
            tx_fifo_wr_en <= '1';
            
        else
            tx_fifo_wr_en <= '0';
            tx_fifo_data <= X"00";
        end if;
        
        
    end process;
    
end rtl;
