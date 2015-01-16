#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
cd sp-kernel
SIZE=$1;
nohup /home/jonkil/MATLAB/bin/matlab -nojvm -nodisplay -r "experiment_setup; run_runtimes('PROTO',$SIZE); exit" > my_code/logs/proto_runtimes$SIZE.log 2>&1
