#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
cd sp-kernel
nohup /home/jonkil/MATLAB/bin/matlab -nojvm -nodisplay < my_code/run_erracccombined.m > my_code/logs/genP_erracccombined12.log 2>&1

