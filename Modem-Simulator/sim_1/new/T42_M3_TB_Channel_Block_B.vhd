library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity T42_M3_TB_Channel_Block is
--  Port ( );
end T42_M3_TB_Channel_Block;

architecture Behavioral of T42_M3_TB_Channel_Block is

component Channel_B is
    generic (
        LFSR_Seed    :  std_logic_vector(32 downto 1) := x"3CA52DF7"    -- Generic seed to intialise the PRNG
    );
    port (
        -- Inputs
        Clk          :  in  std_logic;                                  -- System clock
        Reset        :  in  std_logic;                                  -- Global reset signal
        Clock_En     :  in  std_logic;                                  -- Clock enable signal
        Error_Select :  in  std_logic_vector(1 downto 0);               -- 2 bit input to control the error to be introduced
        I_RX         :  in  std_logic_vector(7 downto 0);               -- Input of I channel
        Q_RX         :  in  std_logic_vector(7 downto 0);               -- Input of the Q channel
        
        -- Outputs
        I_TX         :  out std_logic_vector(7 downto 0);               -- I channel output, with random error
        Q_TX         :  out std_logic_vector(7 downto 0)                -- Q channel output, with random error
    );
end component;

signal Clk          : std_logic := '0';
signal Reset        : std_logic := '0';
signal Clock_En     : std_logic := '0';
signal Error_Select : std_logic_vector(1 downto 0) := "00";
signal I_RX, Q_RX   : std_logic_vector(7 downto 0) := x"80";
signal I_TX, Q_TX   : std_logic_vector(7 downto 0) := x"00";

begin

    Clocking: process
    begin
        Clk <= not Clk;
        wait for 5 ns;
    end process;
    
    Clock_Enable_Driver: process
    begin
        Clock_En <= not Clock_En;
        wait for 10 ns;
        Clock_En <= not Clock_En;
        wait for 40 ns;
    end process;
    
    Error_Select_Driver: process
    begin
        Error_Select <= "00";
        wait for 50 ns;
        Error_Select <= "01";
        wait for 50 ns;
        Error_Select <= "10";
        wait for 50 ns;
        Error_Select <= "11";
        wait for 50 ns;
    end process;
    
--    Input_Stimulus: process
--    begin
--        I_RX <= x"80";
--        Q_RX <= x"80";
--        wait;
----        for i in 63 to 159 loop
----            I_RX <= std_logic_vector(to_unsigned(i,8));
----            Q_RX <= std_logic_vector(to_unsigned(i,8));
----            wait for 50 ns;
----        end loop;
--    end process;
    
    uut: Channel_B
    generic map (
        LFSR_Seed => x"3CA52DF7"
    )
    port map (
        -- Inputs
        Clk          => Clk,  
        Reset        => Reset,
        Clock_En     => Clock_En,
        Error_Select => Error_Select,
        I_RX         => I_RX,
        Q_RX         => Q_RX,
        -- Outputs 
        I_TX         => I_TX,
        Q_TX         => Q_TX
    );
    
end Behavioral;