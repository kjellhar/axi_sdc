----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2014 11:13:18 PM
-- Design Name: 
-- Module Name: tb_sdc_cmd_interface - tb
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

entity tb_sdc_cmd_interface is
end tb_sdc_cmd_interface;

architecture tb of tb_sdc_cmd_interface is
    component sdc_clken_gen is
        Port ( Clk100 : in STD_LOGIC;
               Enable : in STD_LOGIC;
               Frequency : in STD_LOGIC_VECTOR (1 downto 0);
               sdc_clk_level : out STD_LOGIC;
               sdc_clk_redge : out STD_LOGIC;
               sdc_clk_fedge : out STD_LOGIC);
    end component;

    component sdc_cmd_interface is
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
               
               data_out :out  std_logic_vector (31 downto 0);
               response_reg0_en : out std_logic;
               response_reg1_en : out std_logic;
               response_reg2_en : out std_logic;
               response_reg3_en : out std_logic
               );
    end component;


    constant PERIOD : time := 10 ns;

    signal clk100 : std_logic := '0';
    signal sim_en : std_logic := '1';
    
    signal Enable : std_logic := '0';
    signal Frequency : std_logic_vector (1 downto 0) := "10";
    signal sdc_clk_level : std_logic;
    signal sdc_clk_redge : std_logic;
    signal sdc_clk_fedge : std_logic;

    signal sdc_cmd_in : std_logic;
    signal sdc_cmd_out : std_logic;
    signal write_cmd_strobe : std_logic;
    signal read_short_strobe : std_logic;
    signal read_long_strobe : std_logic;
    signal cmd_busy : std_logic;
    signal cmd_index : std_logic_vector (5 downto 0);
    signal cmd_argument : std_logic_vector (31 downto 0);
    signal data_out : std_logic_vector (31 downto 0);
    signal response_reg0_en : std_logic;
    signal response_reg1_en : std_logic;
    signal response_reg2_en : std_logic;
    signal response_reg3_en : std_logic;
    
begin


    u_sdc_clkden_en : sdc_clken_gen
        port map ( 
            Clk100 => Clk100,
            Enable  => Enable,
            Frequency => Frequency,
            sdc_clk_level => sdc_clk_level, 
            sdc_clk_redge => sdc_clk_redge, 
            sdc_clk_fedge => sdc_clk_fedge);

    dut : sdc_cmd_interface
        port map (
            Clk => clk100,
            Enable => Enable,
            sdc_cmd_in => sdc_cmd_in,
            sdc_cmd_out => sdc_cmd_out,
            sdc_clk_redge => sdc_clk_redge,
            sdc_clk_fedge => sdc_clk_fedge,
            write_cmd_strobe => write_cmd_strobe,
            read_short_strobe => read_short_strobe,
            read_long_strobe => read_long_strobe,
            cmd_busy => cmd_busy,
            cmd_index => cmd_index,
            cmd_argument => cmd_argument,
            data_out => data_out,
            response_reg0_en => response_reg0_en,
            response_reg1_en => response_reg1_en,
            response_reg2_en => response_reg2_en,
            response_reg3_en => response_reg3_en);
       
    clockgen : process (clk100, sim_en)
    begin
        if sim_en = '1' then
            clk100 <= not clk100 after PERIOD/2;
        end if;
     end process;


    stim : process
    begin
        sim_en <= '1';
        write_cmd_strobe <= '0';
        read_short_strobe <= '0';
        read_long_strobe <= '0';
        
        wait for 10*PERIOD;
        
        Frequency <= "01";
        Enable <= '1';
        wait for 10*period;
        
        cmd_index <= "100110";
        cmd_argument <= x"6789ABDE";
        
        wait until rising_edge(clk100);
        write_cmd_strobe <= '1';
        
        wait until cmd_busy='1';
        wait until rising_edge(clk100);
        write_cmd_strobe <= '0';
        
        wait until cmd_busy='0';
        
        wait for 5*PERIOD;
        
        
        Enable <= '0';
        sim_en <= '0';
    
        wait;
    
    end process;


end tb;
