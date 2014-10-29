#!/bin/sh
cd sp-kernel
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
nohup /home/jonkil/MATLAB/bin/matlab -nojvm -nodisplay < my_code/fake_experiment.m > my_code/logs/fake_experiment.log 2>&1
