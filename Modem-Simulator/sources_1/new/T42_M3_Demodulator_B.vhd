library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.TYPES.ALL;

entity Demodulator_B is
    port (
        -- Inputs
        Clk      :   in  std_logic;
        Clock_En :   in  std_logic;
        Reset    :   in  std_logic;
        I_RX     :   in  std_logic_vector(7 downto 0);
        Q_RX     :   in  std_logic_vector(7 downto 0);
        
        -- Outputs
        Data     :   out std_logic;
        Symbol   :   out std_logic
    );
end Demodulator_B;

architecture Behavioral of Demodulator_B is
    
    -- Reference waveform is a triangle wave
    signal r_Ref_Waveform : t_Waveform := (x"80", x"A0", x"C0", x"A0", x"80", x"60", x"40", x"60");
    
    -- Index pointer used to judge where in the waveform the system is (waveform is an 8 byte packet)
    signal Index : natural range 0 to 7 := 7;
    
    -- Reference point that simulates input of 0 * REF wave, used to judge if signal is positive or negative
    constant Steady_State : unsigned(19 downto 0) := x"13E00";
    
    -- Accumulate registers for channels I and Q
    signal I_MAC : unsigned(31 downto 0) := (others => '0');
    signal Q_MAC : unsigned(31 downto 0) := (others => '0');
    
    -- Output buffers
    signal r_Data_TX    : std_logic_vector(1 downto 0) := "00";
    signal r_Symbol_TX  : std_logic_vector(1 downto 0) := "00";
    
begin
    
    ----------------------------------------------------------------------
    ------              Multiply Accumulate Process                 ------
    ------   Multiplies input channels with a reference waveform    ------
    ------   before summing and storing the result in I_MAC / Q_MAC ------
    ----------------------------------------------------------------------
    MAC: process(Clk)
    begin   
        if (rising_edge(Clk)) then
            if (Clock_En = '1') then
                I_MAC <= I_MAC + (unsigned(r_Ref_Waveform(Index)) * unsigned(I_RX));
                Q_MAC <= Q_MAC + (unsigned(r_Ref_Waveform(Index)) * unsigned(Q_RX));
            end if; -- Clock enable
        end if; -- rising clock edge check
    end process;


    ------------------------------------------------------------------------
    ------                  Waveform Decision Logic                   ------
    ------   Compares the MAC results for both channels for bit 1     ------
    ------   Compares MAC results with a steady state value for bit 0 ------
    ------------------------------------------------------------------------
    Waveform_Decision: process(Clk)
    begin
        if (rising_edge(Clk)) then
                if (Clock_En = '1') then
                if (Index = 3) then                 -- Check first nibble to compare first half of waveform
                    
                    -- Symbol MSB logic check --
                    if (I_MAC > Q_MAC) then         -- If I channel > Q channel over the first 4 points, then the first bit is 0
                        r_Symbol_TX(1) <= '0';
                    else
                        r_Symbol_TX(1) <= '1';      -- If I < Q for the first 4 data points, the first bit is a 1
                    end if; -- MAC comparisons
                    
                    -- Symbol LSB logic check --
                    if (Q_MAC < Steady_State) then  -- If Q*Ref is greater than 0, bit 0 is '1'
                        r_Symbol_TX(0) <= '1';
                    else
                        r_Symbol_TX(0) <= '0';      -- If Q*Ref is less than 0, bit 0 is '0'
                    end if; -- steady state check
                end if; -- index check
            end if; -- Clock enable
        end if; -- rising clock edge check
    end process;


    ----------------------------------------------------------------------
    ------              Index Pointer Controller                    ------
    ------      Increments Index to track waveform sampling         ------
    ----------------------------------------------------------------------
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
    
    
    ----------------------------------------------------------------------
    ------                  Parallel to Serial Converter            ------
    ------   Output needs to be transmitted as a serial data stream ------
    ----------------------------------------------------------------------
    Output_Control: process(Clk)
    begin
        if (rising_edge(Clk)) then
            -- Output  
            if (Clock_En = '1') then
                if (Index >= 4) then
                    Data    <= r_Symbol_TX(1);
                    Symbol  <= r_Symbol_TX(1);
                else
                    Data    <= r_Symbol_TX(0);
                    Symbol  <= r_Symbol_TX(0);
                end if; -- index check
            end if; -- clock enable
        end if; -- rising edge check
    end process;
    
end Behavioral;