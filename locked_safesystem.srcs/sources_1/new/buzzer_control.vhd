library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity buzzer_control is
    Port (
        clk               : in STD_LOGIC;
        reset             : in STD_LOGIC;
        time_expired      : in STD_LOGIC;
        attempt_exhausted : in STD_LOGIC;
        buzzer_out        : out STD_LOGIC
    );
end buzzer_control;

architecture Behavioral of buzzer_control is
    signal buzzer_active : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                buzzer_active <= '0';
            elsif time_expired = '1' or attempt_exhausted = '1' then
                buzzer_active <= '1';
            end if;
        end if;
    end process;

    buzzer_out <= buzzer_active;
end Behavioral;
