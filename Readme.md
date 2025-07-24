# 5-Stage Pipelined RISC-V CPU  
*with IEEE-754 FPU, Booth Multiplier, and Branch Predictor*

> **Course:** VLSI System Design &nbsp;|&nbsp; **Target ISA:** RV32I / RV32F / RV32M  
> **Flow:** RTL → Synthesis → Place-and-Route → GDSII  

---

## 1. Overview
This project implements a classic 5-stage pipeline (IF → ID → EX → MEM → WB) and extends it with:

- **IEEE-754 Single-Precision FPU**
- **Radix-2 Booth Multiplier**
- **2-bit Bimodal Branch Predictor**
- **Hazard Detection & Forwarding**

A complete ASIC flow is demonstrated using **SuperLint**, **Synopsys Design Compiler**, **ICC2**, and layout verification tools. All RTL is written in Verilog - SystemVerilog.

---

## 2. Key Features
| Category | Details |
|----------|---------|
| **Pipeline** | 5 stages, fully interlocked, bypass paths for ALU & FPU |
| **FPU Ops** | `FLW / FSW / FADD.S / FSUB.S / FMUL.S / FMIN.S / FMAX.S / FEQ.S / FLT.S / FLE.S / FCVT.W.S / FCVT.WU.s / FCVT.S.W / FCVT.S.WU / FMV.X.W / FMV.X.W |
| **Integer ALU** | Full RV32I + (`MUL`) | 
| **Branch Predictor** | one level bimodal predictor |
| **Multiplier** | booth algorithm |
| **Verification** | Custom testbench, 100 % block & expression coverage , 89 % toggle |
| **Flow** | Lint → Compile → P&R → DRC/LVS → **GDS** output |

---

## 3. Architecture
 ```markdown
>   ![Architecture](doc/Architecture.png)
>   ```

---

## 4. Verification
Integer Core Test (prog0) – RV32I arithmetic / logic

Multiply Test (prog4) – RV32M MUL stress-test

Floating-Point Test (prog3) – RV32F load/store, ALU ops

System-level Programs – Merge-sort, Fibonacci

All programs write results to data memory; a Python test-harness compares against golden values and prints simulation pass on success.

---

## 6. Results
### 6.1 Lint & Coverage
Metric	Result
SuperLint	0 blocking errors
Block Coverage	100 %
Expression Coverage	100 %
Toggle Coverage	89 %

###　6.2 ⇨ Synthesis Results (placeholder)
Replace the table below after running final compile_ultra / report_timing, report_area, report_power.

Metric	Value	Note
Clock period	<!-- 14 ns -->	Target = 14 ns (≈ 71 MHz)
Setup Slack	<!-- > 0 ns -->	
Hold Slack	<!-- > 0 ns -->	
Cell Area	<!-- xxxx µm² -->	
Total Power	<!-- xxx mW -->	

###　6.3 ⇨ Layout Results (placeholder)
Insert DEF/GDS screenshots and pin diagram here.

Core Area: <!-- x µm × y µm -->

Die Area : <!-- x µm × y µm -->

## 7. Future Work ⭐
Cache Integration – A parameterised Harvard-style cache module (I-Cache & D-Cache) has been prototyped but is not yet connected to the CPU pipeline. Future steps:

Add AXI-lite wrapper between cache and memories

Insert stall logic for cache miss penalties

Re-run timing and area analysis with caches enabled

## 8. References
VLSI System Design – Course Lecture Notes

Computer Organization – Course Lecture Notes

RISC-V ISA Specification
