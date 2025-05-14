#!/bin/bash
# usage: ./create_module <dir_name> <komponent_name>


aufgabe_dir="ra_projekt"
#mkdir -p $aufgabe_dir


mkdir -p $aufgabe_dir/Komponenten/$1
mkdir -p $aufgabe_dir/Testbenches/$1
mkdir -p $aufgabe_dir/Skripts/$1
echo "Created Sub dirs"

touch $aufgabe_dir/Komponenten/$1/$2.vhdl
touch $aufgabe_dir/Testbenches/$1/$2_tb.vhdl
echo "Created Vhdl files"


filename=$aufgabe_dir/Skripts/$1/test.sh
if [ ! -f $filename ]
then
    echo "#!/bin/bash" >>  $filename
    echo "rm *.cf" >> $filename
	echo "ghdl -a --std=08 Packages/constant_package.vhdl" >> $filename
	echo "ghdl -a --std=08 Packages/type_package.vhdl" >> $filename
	echo " " >> $filename
	echo "ghdl -a --std=08 Komponenten/${1}/${2}.vhdl" >> $filename
	echo "ghdl -a --std=08 Testbenches/${1}/${2}_tb.vhdl" >> $filename
	echo " " >> $filename
	echo "ghdl -e --std=08 ${2}_tb" >> $filename
	echo "ghdl -r --std=08 ${2}_tb --vcd=${2}_tb.vcd" >> $filename

    echo "Created test.sh"
else
    echo "test script already exists"
fi
