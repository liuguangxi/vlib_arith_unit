#!/bin/bash

mkdir -p log

vlib work
vlog -f script/filelist.f

for w in {1..16}; do
    vsim -c tb_AU_bin2gray -gWidth=${w} -do "run -all" -l log/run_W${w}.log
done
for w in {20,50,100,200,500,1000,1024}; do
    vsim -c tb_AU_bin2gray -gWidth=${w} -do "run -all" -l log/run_W${w}.log
done
