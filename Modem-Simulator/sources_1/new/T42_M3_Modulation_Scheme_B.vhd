library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Scheme_B is
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
end Scheme_B;

architecture Behavioral of Scheme_B is

    component Modulator_B is
        port (
            -- Inputs
            Clk         :   in  std_logic;
            Reset       :   in  std_logic;
            Clock_En    :   in  std_logic;
            Symbol_RX   :   in  std_logic_vector(1 downto 0);
            
            -- Outputs
            I_TX        :   out std_logic_vector(7 downto 0);
            Q_TX        :   out std_logic_vector(7 downto 0)
        );  
    end component;

    component Channel_B is
        generic (
            LFSR_Seed    :  std_logic_vector(32 downto 1)
        );
        port (
            -- Inputs
            Clk         :   in  std_logic;
            Reset       :   in  std_logic;
            Clock_En    :   in  std_logic;
            Error_Select:   in  std_logic_vector(1 downto 0);
            I_RX        :   in  std_logic_vector(7 downto 0);
            Q_RX        :   in  std_logic_vector(7 downto 0);
            
            -- Outputs
            I_TX        :   out std_logic_vector(7 downto 0);
            Q_TX        :   out std_logic_vector(7 downto 0)
        );
    end component;

    component Demodulator_B is
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
    end component;

    ---------------------------------------------------------
    ---------- Intermediate Signal Declarations -------------
    ---------------------------------------------------------    
    -- Connect the Modulator to the channel block
    signal r_I_Mod : std_logic_vector(7 downto 0) := x"00";
    signal r_Q_Mod : std_logic_vector(7 downto 0) := x"00";
    
    -- Connect the channel block to the demodulator
    signal r_I_Error : std_logic_vector(7 downto 0) := x"00";
    signal r_Q_Error : std_logic_vector(7 downto 0) := x"00";

begin

    Modulator: Modulator_B
        port map (
            -- Inputs
            Clk         => i_Clk,
            Reset       => i_Reset,
            Clock_En    => i_CE_16Hz,
            Symbol_RX   => i_Symbol_RX,
            
            -- Outputs
            I_TX        => r_I_Mod,
            Q_TX        => r_Q_Mod
        );

    Error: Channel_B
        generic map (
            LFSR_Seed   => x"3CA52DF7"
        )
        port map (
            -- Inputs
            Clk          => i_Clk,
            Reset        => i_Reset,
            Clock_En     => i_CE_2Hz,
            Error_Select => i_Error_Select,
            I_RX         => r_I_Mod,
            Q_RX         => r_Q_Mod,
            
            -- Outputs
            I_TX        => r_I_Error,
            Q_TX        => r_Q_Error
        );

    Demodulator: Demodulator_B
        port map (
            -- Inputs
            Clk         => i_Clk,
            Clock_En    => i_CE_16Hz,
            Reset       => i_Reset,
            I_RX        => r_I_Error,
            Q_RX        => r_Q_Error,
            
            -- Outputs
            Data        => o_Data,
            Symbol      => o_Symbol
        );         
     
end Behavioral;