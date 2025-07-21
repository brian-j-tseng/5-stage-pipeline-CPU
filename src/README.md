# VLSI-Pipeline-CPU
5-stage pipelined RV32I CPU implementation with a floating-point ALU, Booth algorithm-based multiplier, and branch predictor; verified with a custom testbench, Superlint synthesis checks, ICC coverage validation, and full layout. 
## Table of Contents
1. [Features](#features)  
2. [Architecture](#architecture)  
3. [Directory Structure](#directory-structure)  
4. [Prerequisites](#prerequisites)  
5. [Build & Simulation](#build--simulation)  
6. [Verification & Coverage](#verification--coverage)  
7. [Synthesis & Layout](#synthesis--layout)  
8. [Usage](#usage)  
9. [Contributing](#contributing)  
10. [License](#license)  
11. [Contact](#contact)

## Features
- **Five pipeline stages**: IF → ID → EX → MEM → WB :contentReference[oaicite:0]{index=0}  
- **Floating-point ALU** supporting FLW/FSW and IEEE-754 single-precision ops :contentReference[oaicite:1]{index=1}  
- **Fast multiplier** using Booth’s algorithm for high-efficiency multiply :contentReference[oaicite:2]{index=2}  
- **Branch predictor** (bimodal) with flush on mispredict :contentReference[oaicite:3]{index=3}  
- **Hazard resolution**:
  - Structure hazards: separate instruction/data memories  
  - Control hazards: predictor-driven flush :contentReference[oaicite:4]{index=4}  
  - Data hazards: forwarding from MEM/WB back to EX :contentReference[oaicite:5]{index=5}

## Architecture
IF ─► ID ─► EX ─► MEM ─► WB
- **IF (Instruction Fetch)**: fetch instruction from IM  
- **ID (Instruction Decode)**: decode opcode, read registers, sign-extend immediates  
- **EX (Execute)**: perform ALU/FPU operations, calculate branch targets  
- **MEM (Memory Access)**: data load/store via DM + load-size filter  
- **WB (Write Back)**: write results back to register file  

## Directory Structure
.
├── src/ # Verilog RTL: pipeline, ALU, FPU, multiplier, predictor
├── tests/ # Custom Verilog testbench & test programs
├── docs/ # Design documents & diagrams
├── layout/ # Physical layout files
├── scripts/ # Build & synthesis scripts
├── LICENSE
└── README.md

## Prerequisites
- **Verilog simulator** (any compliant RTL simulator)  
- **SuperLint** for static linting :contentReference[oaicite:6]{index=6}  
- **Synopsys ICC** for coverage, synthesis, and layout :contentReference[oaicite:7]{index=7}  

---

## Build & Simulation
```bash
# From project root:
make build       # compile RTL + testbench
make sim         # run tests; prints "simulation pass" on success
Verification & Coverage
Static analysis via SuperLint reports zero critical violations CPU report

ICC coverage:

Block coverage: 100%

Expression coverage: 100%

Toggle coverage: 89% CPU report

## Synthesis & Layout
Synthesis timing: clock period = 14 ns (≥ 71 MHz) with no setup/hold violations

Physical layout: floorplan, pin-out, and DRC/LVS clean 

