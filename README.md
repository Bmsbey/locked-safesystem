# Locked Safe System

An FPGA-based digital safe lock system designed in VHDL with Xilinx Vivado. The project implements a three-digit password mechanism, attempt tracking, countdown behavior, LED feedback, buzzer alerts, seven-segment display output, and servo-based lock control.

## Demo Video

Watch the project demo on YouTube: [Locked Safe System Demo](https://youtu.be/F8EEcSHaBgI)

## Overview

The system accepts a three-digit BCD input from switches, compares it with the active password, and controls the safe lock state based on the result. A correct password unlocks the safe by driving a servo PWM signal. Incorrect attempts reduce the remaining attempt count, activate a short buzzer warning, and rotate the active password through a finite state machine.

After repeated wrong attempts, the system starts a countdown timer and eventually triggers a long buzzer alert when the attempt limit is exhausted or the timer expires.

## Features

- Three-digit BCD password input
- Password validation using a comparator module
- Password rotation with a finite state machine
- Digit-by-digit match indication with LEDs
- Remaining attempt counter
- 45-second countdown timer
- Short buzzer alert for wrong attempts
- Long buzzer alert for timeout or exhausted attempts
- Servo PWM output for locked/unlocked positions
- Four-digit seven-segment display driver
- XDC pin constraints for FPGA implementation

## Hardware Target

- FPGA part: `xc7a35tcpg236-1`
- Design language: VHDL
- Toolchain: Xilinx Vivado 2025.1
- Top module: `top_module`

## Project Structure

```text
locked-safesystem/
|-- README.md
|-- .gitignore
|-- locked_safesystem.xpr
`-- locked_safesystem.srcs/
    |-- constrs_1/
    |   `-- new/
    |       `-- constraint.xdc
    `-- sources_1/
        `-- new/
            |-- LED_control.vhd
            |-- buzzer_control.vhd
            |-- buzzer_control_wrong_attempt.vhd
            |-- countdown_timer.vhd
            |-- digit_match_checker.vhd
            |-- display_data_manager.vhd
            |-- error_counter.vhd
            |-- input_interface.vhd
            |-- password_comporator.vhd
            |-- password_fsm_controller.vhd
            |-- servo_controller.vhd
            |-- seven_segment_driver.vhd
            `-- top_module.vhd
```

## Main Modules

| Module | Responsibility |
| --- | --- |
| `top_module` | Integrates all system components |
| `input_interface` | Captures and confirms user input |
| `password_comparator` | Compares entered code with the active password |
| `password_fsm_controller` | Rotates the active password after wrong attempts |
| `digit_match_checker` | Indicates which digits match the active password |
| `error_counter` | Tracks remaining password attempts |
| `countdown_timer` | Runs the 45-second countdown |
| `servo_controller` | Generates PWM for locked and unlocked servo positions |
| `LED_control` | Drives result feedback LEDs |
| `buzzer_wrong_attempt` | Generates short warning sound for wrong attempts |
| `buzzer_control` | Generates long alarm sound for timeout or lockout |
| `display_data_manager` | Prepares display digits for time and attempts |
| `seven_segment_driver` | Multiplexes and drives the seven-segment display |

## Password Flow

The password controller cycles through the following three-digit combinations:

```text
637 -> 736 -> 367 -> 673 -> 763 -> 376
```

The active password changes after each wrong attempt. When the entered code matches the active password, the system unlocks and the servo output moves to the unlock position.

## Inputs and Outputs

| Signal | Direction | Description |
| --- | --- | --- |
| `clk` | Input | System clock |
| `reset` | Input | Resets the system |
| `load_enable` | Input | Enables loading the digit input |
| `confirm_button` | Input | Confirms the entered password |
| `digit2`, `digit1`, `digit0` | Input | Three BCD password digits |
| `match_leds` | Output | Shows digit-level matches |
| `red_led` | Output | Indicates entered value is lower |
| `yellow_led` | Output | Indicates entered value is greater |
| `green_led` | Output | Indicates successful unlock |
| `buzzer_short` | Output | Wrong-attempt warning buzzer |
| `buzzer_long` | Output | Timeout or lockout buzzer |
| `servo_pwm` | Output | Servo control PWM |
| `system_status_led` | Output | Shows unlocked system status |
| `segments` | Output | Seven-segment segment lines |
| `anodes` | Output | Seven-segment digit enable lines |

## How to Open

1. Open Xilinx Vivado.
2. Select **Open Project**.
3. Choose `locked_safesystem.xpr`.
4. Confirm that `top_module` is selected as the top module.
5. Run synthesis, implementation, and bitstream generation if targeting hardware.

## Notes

Generated Vivado files such as run outputs, cache folders, logs, bitstreams, and hardware export artifacts are intentionally excluded from the repository. The repository keeps only the project definition, source files, constraints, and documentation needed to understand and rebuild the design.
