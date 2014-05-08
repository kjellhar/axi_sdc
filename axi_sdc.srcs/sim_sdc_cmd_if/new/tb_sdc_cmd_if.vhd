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
use IEEE.NUMERIC_STD.ALL;

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

    component sdc_cmd_if is
        Port ( clk100 : in STD_LOGIC;
               enable : in STD_LOGIC;
               sdc_cmd_io : inout std_logic;
               sdc_clk_redge : in std_logic;
               sdc_clk_fedge : in std_logic;
               tx_din : in STD_LOGIC_VECTOR (7 downto 0);
               tx_wr_en : in STD_LOGIC;
               tx_full : out STD_LOGIC;
               tx_empty : out STD_LOGIC;
               rx_dout : out STD_LOGIC_VECTOR (7 downto 0);
               rx_rd_en : in STD_LOGIC;
               rx_full : out STD_LOGIC;
               rx_empty : out STD_LOGIC;
               transmit : in STD_LOGIC;
               length : in std_logic;
               start : in STD_LOGIC;
               busy : out STD_LOGIC);
    end component;

    constant PERIOD : time := 10 ns;

    signal clk100 : std_logic := '0';
    signal sim_en : std_logic := '1';
    
    signal Enable : std_logic := '0';
    signal Frequency : std_logic_vector (1 downto 0) := "10";
    signal sdc_clk_level : std_logic;
    signal sdc_clk_redge : std_logic;
    signal sdc_clk_fedge : std_logic;
    
    signal sdc_clk : std_logic;

    signal sdc_cmd_io : std_logic;
    signal tx_din : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_wr_en : std_logic := '0';
    signal tx_full : std_logic;
    signal tx_empty : std_logic;
    signal rx_dout : std_logic_vector(7 downto 0);
    signal rx_rd_en : std_logic := '0';
    signal rx_full : std_logic;
    signal rx_empty : std_logic;
    signal transmit : std_logic := '0';
    signal length : std_logic := '0';
    signal start : std_logic := '0';
    signal busy : std_logic;
    
    signal ser_data : std_logic_vector(0 to 39) := x"31d2c3b4a5";
    signal par_data : std_logic_vector(7 downto 0);
    
    
begin


    u_sdc_clkden_en : sdc_clken_gen
        port map ( 
            Clk100 => Clk100,
            Enable  => Enable,
            Frequency => Frequency,
            sdc_clk_level => sdc_clk_level, 
            sdc_clk_redge => sdc_clk_redge, 
            sdc_clk_fedge => sdc_clk_fedge);


    dut : sdc_cmd_if
        port map (
            clk100 => clk100,
            enable => enable,
            sdc_cmd_io => sdc_cmd_io,
            sdc_clk_redge => sdc_clk_redge,
            sdc_clk_fedge =>sdc_clk_fedge ,
            tx_din => tx_din,
            tx_wr_en => tx_wr_en,
            tx_full => tx_full,
            tx_empty => tx_empty,
            rx_dout => rx_dout,
            rx_rd_en => rx_rd_en,
            rx_full => rx_full,
            rx_empty => rx_empty,
            transmit=> transmit,
            length => length,
            start => start,
            busy => busy);

       
    clockgen : process (clk100, sim_en)
    begin
        if sim_en = '1' then
            clk100 <= not clk100 after PERIOD/2;
        end if;
     end process;
     
     clk_output : process (clk100)
     begin
        if rising_edge(clk100) then
            sdc_clk <= sdc_clk_level;
        end if;
     end process;


    stim : process
        variable data : unsigned (7 downto 0);
    begin
        sim_en <= '1';
        enable <= '0';
        start <= '0';
        transmit <= '0';
        tx_wr_en <= '0';
        rx_rd_en <= '0';
        length <= '0';
        tx_din <= X"FF";
        sdc_cmd_io <= 'H';
        
        wait for 10*PERIOD;
        
        Frequency <= "01";
        Enable <= '1';
        wait for 10*period;
        
        data := X"11";
        wait until rising_edge(clk100);
        for i in 0 to 5 loop
            tx_din <= std_logic_vector(data);
            tx_wr_en <= '1';
            wait until rising_edge(clk100);
           
            data := data + X"11";  
        end loop;
        tx_wr_en <= '0';
        
        transmit <= '1';
        start <= '1';
        
        wait until busy = '0';
        start <= '0';
        
        wait until rising_edge(clk100);
        transmit <= '0';
        length <= '0';
        start <= '1';
        
        for i in 0 to 4 loop
            wait until rising_edge(clk100) and sdc_clk_fedge='1';
        end loop;
  
  
        for i in 0 to 39 loop
            sdc_cmd_io <= ser_data(i);
            wait until rising_edge(clk100) and sdc_clk_fedge='1';
        end loop;
        
        sdc_cmd_io <= 'H';
        
        wait until busy = '0';
        start <= '0';
        
        wait until rising_edge(clk100);
        
        for i in 0 to 5 loop
            rx_rd_en <= '1';
            wait until rising_edge(clk100);
            par_data <= rx_dout;
        end loop;
        rx_rd_en <= '0';
        
        wait for 5*PERIOD;
        
        
        Enable <= '0';
        sim_en <= '0';
    
        wait;
    
    end process;


end tb;
