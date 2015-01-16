#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
#cd sp-kernel

ZERO=0
#qsub proto_erracc.sh $ZERO
#qsub proto_runtimes.sh $ZERO


for SIZE in $(cat proto_sizes); do
qsub proto_erracc.sh $SIZE
#qsub proto_disterr.sh $SIZE
qsub proto_runtimes.sh $SIZE

done

