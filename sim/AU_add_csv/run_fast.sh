#!/bin/bash

mkdir -p log

vlib work
vlog -f script/filelist.f

for w in {1..5}; do
    vsim -c tb_AU_add_csv -gWidth=${w} -do "run -all" -l log/run_W${w}.log
done
for w in {10,20,50,100,200,500,512}; do
    vsim -c tb_AU_add_csv -gWidth=${w} -do "run -all" -l log/run_W${w}.log
done
