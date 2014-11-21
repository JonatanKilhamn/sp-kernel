#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
cd sp-kernel
nohup /home/jonkil/MATLAB/bin/matlab -nojvm -nodisplay < my_code/roadData_fwcombined.m > my_code/logs/roadData_fwcombined7.log 2>&1
