# Grundlagen der Technischen Informatik
___
## GHDL

```console
ghdl -a --workdir=ghdl_work ghdl_work/hello.vhd
```

```console
ghdl -r --workdir=ghdl_work hello

ghdl_work/hello.vhd:5:1:@0ms:(assertion note): Willkommen zu GdTI!
```

___

## simple OR Gate
```console
ghdl -a design.vhd
ghdl -a orgate.vhd
ghdl -a testbench.vhd
ghdl -r testbench --vcd=testbench.vcd
gtkwave testbench.vcd
```

![gtkwave Screenshot](gtkwave.png?raw=true "gtkwave Screenshot")