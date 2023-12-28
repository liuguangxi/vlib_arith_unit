#!/bin/bash

mkdir -p log

vlib work
vlog -f script/filelist.f

for a in {0..2}; do
    for w in {1..12}; do
        vsim -c tb_AU_decode -gWidth=${w} -gArch=${a} -do "run -all" -l log/run_W${w}_A${a}.log
    done
done
