----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 05/06/2014 12:28:59 AM
-- Design Name: axi_sdc
-- Module Name: sdc_cmd_if - rtl
-- Project Name: axi_sdc
-- Target Devices: Artix7
-- Tool Versions: 
-- Description: 
--  Implements the physical interface to the CMD line. The internal interface is 
--  byte oriented, and both read and write data is buffered in FIFOs.
--  This module does not check or generate CRC.
--
--  Write transactions are always 48 bits long (6 bytes) including CRC7 at the end.
--   All 6 bytes must be loaded into the TX_FIFO on 6 consecutive clock cycles.
--   When at least one byte is loaded. the transaction may be started.
--   pull transmit <= '1'
--   pull start <= '1'
--   The SDC clock must be running. The data is shifted out on the falling edge.
--   The busy line will og high when the transaction starts.
--   The clock must toggle, and transmit must be held during the entire transaction.
--   When the busy line goes low, the transaction is ended and start must immediately
--   be pulled low.
--
--  Read transactions can be 48 bits or 136 bits long. This is selected with the
--   length signal.
--      length = 0 :  48 bits
--      length = 1 :  136 bits
--   To start a read transaction
--   pull transmit <= '0'
--   pull length to desired length
--   pull start <= '1'
--   The SDC clock must be running. The data is sampled on the rising edge.
--   The busy line will go high when the transaction starts.
--   The transmit and length signals must be held during the entire transaction.
--   When the busy line goes low, the transaction has ended and start must immediately
--   be pulled low.
--   The data can then be fetched from the RX_FIFO. This may also be done during the
--   transaction by monitoring the rx_emtpy signal.
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

entity sdc_cmd_if is
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
end sdc_cmd_if;

architecture rtl of sdc_cmd_if is
    COMPONENT cmd_fifo
      PORT (
        clk : IN STD_LOGIC;
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
    
    signal rx_din : std_logic_vector(7 downto 0);
    signal tx_dout : std_logic_vector(7 downto 0);
    signal rx_wr_en : std_logic;
    signal tx_rd_en : std_logic;
    
    signal tx_full_i : std_logic;
    signal tx_empty_i : std_logic;
    signal rx_full_i : std_logic;
    signal rx_empty_i : std_logic;
        
    signal shift_data : std_logic_vector(7 downto 0) := (others => '1');
    signal load_shift_data : std_logic_vector(7 downto 0) := (others => '1');
    signal load_shift : std_logic;
    signal shift_serdata : std_logic;
    signal rx_data_rdy : std_logic;
    
    signal bit_count : unsigned(7 downto 0) := (others => '0');
    signal count_clr : std_logic;
    
    signal clk_enable : std_logic;
    signal count_enable : std_logic;
    signal shift_enable : std_logic;
    
    
    type cmdif_state_t is (
        IDLE,
        WR_START,
        WR_LOAD_DATA,
        WR_SHIFT_DATA,
        WR_END,
        RD_START,
        RD_SHIFT_DATA,
        RD_DATA_RDY,
        RD_END
    );
    
    signal cmdif_state : cmdif_state_t := IDLE;
    signal cmdif_state_next : cmdif_state_t;
    
    
begin

    clk_enable <= sdc_clk_fedge when transmit='1' else sdc_clk_redge;

    rx_fifo : cmd_fifo
        PORT MAP (
            clk => clk100,
            din => rx_din,
            wr_en => rx_wr_en,
            rd_en => rx_rd_en,
            dout => rx_dout,
            full => rx_full_i,
            empty => rx_empty_i
        );
      
    tx_fifo : cmd_fifo
        PORT MAP (
            clk => clk100,
            din => tx_din,
            wr_en => tx_wr_en,
            rd_en => tx_rd_en,
            dout => tx_dout,
            full => tx_full_i,
            empty => tx_empty_i
        );
        
    tx_full <= tx_full_i;
    tx_empty <= tx_empty_i;    
    rx_full <= rx_full_i;
    rx_empty <= rx_empty_i;    
    
    rx_din <= shift_data;
    load_shift_data <= tx_dout;
    tx_rd_en <= load_shift and clk_enable;
    rx_wr_en <= rx_data_rdy and clk_enable;

    shift_8 : process (clk100)
    begin
        if rising_edge(clk100) then
            if shift_enable='1' and clk_enable='1' then
                if load_shift='1' then
                    shift_data <= load_shift_data;
                else
                    shift_data(7 downto 0) <= shift_data(6 downto 0) & shift_serdata;
                end if;
            end if;
        end if;
    end process;


    bit_counter : process (clk100)
    begin
        if rising_edge(clk100) then
            if count_clr='1' then
                bit_count <= (others => '0');
            elsif count_enable='1' and clk_enable='1' then
                bit_count <= bit_count + 1;
            end if;
        end if;
    end process;


    shift_state : process (clk100)
    begin
        if rising_edge(clk100) then
            if enable='1' and enable='1' then
                cmdif_state <= cmdif_state_next;
            end if;
        end if;
    end process;
    
    
    shift_state_logic : process (
                            cmdif_state, transmit, start, tx_empty_i,
                            bit_count, clk_enable, shift_data, sdc_cmd_io, length)
    begin
        case cmdif_state is
            when IDLE =>
                load_shift <= '0';
                count_enable <= '0';
                count_clr <= '1';
                shift_enable <= '0';
                busy <= '0';
                shift_serdata <='1';
                sdc_cmd_io <= 'Z';
                rx_data_rdy <= '0';
            
                if transmit='1' and start='1' and tx_empty_i='0' then
                    cmdif_state_next <= WR_START;
                elsif transmit='0' and start='1' then
                    cmdif_state_next <= RD_START;
                else
                    cmdif_state_next <= IDLE;
                end if;

            when WR_START =>
                load_shift <= '1';
                count_enable <= '0';
                count_clr <= '0';
                shift_enable <= '1';
                busy <= '1';
                shift_serdata <='1';
                sdc_cmd_io <= shift_data(7);
                rx_data_rdy <= '0';
                
                if clk_enable='1' then
                    cmdif_state_next <= WR_SHIFT_DATA;
                else
                    cmdif_state_next <= WR_START;
                end if;
                            
            when WR_LOAD_DATA =>
                load_shift <= '1';
                count_enable <= '1';
                count_clr <= '0';
                shift_enable <= '1';
                busy <= '1';
                shift_serdata <='1';
                sdc_cmd_io <= shift_data(7);
                rx_data_rdy <= '0';
                
                if clk_enable='1' then
                    cmdif_state_next <= WR_SHIFT_DATA;
                else
                    cmdif_state_next <= WR_LOAD_DATA;                    
                end if;
                
            when WR_SHIFT_DATA =>
                load_shift <= '0';
                count_enable <= '1';
                count_clr <= '0';
                shift_enable <= '1';
                busy <= '1';
                shift_serdata <='1';
                sdc_cmd_io <= shift_data(7);
                rx_data_rdy <= '0';
                
                if clk_enable='1' then
                    if bit_count(2 downto 0)="110" then
                        if bit_count(5 downto 3)="101" then
                            cmdif_state_next <= WR_END;
                        else
                            cmdif_state_next <= WR_LOAD_DATA;
                        end if;
                    else
                        cmdif_state_next <= WR_SHIFT_DATA;
                    end if;
                else
                    cmdif_state_next <= WR_SHIFT_DATA;                     
                end if;     
            
            when WR_END =>
                load_shift <= '0';
                count_enable <= '1';
                count_clr <= '1';
                shift_enable <= '1';
                busy <= '1';
                shift_serdata <='1';
                sdc_cmd_io <= shift_data(7);
                rx_data_rdy <= '0';  
                
                if clk_enable='1' then
                    cmdif_state_next <= IDLE;
                else
                    cmdif_state_next <= WR_END;                    
                end if;                

            when RD_START =>
                load_shift <= '0';
                count_enable <= '0';
                count_clr <= '0';
                shift_enable <= '1';
                busy <= '1';
                shift_serdata <= sdc_cmd_io;
                sdc_cmd_io <= 'Z';
                rx_data_rdy <= '0';
                
                if sdc_cmd_io='0' and clk_enable='1' then
                    cmdif_state_next <= RD_SHIFT_DATA;
                else
                    cmdif_state_next <= RD_START;
                end if;

            when RD_SHIFT_DATA =>
                load_shift <= '0';
                count_enable <= '1';
                count_clr <= '0';
                shift_enable <= '1';
                busy <= '1';
                shift_serdata <= sdc_cmd_io;
                sdc_cmd_io <= 'Z';
                rx_data_rdy <= '0';
                
                if clk_enable='1' then
                    if bit_count(2 downto 0)="110" then
                        cmdif_state_next <= RD_DATA_RDY;
                    else
                        cmdif_state_next <= RD_SHIFT_DATA;
                    end if;
                else
                    cmdif_state_next <= RD_SHIFT_DATA;                       
                end if;                     

            when RD_DATA_RDY =>
                load_shift <= '0';
                count_enable <= '1';
                count_clr <= '0';
                shift_enable <= '1';
                busy <= '1';
                shift_serdata <= sdc_cmd_io;
                sdc_cmd_io <= 'Z';
                rx_data_rdy <= '1';
                
                if clk_enable='1' then                
                    if (length='0' and bit_count(5 downto 3)="101") or (length='1' and bit_count(7 downto 3)="10000") then
                        cmdif_state_next <= RD_END;
                    else
                        cmdif_state_next <= RD_SHIFT_DATA;
                    end if;
                else
                    cmdif_state_next <= RD_DATA_RDY;                     
                end if;

            when RD_END =>
                load_shift <= '0';
                count_enable <= '1';
                count_clr <= '1';
                shift_enable <= '0';
                busy <= '1';
                shift_serdata <= '1';
                sdc_cmd_io <= 'Z';
                rx_data_rdy <= '0';  
                
                if clk_enable='1' then
                    cmdif_state_next <= IDLE;
                else
                    cmdif_state_next <= RD_END;                      
                end if;                                                          
                                      
        end case;
    end process;


end rtl;
