#!/bin/bash
# usage: ./create_abgabe <versuch_nummer> <aufgabe> <komponent_name>


aufgabe_dir="Tiefenmoser_Cornelius_Versuch${1}_Aufgabe${2}"
mkdir -p $aufgabe_dir



echo "Created directory"

mkdir -p $aufgabe_dir/Packages
mkdir -p $aufgabe_dir/Risc-V


mkdir -p $aufgabe_dir/Komponenten/$3
mkdir -p $aufgabe_dir/Testbenches/$3
mkdir -p $aufgabe_dir/Skripts/$3
echo "Created Sub dirs"

filename=$aufgabe_dir/Skripts/$3/test.sh
if [ ! -f $filename ]
then
    echo "#!/bin/bash" >>  $filename
    echo "Created test.sh"
else
    echo "test script already exists"
fi