#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
cd sp-kernel

for SIZE in $(cat proto_sizes); do
qsub sh -F "proto_fw $SIZE"
done

