#!/bin/bash

rm *.cf


ghdl -a --std=08 Packages/constant_package.vhdl
ghdl -a --std=08 Packages/type_packages.vhdl
ghdl -a --std=08 Packages/types.vhdl
ghdl -a --std=08 Packages/Util_Asm_Package.vhdl

ghdl -a --std=08 Komponenten/SignExtender/signExtension.vhdl
ghdl -a --std=08 Testbenches/SignExtender/signExtension_tb.vhdl

ghdl -e --std=08 signExtension_tb
ghdl -r --std=08 signExtension_tb --vcd=signExtension_tb.vcd
