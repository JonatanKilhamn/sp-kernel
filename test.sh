#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
/home/jonkil/MATLAB/bin/matlab -nojvm -nodisplay -r "fprintf(1,'Hej');exit;"
cat experiment_setup.m
