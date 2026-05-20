library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity password_fsm_controller is
    Port (
        clk        : in STD_LOGIC;
        reset      : in STD_LOGIC;
        next_state : in STD_LOGIC;
        pass_d2    : out STD_LOGIC_VECTOR(3 downto 0);
        pass_d1    : out STD_LOGIC_VECTOR(3 downto 0);
        pass_d0    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end password_fsm_controller;

architecture Behavioral of password_fsm_controller is
    type state_type is (S0, S1, S2, S3, S4, S5);
    signal current_state : state_type := S0;

    constant d3 : std_logic_vector(3 downto 0) := "0011";
    constant d6 : std_logic_vector(3 downto 0) := "0110";
    constant d7 : std_logic_vector(3 downto 0) := "0111";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= S0;
            elsif next_state = '1' then
                case current_state is
                    when S0 => current_state <= S1;
                    when S1 => current_state <= S2;
                    when S2 => current_state <= S3;
                    when S3 => current_state <= S4;
                    when S4 => current_state <= S5;
                    when S5 => current_state <= S0;
                end case;
            end if;
        end if;
    end process;

    process(current_state)
    begin
        case current_state is
            when S0 => pass_d2 <= d6; pass_d1 <= d3; pass_d0 <= d7; -- 637
            when S1 => pass_d2 <= d7; pass_d1 <= d3; pass_d0 <= d6; -- 736
            when S2 => pass_d2 <= d3; pass_d1 <= d6; pass_d0 <= d7; -- 367
            when S3 => pass_d2 <= d6; pass_d1 <= d7; pass_d0 <= d3; -- 673
            when S4 => pass_d2 <= d7; pass_d1 <= d6; pass_d0 <= d3; -- 763
            when S5 => pass_d2 <= d3; pass_d1 <= d7; pass_d0 <= d6; -- 376
        end case;
    end process;
end Behavioral;
