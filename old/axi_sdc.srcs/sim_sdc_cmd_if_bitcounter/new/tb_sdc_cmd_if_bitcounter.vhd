----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2014 11:13:18 PM
-- Design Name: 
-- Module Name: tb_sdc_cmd_if_bitcounter - tb
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

entity tb_sdc_cmd_if_bitcounter is
end tb_sdc_cmd_if_bitcounter;

architecture tb of tb_sdc_cmd_if_bitcounter is

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

    constant PERIOD : time := 10 ns;

    signal clk100 : std_logic := '0';
    signal sim_en : std_logic := '1';
    
    
    signal bitc_en : std_logic := '0';
    signal bitc_clr : std_logic := '1';
    signal cmd_pre_finish : std_logic;
    signal cmd_short_finish : std_logic;
    signal cmd_arg0_finish : std_logic;
    signal cmd_arg1_finish : std_logic;
    signal cmd_arg2_finish : std_logic;
    signal cmd_arg3_finish : std_logic;
    
    signal count : integer := 0;

    
begin
    dut : sdc_cmd_if_bitcounter
    port map (
        Clk => clk100,
        bitc_en => bitc_en,
        bitc_clr => bitc_clr,
        cmd_pre_finish => cmd_pre_finish,
        cmd_short_finish => cmd_short_finish,
        cmd_arg0_finish => cmd_arg0_finish,
        cmd_arg1_finish => cmd_arg1_finish,
        cmd_arg2_finish => cmd_arg2_finish,
        cmd_arg3_finish => cmd_arg3_finish);

    clockgen : process (clk100, sim_en)
    begin
        if sim_en = '1' then
            clk100 <= not clk100 after PERIOD/2;
        end if;
     end process;


    stim : process
    begin
        sim_en <= '1';
        bitc_en <= '0';
        bitc_clr <= '1';
        count <= 0;
        wait for 10*PERIOD;
        
        wait until rising_edge(clk100);
        bitc_clr <= '0';
        
        wait until rising_edge(clk100);
        bitc_en <= '1';


        for i in 0 to 140 loop
            wait until rising_edge(clk100);
            count <= count + 1;
        end loop;

        bitc_en <= '0';
 
        sim_en <= '0';   
        wait;
    
    end process;


end tb;
