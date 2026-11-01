Sensor Hub RTL-to-GDS Implementation

A digital Sensor Hub designed using Verilog HDL and implemented through an RTL-to-GDS physical-design flow using OpenLane 2 and the SKY130 open-source PDK.

Project Overview

This project implements a digital Sensor Hub that selects data from multiple sensor inputs, buffers the selected data using a FIFO, controls the data flow through a finite state machine (FSM), and transmits the data serially using a UART transmitter.

The design demonstrates the digital design flow from RTL development and functional simulation to logic synthesis and physical implementation.

Architecture

The design consists of four main functional blocks:

1. Sensor Selector: Selects the data from Sensor 0 or Sensor 1.
2. FIFO Buffer: Temporarily stores sensor data before transmission.
3. FSM Controller: Coordinates the control sequence and data transfer.
4. UART Transmitter: Converts parallel data into serial output.

Design Flow

RTL Design → Functional Simulation → Yosys Synthesis → OpenLane 2 Physical Design → GDSII Generation → KLayout Inspection

RTL Modules

Module| Description
"sensor_hub_top.v"| Top-level integration
"sensor_selector.v"| Sensor input selection
"fifo.v"| Data buffering
"fsm_controller.v"| Control logic
"uart_tx.v"| UART serial transmission

Verification

Individual Verilog testbenches were developed for the FIFO, FSM controller, sensor selector, UART transmitter and integrated Sensor Hub.

Simulation was performed using Icarus Verilog, with waveform inspection using GTKWave.

Observed Simulation Behaviour

- Sensor 0 data: 25
- Sensor 1 data: 80
- UART transmission completion observed for both sensor transactions.

Simulation waveform files (".vcd") are included in the repository.

Synthesis

RTL synthesis was performed using Yosys.

The synthesis output includes:

- Synthesized Verilog netlist.
- Synthesis report.
- Generic logic synthesis statistics.

Physical Design Implementation

The design was implemented using:

- OpenLane 2
- SKY130A PDK
- Docker
- Ubuntu on WSL2

A 100 ns clock period was used as the initial design constraint.

Physical Design Outputs

File| Purpose
"sensor_hub_top.gds"| Final GDSII layout
"sensor_hub_top.def"| Physical design information
"sensor_hub_top.lef"| Layout abstract
"sensor_hub_top.sdc"| Timing constraints

The generated GDSII layout was opened and inspected using KLayout.

Timing Analysis

The inspected setup timing report showed:

- Setup slack (MET): approximately 79.785 ns
- Worst Negative Slack (WNS): 0 ns
- Total Negative Slack (TNS): 0 ns

These values correspond to the configured timing constraints and reported analysis corner.

Physical Verification

The project includes reports generated during physical implementation:

- Magic DRC report
- Netgen LVS report
- Antenna report
- OpenROAD timing reports

The inspected LVS report states: Circuits match uniquely.

DRC and antenna status should be interpreted from the corresponding reports.

Tools and Technologies

- Verilog HDL
- Icarus Verilog
- GTKWave
- Yosys
- OpenLane 2
- SKY130A PDK
- Docker
- Ubuntu / WSL2
- KLayout
- Git and GitHub

Key Learning Outcomes

- RTL design and modular Verilog coding.
- FSM-based digital control design.
- FIFO implementation and data buffering.
- UART serial communication.
- Functional simulation and waveform debugging.
- Logic synthesis using Yosys.
- RTL-to-GDS physical-design flow.
- Physical layout inspection using KLayout.
- Timing analysis and LVS report interpretation.

Project Status

RTL development, functional simulation, synthesis and GDSII generation have been completed. Physical verification results are documented in the included reports.

Repository Contents

The repository contains Verilog RTL modules, testbenches, simulation waveforms, synthesis outputs, physical-design files and verification reports.

Author

Subashree

Electronics Engineering – VLSI Design and Technology

GitHub: "subashreet18-pixel" (https://github.com/subashreet18-pixel)
