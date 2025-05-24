#!/bin/bash

rm *.cf

ghdl -a --std=08 Packages/constant_package.vhdl
ghdl -a --std=08 Packages/types.vhdl

ghdl -a --std=08 Komponenten/Registerfile/register_file.vhdl

ghdl -a --std=08 Testbenches/Registerfile/register_file_tb.vhdl

ghdl -e --std=08 register_file_tb
ghdl -r --std=08 register_file_tb --vcd=reg_tb.vcd

