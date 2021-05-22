library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity I2C_Controller is
    port (
    -- Inputs
        Clk         : in std_logic;                         -- Serial clock input
        i_Reset     : in std_logic;                         -- Pulses high to signal system reset condition
        i_Start     : in std_logic;                         -- Pulses high when inputs are loaded with data to be transmitted
        i_Slave_Adr : in std_logic_vector(7 downto 0);      -- Device ID and R/W bit
        i_Reg_Adr   : in std_logic_vector(15 downto 0);     -- Camera register address, the OV5642 uses 16-bit address registers (read from ROM)
        i_Reg_Val   : in std_logic_vector(7 downto 0);      -- Camera register data value (read from ROM)
    -- Outputs
        o_ROM_Adr   : out std_logic_vector(9 downto 0);     -- Address in ROM to point to and read register contents+adr
        o_Idle      : out std_logic;                        -- Signals when the sender is idle
        o_SDA       : out std_logic;                        -- Serial Data Line output to the camera module
        o_SCL       : out std_logic                         -- Serial Clock Line output to the camera module
    );
end I2C_Controller;

architecture Behavioral of I2C_Controller is

    type t_I2C_Sender is (IDLE, START, SLAVE_ADDRESS, ACK_1, REGISTER_ADDRESS_1, ACK_2, REGISTER_ADDRESS_2, ACK_3, REGISTER_DATA, ACK_4, STOP); -- Different states of an SCCB sender
    signal State : t_I2C_Sender := IDLE;
    
    signal Bit_Counter  : integer range 0 to 15 := 0;
    signal Slave_Adr    : std_logic_vector(7 downto 0) := x"00";
    signal Reg_Adr      : std_logic_vector(15 downto 0)  := x"0000";
    signal Reg_Val      : std_logic_vector(7 downto 0)   := x"00";
    signal ROM_Adr      : unsigned(9 downto 0) := (others => '0');
    signal Idle_Counter : unsigned(1 downto 0) := "00";
    
    begin
    
    o_SCL <= Clk;
    
    Address_Controller: process(Clk)
    begin
        if (rising_edge(Clk)) then
            if (i_Reset = '1') then
                ROM_Adr <= (others => '0');
            elsif (Idle_Counter = "11") then
                if (ROM_Adr < x"208") and (Idle_Counter = "11") then
                    ROM_Adr <= ROM_Adr + 1;
                    o_ROM_Adr <= std_logic_vector(ROM_Adr);
                end if;
            end if;
        end if;
    end process;
    
    State_Control: process(Clk)
    begin
        if (rising_edge(Clk)) then
            if (i_Reset = '1') then
                State <= IDLE;
            else
                case State is
                    when IDLE =>
                        Idle_Counter <= Idle_Counter + 1;
                        o_SDA <= '1';                   -- Pull the SDA output high while idle
                        o_Idle <= '1';                  -- Indicate that the sender is idle, meaning it's ready to receive new data
                        Bit_Counter <= 7;
                        if (i_Start = '1') then         -- If the next frame of data is ready, the start input will be high
                            State <= START;             -- Update the state to transmit the start bit
                            Slave_Adr <= i_Slave_Adr;   -- 
                            Reg_Adr <= i_Reg_Adr;
                            Reg_Val <= i_Reg_Val;
                        else
                            State <= IDLE;
                        end if;
                        
                    when START =>
                        Idle_Counter <= "00";
                        o_SDA <= '0';
                        o_Idle <= '0';
                        State <= SLAVE_ADDRESS;
                        
                    when SLAVE_ADDRESS =>
                        o_SDA <= Slave_Adr(Bit_Counter);
                        if (Bit_Counter = 0) then
                            State <= ACK_1;
                        else
                            Bit_Counter <= Bit_Counter - 1;
                        end if;
                        
                    when ACK_1 =>
                        o_SDA <= '0';
                        State <= REGISTER_ADDRESS_1;
                        Bit_Counter <= 15;
                        
                    when REGISTER_ADDRESS_1 =>
                        o_SDA <= Reg_Adr(Bit_Counter);
                        if (Bit_Counter = 8) then
                            State <= Ack_2;
                        else
                            Bit_Counter <= Bit_Counter - 1;
                        end if;
                        
                    when ACK_2 =>
                        o_SDA <= '0';
                        State <= REGISTER_ADDRESS_2;
                        Bit_Counter <= 7;
                    
                    when REGISTER_ADDRESS_2 =>
                        o_SDA <= Reg_Adr(Bit_Counter);
                        if (Bit_Counter = 0) then
                            State <= ACK_3;
                        else
                            Bit_Counter <= Bit_Counter - 1;
                        end if;
                        
                    when ACK_3 =>
                        o_SDA <= '0';
                        State <= REGISTER_DATA;
                        Bit_Counter <= 7;
                        
                    when REGISTER_DATA =>
                        o_SDA <= Reg_Val(Bit_Counter);
                        if (Bit_Counter = 0) then
                            State <= ACK_4;
                        else
                            Bit_Counter <= Bit_Counter - 1;
                        end if;
                        
                    when ACK_4 =>
                        o_SDA <= '0';
                        State <= STOP;
                        
                    when STOP =>
                        o_SDA <= '1';
                        State <= IDLE;
                end case;
            end if;
        end if;
    end process;
    
end Behavioral;