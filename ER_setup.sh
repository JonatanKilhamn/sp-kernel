#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
cd sp-kernel
nohup /home/jonkil/MATLAB/bin/matlab -nojvm -nodisplay < my_code/er_setup.m > my_code/logs/ER_setup.log 2>&1