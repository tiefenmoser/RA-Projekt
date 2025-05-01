#!/bin/bash

rm *.cf

ghdl -a --std=08 Packages/constant_package.vhdl
ghdl -a --std=08 Komponenten/Multiplexer/gen_mux.vhdl

ghdl -a --std=08 Testbenches/Multiplexer/gen_mux_tb.vhdl

ghdl -e --std=08 gen_mux_tb
ghdl -r --std=08 gen_mux_tb
