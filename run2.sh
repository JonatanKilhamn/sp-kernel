#!/bin/sh

DATA=$1

for SIZE in $(cat ${DATA}_sizes); do
qsub run_erracc.sh $DATA $SIZE
qsub run_disterr.sh $DATA $SIZE
done

qsub run_runtimes.sh $DATA $SIZE
