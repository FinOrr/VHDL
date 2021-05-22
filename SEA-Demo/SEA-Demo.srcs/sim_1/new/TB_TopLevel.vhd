library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_TopLevel is
--  Port ( );
end TB_TopLevel;

architecture Behavioral of TB_TopLevel is

    component TopLevel is
        port (
            Clk : in std_logic;
            Key : in std_logic_vector(1 downto 0) := "00";
            LED : out std_logic_vector(1 downto 0) := "00"
        );
    end component;
    
    constant CLK_PERIOD : time := 10 ns;
    constant SEC        : time := 100_000_000 ns;
    signal Clk : std_logic := '0';
    signal Key : std_logic_vector(1 downto 0) := "00";
    signal LED : std_logic_vector(1 downto 0) := "00";
    
begin

    UUT: TopLevel
    port map (
        Clk => Clk,
        Key => Key,
        LED => LED
    );
    
    Clocking: process
    begin
        Clk <= NOT Clk;
        wait for Clk_Period / 2;
    end process;

    Input_Stimulus: process
    begin
        
    end process;
    
    
    end Behavioral;
