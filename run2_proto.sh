#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
#cd sp-kernel

nohup /home/jonkil/MATLAB/bin/matlab -nojvm -nodisplay -r "experiment_setup; run_erracccombined('PROTO',0); exit" > my_code/logs/proto_erracccombined0.log 2>&1


for SIZE in $(cat proto_sizes); do
qsub proto_erracc.sh $SIZE
qsub proto_disterr.sh $SIZE
done

