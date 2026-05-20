library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_module is
    Port (
        clk, reset                     : in  STD_LOGIC;
        load_enable, confirm_button    : in  STD_LOGIC;
        digit2, digit1, digit0         : in  STD_LOGIC_VECTOR(3 downto 0);
        match_leds                     : out STD_LOGIC_VECTOR(2 downto 0);
        red_led, green_led, yellow_led : out STD_LOGIC;
        buzzer_short, buzzer_long      : out STD_LOGIC;
        servo_pwm, system_status_led   : out STD_LOGIC;
        segments                       : out STD_LOGIC_VECTOR(6 downto 0);
        anodes                         : out STD_LOGIC_VECTOR(3 downto 0)
    );
end top_module;

architecture Behavioral of top_module is
    signal code_in                   : std_logic_vector(11 downto 0);
    signal input_ready               : std_logic;
    signal pass_d2, pass_d1, pass_d0 : std_logic_vector(3 downto 0);
    signal password                  : std_logic_vector(11 downto 0);
    signal eq, gt, lt                : std_logic;
    signal match_flags, match_latch  : std_logic_vector(2 downto 0);
    signal wrong_pulse               : std_logic;
    signal system_unlocked           : std_logic := '0';
    signal attempts_left             : std_logic_vector(2 downto 0);
    signal lock_trigger, start_timer : std_logic;
    signal remaining_time            : std_logic_vector(5 downto 0);
    signal time_expired              : std_logic;
    signal d0, d1, d2, d3            : std_logic_vector(3 downto 0);
begin
    input_if: entity work.input_interface
        port map (
            clk            => clk,
            reset          => reset,
            load_enable    => load_enable,
            confirm_button => confirm_button,
            digit2         => digit2,
            digit1         => digit1,
            digit0         => digit0,
            code_out       => code_in,
            input_ready    => input_ready
        );

    fsm: entity work.password_fsm_controller
        port map (
            clk        => clk,
            reset      => reset,
            next_state => wrong_pulse,
            pass_d2    => pass_d2,
            pass_d1    => pass_d1,
            pass_d0    => pass_d0
        );

    password <= pass_d2 & pass_d1 & pass_d0;

    cmp: entity work.password_comparator
        port map (
            code_in     => code_in,
            password    => password,
            input_ready => input_ready,
            eq          => eq,
            gt          => gt,
            lt          => lt
        );

    wrong_pulse <= input_ready and not eq;

    match_chk: entity work.digit_match_checker
        port map (
            d2          => code_in(11 downto 8),
            d1          => code_in(7 downto 4),
            d0          => code_in(3 downto 0),
            pwd2        => pass_d2,
            pwd1        => pass_d1,
            pwd0        => pass_d0,
            match_flags => match_flags
        );

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                match_latch <= (others => '0');
            elsif input_ready = '1' then
                match_latch <= match_flags;
            end if;
        end if;
    end process;

    match_leds <= match_latch;

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                system_unlocked <= '0';
            elsif input_ready = '1' and eq = '1' then
                system_unlocked <= '1';
            end if;
        end if;
    end process;

    servo_inst: entity work.servo_controller
        port map (
            clk        => clk,
            reset      => reset,
            enable     => system_unlocked,
            pwm_signal => servo_pwm
        );

    green_led         <= system_unlocked;
    system_status_led <= system_unlocked;

    led_ctrl: entity work.LED_control
        port map (
            clk         => clk,
            reset       => reset,
            equal       => eq,
            less        => lt,
            greater     => gt,
            input_ready => input_ready,
            red_led     => red_led,
            green_led   => open,
            yellow_led  => yellow_led
        );

    err_cnt: entity work.error_counter
        port map (
            clk           => clk,
            reset         => reset,
            wrong_pulse   => wrong_pulse,
            attempts_left => attempts_left,
            lock_trigger  => lock_trigger,
            start_timer   => start_timer
        );

    timer: entity work.countdown_timer
        port map (
            clk            => clk,
            reset          => reset,
            start          => start_timer,
            unlock         => system_unlocked,
            stop           => lock_trigger,
            remaining_time => remaining_time,
            time_expired   => time_expired
        );

    buz_wrong: entity work.buzzer_wrong_attempt
        port map (
            clk        => clk,
            reset      => reset,
            trigger    => wrong_pulse,
            buzzer_out => buzzer_short
        );

    buz_ctrl: entity work.buzzer_control
        port map (
            clk               => clk,
            reset             => reset,
            time_expired      => time_expired,
            attempt_exhausted => lock_trigger,
            buzzer_out        => buzzer_long
        );

    disp_data: entity work.display_data_manager
        port map (
            seconds_left  => remaining_time,
            attempts_left => attempts_left,
            digit0        => d0,
            digit1        => d1,
            digit2        => d2,
            digit3        => d3
        );

    seg_drv: entity work.seven_segment_driver
        port map (
            clk      => clk,
            reset    => reset,
            digit0   => d0,
            digit1   => d1,
            digit2   => d2,
            digit3   => d3,
            segments => segments,
            anodes   => anodes
        );
end Behavioral;
