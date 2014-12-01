#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
cd sp-kernel
nohup /home/jonkil/MATLAB/bin/matlab -nojvm -nodisplay < my_code/run_kernels.m > my_code/logs/genP_kernels5.log 2>&1
