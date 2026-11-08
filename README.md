# Washing Machine Controller

This project is a small digital controller written in Verilog HDL. It uses a
finite-state machine (FSM) to move through the main parts of a wash cycle:
idle, waiting for clothes, washing, draining, and finishing.

## Contents

- [How the controller works](#how-the-controller-works)
- [Inputs and outputs](#inputs-and-outputs)
- [Project files](#project-files)
- [Run the simulation](#run-the-simulation)
- [View the waveform](#view-the-waveform)

## How the controller works

The FSM stores its current step in `ps` and calculates the next step in `ns`.
The current state changes on the rising edge of `clk`.

| State | What it does | Moves to |
| --- | --- | --- |
| `IDLE` | Waits for `start` | `FILL` when `start` is high |
| `FILL` | Waits for clothes to be detected | `WASH` when `cloath_in` is high |
| `WASH` | Counts wash clock cycles while clothes are detected | `DRAIN` when `wash_done` is high |
| `DRAIN` | Counts drain clock cycles after washing | `DONE` when `drain_done` is high |
| `DONE` | Turns on `cloath_out` | Returns to `IDLE` |

`rest` is an active-high, synchronous reset. It returns the state and output
signals to their reset values on a rising clock edge.

The wash and drain timers are 4-bit values. Each counter starts at zero and is
compared with its timer before being incremented. Therefore, a timer value of
`N` completes on the `(N + 1)`th counting edge; a value of zero completes on
the first counting edge. The wash counter pauses while `cloath_in` is low.

In this implementation, `wash_done`, `drain_done`, and `cloath_out` remain high
after they are asserted until `rest` is applied.

## Inputs and outputs

| Signal | Direction | Meaning |
| --- | --- | --- |
| `clk` | Input | Clock; state and counters update on its rising edge |
| `rest` | Input | Active-high synchronous reset |
| `start` | Input | Starts a cycle from `IDLE` |
| `cloath_in` | Input | Indicates clothes are present |
| `wash_timer[3:0]` | Input | Wash counter's target value |
| `drain_timer[3:0]` | Input | Drain counter's target value |
| `cloath_out` | Output | Goes high in `DONE` |
| `wash_done` | Output | Goes high when the wash counter reaches its target |
| `drain_done` | Output | Goes high when the drain counter reaches its target |

## Project files

- [Controller RTL](rtl/washing_machine.v): state transitions, counters, and outputs.
- [Testbench](testbench/washing_machine_tb.v): clock, reset, and example input sequence; also writes the waveform.

## Run the simulation

Install Icarus Verilog, then run these commands from the project root:

```sh
iverilog -g2012 -Wall -o washing_machine_sim rtl/washing_machine.v testbench/washing_machine_tb.v
vvp washing_machine_sim
```

The testbench runs the supplied sequence and stops automatically. It does not
check results with assertions.

## View the waveform

The testbench writes `washing_machine.vcd` in the current directory. Open it
with GTKWave:

```sh
gtkwave washing_machine.vcd
```

The VCD dump is set up in the [testbench source](testbench/washing_machine_tb.v).
