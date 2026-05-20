library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity countdown_timer is
    Port (
        clk            : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        start          : in  STD_LOGIC;
        unlock         : in  STD_LOGIC;
        stop           : in  STD_LOGIC;
        remaining_time : out STD_LOGIC_VECTOR(5 downto 0);
        time_expired   : out STD_LOGIC
    );
end countdown_timer;

architecture Behavioral of countdown_timer is
    signal counter     : unsigned(5 downto 0) := to_unsigned(45, 6);
    signal running     : std_logic := '0';
    signal clk_divider : unsigned(26 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter     <= to_unsigned(45, 6);
                clk_divider <= (others => '0');
                running     <= '0';
            elsif start = '1' then
                counter     <= to_unsigned(45, 6);
                clk_divider <= (others => '0');
                running     <= '1';
            elsif running = '1' then
                if unlock = '1' or stop = '1' then
                    running <= '0';
                else
                    clk_divider <= clk_divider + 1;
                    if clk_divider = 100_000_000 - 1 then
                        clk_divider <= (others => '0');
                        if counter > 0 then
                            counter <= counter - 1;
                        else
                            running <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    remaining_time <= std_logic_vector(counter);
    time_expired   <= '1' when (counter = 0) else '0';
end Behavioral;
