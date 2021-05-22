
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity T42_M3_TB_Modulator_B is
--  Port ( );
end T42_M3_TB_Modulator_B;

architecture Behavioral of T42_M3_TB_Modulator_B is

component Modulator_B is
port (
    -- Inputs
    Clk         :   in  std_logic;
    Clock_En    :   in  std_logic;
    Symbol_RX   :   in  std_logic_vector(1 downto 0);
    Reset       :   in  std_logic;
    
    -- Outputs
    I_TX        :   out std_logic_vector(7 downto 0);
    Q_TX        :   out std_logic_vector(7 downto 0)
);
end component;

constant Clk_Period : time := 10 ns;

signal Clk      : std_logic := '0';
signal Clock_En : std_logic := '0';
signal Symbol_RX: std_logic_vector(1 downto 0) := "00";
signal Reset    : std_logic := '0';
signal I_TX     : std_logic_vector(7 downto 0) := x"7F";
signal Q_TX     : std_logic_vector(7 downto 0) := x"7F";

begin

Modulator: Modulator_B
port map (
    Clk       => Clk,
    Clock_En  => Clock_En,
    Symbol_RX => Symbol_RX,
    Reset     => Reset,
    I_TX      => I_TX,
    Q_TX      => Q_TX
);

Clocking: process
begin
    Clk <= not Clk;
    wait for Clk_Period / 2;
end process;

Clock_Enable: process
begin
    Clock_En <= not Clock_En;
    wait for Clk_Period;
end process;

Symbol_Stimulus: process
begin
    Symbol_RX <= "00";
    wait for Clk_Period * 16;
    Symbol_RX <= "10";
    wait for Clk_Period * 16;
    Symbol_RX <= "11";
    wait for Clk_Period * 16;
    Symbol_RX <= "01";
    wait for Clk_Period * 16;
end process;

end Behavioral;