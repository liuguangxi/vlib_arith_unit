#!/bin/bash

mkdir -p log

vlib work
vlog -f script/filelist.f

for a in {0..2}; do
    for w in {1..16}; do
        vsim -c tb_AU_int_log2 -gWidth=${w} -gArch=${a} -do "run -all" -l log/run_W${w}_A${a}.log
    done
    for w in {20,50,100,200,500,1000,1024}; do
        vsim -c tb_AU_int_log2 -gWidth=${w} -gArch=${a} -do "run -all" -l log/run_W${w}_A${a}.log
    done
done
