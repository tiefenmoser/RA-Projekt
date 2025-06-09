#!/bin/bash
rm *.cf

ghdl -a --std=08 Packages/constant_package.vhdl
ghdl -a --std=08 Packages/type_packages.vhdl
ghdl -a --std=08 Packages/types.vhdl
ghdl -a --std=08 Packages/Util_Asm_Package.vhdl
 
ghdl -a --std=08 Komponenten/Decoder/decoder.vhdl
ghdl -a --std=08 Testbenches/Decoder/decoder_tb.vhdl
 
ghdl -e --std=08 decoder_tb
ghdl -r --std=08 decoder_tb  --wave=decoder.ghw
