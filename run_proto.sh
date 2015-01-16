#!/bin/sh
#export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
#cd sp-kernel

for SIZE in $(cat proto_sizes); do
qsub proto_fw.sh $SIZE
qsub proto_vorPre.sh $SIZE
qsub proto_sf.sh $SIZE
done

