#!/bin/bash



#yes thats a hack but i dont really care the other way i know is to hardcode
#the path of every single file which is worse since i use more than 1 system.
#The right way would be with some bash magic thingy which i dont know
rm *.cf
pwd
ghdl -a --std=08 Packages/constant_package.vhdl
ghdl -a --std=08 Komponenten/ALU/half_add.vhdl
ghdl -a --std=08 Komponenten/ALU/full_add.vhdl
ghdl -a --std=08 Komponenten/ALU/variable_bit_add.vhdl

ghdl -a --std=08 Komponenten/ALU/gen_or.vhdl
ghdl -a --std=08 Komponenten/ALU/gen_xor.vhdl
ghdl -a --std=08 Komponenten/ALU/gen_and.vhdl

ghdl -a --std=08 Komponenten/ALU/shifter.vhdl

ghdl -a --std=08 Komponenten/ALU/slt.vhdl
ghdl -a --std=08 Komponenten/ALU/sltu.vhdl

ghdl -a --std=08 Komponenten/ALU/alu.vhdl

ghdl -a --std=08 Testbenches/ALU/my_alu_tb.vhdl

ghdl -e --std=08 my_alu_tb 
ghdl -r --std=08 my_alu_tb --vcd=my_alu_tb.vcd


if [ "$1" == "t" ]; then
    gtkwave $tb_name
fi
