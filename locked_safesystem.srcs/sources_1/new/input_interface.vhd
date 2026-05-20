library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_interface is
    Port (
        clk            : in std_logic;
        reset          : in std_logic;
        load_enable    : in std_logic;
        confirm_button : in std_logic;
        digit2         : in std_logic_vector(3 downto 0);
        digit1         : in std_logic_vector(3 downto 0);
        digit0         : in std_logic_vector(3 downto 0);
        code_out       : out std_logic_vector(11 downto 0);
        input_ready    : out std_logic
    );
end input_interface;

architecture Behavioral of input_interface is
    type input_state_type is (IDLE, LOAD, CONFIRM_LOCK);
    signal current_state : input_state_type := IDLE;
    signal bufferr       : std_logic_vector(11 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= IDLE;
                bufferr       <= (others => '0');
                input_ready   <= '0';
            else
                case current_state is
                    when IDLE =>
                        input_ready <= '0';
                        if load_enable = '1' then
                            current_state <= LOAD;
                        end if;

                    when LOAD =>
                        bufferr <= digit2 & digit1 & digit0;
                        if confirm_button = '1' then
                            current_state <= CONFIRM_LOCK;
                            input_ready   <= '1';
                        end if;

                    when CONFIRM_LOCK =>
                        input_ready <= '0';
                        if load_enable = '0' and confirm_button = '0' then
                            current_state <= IDLE;
                        end if;
                end case;
            end if;
        end if;
    end process;

    code_out <= bufferr;
end Behavioral;
