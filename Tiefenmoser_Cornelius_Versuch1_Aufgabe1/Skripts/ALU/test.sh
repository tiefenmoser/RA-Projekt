#!/bin/bash

cur_dir= pwd 

cd $cur_dir
cd ..
cd .. #yes thats a hack but i dont want to do string logic

ghdl -a /Packages/constant_package.vhdl
ghdl -a /Komponenten/ALU/half_add.vhdl
ghdl -a /Komponenten/ALU/full_add.vhdl

ghdl -e  fa_tb
ghdl -r  fa_tb --vcd=fa_tb.vcd
