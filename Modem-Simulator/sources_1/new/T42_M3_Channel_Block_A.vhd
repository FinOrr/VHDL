----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2019 14:11:10
-- Design Name: 
-- Module Name: T42_M3_Channel_Block_A - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity T42_M3_Channel_Block_A is
    Port ( 
    -- Inputs
            i_Clk           :   in STD_LOGIC;
            i_Reset         :   in STD_LOGIC;
            i_Clock_Enable  :   in STD_LOGIC;
            i_Error_Select  :   in STD_LOGIC_VECTOR (1 downto 0);
            i_I             :   in STD_LOGIC_VECTOR (7 downto 0);
            i_Q             :   in STD_LOGIC_VECTOR (7 downto 0);
     
    -- Outputs        
            o_I             :   out STD_LOGIC_VECTOR (7 downto 0) := x"80";
            o_Q             :   out STD_LOGIC_VECTOR (7 downto 0) := x"80"
     );
                
end T42_M3_Channel_Block_A;


architecture Behavioral of T42_M3_Channel_Block_A is
    
    -- LFSR SEED holds the intial value of the shift register when system powers on
    constant LFSR_SEED : STD_LOGIC_VECTOR(31 downto 0) := x"36CFEBA5";
        
	-- Sign flag is randomly generated and indicates if error should be added or subtracted from input wave: [0 : +] [1 : -]
	signal I_Sign : STD_LOGIC := '0';
	signal Q_Sign : STD_LOGIC := '0';
	
	-- Internal registers to add error to input values
	signal I_Reg, Q_Reg : STD_LOGIC_VECTOR(7 downto 0) := x"80";
	   
	-- Linear feedback shift register, SReg contains 30 pseudo random bits, with an initial random value
    signal SReg : STD_LOGIC_VECTOR (31 downto 0) := LFSR_SEED;

    -- A new bit, r_XNOR is shifted into the shift register each clock cycle- MUST be initialised with a value
    signal XNOR_Bit : STD_LOGIC := '0';
    
    -- Error value to be added or subtracted from the input wave
    signal I_Error_Val : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal Q_Error_Val : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    
    -- Waveform pointer indicates which point in the input wave we're adding error to
    signal Waveform_Pointer : natural range 7 downto 0 := 7;
    
begin
    
    -- Connect output registers to output ports
    o_I <= I_Reg;
    o_Q <= Q_Reg;
    
    -- Generate a new LFSR bit by XNOR'ing values in the shift register
    XNOR_Bit <= SReg(31) XNOR SReg(22) XNOR SReg(2) XNOR SReg(1);    
    
    -- Pseudo random number generator based on example from NANDLAND
    -- Shift register shifts new XNOR bit at system clock frequency
	Random_Gen: process(i_Clk) 
	begin
		if (rising_edge(i_Clk)) then
			if (i_Reset = '1') then
			    -- Reload the seed to shift register when system is reset
                SReg <= LFSR_SEED;
			else
			    -- Shift new bit into shift register's LSB (was previously 31 downto 1 so didn't shift!)
                SReg <= SReg(30 downto 0) & XNOR_Bit;
			end if;	
		end if;
    end process;
    
    -- Generates random error values for the I and Q channels every system clock cycle depending on Error Select switch input
    -- Sets the MSBs to 0 to limit the range of possible values
    Error_Gen: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
            case (i_Error_Select) is
                -- Input = 01:  +/- 16 error
                when "01" =>
                    I_Error_Val <= '0' & '0' & SReg(17 downto 14);
                    Q_Error_Val <= '0' & '0' & SReg(17 downto 14);
                
                -- Input = 10:  +/- 32 error
                when "10" =>
                    I_Error_Val <= '0' & SReg(18 downto 14);
                    Q_Error_Val <= '0' & SReg(18 downto 14);
                
                -- Input = 11:  
                -- +/- 64 error
                when "11" =>
                    I_Error_Val <= SReg(19 downto 14);
                    Q_Error_Val <= SReg(19 downto 14);
                
                -- Input = 00 or error: 0 error
                when others =>
                    I_Error_Val <= (others => '0');
                    Q_Error_Val <= (others => '0');
            end case;
        end if;
    end process;
  
    Add_Errors: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
            -- Sign bit is assigned a random value from the LFSR
            I_Sign <= SReg(27);
            Q_Sign <= SReg(12);
            -- Clock enable driven at 16Hz
            if (i_Clock_Enable = '1') then
                
                -- Check to add or subtract error from I channel
                if (I_Sign = '0') then   
                    -- No sign means add the error to waveform point
                    I_Reg <= STD_LOGIC_VECTOR(UNSIGNED(i_I) + UNSIGNED(I_Error_Val));
                else
                    -- Sign flag is true, so subtract the error value from the I channel
                    I_Reg <= STD_LOGIC_VECTOR(UNSIGNED(i_I) - UNSIGNED(I_Error_Val));
                end if;
                
                -- Check for Q channel sign bit
                if (Q_Sign = '0') then
                    -- Sign flag false, so add error value to Q input
                    Q_Reg <= STD_LOGIC_VECTOR(UNSIGNED(i_Q) + UNSIGNED(Q_Error_Val));
                else
                    -- Sign flag true, so subtract random error from the Q input
                    Q_Reg <= STD_LOGIC_VECTOR(UNSIGNED(i_Q) - UNSIGNED(Q_Error_Val));
                end if;
            end if;
        end if;
    end process;
    
    -- Loops through the values 7 down to 0 with each clock enable, corresponding to position in the waveform
    Pointer_Ctrl: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
            if (i_Clock_Enable = '1') then
                -- If we're at the end of a bit's waveform, reset waveform pointer to start
                if (Waveform_Pointer = 0) then
                    Waveform_Pointer <= 7;
                else
                    Waveform_Pointer <= Waveform_Pointer - 1;
                end if;
            end if;
        end if;
    end process;

end Behavioral;