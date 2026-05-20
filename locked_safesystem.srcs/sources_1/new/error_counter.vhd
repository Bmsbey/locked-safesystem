library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity error_counter is
    port(
        clk           : in std_logic;
        reset         : in std_logic;
        wrong_pulse   : in std_logic;
        attempts_left : out std_logic_vector(2 downto 0);
        lock_trigger  : out std_logic;
        start_timer   : out std_logic
    );
end entity;

architecture Behavioral of error_counter is
    signal counter : unsigned(2 downto 0) := to_unsigned(5, 3);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter <= to_unsigned(5, 3);
            elsif wrong_pulse = '1' then
                if counter > 0 then
                    counter <= counter - 1;
                end if;
            end if;
        end if;
    end process;

    attempts_left <= std_logic_vector(counter);
    lock_trigger  <= '1' when counter = 0 else '0';
    start_timer   <= '1' when counter = 3 else '0';
end Behavioral;
