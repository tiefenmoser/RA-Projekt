#!/bin/bash



#yes thats a hack but i dont really care the other way i know is to hardcode
#the path of every single file which is worse since i use more than 1 system.
#The right way would be with some bash magic thingy which i dont know
rm *.cf
pwd
ghdl -a Packages/constant_package.vhdl
ghdl -a Komponenten/ALU/half_add.vhdl
ghdl -a Komponenten/ALU/full_add.vhdl
ghdl -a Komponenten/ALU/variable_bit_add.vhdl

ghdl -a Komponenten/ALU/gen_or.vhdl
ghdl -a Komponenten/ALU/gen_xor.vhdl
ghdl -a Komponenten/ALU/gen_add.vhdl

#ghdl -a Komponenten/ALU/slt.vhdl
#ghdl -a Komponenten/ALU/sltu.vhdl

ghdl -a Komponenten/ALU/alu.vhdl

tb_name= "my_alu_tb"
ghdl -e  Testbenches/ALU/$tb_name
ghdl -r  Testbenches/ALU/$tb_name --vcd=$tb_name.vcd


if [ "$1" == "t" ]; then
    gtkwave $tb_name
fi