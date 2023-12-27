#!/bin/bash

mkdir -p log

vlib work
vlog -f script/filelist.f

for w in {1..128}; do
    vsim -c tb_AU_encode -gWidth=${w} -do "run -all" -l log/run_W${w}.log
done
