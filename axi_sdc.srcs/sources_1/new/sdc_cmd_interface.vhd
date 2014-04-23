----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 04/23/2014 07:45:50 PM
-- Design Name: axi_sdc
-- Module Name: sdc_cmd_interface - rtl
-- Project Name: axi_sdc
-- Target Devices: Artix7
-- Tool Versions: 
-- Description: 
--  Controls the data flow through the SDC command interface, to and from the 
--  registers. 
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

entity sdc_cmd_interface is
    Port ( Clk : in std_logic;
           Enable : in std_logic;
           
           sdc_cmd_in : in std_logic;
           sdc_cmd_out : out std_logic;
           sdc_clk_redge : in std_logic;
           sdc_clk_fedge : in std_logic;
           
           write_cmd_strobe : in std_logic;
           read_short_strobe : in std_logic;
           read_long_strobe : in std_logic;
           cmd_busy : out std_logic;
           
           cmd_index : in std_logic_vector (5 downto 0);
           cmd_argument : in std_logic_vector (31 downto 0);
           load_cmd : in std_logic;
           
           data_out :out  std_logic_vector (31 downto 0);
           response_reg0_en : out std_logic;
           response_reg1_en : out std_logic;
           response_reg2_en : out std_logic;
           response_reg3_en : out std_logic
           );
end sdc_cmd_interface;

architecture rtl of sdc_cmd_interface is
    component sdc_crc7 is
    Port ( Clk : in std_logic;
           Enable : in std_logic;
           Clr : in std_logic;
           SData_in : in std_logic;
           Crc7_out : out std_logic_vector (6 downto 0));
    end component;
    
    component sdc_shift32 is
    Port ( Clk : in STD_LOGIC;
           shift_en : in STD_LOGIC;
           load_en : in STD_LOGIC;
           sdata_in : in STD_LOGIC;
           sdata_out : out STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component sdc_cmd_if_bitcounter is
    Port ( Clk : in std_logic;
           bitc_en : in std_logic;
           bitc_clr : in std_logic;
           cmd_pre_finish : out std_logic;
           cmd_short_finish : out std_logic;
           cmd_arg0_finish : out std_logic;
           cmd_arg1_finish : out std_logic;
           cmd_arg2_finish : out std_logic;
           cmd_arg3_finish : out std_logic);
end component;    
    
    type cmd_if_state_t is (
        IDLE,
        WRITE_CMD_LOAD_PRE,
        WRITE_CMD_PRE,
        WRITE_CMD_LOAD_ARG,
        WRITE_CMD_ARG,
        WRITE_CMD_LOAD_CRC7,
        WRITE_CMD_CRC7);
        
    signal cmd_if_state : cmd_if_state_t := IDLE;
    
    signal bitc_clr : std_logic;
    
    signal cmd_pre_finish : std_logic;
    signal cmd_short_finish : std_logic;
    signal cmd_arg0_finish : std_logic;
    signal cmd_arg1_finish : std_logic;
    signal cmd_arg2_finish : std_logic;
    signal cmd_arg3_finish : std_logic;
    
    signal crc7_en : std_logic;
    signal crc7_clr : std_logic;
    signal crc7_data_stream : std_logic;
    signal crc7 : std_logic_vector (6 downto 0);
    signal shift_en : std_logic;
    signal shift_load_en : std_logic;
    signal sdata_in : std_logic;
    signal sdata_out : std_logic;
    signal pdata_in : std_logic_vector (31 downto 0);
    signal pdata_out : std_logic_vector (31 downto 0);
    signal bitc_en : std_logic;

    
begin
    u_crc7 : sdc_crc7
    port map (
        Clk => Clk,
        Enable => Crc7_en,
        Clr => Crc7_clr,
        SData_in => crc7_data_stream,
        Crc7_out => Crc7);

    u_shiftreg : sdc_shift32
    port map (
        Clk => Clk,
        shift_en => shift_en,
        load_en => shift_load_en,
        sdata_in => sdata_in,
        sdata_out => sdata_out,
        data_in => pdata_in,
        data_out => pdata_out);

    u_sdc_cmd_if_bitcounter : sdc_cmd_if_bitcounter
    port map (
        Clk => Clk,
        bitc_en => bitc_en,
        bitc_clr => bitc_clr,
        cmd_pre_finish => cmd_pre_finish,
        cmd_short_finish => cmd_short_finish,
        cmd_arg0_finish => cmd_arg0_finish,
        cmd_arg1_finish => cmd_arg1_finish,
        cmd_arg2_finish => cmd_arg2_finish,
        cmd_arg3_finish => cmd_arg3_finish);

    cmd_if_state_machine : process (clk)
    begin
        if rising_edge(clk) then
            if Enable = '1' then
                case cmd_if_state is
                    when IDLE =>
                        bitc_clr <= '1';
                        crc7_clr <= '1';
                        crc7_en <= '0';
                        shift_en <= '0';
                        bitc_en <= '0';
                        shift_load_en <= '0';
                        pdata_in <= (others => '0');
                        
                        if write_cmd_strobe = '1' then     
                            cmd_if_state <= WRITE_CMD_LOAD_PRE;
                                           
                        elsif read_short_strobe = '1' then
                        
                        elsif read_long_strobe = '1' then
                        
                        end if;
                        
                    when WRITE_CMD_LOAD_PRE =>
                        bitc_clr <= '1';
                        crc7_clr <= '1';
                        crc7_en <= '0';
                        shift_en <= '0';
                        shift_load_en <= '1';
                        bitc_en <= '0';
                        pdata_in <= "01" & cmd_index & x"000000";
                        
                        
                        cmd_if_state <= WRITE_CMD_PRE;
                        
                    when WRITE_CMD_PRE =>
                        bitc_clr <= '0';
                        crc7_clr <= '0';
                        crc7_en <= sdc_clk_fedge;
                        shift_en <= sdc_clk_fedge;
                        shift_load_en <= '0';
                        bitc_en <= sdc_clk_fedge;
                        pdata_in <= (others => '0');
                        
                        if cmd_pre_finish = '1' then
                            cmd_if_state <= WRITE_CMD_LOAD_ARG;
                        end if;
                    
                    when WRITE_CMD_LOAD_ARG =>
                        bitc_clr <= '0';
                        crc7_clr <= '0';
                        crc7_en <= '0';
                        shift_en <= '0';
                        shift_load_en <= '1';
                        bitc_en <= '0';
                        pdata_in <= cmd_argument;
                        
                        cmd_if_state <= WRITE_CMD_ARG;
                                           
                    when WRITE_CMD_ARG =>
                        bitc_clr <= '0';
                        crc7_clr <= '0';
                        crc7_en <= sdc_clk_fedge;
                        shift_en <= sdc_clk_fedge;
                        shift_load_en <= '0';
                        bitc_en <= sdc_clk_fedge;
                        pdata_in <= (others => '0');
                        
                        if cmd_arg0_finish = '1' then
                            cmd_if_state <= WRITE_CMD_LOAD_CRC7;
                        end if;  
                                          
                    when WRITE_CMD_LOAD_CRC7 =>
                        bitc_clr <= '0';
                        crc7_clr <= '0';
                        crc7_en <= '0';
                        shift_en <= '0';
                        shift_load_en <= '1';
                        bitc_en <= '0';
                        pdata_in <= crc7 & '1' & x"000000";
                        
                        cmd_if_state <= WRITE_CMD_ARG;                    
                        
                    when WRITE_CMD_CRC7 =>
                        bitc_clr <= '0';
                        crc7_clr <= '0';
                        crc7_en <= sdc_clk_fedge;
                        shift_en <= sdc_clk_fedge;
                        shift_load_en <= '0';
                        bitc_en <= sdc_clk_fedge;
                        pdata_in <= (others => '0');
                        
                        if cmd_short_finish = '1' then
                            cmd_if_state <= IDLE;
                        end if;                                            
                    when others =>
                end case;
            end if;
        end if;
    end process;





end rtl;
