----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2014 11:13:18 PM
-- Design Name: 
-- Module Name: tb_sdc_clken_gen - tb
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

entity tb_sdc_clken_gen is
end tb_sdc_clken_gen;

architecture tb of tb_sdc_clken_gen is
    component sdc_clken_gen is
        Port ( Clk100 : in STD_LOGIC;
               Enable : in STD_LOGIC;
               sdc_clockgen_en : in std_logic;
               Frequency : in STD_LOGIC_VECTOR (1 downto 0);
               sdc_clk_level : out STD_LOGIC;
               sdc_clk_redge : out STD_LOGIC;
               sdc_clk_fedge : out STD_LOGIC);
    end component;


    constant PERIOD : time := 10 ns;

    signal clk100 : std_logic := '0';
    signal sim_en : std_logic := '1';
    
    signal Enable : std_logic := '0';
    signal Frequency : std_logic_vector (1 downto 0) := "10";
    signal sdc_clk_level : std_logic;
    signal sdc_clk_redge : std_logic;
    signal sdc_clk_fedge : std_logic;
    signal sdc_clockgen_en : std_logic := '0';
    
begin


    dut : sdc_clken_gen
        port map ( 
            Clk100 => Clk100,
            Enable  => Enable,
            sdc_clockgen_en => sdc_clockgen_en,
            Frequency => Frequency,
            sdc_clk_level => sdc_clk_level, 
            sdc_clk_redge => sdc_clk_redge, 
            sdc_clk_fedge => sdc_clk_fedge);


    clockgen : process (clk100, sim_en)
    begin
        if sim_en = '1' then
            clk100 <= not clk100 after PERIOD/2;
        end if;
     end process;


    stim : process
    begin
        sim_en <= '1';
        wait for 10*PERIOD;
       
        
        Frequency <= "10";
        Enable <= '1';
        wait for 10*period;
       
        sdc_clockgen_en <= '1';
        
        wait for 10.6*period;
        
        sdc_clockgen_en <= '0';
      
        
        wait for 5*period;
      
        sdc_clockgen_en <= '1';
        
        Frequency <= "01";
        Enable <= '1';
        wait for 20*period;

        Frequency <= "00";
        Enable <= '1';
        wait for 500*period;

        
        sim_en <= '0';
    
        wait;
    
    end process;


end tb;
