# Secure Real-Time Sensor Communication System Using SPN Encryption (ZedBoard FPGA)

## Overview

This project implements a **fully hardware-based secure real-time sensor communication system** on a Zynq-7000 FPGA (ZedBoard). The system ensures deterministic and low-latency data transmission by integrating an **SPN (Substitution–Permutation Network) encryption engine** directly in programmable logic.

Unlike processor-based solutions, this design operates entirely in hardware, enabling **true real-time performance, enhanced security, and predictable timing behavior**.

---

## Key Features

* 100% hardware implementation using Verilog RTL
* Real-time deterministic operation at 100 MHz PL clock
* Custom 8-bit SPN encryption engine
* Secure UART data transmission at 115200 bps
* Fully pipelined data path architecture
* Sub-millisecond system latency
* Real-time ultrasonic distance measurement support

---

## System Architecture

The hardware pipeline consists of the following stages:

```
Sensor → SPN Encryption → Packetization → UART Transmitter → PC Receiver
```

### Data Flow Description

1. Sensor data is captured from an ultrasonic distance sensor.
2. The SPN encryption engine secures the data in hardware.
3. Data packets are formatted with checksum for integrity.
4. Encrypted packets are transmitted via UART to a PC.
5. Real-time monitoring is performed at the receiver end.

---

## Hardware Platform

* FPGA Board: ZedBoard (Zynq-7000 SoC)
* Programmable Logic Clock: 100 MHz
* Communication Interface: UART
* Sensor Interface: Ultrasonic distance sensor

---

## SPN Encryption Engine

The custom hardware encryption module implements an 8-bit SPN structure including:

* XOR Key Mixing Stage
* 4-bit S-Box Substitution Layer
* Bit Permutation Layer
* Checksum Generation for Data Integrity

The encryption pipeline is fully hardware-optimized for low latency and high throughput.

---

## Design Characteristics

| Feature         | Specification                 |
| --------------- | ----------------------------- |
| Encryption Type | SPN (Hardware Implementation) |
| Data Width      | 8-bit                         |
| UART Speed      | 115200 bps                    |
| Clock Frequency | 100 MHz                       |
| Latency         | Sub-millisecond               |
| Architecture    | Fully pipelined               |
| Processing Type | Hardware-only (No CPU)        |

---

## Project Structure

```
project/
│── rtl/
│   ├── spn_encryptor.v
│   ├── uart_tx.v
│   ├── packetizer.v
│   ├── sensor_interface.v
│   └── top_module.v
│
│── constraints/
│── testbench/
│── docs/
│── README.md
```

---

## How to Run the Project

### Step 1: Open in FPGA Toolchain(Xilinx Vivado 2018 and above)

Use your FPGA development environment to open the project files.

### Step 2: Synthesize and Implement

Run synthesis, implementation, and generate bitstream.

### Step 3: Program the Board

Upload the bitstream to the ZedBoard.

### Step 4: Monitor UART Output

Connect UART to PC and observe encrypted real-time sensor data.

---

## Applications

This system can be applied in:

* Secure IoT sensor networks
* Industrial automation systems
* Real-time embedded security systems
* Defense and aerospace communication systems
* Hardware cryptography research

---

## Key Contributions

* Designed a hardware-only secure communication pipeline
* Implemented SPN encryption in FPGA logic
* Achieved deterministic real-time performance
* Developed a low-latency pipelined architecture

---

## Future Enhancements

Possible future improvements include:

* Higher bit-width encryption support
* Hardware decryption module
* Multi-sensor secure communication
* Integration with hardware key management
* Migration to high-speed serial interfaces

---

## Author

S. S. Jhotheeshwar

Electronics Engineering Student

Chennai Institute of Technology


---






