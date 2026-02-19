# Basys-3-UART-transmitter
This project implements a fully functional UART transmitter that divides the Basys 3's 100 MHz system clock down to a 9600 baud timing reference, builds 10-bit UART frames, and continuously transmits an ASCII message over the onboard USB-UART bridge.
## Features

- 9600 baud UART transmission
- 100 MHz → 9600 baud clock divider with edge-detect strobe
- 10-bit frame format: start bit + 8 data bits (LSB first) + stop bit
- Small ASCII ROM storing the repeating message "0123"
- Idle-high TX line (standard UART/RS232 framing)
- FSM-based design (IDLE → LOAD → SHIFT)

## Hardware

- **Board:** Digilent Basys 3 (Artix-7 FPGA)
- **Clock:** 100 MHz onboard oscillator (pin W5)
- **Reset:** Center button btnC (pin U18, active high)
- **TX:** Onboard USB-UART bridge (pin B16)

## Files

| File | Description |
|------|-------------|
| `uart.vhd` | Top-level UART transmitter (baud gen + FSM) |
| `uart_top.xdc` | Basys 3 pin constraints |

## How to Use

1. Open Vivado and create a new RTL project
2. Add `uart.vhd` as a design source
3. Add `uart_top.xdc` as a constraints file
4. Set `uart_top` as the top module
5. Run Synthesis → Implementation → Generate Bitstream
6. Program the Basys 3

## Viewing Output

Open a serial terminal (PuTTY, Tera Term, etc.) with these settings:

- Baud rate: 9600
- Data bits: 8
- Parity: None
- Stop bits: 1

You should see `0123` repeating continuously.

## Tools

- Xilinx Vivado Design Suite
- VHDL (IEEE 1076)
