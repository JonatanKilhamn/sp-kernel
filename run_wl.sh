#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
cd sp-kernel
DATA=$1
SIZE=$2
nohup /home/jonkil/MATLAB/bin/matlab -nojvm -nodisplay -r "experiment_setup; run_wl('$DATA',$SIZE); exit" > my_code/logs/${DATA}_wl$SIZE.log 2>&1
