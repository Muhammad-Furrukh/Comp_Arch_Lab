@echo off

:: Set the base directory relative to testbench
set BASE_DIR=D:\Documents\UET_Courses\6th_Semester\Computer_Architecture

:: Clean previous files
echo Cleaning old files...
if exist work rmdir /s /q work
del transcript *.vcd *.wlf 2>nul

:: Create work library
echo Creating work library...
vlib work

:: Compile all files with correct paths
echo Compiling Verilog files...
vlog -sv ^
+incdir+%BASE_DIR%/Lab/PMP/defines ^
%BASE_DIR%/Lab/PMP/defines/cep_define.sv ^
pmp_tb.sv ^
%BASE_DIR%/Lab/PMP/rtl/tor.sv ^
%BASE_DIR%/Lab/PMP/rtl/addr_check_n.sv ^
%BASE_DIR%/Lab/PMP/rtl/na4.sv ^
%BASE_DIR%/Lab/PMP/rtl/napot.sv ^
%BASE_DIR%/Lab/PMP/rtl/pmp.sv ^
%BASE_DIR%/Lab/PMP/rtl/pmp_check.sv ^
%BASE_DIR%/Lab/PMP/rtl/pmp_registers.sv


:: Run simulation
echo Starting simulation...
vsim -c -voptargs="+acc" -do "run -all; quit" pmp_tb

echo Simulation complete!
pause