# Verilog Library of Arithmetic Units: Components


## Introduction
The library contains units for a comprehensive set of arithmetic operations. The units are made available as circuit generators implemented in parameterized structural and synthesizable Verilog code.
The Verilog code could be supported by recent synthesis and simulation tools, like Vivado, Design Compiler, ModelSim, VCS and so on.


## Components List

### AU_prefix_and
* Prefix AND

### AU_prefix_or
* Prefix OR

### AU_prefix_xor
* Prefix XOR

### AU_prefix_and_or
* Prefix AND-OR

### AU_encode
* One-hot to binary encoder

### AU_decode
* Binary to one-hot decoder

### AU_bin2gray
* Binary to Gray converter

### AU_gray2bin
* Gray to binary converter
* Dependency: AU_prefix_xor

### AU_inc_gray
* Gray incrementer
* Dependency: AU_prefix_and

### AU_inc_gray_c
* Gray incrementer with carry-in
* Dependency: AU_prefix_and

### AU_lead_zero_det
* Leading zeros detector (LZD)
* Dependency: AU_prefix_and

### AU_lead_one_det
* Leading ones detector (LOD)
* Dependency: AU_prefix_and

### AU_lead_sign_det
* Leading signs detector (LSD)
* Dependency: AU_prefix_and

### AU_int_log2
* Integer logarithm to base 2
* Dependency: AU_lead_zero_det, AU_prefix_and, AU_encode

### AU_inc
* Incrementer
* Dependency: AU_prefix_and

### AU_inc_c
* Incrementer with carry-in and carry-out
* Dependency: AU_prefix_and

### AU_dec
* Decrementer
* Dependency: AU_prefix_and

### AU_dec_c
* Decrementer with carry-in and carry-out
* Dependency: AU_prefix_and

### AU_incdec
* Incrementer-Decrementer
* Dependency: AU_prefix_and

### AU_incdec_c
* Incrementer-Decrementer with carry-in and carry-out
* Dependency: AU_prefix_and

### AU_full_adder
* Full adder

### AU_add
* Adder
* Dependency: AU_prefix_and_or

### AU_add_c
* Adder with carry-in and carry-out
* Dependency: AU_prefix_and_or

### AU_add_cfast
* Adder with fast carry-in and carry-out
* Dependency: AU_prefix_and_or

### AU_add_v
* Adder with carry-in and 2's compl. overflow flag
* Dependency: AU_prefix_and_or

### AU_sub
* Subtractor
* Dependency: AU_prefix_and_or

### AU_sub_cz
* Subtractor with carry-in, carry-out and zero flag
* Dependency: AU_prefix_and_or

### AU_sub_vz
* Subtractor with carry-in, 2's compl. overflow flag and zero flag
* Dependency: AU_prefix_and_or

### AU_neg
* 2's complementer
* Dependency: AU_prefix_and

### AU_neg_c
* Conditional 2's complementer
* Dependency: AU_prefix_and

### AU_absval
* Absolute value for 2's compl. number
* Dependency: AU_prefix_and

### AU_addsub
* Adder-Subtractor
* Dependency: AU_prefix_and_or

### AU_addsub_c
* Adder-Subtractor with carry-in and carry-out
* Dependency: AU_prefix_and_or

### AU_addsub_v
* Adder-Subtractor with carry-in and 2's compl. overflow flag
* Dependency: AU_prefix_and_or

### AU_sum_zero_det
* Fast zero-sum detector

## AU_cmp_eq
* Equality comparator

## AU_cmp6_uns
* Unsigned 6-function comparator
* Dependency: AU_prefix_and_or

## AU_cmp6_sgn
* Signed 6-function comparator
* Dependency: AU_prefix_and_or
