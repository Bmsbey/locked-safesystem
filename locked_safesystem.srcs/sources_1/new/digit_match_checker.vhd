library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digit_match_checker is
    port (
        d2, d1, d0       : in STD_LOGIC_VECTOR(3 downto 0);
        pwd2, pwd1, pwd0 : in STD_LOGIC_VECTOR(3 downto 0);
        match_flags      : out STD_LOGIC_VECTOR(2 downto 0)
    );
end digit_match_checker;

architecture Behavioral of digit_match_checker is
begin
    process(d0, d1, d2, pwd0, pwd1, pwd2)
    begin
        if d2 = pwd2 then
            match_flags(2) <= '1';
        else
            match_flags(2) <= '0';
        end if;

        if d1 = pwd1 then
            match_flags(1) <= '1';
        else
            match_flags(1) <= '0';
        end if;

        if d0 = pwd0 then
            match_flags(0) <= '1';
        else
            match_flags(0) <= '0';
        end if;
    end process;
end Behavioral;
