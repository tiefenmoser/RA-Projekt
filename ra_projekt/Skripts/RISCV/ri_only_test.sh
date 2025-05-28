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
ghdl -a --std=08 Komponenten/Multiplexer/gen_mux.vhdl

ghdl -a --std=08 Komponenten/ALU/shifter.vhdl
ghdl -a --std=08 Komponenten/ALU/slt.vhdl
ghdl -a --std=08 Komponenten/ALU/sltu.vhdl

ghdl -a --std=08 Komponenten/ALU/alu.vhdl

ghdl -a --std=08 Komponenten/Decoder/decoder.vhdl

ghdl -a --std=08 Komponenten/Registerfile/register_file.vhdl


ghdl -a --std=08 Komponenten/SignExtender/signExtension.vhdl


ghdl -a --std=08 Komponenten/Cache/instruction_cache.vhdl

ghdl -a --std=08 Komponenten/Register/PipelineRegister.vhdl
ghdl -a --std=08 Komponenten/Register/controlwordregister.vhdl

ghdl -a --std=08 RISCV/RI_only_RISC_V.vhdl


ghdl -a --std=08 Testbenches/RISCV/ri_only_RISC_V_tb.vhdl
ghdl -e --std=08 ri_only_RISC_V_tb
ghdl -r --std=08 ri_only_RISC_V_tb --vcd=ri_riscv.vcd
#--wave=ri_riscv.ghw
