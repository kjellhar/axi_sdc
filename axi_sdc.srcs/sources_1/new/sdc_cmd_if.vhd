----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2014 12:28:59 AM
-- Design Name: 
-- Module Name: sdc_cmd_if - rtl
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

entity sdc_cmd_if is
    Port ( clk100 : in STD_LOGIC;
           sdc_clk_en : in STD_LOGIC;
           Enable : in STD_LOGIC;
           tx_din : in STD_LOGIC_VECTOR (7 downto 0);
           tx_wr_en : in STD_LOGIC;
           tx_full : out STD_LOGIC;
           tx_empty : out STD_LOGIC;
           rx_dout : out STD_LOGIC_VECTOR (7 downto 0);
           rx_rd_en : in STD_LOGIC;
           rx_full : out STD_LOGIC;
           rx_empty : out STD_LOGIC;
           rw : in STD_LOGIC;
           length : in std_logic;
           start : in STD_LOGIC;
           busy : out STD_LOGIC);
end sdc_cmd_if;

architecture rtl of sdc_cmd_if is
    COMPONENT cmd_fifo
      PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC
      );
    END COMPONENT;
    ATTRIBUTE SYN_BLACK_BOX : BOOLEAN;
    ATTRIBUTE SYN_BLACK_BOX OF cmd_fifo : COMPONENT IS TRUE;
    ATTRIBUTE BLACK_BOX_PAD_PIN : STRING;
    ATTRIBUTE BLACK_BOX_PAD_PIN OF cmd_fifo : COMPONENT IS "clk,srst,din[7:0],wr_en,rd_en,dout[7:0],full,empty";
    
    signal rx_din : std_logic_vector(7 dwonto 0);
    signal tx_dout : std_logic_vector(7 dwonto 0);
    signal rx_wr_en : std_logic;
    signal tx_rd_en : std_logic;
    
    signal shift_data : std_logic_vector(7 downto 0) := (others => '1');
    signal shift_counter : integer range 0 to 135 := 0;
    
begin

    rx_fifo : cmd_fifo
      PORT MAP (
        clk => clk100,
        din => rx_din,
        wr_en => rx_wr_en,
        rd_en => rx_rd_en,
        dout => rx_dout,
        full => rx_full,
        empty => rx_empty
      );
      
    tx_fifo : cmd_fifo
            PORT MAP (
              clk => clk100,
              din => tx_din,
              wr_en => tx_wr_en,
              rd_en => tx_rd_en,
              dout => tx_dout,
              full => tx_full,
              empty => tx_empty
            );      

    shift_8 : process (clk100)
    begin
        if rising_edge(clk100) then
            if sdc_clk_en='1' then
                if rw='0' then
                    shift_data(7 downto 0) <= shift_data(6 downto 0) & sdc_cmd_in;
                else
                    shift_data(7 downto 0) <= shift_data(6 downto 0) & '1';
                end if;
            end if;
        end if;
    end process;



end rtl;
