----------------------------------------------------------------------------    ------
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
    component cmd_if_in is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           sdc_cmd_in : in STD_LOGIC;
           long_resp : in STD_LOGIC;
           start : in STD_LOGIC;
           done : out STD_LOGIC;
           response : out STD_LOGIC_VECTOR (135 downto 0);
           crc_error : out STD_LOGIC);
    end component;


    constant PERIOD : time := 10 ns;

    signal Clk : std_logic := '0';
    signal sim_en : std_logic := '1';
    
    signal enable : std_logic := '0';
    signal sdc_cmd_in : std_logic := '1';    
    signal start : std_logic := '0';
    signal done : std_logic;    
    signal resp_short_crcok : std_logic_vector (47 downto 0) := x"123456789a95";
    signal resp_short_crcerr : std_logic_vector (47 downto 0) := x"123456789a85";
    signal resp_long_crcok : std_logic_vector (135 downto 0) := X"123456789abcdef0123456789abcdef0EF";
    signal resp_long_crcerr : std_logic_vector (135 downto 0) := X"123456789abcdef0123456789abcdef0DF";
    signal crc_error : std_logic;
    signal long_resp : std_logic := '0';
    signal response : std_logic_vector (135 downto 0);

    
begin

    dut : cmd_if_in  
        port map (
            clk => clk, 
            enable => enable,
            sdc_cmd_in => sdc_cmd_in,
            long_resp => long_resp,
            start => start,
            done => done,
            response => response,
            crc_error => crc_error
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
        long_resp <= '0';
        sdc_cmd_in <= '1';
        
        wait for 10*PERIOD;
        Enable <= '1';
        wait for 10*PERIOD;

        wait for 3*PERIOD;
        
        wait until rising_edge(Clk);
        start <= '1';
         wait until rising_edge(Clk);
        start <= '0';
              
        wait for 3*PERIOD;
        
        for i in resp_short_crcok'left downto 0 loop
            wait until rising_edge(clk);
            sdc_cmd_in <= resp_short_crcok(i);
        end loop;            
              
        wait until done='1';

        wait for 10*PERIOD;
        
        wait until rising_edge(Clk);
        start <= '1';
         wait until rising_edge(Clk);
        start <= '0';
              
        wait for 3*PERIOD;
        
        for i in resp_short_crcerr'left downto 0 loop
            wait until rising_edge(clk);
            sdc_cmd_in <= resp_short_crcerr(i);
        end loop;            
              
        wait until done='1';

        wait for 10*PERIOD;        
        
        long_resp <= '1';
        wait until rising_edge(Clk);
        start <= '1';
         wait until rising_edge(Clk);
        start <= '0';
             
        wait for 3*PERIOD;
        
        for i in resp_long_crcok'left downto 0 loop
            wait until rising_edge(clk);
            sdc_cmd_in <= resp_long_crcok(i);
        end loop;            
              
        wait until done='1';

        wait for 10*PERIOD;
        
        wait until rising_edge(Clk);
        start <= '1';
         wait until rising_edge(Clk);
        start <= '0';
              
        wait for 3*PERIOD;
        
        for i in resp_long_crcerr'left downto 0 loop
            wait until rising_edge(clk);
            sdc_cmd_in <= resp_long_crcerr(i);
        end loop;            
              
        wait until done='1';

        wait for 10*PERIOD;                
        
        sim_en <= '0';
    
        wait;
    
    end process;


end tb;