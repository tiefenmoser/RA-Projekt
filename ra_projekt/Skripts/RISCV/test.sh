#!/bin/bash

rm *.cf


ghdl -a --std=08 Packages/constant_package.vhdl
ghdl -a --std=08 Packages/type_packages.vhdl
ghdl -a --std=08 Packages/types.vhdl
ghdl -a --std=08 Packages/Util_Asm_Package.vhdl

ghdl -a --std=08 Komponenten/ALU/half_add.vhdl
ghdl -a --std=08 Komponenten/ALU/full_add.vhdl
ghdl -a --std=08 Komponenten/ALU/variable_bit_add.vhdl

ghdl -a --std=08 Komponenten/ALU/gen_or.vhdl
ghdl -a --std=08 Komponenten/ALU/gen_xor.vhdl
ghdl -a --std=08 Komponenten/ALU/gen_and.vhdl

ghdl -a --std=08 Komponenten/ALU/shifter.vhdl

ghdl -a --std=08 Komponenten/ALU/alu.vhdl

ghdl -a --std=08 Komponenten/Decoder/decoder.vhdl

ghdl -a --std=08 Komponenten/Registerfile/register_file.vhdl


#ghdl -a --std=08 Komponenten/SignExtender/signExtension.vhdl


ghdl -a --std=08 Komponenten/Cache/instruction_cache.vhdl

ghdl -a --std=08 Komponenten/Register/PipelineRegister.vhdl
ghdl -a --std=08 Komponenten/Register/controlwordregister.vhdl

ghdl -a --std=08 RISCV/R_only_RISC_V.vhdl


ghdl -a --std=08 Testbenches/RISCV/R_only_RISC_V_tb.vhdl
ghdl -e --std=08 R_only_RISC_V_tb
ghdl -r --std=08 R_only_RISC_V_tb --vcd=riscv.vcd


ghdl -a --std=08 Testbenches/RISCV/R_only_RISC_V_2_tb.vhdl
ghdl -e --std=08 R_only_RISC_V_2_tb
ghdl -r --std=08 R_only_RISC_V_2_tb --vcd=riscv.vcd
