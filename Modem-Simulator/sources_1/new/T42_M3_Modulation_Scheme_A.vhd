----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2019 12:42:34
-- Design Name: 
-- Module Name: T42_M3_Modulation_Scheme_A - Behavioral
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


entity Modulation_Scheme_A is
Port (
    -- Inputs
    i_Clk           :   in  STD_LOGIC;
    i_CE_2Hz        :   in  STD_LOGIC;
    i_CE_16Hz       :   in  STD_LOGIC;
    i_Reset         :   in  STD_LOGIC;
    i_Symbol        :   in  STD_LOGIC_VECTOR (1 downto 0);
    i_Error_Select  :   in  STD_LOGIC_VECTOR (1 downto 0);
                    
    -- Outputs      
    o_Data          :   out STD_LOGIC;
    o_Symbol        :   out STD_LOGIC
    );
end Modulation_Scheme_A;


architecture Behavioral of Modulation_Scheme_A is

    -- Connect module io to registers
    signal Clk, r_CE_2Hz, r_CE_16Hz, r_Reset, r_Data, r_Output_Symbol : STD_LOGIC := '0';
    signal r_Input_Symbol, r_Error_Select : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    
    -- Intermediate signals
    signal r_I_Modulated, r_Q_Modulated : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal r_I_CB, r_Q_CB               : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        
    component Modulator_A is 
    Port (         
        i_Clk           :   in STD_LOGIC;
        i_Reset         :   in STD_LOGIC;
        i_CE_16Hz       :   in STD_LOGIC;
        i_Input_Symbol  :   in STD_LOGIC_VECTOR (1 downto 0);
        o_I             :   out STD_LOGIC_VECTOR (7 downto 0);
        o_Q             :   out STD_LOGIC_VECTOR (7 downto 0)
    );
    end component;
    
    component T42_M3_Channel_Block_A is
    Port ( 
        i_Clk           :   in STD_LOGIC;
        i_Reset         :   in STD_LOGIC;
        i_Clock_Enable  :   in STD_LOGIC;
        i_Error_Select  :   in STD_LOGIC_VECTOR (1 downto 0);
        i_I             :   in STD_LOGIC_VECTOR (7 downto 0);
        i_Q             :   in STD_LOGIC_VECTOR (7 downto 0);
        o_I             :   out STD_LOGIC_VECTOR (7 downto 0);
        o_Q             :   out STD_LOGIC_VECTOR (7 downto 0)
    );
    end component; 
    
    component T42_M3_Demodulator_A is
    Port ( 
        i_Clk           :   in STD_LOGIC;
        i_Clock_Enable  :   in STD_LOGIC;
        i_Reset         :   in STD_LOGIC;
        i_I             :   in STD_LOGIC_VECTOR (7 downto 0);
        i_Q             :   in STD_LOGIC_VECTOR (7 downto 0);
        o_Data          :   out STD_LOGIC;
        o_Symbol        :   out STD_LOGIC
    );                   
    end component;
   
   
begin
    
    Clk             <= i_Clk;
    r_CE_2Hz        <= i_CE_2Hz;
    r_CE_16Hz       <= i_CE_16Hz;
    r_Reset         <= i_Reset;
    r_Input_Symbol  <= i_Symbol;
    r_Error_Select  <= i_Error_Select;
    o_Symbol        <= r_Output_Symbol;
    o_Data          <= r_Data;

     
    Modulator: Modulator_A 
    port map( 
    -- Inputs
        i_Clk           => Clk,
        i_Reset         => r_Reset,
        i_CE_16Hz       => r_CE_16Hz,
        i_Input_Symbol  => r_Input_Symbol,
        
    -- Outputs     
        o_I             => r_I_Modulated,
        o_Q             => r_Q_Modulated 
    );     
                
    Channel_Block: T42_M3_Channel_Block_A
    port map(
    -- Inputs 
        i_Clk           =>   Clk,
        i_Reset         =>   r_Reset,
        i_Clock_Enable  =>   r_CE_2Hz,
        i_Error_Select  =>   r_Error_Select,
        i_I             =>   r_I_Modulated,
        i_Q             =>   r_Q_Modulated,
        
    -- Outputs
        o_I             =>   r_I_CB,
        o_Q             =>   r_Q_CB
    );
 
    Demodulator: T42_M3_Demodulator_A
    port map(
    -- Inputs
        i_Clk           =>   Clk,
        i_Clock_Enable  =>   r_CE_16Hz,
        i_Reset         =>   r_Reset,
        i_I             =>   r_I_CB,
        i_Q             =>   r_Q_CB,
      
    -- Outputs
        o_Data          =>   r_Data,
        o_Symbol        =>   r_Output_Symbol
    );
    
end Behavioral;
