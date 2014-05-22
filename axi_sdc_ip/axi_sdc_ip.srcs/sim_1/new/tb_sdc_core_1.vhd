----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2014 10:41:39 AM
-- Design Name: 
-- Module Name: tb_sdc_ctrl - Behavioral
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

entity tb_sdc_core is
end tb_sdc_core;

architecture tb of tb_sdc_core is
    component sdc_core is
    Port ( clk : in STD_LOGIC;
       resetn : in STD_LOGIC;
       sdc_clk : out std_logic;
       sdc_cmd_in : in std_logic;
       sdc_cmd_out : out std_logic;
       sdc_cmd_dir : out std_logic;
       sdc_dat_in : in std_logic_vector (3 downto 0);
       sdc_dat_out : out std_logic_vector (3 downto 0);
       sdc_dat_dir : out std_logic;
       
       sdc_card_detect : in std_logic;
       sdc_card_en : out std_logic;
       
       intr : out std_logic;   
       busy : out std_logic;
       cmd_received : in std_logic;     
       
       ctrl1_reg : in std_logic_vector (31 downto 0);
       ctrl2_reg : in std_logic_vector (31 downto 0);
       cmd_reg : in std_logic_vector (31 downto 0);
       carg_reg : in std_logic_vector (31 downto 0);
       evmask_reg : in std_logic_vector (31 downto 0);
      
       resp0_out : out STD_LOGIC_VECTOR (31 downto 0);
       resp1_out : out STD_LOGIC_VECTOR (31 downto 0);
       resp2_out : out STD_LOGIC_VECTOR (31 downto 0);
       resp3_out : out STD_LOGIC_VECTOR (31 downto 0);
       resp_wr_en : out std_logic;              
       event_out : out STD_LOGIC_VECTOR (31 downto 0);
       event_wr_en : out std_logic);
    end component;
    
    constant PERIOD : time := 10 ns;
    
    signal cmd_received : std_logic;
    signal busy : std_logic;
    signal ctrl1_r : std_logic_vector (31 downto 0) := (others => '0');
    signal ctrl2_r : std_logic_vector (31 downto 0) := (others => '0');
    signal carg_r : std_logic_vector (31 downto 0) := (others => '0');
    signal cmd_r : std_logic_vector (31 downto 0) := (others => '0');
    signal resp0_r : std_logic_vector (31 downto 0) := (others => '0');
    signal resp1_r : std_logic_vector (31 downto 0) := (others => '0');
    signal resp2_r : std_logic_vector (31 downto 0) := (others => '0');
    signal resp3_r : std_logic_vector (31 downto 0) := (others => '0');
    signal evmask_r : std_logic_vector (31 downto 0) := (others => '0');
    signal event_r : std_logic_vector (31 downto 0) := (others => '0');
    signal resp_wr_en : std_logic;
    signal event_wr_en : std_logic;
    
    signal clk : std_logic := '0';
    signal sim_en : std_logic := '1';
    signal resetn : std_logic := '0';

    signal sdc_clk : std_logic;
    signal sdc_cmd_in : std_logic;
    signal sdc_cmd_out : std_logic;
    signal sdc_cmd_dir : std_logic;
    signal sdc_dat_in : std_logic_vector(3 downto 0);
    signal sdc_dat_out : std_logic_vector(3 downto 0);
    signal sdc_dat_dir : std_logic;
    signal sdc_card_detect : std_logic;
    signal sdc_card_en : std_logic;
 
 
    signal intr : std_logic;
    
    signal resp_short_crcok : std_logic_vector (47 downto 0) := x"123456789a95";
    

begin

    clockgen : process (Clk, sim_en)
    begin
        if sim_en = '1' then
            Clk <= not Clk after PERIOD/2;
        end if;
     end process;

    u_sdc_core : sdc_core
    Port map ( 
        clk => clk,
        resetn => resetn,
        sdc_clk =>sdc_clk ,
        sdc_cmd_in => sdc_cmd_in,
        sdc_cmd_out => sdc_cmd_out,
        sdc_cmd_dir => sdc_cmd_dir,
        sdc_dat_in => sdc_dat_in,
        sdc_dat_out => sdc_dat_out,
        sdc_dat_dir => sdc_dat_dir,
        
        sdc_card_detect => sdc_card_detect,
        sdc_card_en => sdc_card_en,
        
        intr => intr,   
        busy => busy,
        cmd_received => cmd_received,     
        
        ctrl1_reg => ctrl1_r,
        ctrl2_reg => ctrl2_r,
        cmd_reg => cmd_r,
        carg_reg => carg_r,
        evmask_reg => evmask_r,
        
        resp0_out => resp0_r,
        resp1_out => resp1_r,
        resp2_out => resp2_r,
        resp3_out => resp3_r,
        resp_wr_en => resp_wr_en,              
        event_out => event_r,
        event_wr_en => event_wr_en);

    stim : process
    begin
        sim_en <= '1';
        resetn <= '0';
        cmd_received <= '0';
        
        ctrl1_r <= X"00010001";
        ctrl2_r <= X"00000000";
        carg_r <= X"12345678";
        cmd_r <= X"00000003";
        evmask_r <= X"00000000";


        wait for 10*PERIOD;
        resetn <= '1';
        wait for 3*PERIOD;
        

        wait until rising_edge(Clk);
        cmd_received <= '1';
        wait until busy='1';
        cmd_received <= '0';
        
        wait until busy='0';
        
        wait until rising_edge(Clk);
        
        wait for 3*PERIOD;
        
        for i in resp_short_crcok'left downto 0 loop
            wait until rising_edge(sdc_clk);
            sdc_cmd_in <= resp_short_crcok(i);
        end loop;  
        
        wait until rising_edge(clk);

        wait for 10*PERIOD;
        sim_en <= '0';
    
        wait;
    
    end process;

end tb;
