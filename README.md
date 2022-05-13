# Abstract
The goal of this Project is to design a RISC-V processor with 5 pipeline stages. This version of the RISC-V processor supports only a limited subset of the whole RV32I instruction set, but in the design here reported all the standard instructions except ECALL, EBREAK, and FENCE are implemented. 

![Figure 0: RISC-V Chip view diagram](https://github.com/abdelazeem201/5-Stage-Pipeline-RISC-V-RV32I/blob/main/Figures/riscv_mpu.png)

The processor is tested by simulating the execution of a program that computes the minimum absolute value of an array of integers. After that, a custom instruction is added in order to compute the absolute value in a single clock cycle using some additional hardware. At this point the program is improved using the new instruction and simulated once again. Finally, a comparison between the two version is made in order to evaluate the advantages and the disadvantages of the two approaches. Both the version of the processor are synthesized in a 45nm standard-cell library and then place-and-routed in a physical design.

Table of Contents
=================
* [Abstract](#Abstract)
* [RISC-V Features](#Features)
   * [Supported instruction set](#Supported-instruction-set)
   * [Memory and addressing space](#Memory-and-addressing-space)
   * [Instruction Memory](#instruction-memory)
# Features

| 32-bit RISC CPU  | 
| -------------    | 
| Five stages pipeline with forwarding  | 
| Automatic hazard detection            | 
| Up to 4GB of addressing space         |
| Branch target buffer with 4-way 8-set associative cache 8-bit TAG, LRU policy replacement |
|Ready for multi-cycle arithmetic operations |
| Absolute value custom instruction |

| 45 nm CMOS technology |
| --------------------- |
| Max clock frequency: 500MHz |
| Supply voltage: 1:1V |
| Total power dissipation: 15:21mW |
| Silicon die: 226 μm x 226 μm |

# RISC-V

The top level view of the processor is shown in figure 1.1, it has in addition to the clock and the reset
ports, an interface for the IRAM (Instruction RAM) and one for the DRAM (Data RAM). Inside it
we find the following blocks:

• The datapath: it is the block where both the memories are connected from the outside except
for the DRAM write enable that is driven by the CU (Control Unit). Furthermore it receives the
control from the CU, the FU (Forwarding Unit), and the HDU (Hazard Detection Unit), while
the only output signal is the misprediction one, used by the BPU (Branch Prediction Unit) to
inform the HDU that an hazard have occured.

• A set of registers used to keep track of all the instructions running inside the pipeline.

• The CU, which receives the instruction in the ID stage and according to this produces the
appropriate control outputs.

• A set of registers that propagate the CU outputs, in order to send the signals to the datapath
at the right time depending on the pipeline stage where they are used.

• The FU that reading all the instruction in execution from the second stage to the last stage
can detect the data dependencies and, when it is possible, avoids the data hazard bypassing the
data between the pipeline stages.

• The HDU, according on the instruction in the second and in the third stage and on the mispre-
diction signal (received by the BPU inside the datapath) it has the ability to stop some pipeline
stages and to discard an already fetched instruction, in order to avoid any kind of hazard.

![Figure 1.1: RISC-V top view diagram](https://github.com/abdelazeem201/5-Stage-Pipeline-RISC-V-RV32I/blob/main/Figures/riscv.png)

# Supported-instruction-set
1. Register-to-register-operations: ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND.
2. Immediate operations: ADDI, SLLI, SLTI, SLTIU, XORI, SRLI, SRAI, ORI, ANDI.
3. Load: LB, LH, LW, LBU, LHU.
4. Store: SB, SH, SW.
5. Branch: BEQ, BNE, BLT, BGE, BLTU, BGEU.
6. Jump: JAL, JALR.
7. Upper immediate operations: AUIPC, LUI.

# Memory-and-addressing-space
Both the memories (IRAM and DRAM) are simulated with a VHDL file only for the testbench, because
they are not synthesizable with the used library and anyway they are designed to be connected from
the outside.

The two address spaces are disjointed, so a specific address corresponds to only one specific memory.
Actually it would be possible to overlap the addresses for instructions and for data but this is not
compliant with the RISC-V specifications.

In this design the IRAM is assumed to keep the space 0x0040XXXX, while the DRAM handle
the space 0x1001XXXX. Both the memory has 16 bits of address and start from 0x0000 so they are
activated by means of the chip select only when the other 16 bits correspond to their address space.
The program counter is designed to start from 0x00400000 when reset, so there is no need to jump to
this address at the power on

# Testbench

In order to test the design, the memories described in the previous chapter are connected to the
processor using a verilog top-level testbench, driving properly the chip selects. In addition to the
DRAM, the IRAM, and the DUT (device under test), there is also a clock and reset generator block
needed to initialize the sequential components and to feed them with a clock. In figure 2.1 this
organization is shown

![Figure 2.1: Testbench structure.](https://github.com/abdelazeem201/5-Stage-Pipeline-RISC-V-RV32I/blob/main/Figures/testbench.png)
 
The designs are simulated three times: pre-synthesis, post-synthesis, and post-place-and-route. in the Figure 2.2 is Pre-synthesis Simulation.

![Figure 2.2 Pre-synthesis.](https://github.com/abdelazeem201/5-Stage-Pipeline-RISC-V-RV32I/blob/main/Figures/simulation.png)




# Reference
1. [Digital Design and Computer Architecture, RISC-V Edition](https://www.elsevier.com/books/digital-design-and-computer-architecture/harris/978-0-12-820064-3)
2. [Computer Organization and Design RISC-V Edition](https://www.elsevier.com/books/computer-organization-and-design-risc-v-edition/patterson/978-0-12-812275-4)
3. [York University - Computer Organization and Architecture (EECS2021E)](https://youtube.com/playlist?list=PL-Mfq5QS-s8iUJpNzCOtQKRfpswCrPbiW)
4. [risc-v foundation](https://riscv.org/)
