#!/bin/bash
for i in `seq 1 100`;
do
    echo i = $i
    mkdir -pv $i
    pushd $i
    rm -f output.txt times.txt
    date > times.txt
    export JANA_CALIB_URL=`$BUILD_SCRIPTS/calib_url_chooser.sh`
    echo JANA_CALIB_URL = $JANA_CALIB_URL
    ( time hd_root -PPLUGINS=danarest --nthreads=1 -PEVENTS_TO_KEEP=50 /cache/halld/RunPeriod-2017-01/rawdata/Run030300/hd_rawdata_030300_000.evio >& output.txt ; date >> times.txt ) &
    popd
done
