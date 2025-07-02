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
ghdl -a --std=08 Komponenten/Multiplexer/four_port_mux.vhdl

ghdl -a --std=08 Komponenten/ALU/shifter.vhdl
ghdl -a --std=08 Komponenten/ALU/slt.vhdl
ghdl -a --std=08 Komponenten/ALU/sltu.vhdl

ghdl -a --std=08 Komponenten/ALU/alu.vhdl

ghdl -a --std=08 Komponenten/Decoder/decoder.vhdl

ghdl -a --std=08 Komponenten/Registerfile/register_file.vhdl


ghdl -a --std=08 Komponenten/SignExtender/signExtension.vhdl


ghdl -a --std=08 Komponenten/Cache/instruction_cache.vhdl
ghdl -a --std=08 Komponenten/Cache/data_memory.vhdl

ghdl -a --std=08 Komponenten/Register/PipelineRegister.vhdl
ghdl -a --std=08 Komponenten/Register/Single_bit_PipelineRegister.vhdl
ghdl -a --std=08 Komponenten/Register/controlwordregister.vhdl

ghdl -a --std=08 RISCV/RIUBS_bp_lu_only_RISC_V.vhdl


ghdl -a --std=08 Testbenches/RISCV/riubs_only_RISC_V_tb3.vhdl
ghdl -e --std=08 riubs_only_RISC_V_tb3
ghdl -r --std=08 riubs_only_RISC_V_tb3 --wave=riubs3_riscv.ghw --stop-delta=1000000000000000000
