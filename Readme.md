# Pipelined RISC-V CPU with FPU and Booth Multiplier

This project implements a 5-stage pipelined RISC-V processor that supports floating-point instructions and a Booth multiplier.  
The full RTL-to-GDS flow was carried out using industry tools such as Design Compiler, ICC2, and layout verification utilities.

---

## 🔧 Features
- 5-stage pipeline: **IF → ID → EX → MEM → WB**  
- IEEE-754 single-precision FPU  
- Booth multiplier for signed multiplication
- branch predictor  
- Hazard detection & forwarding  
- 100 % functional coverage with custom testbench  
- Complete ASIC flow: SuperLint → Design Compiler → ICC2 → GDS export

---

## 🚀 Booth Multiplier Design
- Implements Radix-2 Booth’s Algorithm

- Efficient when the multiplier contains long runs of 1s

- Handles signed multiplication via mul rd, rs1, rs2

- Uses mulshift & mulshift_c for partial-product updates

---

## 🔬 FPU Implementation
- Mantissa normalization, exponent alignment, rounding, sign logic

- Data forwarding between consecutive FP ops

- Verified with waveform analysis (nWave)

---

## ✅ Verification Highlights
- Integer, floating-point, logic, and control test vectors

- 100 % coverage reported by Design Compiler

- Fixed predictor one-cycle delay & controller mis-decode issues

- Waveform back-tracing to resolve cross-stage hazards

---

## 🛠️ Tools Used
- SuperLint – RTL linting

- Design Compiler – Logic synthesis

- ICC2 – Place & route

- nWave – Waveform viewer

- Synopsys layout tools – DRC / LVS / GDS export

---

## 📚 References
VLSI System Design lecture notes

Computer Organization lecture notes

RISC-V Instruction Set Manual


