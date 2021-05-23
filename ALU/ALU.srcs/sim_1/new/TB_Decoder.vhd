LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
 
ENTITY TB_Decoder IS
END TB_Decoder;
 
ARCHITECTURE Behavioral OF TB_Decoder IS 
 
    -- Component Declaration for the Unit Under Test (UUT) 
    component Decoder
        port (
            -- Inputs
            Clk         : in std_logic;
            i_Control   : in std_logic_vector(1 downto 0);
            -- Outputs
            o_Enable    : out std_logic_vector(3 downto 0)
        );
    end component;

    constant Clk_Period : time := 10 ns;                -- For 100MHz clock
    signal t_Clk        : std_logic := '1';                    -- TB clock driver
    signal t_Control    : std_logic_vector(1 downto 0); -- TB control signal
    signal t_Enable     : std_logic_vector(3 downto 0); -- TB enable output

begin

    UUT: Decoder
    port map(
        Clk         => t_Clk,
        i_Control   => t_Control,
        o_Enable    => t_Enable
    );

    Clocking: process
    begin
        t_Clk <= '1';
        wait for Clk_Period / 2;
        t_Clk <= '0';
        wait for Clk_Period / 2;
    end process;
    
    Input_Driver: process
    begin
        t_Control <= "00";
        wait for Clk_Period * 4;
        t_Control <= "01";
        wait for Clk_Period * 4;
        t_Control <= "10";
        wait for Clk_Period * 4;
        t_Control <= "11";
        wait for Clk_Period * 4;
    end process;
end;