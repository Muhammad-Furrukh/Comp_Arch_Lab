# RISC-V Physical Memory Protection (PMP) Module

![RISC-V Logo](https://riscv.org/wp-content/uploads/2019/12/riscv-logo-1.png)

This repository contains a Verilog implementation of a standalone RISC-V Physical Memory Protection (PMP) module with comprehensive testbenches for verification.

## Table of Contents
- [Directory Structure](#directory-structure)
- [Module Interface](#module-interface)
- [Implementation Details](#implementation-details)
- [Simulation Guide](#simulation-guide)
  - [Using Batch Files](#using-batch-files)
  - [Manual QuestaSim Commands](#manual-questasim-commands)
- [Waveform Generation](#waveform-generation)
- [Configuration](#configuration)
- [Testing Strategy](#testing-strategy)

## Directory Structure
PMP/
├── defines/ # Package definitions
│ └── pkg.sv # PMP package with parameters and types
├── rtl/ # RTL implementation
│ └── pmp.sv # Main PMP module
└── testbench/ # Verification environment
├── simple_tb/ # Basic testbench
│ └── tb.sv # Simple test cases
└── self_driving_tb/ # Advanced testbench
├── tb.sv # Self-checking testbench
├── c.bat # Simulation script
└── clean.bat # Cleanup script

## Module Interface

### Inputs
| Signal      | Width  | Description                          |
|-------------|--------|--------------------------------------|
| `clock`     | 1      | System clock                         |
| `reset`     | 1      | Active-high reset                    |
| `wr_en`     | 1      | PMP CSR write enable                 |
| `oper`      | [1:0]  | Operation type (00=read, 01=write, 10=execute) |
| `size`      | [1:0]  | Access size (00=1B, 01=2B, 11=4B)    |
| `priv_mode` | [1:0]  | Privilege mode (00=M, 01=S, 10=U)    |
| `addr`      | [31:0] | Memory address to check              |
| `rw_addr`   | [31:0] | PMP register address                 |
| `wdata`     | [31:0] | Write data                           |

### Outputs
| Signal       | Width  | Description                          |
|--------------|--------|--------------------------------------|
| `rdata`      | [31:0] | Read data                            |
| `permission` | [1:0]  | 00=read fault, 01=write fault, 10=execute fault, 11=granted |

## Implementation Details

The PMP module features:
- Protection for **16 memory regions**
- **16 PMP address registers** (to define protected regions)
- **4 PMP configuration registers** (each controls 4 regions)
- Support for three privilege modes (Machine, Supervisor, User)
- Three access type checks (read, write, execute)
- Variable access size support (byte, half-word, word)

## Simulation Guide

### Using Batch Files

```bash
# Navigate to testbench directory
cd testbench/self_driving_tb/

# Run simulation (Windows)
c.bat

# Clean generated files (Windows)
clean.bat

```
## Manual QuestaSim Commands

```bash
# Create work library
vlib work

# Compile design and testbench
vlog ../../defines/pkg.sv
vlog ../../rtl/pmp.sv
vlog tb.sv

# Start simulation
vsim work.tb

# Run complete simulation
run -all

# Alternative: Run for specific time
run 1000ns
```

## Waveform Generation

```bash
# Open waveform window
view wave

# Add all signals
add wave -r /tb/pmp_inst/*

# Recommended wave groupings
add wave -group "Control" /tb/pmp_inst/clock /tb/pmp_inst/reset
add wave -group "Access" /tb/pmp_inst/oper /tb/pmp_inst/size /tb/pmp_inst/addr
add wave -group "Results" /tb/pmp_inst/permission

# Save waveform (optional)
wave zoom full
wave export -format wlf -image -output pmp_waveform.wlf
```

## Configuration
The PMP configuration is defined in defines/pkg.sv with these key parameters:

```systemverilog
parameter NUM_REGIONS = 16;      // Number of protected regions
parameter CFG_REGS = 4;          // Number of configuration registers
parameter ADDR_WIDTH = 32;       // Address bus width
```

## Testing
1. Simple Testbench:

- Basic read/write tests

- Permission checks for each privilege mode

- Edge case verification

2. Self-Driving Testbench:

- Randomized input generation

- Automatic result checking

- Coverage collection

- Stress testing with back-to-back operations

For questions or issues, please open an issue in the GitHub repository.