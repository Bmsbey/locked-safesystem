library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity servo_controller is
    Port (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        enable     : in  STD_LOGIC;
        pwm_signal : out STD_LOGIC
    );
end servo_controller;

architecture Behavioral of servo_controller is
    constant PWM_PERIOD   : unsigned(20 downto 0) := to_unsigned(1_999_999, 21);
    constant PULSE_LOCK   : unsigned(20 downto 0) := to_unsigned(100_000, 21);
    constant PULSE_UNLOCK : unsigned(20 downto 0) := to_unsigned(200_000, 21);
    signal counter        : unsigned(20 downto 0) := (others => '0');
    signal pwm_out        : std_logic := '0';
begin
    process(clk)
        variable pulse_width : unsigned(20 downto 0);
    begin
        if rising_edge(clk) then
            if enable = '1' then
                pulse_width := PULSE_UNLOCK;
            else
                pulse_width := PULSE_LOCK;
            end if;

            if reset = '1' then
                counter <= (others => '0');
                pwm_out <= '0';
            else
                if counter = PWM_PERIOD then
                    counter <= (others => '0');
                else
                    counter <= counter + 1;
                end if;

                if counter < pulse_width then
                    pwm_out <= '1';
                else
                    pwm_out <= '0';
                end if;
            end if;
        end if;
    end process;

    pwm_signal <= pwm_out;
end Behavioral;
