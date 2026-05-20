library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity password_comparator is
    port(
        code_in     : in STD_LOGIC_VECTOR(11 downto 0);
        password    : in STD_LOGIC_VECTOR(11 downto 0);
        input_ready : in STD_LOGIC;
        eq          : out STD_LOGIC;
        gt          : out STD_LOGIC;
        lt          : out STD_LOGIC
    );
end entity;

architecture Behavioral of password_comparator is
    signal code_val : unsigned(11 downto 0);
    signal pass_val : unsigned(11 downto 0);
begin
    code_val <= unsigned(code_in);
    pass_val <= unsigned(password);

    process(code_val, pass_val, input_ready)
    begin
        if input_ready = '1' then
            if code_val = pass_val then
                eq <= '1';
                gt <= '0';
                lt <= '0';
            elsif code_val > pass_val then
                eq <= '0';
                gt <= '1';
                lt <= '0';
            else
                eq <= '0';
                gt <= '0';
                lt <= '1';
            end if;
        else
            eq <= '0';
            gt <= '0';
            lt <= '0';
        end if;
    end process;
end Behavioral;
