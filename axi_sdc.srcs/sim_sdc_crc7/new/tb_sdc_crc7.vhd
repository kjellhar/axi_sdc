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
    component sdc_crc7 is
        Port ( Clk : in STD_LOGIC;
               Enable : in STD_LOGIC;
               Clr : in STD_LOGIC;
               SData_in : in STD_LOGIC;
               Crc7_out : out STD_LOGIC_VECTOR (6 downto 0));
    end component;



    constant PERIOD : time := 10 ns;

    signal Clk : std_logic := '0';
    signal sim_en : std_logic := '1';
    
    signal Enable : std_logic := '0';
    signal Clr : std_logic := '0';
    signal SData_in : std_logic := '0';
    signal Crc7_out : std_logic_vector (6 downto 0);
    
    signal data_string : std_logic_vector (47 downto 0) := x"123456781234";

    
begin

    dut : sdc_crc7 
        port map (
            Clk => Clk, 
            Enable => Enable,
            Clr => Clr, 
            SData_in => SData_in,
            Crc7_out => Crc7_out);



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
        Clr <= '0';
        wait for 10*PERIOD;
        
        wait until rising_edge(Clk);
        Clr <= '1';
         wait until rising_edge(Clk);
        Clr <= '0';
        Enable <= '1';
        
        for i in data_string'high downto data_string'low loop
            SData_in <= data_string(i);
            wait until rising_edge(Clk);
        end loop;
        Enable <= '0';
        
        wait for 5*period;

        
        sim_en <= '0';
    
        wait;
    
    end process;


end tb;
