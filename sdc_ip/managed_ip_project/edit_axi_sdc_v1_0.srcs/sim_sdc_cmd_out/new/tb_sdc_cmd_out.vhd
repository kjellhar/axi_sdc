----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2014 11:13:18 PM
-- Design Name: 
-- Module Name: tb_sdc_crc7 - tb
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

entity tb_sdc_crc7 is
end tb_sdc_crc7;

architecture tb of tb_sdc_crc7 is
    component cmd_if_out is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           sdc_cmd_out : out STD_LOGIC;
           cmd_in : in STD_LOGIC_VECTOR (39 downto 0);
           start : in STD_LOGIC;
           done : out STD_LOGIC
           );
    end component;


    constant PERIOD : time := 10 ns;

    signal Clk : std_logic := '0';
    signal sim_en : std_logic := '1';
    
    signal enable : std_logic := '0';
    signal sdc_cmd_out : std_logic := '0';    
    signal start : std_logic := '0';
    signal done : std_logic := '0';    
    signal cmd_in : std_logic_vector (39 downto 0) := x"123456789a";
    

    
begin

    dut : cmd_if_out 
        port map (
            clk => clk, 
            enable => enable,
            sdc_cmd_out => sdc_cmd_out,
            cmd_in => cmd_in,
            start => start,
            done => done
            );


    clockgen : process (Clk, sim_en)
    begin
        if sim_en = '1' then
            Clk <= not Clk after PERIOD/2;
        end if;
     end process;


    stim : process
    begin
        sim_en <= '1';
        Enable <= '0';
        start <= '0';
        
        wait for 10*PERIOD;
        Enable <= '1';
        wait for 10*PERIOD;

        wait for 3*PERIOD;
        
        wait until rising_edge(Clk);
        start <= '1';
         wait until rising_edge(Clk);
        start <= '0';
                
        wait until done='1';

        wait for 10*PERIOD;
        sim_en <= '0';
    
        wait;
    
    end process;


end tb;