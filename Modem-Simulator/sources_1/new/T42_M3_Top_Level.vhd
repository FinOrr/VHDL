----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.02.2019 12:17:49
-- Design Name: 
-- Module Name: Top_Level - Behavioral
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

entity Top_Level is
    port (
        -- Inputs
        Clk                 : in  std_logic;
        i_Fast_Sw           : in  std_logic;
        i_Stop_Btn          : in  std_logic;
        i_Reset_Btn         : in  std_logic;
        i_Error_Select_Sw   : in  std_logic_vector(1 downto 0);
        i_Data_Select_Sw    : in  std_logic_vector(2 downto 0);
        i_Display_Select_Sw : in  std_logic_vector(2 downto 0);
        
        -- Outputs
        o_LED               : out std_logic_vector(3 downto 0);
        o_Segment_Cathodes  : out std_logic_vector(6 downto 0);
        o_Segment_Anodes    : out std_logic_vector(3 downto 0)
    );
end Top_Level;

architecture Behavioral of Top_Level is

    component Debounce is
        port (
            -- Inputs
            i_Clk     :   in  std_logic;
            i_Input   :   in  std_logic;
            -- Output
            o_Output  :   out std_logic
        );
    end component;
    
    component Button_Latch is
        port (
            -- Input
            i_Set   :   in  std_logic;      -- Input value to be toggled on/off like a switch
            -- Output
            o_Latch :   out std_logic       -- Output of the latch
        );
    end component;

    component Pulse_Generator is
        generic (
            Frequency : natural
        );
        port (
            -- Input
            i_Clk    : in  std_logic;
            -- Output
            o_Strobe : out std_logic
        );    
    end component;
    
    component Data_Generator is
        port (
            -- Inputs
            i_Clk          : in std_logic;        -- Global clock
            i_Stop         : in std_logic;        -- Start stop switch       
            i_Clock_Enable : in std_logic;        -- 1 Hz Clock enable signal
            i_Data_Select  : in std_logic_vector(2 downto 0);     -- 3 Bit data select input, corresponding to switches 
            i_Reset        : in std_logic;        -- Global reset
            -- Outputs
            o_Data         : out std_logic_vector(3 downto 0)     -- Data output to the Symbol Converter module
        );
    end component;
    
    component Symbol_Converter is
        port (
            -- Inputs
            i_Clk    : in std_logic;
            i_Stop   : in std_logic;
            i_Reset  : in std_logic;
            i_CE_2Hz : in std_logic;
            i_Data   : in std_logic_vector(3 downto 0);
            --Outputs
            o_Symbol : out std_logic_vector(1 downto 0)
        );
    end component;
    
    component Display_Driver is
        port (
            -- Inputs
            i_Clk       :   in  std_logic;                      -- Global system clock, 100MHz
            i_Stop      :   in  std_logic;                      -- Stop signal, mapped to BTN Centre
            i_Symbol    :   in  std_logic;                      -- 2 bit symbol to be displayed on 7 seg
            i_DS        :   in  std_logic_vector(2 downto 0);   -- Data select value generated from switches position
            i_Data      :   in  std_logic;                      -- 4 bit data select decimal value 
            i_CE_4Hz    :   in  std_logic;                      -- Clock enable, pulses at 4Hz
            i_CE_250Hz  :   in  std_logic;                      -- Clock enable, pulses at 250Hz
            -- Output
            o_Cathode_Value  : out std_logic_vector(3 downto 0); -- 4 Bit binary value to be sent to 7 seg decoder
            o_Anode_Control  : out std_logic_vector(3 downto 0)  -- Anode control bits illuminate the 7 seg
        );
    end component;
    
    component Scheme_B is
        port (    
            -- Inputs
            i_Clk           :   in  std_logic;
            i_CE_2Hz        :   in  std_logic;
            i_CE_16Hz       :   in  std_logic;
            i_Reset         :   in  std_logic;  
            i_Symbol_RX     :   in  std_logic_vector(1 downto 0);
            i_Error_Select  :   in  std_logic_vector(1 downto 0);
            
            -- Outputs
            o_Data            :   out std_logic;
            o_Symbol          :   out std_logic
        );
    end component;
    
    component Modulation_Scheme_A is
        port (
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
    end component;
    
    component Seven_Segment_Decoder is
        port (
            -- Inputs
            i_Cathode_Value     :   in  std_logic_vector(3 downto 0);       -- binary value of number to be displayed on seven segment 
            -- Outputs
            o_Seg_Cathodes      :   out std_logic_vector(6 downto 0)        -- bits corresponding to seven segment anodes (active low)
        );
    end component;
    
    --------------------------------------------------------
    -------------- Internal signal declarations ------------
    --------------------------------------------------------
    
    signal r_CE_1Hz      : std_logic := '0';     -- Clock enable 1Hz signal
    signal r_CE_2Hz      : std_logic := '0';     -- Clock enable 2Hz signal
    signal r_CE_4Hz      : std_logic := '0';     -- Clock enable 4Hz signal
    signal r_CE_16Hz     : std_logic := '0';     -- Clock enable 16Hz signal
    signal r_CE_250Hz    : std_logic := '0';     -- Clock Enable 250Hz signal
    
    signal r_Fast        : std_logic := '0';     -- Debounced FAST toggle switch
    signal r_Stop_Btn    : std_logic := '0';     -- Debounced START / STOP button
    signal r_Stop        : std_logic := '0';     -- Debounced START / STOP button, latched to act as a switch
    signal r_Reset       : std_logic := '0';     -- Debounced RESET button
    
    signal r_Error_Select   : std_logic_vector(1 downto 0) := "00";     -- Debounced error select switches
    signal r_Data_Select    : std_logic_vector(2 downto 0) := "000";    -- Debounced data select switches
    signal r_Display_Select : std_logic_vector(2 downto 0) := "000";    -- Debounced display select switches
    
    signal r_Data_Gen       : std_logic_vector(3 downto 0) := x"0";     -- 4 bit data value, from the data generator
    signal r_Cathode_Value  : std_logic_vector(3 downto 0) := x"0";     -- Binary value of the number to be displayed on seven seg
    
    signal r_Data_RX        : std_logic := '0';                         -- Data value, produced by the demodulator
    signal r_Data_Mod_A     : std_logic := '0';                         -- Data value, produced by the demodulator
    signal r_Data_Mod_B     : std_logic := '0';                         -- Data value, produced by the demodulator
    
    signal r_Symbol_RX      : std_logic_vector(1 downto 0) := "00";     -- Output from the symbol generator; a 2 bit representation of the data gen value
    signal r_Symbol_Mod_A   : std_logic := '0';                         -- Output symbol from modulation scheme A
    signal r_Symbol_Mod_B   : std_logic := '0';                         -- Output symbol from modulation scheme B 
    signal r_Symbol         : std_logic := '0';                         --
            
begin
    
    ------------------------------------------
    ------     Stop Button Latch        ------
    ------------------------------------------
    Stop_Latch: Button_Latch
        port map (
            -- Input
            i_Set   => r_Stop_Btn,
            -- Output
            o_Latch => r_Stop
        );
        
        
    ----------------------------------------------
    ------      Clock enable drivers        ------
    ------      1Hz, 2Hz, 16Hz, 250Hz       ------
    ----------------------------------------------
    CE_1Hz: Pulse_Generator
        generic map (
            Frequency => 1
        )
        port map (
            -- Input
            i_Clk       => Clk,
            -- Output
            o_Strobe    => r_CE_1Hz
        );     
        
    CE_2Hz: Pulse_Generator
        generic map (
            Frequency => 2
        )
        port map (
            -- Input
            i_Clk       => Clk,
            -- Output
            o_Strobe    => r_CE_2Hz
        ); 
        
    CE_4Hz: Pulse_Generator
        generic map (
            Frequency => 4
        )
        port map (
            -- Input
            i_Clk       => Clk,
            -- Output
            o_Strobe    => r_CE_4Hz
        );     
               
    CE_16Hz: Pulse_Generator
        generic map (
            Frequency => 16
        )
        port map (
            -- Input
            i_Clk       => Clk,
            -- Output
            o_Strobe    => r_CE_16Hz
        ); 
    
    CE_250Hz: Pulse_Generator
        generic map (
            Frequency => 250
        )
        port map (
            -- Input
            i_Clk       => Clk,
            -- Output
            o_Strobe    => r_CE_250Hz
        );
        
        
    ----------------------------------------------------------
    ------                  Debounce inputs             ------
    ----    BUTTONS : Fast, Reset, Stop                   ----
    ------  SWITCHES: Error Sel, Data Sel, Display Sel  ------
    ----------------------------------------------------------
    Fast_Debounce: Debounce
        port map (                
            -- Inputs      
            i_Clk       => Clk, 
            i_Input     => i_Fast_Sw,
            -- Output
            o_Output    => r_Fast
    );
    
    Reset_Debounce: Debounce
        port map (                
            -- Inputs      
            i_Clk       => Clk, 
            i_Input     => i_Reset_Btn,
            -- Output
            o_Output    => r_Reset
    );
    
    Stop_Debounce: Debounce
        port map (                
            -- Inputs      
            i_Clk       => Clk, 
            i_Input     => i_Stop_Btn,
            -- Output
            o_Output    => r_Stop_Btn
    );
         
    Gen_Err_Sel_Debounce: 
    for i in 1 downto 0 generate
        Error_Select_Debounce: Debounce
            port map (
                -- Inputs
                i_Clk    => Clk,
                i_Input  => i_Error_Select_Sw(i),
                        -- Outputs
                o_Output => r_Error_Select(i)
            );    
    end generate;
        
    Gen_Data_Sel_Debounce: 
    for i in 2 downto 0 generate
        Data_Select_Debounce: Debounce
            port map (
                -- Inputs
                i_Clk    => Clk,
                i_Input  => i_Data_Select_Sw(i),
                -- Outputs
                o_Output => r_Data_Select(i)
            );
    end generate;
        
    Gen_Disp_Sel_Debounce: 
    for i in 2 downto 0 generate
        Display_Select_Debounce: Debounce
            port map (
                -- Inputs
                i_Clk    => Clk,
                i_Input  => i_Display_Select_Sw(i),
                -- Outputs
                o_Output => r_Display_Select(i)
            );
    end generate;
    
    
    ----------------------------------------------------------
    ------               Data Generator                 ------
    ------ Generates 4 bit data values at a rate of 1Hz ------
    ----------------------------------------------------------
    Data_Gen: Data_Generator
        port map (
            -- Inputs
            i_Clk          => Clk,
            i_Stop         => r_Stop,
            i_Clock_Enable => r_CE_1Hz,
            i_Data_Select  => r_Data_Select,
            i_Reset        => r_Reset,
            -- Output
            o_Data         => r_Data_Gen
        );
    
    
    ----------------------------------------------------------
    ------              Symbol Converter                ------
    ------  Takes 4 bit input from the data generator,  ------
    ------  and creates 2 x 2-bit symbols               ------
    ----------------------------------------------------------
    Symbol_Conversion: Symbol_Converter
        port map (
            -- Inputs
            i_Clk       => Clk,
            i_Stop      => r_Stop,
            i_Reset     => r_Reset,
            i_CE_2Hz    => r_CE_2Hz,
            i_Data      => r_Data_Gen,
            --Outputs
            o_Symbol    => r_Symbol_RX
        );
        
        --------------------------------------------------------------
        ------              Modulation Scheme A                 ------
        ------  CONTAINS: Modulator, Error Channel, Demodulator ------
        --------------------------------------------------------------    
    Mod_Scheme_A: Modulation_Scheme_A
        port map (
            -- Inputs
            i_Clk           => Clk,  
            i_CE_2Hz        => r_CE_2Hz,
            i_CE_16Hz       => r_CE_16Hz,
            i_Reset         => r_Reset,
            i_Symbol        => r_Symbol_RX,
            i_Error_Select  => r_Error_Select,
                           
            -- Outputs     
            o_Data          => r_Data_Mod_A,
            o_Symbol        => r_Symbol_Mod_A  
        );
    
    
    --------------------------------------------------------------
    ------              Modulation Scheme B                 ------
    ------  CONTAINS: Modulator, Error Channel, Demodulator ------
    --------------------------------------------------------------
    Mod_Scheme_B: Scheme_B
        port map (
            -- Inputs
            i_Clk          => Clk,
            i_CE_2Hz       => r_CE_2Hz,
            i_CE_16Hz      => r_CE_16Hz,
            i_Reset        => r_Reset,  
            i_Symbol_RX    => r_Symbol_RX,
            i_Error_Select => r_Error_Select,
            
            -- Outputs
            o_Data         => r_Data_Mod_B,
            o_Symbol       => r_Symbol_Mod_B
        );
    
    
    -----------------------------------------------------
    ------          Seven Segment Decoder          ------
    ------  Translates 4 bit binary values to      ------
    ------  their corresponding cathode patterns   ------
    -----------------------------------------------------
    Seven_Seg_Decoder: Seven_Segment_Decoder
        port map (
            -- Inputs
            i_Cathode_Value => r_Cathode_Value,     
            -- Outputs
            o_Seg_Cathodes  => o_Segment_Cathodes
        );    
    
    
    -----------------------------------------------------------
    ------              Display Driver                   ------
    ----   Drives anodes and generates input for decoder   ----
    ------ depending on the data select switch inputs    ------
    -----------------------------------------------------------
    Display_Driver_M3: Display_Driver
        port map (
            -- Inputs       
            i_Clk           => Clk,
            i_Stop          => r_Stop,
            i_Symbol        => r_Symbol,
            i_DS            => r_Data_Select,
            i_Data          => r_Data_RX,
            i_CE_4Hz        => r_CE_4Hz,
            i_CE_250Hz      => r_CE_250Hz,
            -- Output       
            o_Cathode_Value => r_Cathode_Value,
            o_Anode_Control => o_Segment_Anodes
        );
    
        
    ------------------------------------------------------
    ------          Concurrent Statements           ------
    ------------------------------------------------------
    
    -- Control which modulation scheme's symbol is fed to the display
    with r_Display_Select select r_Symbol <=
        r_Symbol_Mod_A  when "001",
        r_Symbol_Mod_A  when "010",
        r_Symbol_Mod_A  when "011",
        r_Symbol_Mod_B  when "101",
        r_Symbol_Mod_B  when "110",
        r_Symbol_Mod_B  when "111";
    
end Behavioral;
