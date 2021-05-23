LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
 
ENTITY TB_Logical_Unit IS
END TB_Logical_Unit;
 
ARCHITECTURE Behavioral OF TB_Logical_Unit IS 
 
    -- Component Declaration for the Unit Under Test (UUT) 
    component Logical_Unit
        port (
            -- Inputs
            Clk     : in std_logic;
            i_A     : in std_logic;
            i_B     : in std_logic;
            i_Enable: in std_logic_vector(2 downto 0); -- Enable(2) = AB;   Enable(1) = A+B;    Enable(0) = NOT-B. Signals driven by the decoder unit
            o_Result: out std_logic_vector(2 downto 0)  -- This bus contains the AB / A+B / NOT-B logic status using wires (2:0)
        );
    end component;

    constant Clk_Period : time := 10 ns;            -- For 100MHz clock
    signal t_Clk        : std_logic := '1';         -- TB clock driver
    signal t_A          : std_logic := '0';                    
    signal t_B          : std_logic := '0';                    
    signal t_Result     : std_logic_vector(2 downto 0);
    signal t_Enable     : std_logic_vector(2 downto 0); 

begin

    UUT: Logical_Unit
    port map(
        Clk         => t_Clk,
        i_A         => t_A,
        i_B         => t_B,
        i_Enable    => t_Enable,
        o_Result    => t_Result
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
        for a in std_logic range '0' to '1' loop
            for b in std_logic range '0' to '1' loop
                for en in 0 to 7 loop        
                    t_A      <= a;
                    t_B      <= b;
                    t_Enable <= std_logic_vector(to_unsigned(en,3));
                    wait for Clk_Period;
                end loop;
            end loop;
        end loop;
    end process;
end;