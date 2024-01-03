# Verilog Library of Arithmetic Units: Components


## Introduction
The library contains units for a comprehensive set of arithmetic operations. The units are made available as circuit generators implemented in parameterized structural and synthesizable Verilog code.

The Verilog code could be supported by recent synthesis and simulation tools, like Vivado, Design Compiler, ModelSim, VCS and so on.


## Components List

### AU_encode
* One-hot to binary encoder

### AU_decode
* Binary to one-hot decoder

### AU_prefix_xor
* Prefix XOR

### AU_bin2gray
* Binary to Gray converter

### AU_gray2bin
* Gray to binary converter
* Dependency: AU_prefix_xor