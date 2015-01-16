#!/bin/sh

DATA=$1

# Get the last line (last size in the list)
SIZE=$(sed -e '$!d' ${DATA}_sizes)

qsub run_erracccombined.sh $DATA $SIZE

