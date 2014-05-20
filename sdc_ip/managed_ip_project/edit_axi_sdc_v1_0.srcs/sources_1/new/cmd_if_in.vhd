----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen 
-- 
-- Create Date: 05/19/2014 11:22:45 PM
-- Design Name: AXI_SDC
-- Module Name: cmd_if_in - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cmd_if_in is
    Port ( clk : in STD_LOGIC;
           reset : in std_logic;
           enable : in STD_LOGIC;
           sdc_cmd_in : in STD_LOGIC;
           long_resp : in STD_LOGIC;
           start : in STD_LOGIC;
           done : out STD_LOGIC;
           resp0_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp1_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp2_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp3_out : out STD_LOGIC_VECTOR (31 downto 0);
           crc_error : out STD_LOGIC);
end cmd_if_in;

architecture rtl of cmd_if_in is

    type state_t is (
        IDLE_S,
        WAIT_START_S,
        CMD_SHORT_S,
        DATA_SHORT_S,
        CRC_SHORT_S,
        CMD_LONG_S,
        DATA_LONG_S,
        CRC_LONG_S,
        STOP_BIT_S,
        CMD_DONE_S);
        
    signal state : state_t := IDLE_S;
    
    signal cmd_reg : std_logic_vector (135 downto 0) := (others => '0');
    signal crc_reg : std_logic_vector (6 downto 0) := (others => '0');
    
    signal long_resp_reg : std_logic := '0';
    
    signal bit_counter : integer range 0 to 136 := 0;

begin

    done <= '1' when state=CMD_DONE_S else '0';
    crc_error <= '1' when state=CMD_DONE_S and crc_reg /= cmd_reg(7 downto 1) else '0';
    
    resp0_out <= cmd_reg(39 downto 8) when long_resp_reg = '0' else
                 cmd_reg(127 downto 96);
    resp1_out <= (others => '0') when long_resp_reg = '0' else
                 cmd_reg(95 downto 64);                
    resp2_out <= (others => '0') when long_resp_reg = '0' else
                 cmd_reg(63 downto 32);                
    resp3_out <= (others => '0') when long_resp_reg = '0' else
                 cmd_reg(31 downto 0);                
                  

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= IDLE_S;
                bit_counter <= 0;
                cmd_reg <= (others => '0');
            else
                if enable='1' then
                    case state is
                        when IDLE_S =>
                            bit_counter <= 0;
                            cmd_reg <= (others => '0');
                            
                            if start='1' then
                                state <= WAIT_START_S;
                                long_resp_reg <= long_resp;
                            end if;
                            
                        when WAIT_START_S =>                       
                            if sdc_cmd_in = '0' then
                                bit_counter <= 1;
                                cmd_reg(cmd_reg'left downto 0) <= cmd_reg(cmd_reg'left-1 downto 0) & sdc_cmd_in;
                                                    
                                if long_resp = '0' then
                                    state <= CMD_SHORT_S;
                                else
                                    state <= CMD_LONG_S;
                                end if;
                            end if;
                        
                        when CMD_SHORT_S =>
                            bit_counter <= bit_counter + 1;
                            cmd_reg(cmd_reg'left downto 0) <= cmd_reg(cmd_reg'left-1 downto 0) & sdc_cmd_in;
                            
                            if bit_counter=7 then
                                state <= DATA_SHORT_S;
                            end if;
                            
                        when DATA_SHORT_S =>
                                bit_counter <= bit_counter + 1;
                                cmd_reg(cmd_reg'left downto 0) <= cmd_reg(cmd_reg'left-1 downto 0) & sdc_cmd_in;
                                
                                if bit_counter=39 then
                                    state <= CRC_SHORT_S;
                                end if;                                 
                       
                        when CRC_SHORT_S =>
                                    bit_counter <= bit_counter + 1;
                                    cmd_reg(cmd_reg'left downto 0) <= cmd_reg(cmd_reg'left-1 downto 0) & sdc_cmd_in;
            
                                    if bit_counter=46 then
                                        state <= STOP_BIT_S;
                                    end if;                   
                        
                        when CMD_LONG_S =>
                            bit_counter <= bit_counter + 1;
                            cmd_reg(cmd_reg'left downto 0) <= cmd_reg(cmd_reg'left-1 downto 0) & sdc_cmd_in;
                            
                            if bit_counter=7 then
                                state <= DATA_LONG_S;
                            end if;                        
                        
                        when DATA_LONG_S =>
                            bit_counter <= bit_counter + 1;
                            cmd_reg(cmd_reg'left downto 0) <= cmd_reg(cmd_reg'left-1 downto 0) & sdc_cmd_in;
                            
                            if bit_counter=127 then
                                state <= CRC_LONG_S;
                            end if;                        
                         
                        when CRC_LONG_S =>
                                bit_counter <= bit_counter + 1;
                                cmd_reg(cmd_reg'left downto 0) <= cmd_reg(cmd_reg'left-1 downto 0) & sdc_cmd_in;
        
                                if bit_counter=134 then
                                    state <= STOP_BIT_S;
                                end if;                                                          
                        
                        when STOP_BIT_S =>
                            bit_counter <= bit_counter + 1;
                            cmd_reg(cmd_reg'left downto 0) <= cmd_reg(cmd_reg'left-1 downto 0) & sdc_cmd_in;
                            state <= CMD_DONE_S;
                        
                        when CMD_DONE_S =>
                            state <= IDLE_S;
                    end case;
                end if;
            end if;
        end if;
    end process;
    
    
    process (clk)
    begin
        if rising_Edge(clk) then
            if enable='1' then
                if state=IDLE_S then
                    crc_reg <= (others => '0');
                    
                elsif   (state=WAIT_START_S and sdc_cmd_in='0' and long_resp='0') or
                        (state=CMD_SHORT_S) or
                        (state=DATA_SHORT_S) or
                        (state=DATA_LONG_S) then

                    crc_reg(0) <= crc_reg(6) xor sdc_cmd_in;
                    crc_reg(1) <= crc_reg(0);
                    crc_reg(2) <= crc_reg(1);
                    crc_reg(3) <= crc_reg(2) xor crc_reg(6) xor sdc_cmd_in;
                    crc_reg(4) <= crc_reg(3);
                    crc_reg(5) <= crc_reg(4);
                    crc_reg(6) <= crc_reg(5);                
                end if;
            end if;
        end if;
    end process;


end rtl;
