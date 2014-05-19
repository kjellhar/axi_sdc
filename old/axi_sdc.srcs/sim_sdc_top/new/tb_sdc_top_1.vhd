----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2014 11:13:18 PM
-- Design Name: 
-- Module Name: tb_sdc_top - tb
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

entity tb_sdc_top is
end tb_sdc_top;

architecture tb of tb_sdc_top is

    constant PERIOD : time := 10 ns;


    component sdc_top is
        port (
            -- System signals
            Clk100 : in std_logic;      -- Must be 100MHz for the timing to be correct
            Enable : in std_logic;      -- Enables the clock in the core module
        
            -- SD Card external interface
            SDC_CLK : out std_logic;
            SDC_CMD : inout std_logic;
            SDC_DAT : inout std_logic_vector (3 downto 0);
            
            -- Internal register interfaces
            reg_argument : in std_logic_vector (31 downto 0);
            reg_command : in std_logic_vector (31 downto 0);
            reg_response0 : out std_logic_vector (31 downto 0);
            reg_response1 : out std_logic_vector (31 downto 0);
            reg_response2 : out std_logic_vector (31 downto 0);
            reg_response3 : out std_logic_vector (31 downto 0);
            reg_control : in std_logic_vector (31 downto 0);
            reg_timeout : in std_logic_vector (31 downto 0);
            reg_event : out std_logic_vector (31 downto 0);
            reg_event_enable : in std_logic_vector (31 downto 0);
            
            -- Register write enable signals
            reg_response0_w : out std_logic;
            reg_response1_w : out std_logic;
            reg_response2_w : out std_logic;
            reg_response3_w : out std_logic;
            reg_event_w     : out std_logic;
            
            -- Other internal control signals
            interrupt : out std_logic;
            transaction_start : in std_logic;
            sdc_busy : out std_logic
        );
    end component;

    signal clk100 : std_logic := '0';
    signal sim_en : std_logic := '1';
    
    signal Enable : std_logic := '0';

    signal SDC_CLK : std_logic;
    signal SDC_CMD : std_logic;
    signal SDC_DAT : std_logic_vector (3 downto 0);
    signal reg_argument : std_logic_vector (31 downto 0);
    signal reg_command : std_logic_vector (31 downto 0);
    signal reg_response0 : std_logic_vector (31 downto 0);
    signal reg_response1 : std_logic_vector (31 downto 0);
    signal reg_response2 : std_logic_vector (31 downto 0);
    signal reg_response3 : std_logic_vector (31 downto 0);
    signal reg_control : std_logic_vector (31 downto 0);
    signal reg_timeout : std_logic_vector (31 downto 0);
    signal reg_event : std_logic_vector (31 downto 0);
    signal reg_event_enable : std_logic_vector (31 downto 0);
    signal reg_response0_w : std_logic;
    signal reg_response1_w : std_logic;
    signal reg_response2_w : std_logic;
    signal reg_response3_w : std_logic;
    signal reg_event_w : std_logic;
    signal interrupt : std_logic;
    signal transaction_start : std_logic;
    signal sdc_busy: std_logic;
    
    
    signal ser_data : std_logic_vector(0 to 47);
    
begin


    dut : sdc_top 
        port map (
            -- System signals
            Clk100 => clk100,
            Enable => Enable,
        
            -- SD Card external interface
            SDC_CLK => SDC_CLK,
            SDC_CMD => SDC_CMD,
            SDC_DAT => SDC_DAT,
            
            -- Internal register interfaces
            reg_argument => reg_argument,
            reg_command => reg_command,
            reg_response0 => reg_response0,
            reg_response1 => reg_response1,
            reg_response2 => reg_response2,
            reg_response3 => reg_response3,
            reg_control => reg_control,
            reg_timeout => reg_timeout,
            reg_event => reg_event,
            reg_event_enable => reg_event_enable,
            
            -- Register write enable signals
            reg_response0_w => reg_response0_w,
            reg_response1_w => reg_response1_w,
            reg_response2_w => reg_response2_w,
            reg_response3_w => reg_response3_w,
            reg_event_w => reg_event_w,
            
            -- Other internal control signals
            interrupt => interrupt,
            transaction_start => transaction_start,
            sdc_busy => sdc_busy
        );


       
    clockgen : process (clk100, sim_en)
    begin
        if sim_en = '1' then
            clk100 <= not clk100 after PERIOD/2;
        end if;
     end process;


    stim : process
        variable data : unsigned (7 downto 0);
    begin
        sim_en <= '1';
        enable <= '0';
        
        SDC_CMD <= 'Z';
 
        wait for 10*PERIOD;

        Enable <= '1';
        wait for 10*period;


        reg_argument <= X"56789ABC";
        reg_command <= X"00000003";
        reg_control <= X"00000001";
        
        transaction_start <= '1';
        wait until sdc_busy = '1';
        transaction_start <= '0';        
        
        for i in 0 to 50 loop
            wait until rising_edge(SDC_CLK);
        end loop;
        
        ser_data <= x"31d2c3b4a532";

        wait until falling_edge(SDC_CLK);        
   
        for i in 0 to 47 loop
            SDC_CMD <= ser_data(i);
            wait until falling_edge(SDC_CLK);
        end loop;        
        
        wait until falling_edge(SDC_CLK);
        SDC_CMD <= 'Z';

        
        wait until sdc_busy = '0';
        
        
        wait for 10*period;
        Enable <= '0';
        sim_en <= '0';
    
        wait;
    
    end process;


end tb;
