#!/bin/sh

DATA=$1

for SIZE in $(cat "${DATA}_sizes"); do
qsub run_fw.sh $DATA $SIZE
qsub run_vor.sh $DATA $SIZE
qsub run_sf.sh $DATA $SIZE
done

