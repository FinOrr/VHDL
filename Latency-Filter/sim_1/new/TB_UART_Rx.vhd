library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TB_UART_Rx is
--  Port ( );
end TB_UART_Rx;

architecture Behavioral of TB_UART_Rx is

    component UART_Receiver is
        generic (
            Sys_Freq  : natural;
            Baud_Rate : natural
        );
        port (
            -- System clock
            Clk         : in std_logic;                         
            -- Serial input port
            i_RX        : in std_logic;                         
            -- Signal driven high when finished recieving data
            o_RX_Finish : out std_logic;                        
            -- Byte output
            o_RX_Byte   : out std_logic_vector(7 downto 0)      
        );
    end component;
    
    -- Signal declarations --
    signal Clk      : std_logic := '0';     -- System clock
    signal Rx       : std_logic := '1';     -- Serial input, pull low to start the transmission
    signal Rx_Finish: std_logic := '0';     -- Pulses high when byte received
    signal Rx_Byte  : std_logic_vector(7 downto 0) := (others => '0');  -- Output of the serdes
    
    constant Period : time := 26041 ns;     -- Time period between bits (1/38400 second)
    signal Test_Byte_0 : std_logic_vector(7 downto 0) := "00111010";
    signal Test_Byte_1 : std_logic_vector(7 downto 0) := "01101101";
    signal Test_Byte_2 : std_logic_vector(7 downto 0) := "11011000";

begin

    UUT: UART_Receiver
    generic map (
        Sys_Freq    => 100_000_000,
        Baud_Rate   => 38_400
    )
    port map (
        Clk         => Clk,
        i_Rx        => Rx,
        o_Rx_Finish => Rx_Finish,
        o_RX_Byte   => Rx_Byte
    );
    
    Clocking: process
    begin
        Clk <= NOT Clk;
        wait for 5 ns;
    end process;
    
    Stimulus: process
    begin
        Rx <= '1';
        wait for Period;
        -- Test byte 1: 0011 1010
        Rx <= '0';                  -- Start bit
        wait for Period;
        for i in 0 to 7 loop        -- RS485 is little-endian, so send the bits from LSB to MSB
            Rx <= Test_Byte_0(i);
            wait for Period;
        end loop;
        Rx <= '1';
        wait for Period;
        
        -- Test byte 2: 0110 1101
        Rx <= '0';                -- Start bit
        wait for Period;
        for i in 0 to 7 loop
            Rx <= Test_Byte_1(i);
            wait for Period;
        end loop;
        Rx <= '1';
        wait for Period;
        
        -- Test byte 3: 1101 1000
        Rx <= '0';                -- Start bit
        wait for Period;
        for i in 0 to 7 loop
            Rx <= Test_Byte_2(i);
            wait for Period;
        end loop;
        Rx <= '1';
        wait for Period;
        
        wait;
    end process;

end Behavioral;
