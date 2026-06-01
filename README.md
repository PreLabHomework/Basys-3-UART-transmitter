# Basys 3 UART Transmitter

A VHDL UART transmitter implemented on the Digilent Basys 3 Artix 7 FPGA. The design divides the onboard 100 MHz clock down to a 9600 baud timing reference, builds standard 10 bit UART frames, and continuously transmits an ASCII message through the onboard USB UART bridge.

## What it does

The transmitter sends the repeating message `0123` over serial using standard UART framing. When connected to a serial terminal at 9600 baud, the terminal displays the message continuously.

## Features

- 9600 baud UART transmission
- 100 MHz to 9600 baud clock divider
- Edge detect baud strobe generation
- 10 bit UART frame format: start bit, 8 data bits LSB first, stop bit
- ASCII ROM storing the repeating message `0123`
- Idle high TX line for standard UART and RS232 style framing
- FSM based design with IDLE, LOAD, and SHIFT states
- Hardware validated through the Basys 3 onboard USB UART bridge

## Hardware

- Board: Digilent Basys 3
- FPGA: Xilinx Artix 7
- Clock: 100 MHz onboard oscillator, pin W5
- Reset: Center button btnC, pin U18, active high
- TX: Onboard USB UART bridge, pin B16

## Files

| File | Description |
| --- | --- |
| `uart.vhd` | Top level UART transmitter with baud generator, ROM, and FSM |
| `uart_top.xdc` | Basys 3 pin constraints |

## Design overview

The design has three main blocks:

1. Baud rate generator  
   Divides the 100 MHz system clock to produce a 9600 baud timing strobe.

2. Message ROM  
   Stores the ASCII characters for the repeating message `0123`.

3. UART transmit FSM  
   Loads each character into a 10 bit frame and shifts it out on the TX line using UART timing.

How to run
Open Vivado and create a new RTL project.
Add uart.vhd as a design source.
Add uart_top.xdc as a constraints file.
Set uart_top as the top module.
Run Synthesis, Implementation, and Generate Bitstream.
Program the Basys 3 board.
Viewing output

Open a serial terminal such as PuTTY, Tera Term, or the Arduino Serial Monitor with these settings:

Baud rate: 9600
Data bits: 8
Parity: None
Stop bits: 1

Expected output:
0123012301230123...

Skills demonstrated:
VHDL hardware design
FPGA clock division
FSM based control logic
UART and RS232 style serial communication
Xilinx Vivado workflow
Basys 3 hardware validation


```text
start bit | data bit 0 | data bit 1 | ... | data bit 7 | stop bit
