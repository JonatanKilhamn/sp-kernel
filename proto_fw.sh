#!/bin/sh
export LD_LIBRARY_PATH="/home/jonkil/lib:$LD_LIBRARY_PATH"
cd sp-kernel
SIZE=$1;
#nohup matlab -nojvm -nodisplay -r "experiment_setup; run_test('PROTO',$SIZE); exit" > my_code/logs/test_proto$SIZE.log 2>&1
echo $SIZE

