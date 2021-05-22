
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library WORK;
use WORK.TYPES.ALL;

entity Modulator_B is
    port (
        -- Inputs
        Clk         :   in  std_logic;                              -- System clock 
        Clock_En    :   in  std_logic;                              -- 16Hz Clock enable signal
        Symbol_RX   :   in  std_logic_vector(1 downto 0);           -- Input symbol to be modulated
        Reset       :   in  std_logic;                              -- Global reset button
        
        -- Outputs
        I_TX        :   out std_logic_vector(7 downto 0) := x"7F";  -- Channel I transmission
        Q_TX        :   out std_logic_vector(7 downto 0) := x"7F"   -- Channel Q transmission
    );
end Modulator_B;

architecture Behavioral of Modulator_B is

    -- Waveforms represented as an array of 8 natural values 
    signal Waveform_Zero, Waveform_One, Waveform_Flat  : t_Waveform;
    
    -- The Index pointer that tracks where in the waveform the modulator is 
    -- keep track of which waveform sample is being output
    signal Index    :   natural range 0 to 7 := 7;

begin

    -- Modulation Scheme B: Symbol 0 bits
    Waveform_Zero <= (x"80", X"A0", x"C0", x"A0", x"80", x"60", x"40", x"60");
    -- Modulation Scheme B: Symbol 1 bits
    Waveform_One  <= (x"80", x"60", x"40", x"60", x"80", x"A0", x"C0", x"A0");
    -- Modulation Scheme B: Flat line 
    Waveform_Flat <= (others => x"80");

    Wave_Generator: process(Clk)
    begin
        if(rising_edge(Clk)) then
            if (Clock_En = '1') then
                case Symbol_RX is
                when "00" =>
                    I_TX <= Waveform_Zero(Index);  
                    Q_TX <= Waveform_Flat(Index);
                when "10" =>
                    I_TX <= Waveform_Flat(Index);
                    Q_TX <= Waveform_Zero(Index);
                when "11" =>
                    I_TX <= Waveform_One(Index);
                    Q_TX <= Waveform_Flat(Index);
                when "01" =>
                    I_TX <= Waveform_Flat(Index);
                    Q_TX <= Waveform_One(Index);
                when others =>
                    I_TX <= (others => 'Z');
                    Q_TX <= (others => 'Z');
                end case; -- End case check for input symbol
            end if; -- End Reset / Clock enable check
        end if; -- End rising edge check
    end process;

    Pointer_Control: process(Clk)
    begin
        if (rising_edge(Clk)) then
            if(Reset = '1') then        -- Check for reset button
                Index <= 7;             -- Reset to the start of the waveform
            elsif(Clock_En = '1') then  -- Trigger on 16Hz clock enable
                if (Index = 0) then     -- If all the data points have been output
                    Index <= 7;         -- Reset pointer
                else                    -- Else if there's more data to be output in the waveform
                    Index <= Index - 1; -- Increment waveform sample index to point to next sample
                end if; -- Check for end of packet
            end if; -- Reset / clock enable check
        end if; -- Clock rising edge check
    end process;
    
end Behavioral;