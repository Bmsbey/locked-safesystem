library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment_driver is
    Port (
        clk      : in STD_LOGIC;
        reset    : in STD_LOGIC;
        digit0   : in STD_LOGIC_VECTOR(3 downto 0);
        digit1   : in STD_LOGIC_VECTOR(3 downto 0);
        digit2   : in STD_LOGIC_VECTOR(3 downto 0);
        digit3   : in STD_LOGIC_VECTOR(3 downto 0);
        segments : out STD_LOGIC_VECTOR(6 downto 0);
        anodes   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end seven_segment_driver;

architecture Behavioral of seven_segment_driver is
    signal refresh_counter : unsigned(15 downto 0) := (others => '0');
    signal mux_select      : unsigned(1 downto 0) := (others => '0');
    signal current_digit   : std_logic_vector(3 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                refresh_counter <= (others => '0');
                mux_select      <= (others => '0');
            else
                refresh_counter <= refresh_counter + 1;
                if refresh_counter = 0 then
                    mux_select <= mux_select + 1;
                end if;
            end if;
        end if;
    end process;

    process(mux_select, digit0, digit1, digit2, digit3)
    begin
        case mux_select is
            when "00" =>
                anodes        <= "1110";
                current_digit <= digit0;
            when "01" =>
                anodes        <= "1101";
                current_digit <= digit1;
            when "10" =>
                anodes        <= "1011";
                current_digit <= digit2;
            when others =>
                anodes        <= "0111";
                current_digit <= digit3;
        end case;
    end process;

    process(current_digit)
    begin
        case current_digit is
            when "0000" => segments <= "1000000";
            when "0001" => segments <= "1111001";
            when "0010" => segments <= "0100100";
            when "0011" => segments <= "0110000";
            when "0100" => segments <= "0011001";
            when "0101" => segments <= "0010010";
            when "0110" => segments <= "0000010";
            when "0111" => segments <= "1111000";
            when "1000" => segments <= "0000000";
            when "1001" => segments <= "0010000";
            when others => segments <= "1111111";
        end case;
    end process;
end Behavioral;
