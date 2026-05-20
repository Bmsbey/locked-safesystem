library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity buzzer_wrong_attempt is
    Port (
        clk        : in STD_LOGIC;
        reset      : in STD_LOGIC;
        trigger    : in STD_LOGIC;
        buzzer_out : out STD_LOGIC
    );
end buzzer_wrong_attempt;

architecture Behavioral of buzzer_wrong_attempt is
    constant BUZZ_DURATION : unsigned(25 downto 0) := to_unsigned(50_000_000, 26);
    signal buzzer_timer    : unsigned(25 downto 0) := (others => '0');
    signal active          : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                buzzer_timer <= (others => '0');
                active       <= '0';
            elsif trigger = '1' then
                buzzer_timer <= BUZZ_DURATION;
                active       <= '1';
            elsif active = '1' then
                if buzzer_timer > 0 then
                    buzzer_timer <= buzzer_timer - 1;
                else
                    active <= '0';
                end if;
            end if;
        end if;
    end process;

    buzzer_out <= active;
end Behavioral;
