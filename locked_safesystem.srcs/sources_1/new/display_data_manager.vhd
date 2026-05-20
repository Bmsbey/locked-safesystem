library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_data_manager is
    Port (
        seconds_left  : in STD_LOGIC_VECTOR(5 downto 0);
        attempts_left : in STD_LOGIC_VECTOR(2 downto 0);
        digit0        : out STD_LOGIC_VECTOR(3 downto 0);
        digit1        : out STD_LOGIC_VECTOR(3 downto 0);
        digit2        : out STD_LOGIC_VECTOR(3 downto 0);
        digit3        : out STD_LOGIC_VECTOR(3 downto 0)
    );
end display_data_manager;

architecture Behavioral of display_data_manager is
    signal seconds : integer;
    signal tens    : integer;
    signal ones    : integer;
begin
    process(seconds_left)
    begin
        seconds <= to_integer(unsigned(seconds_left));
        tens    <= seconds / 10;
        ones    <= seconds mod 10;
        digit1  <= std_logic_vector(to_unsigned(tens, 4));
        digit0  <= std_logic_vector(to_unsigned(ones, 4));
    end process;

    process(attempts_left)
    begin
        digit3 <= "0" & attempts_left;
    end process;

    digit2 <= "1111";
end Behavioral;
