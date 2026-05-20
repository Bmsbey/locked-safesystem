library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LED_control is
    Port (
        clk         : in STD_LOGIC;
        reset       : in STD_LOGIC;
        equal       : in STD_LOGIC;
        less        : in STD_LOGIC;
        greater     : in STD_LOGIC;
        input_ready : in STD_LOGIC;
        red_led     : out STD_LOGIC;
        green_led   : out STD_LOGIC;
        yellow_led  : out STD_LOGIC
    );
end LED_control;

architecture Behavioral of LED_control is
    signal red_s, green_s, yellow_s : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                red_s    <= '0';
                green_s  <= '0';
                yellow_s <= '0';
            elsif input_ready = '1' then
                red_s    <= '0';
                green_s  <= '0';
                yellow_s <= '0';

                if equal = '1' then
                    green_s <= '1';
                elsif less = '1' then
                    red_s <= '1';
                elsif greater = '1' then
                    yellow_s <= '1';
                end if;
            end if;
        end if;
    end process;

    red_led    <= red_s;
    green_led  <= green_s;
    yellow_led <= yellow_s;
end Behavioral;
