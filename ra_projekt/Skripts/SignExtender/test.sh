#!/bin/bash
ghdl -a --std=08 Packages/constant_package.vhdl
ghdl -a --std=08 Packages/type_package.vhdl

ghdl -a --std=08 Komponenten/SignExtender/signExtension.vhdl
ghdl -a --std=08 Komponenten/SignExtender/signExtension_tb.vhdl

ghdl -e --std=08 signExtension_tb
ghdl -r --std=08 signExtension_tb --vcd=signExtension_tb.vcd
