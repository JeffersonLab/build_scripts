#!/bin/bash
# test sim-recon: run hd_root with various plugins, and run hdgeant
# nonzero exit code signals runtime error or mistake in env. setup
# EVIO: path to evio file to process
# plugins.txt: list of plugins to test
initial_dir=$(pwd)
BUILD_SCRIPTS=/home/gluex/build_scripts
osrelease=$(perl $BUILD_SCRIPTS/osrelease.pl)
branch=$1
target_dir=/work/halld/pull_request_test/sim-recon^$branch/tests
rm -rf $target_dir; mkdir $target_dir; cd $target_dir
cp $BUILD_SCRIPTS/pull_request/plugins.txt .
cp $BUILD_SCRIPTS/pull_request/control.in .
LOG=log; mkdir $LOG
source ../$osrelease/setenv.sh
EVIO=/work/halld/pull_request_test/hd_rawdata_003180_000.evio
EVENTS=500
THREADS=8
TLIMIT=60
echo "Test summary" > summary.txt
for plugin in $(cat plugins.txt); do
    echo -e "\nTesting $plugin ..." >> summary.txt
    timeout $TLIMIT hd_root -PNTHREADS=$THREADS -PEVENTS_TO_KEEP=$EVENTS $EVIO -PPLUGINS=$plugin >& $LOG/$plugin.txt
    if test $? -ne 0; then
        echo "$plugin failed."
    else
        echo "$plugin passed."
    fi >> summary.txt
done
function join { local IFS="$1"; shift; echo "$*"; }
plugins=$(join , $(cat plugins.txt))
echo -e "\nTesting all listed plugins at the same time ..." >> summary.txt
timeout $TLIMIT hd_root -PNTHREADS=$THREADS -PEVENTS_TO_KEEP=$EVENTS $EVIO -PPLUGINS=$plugins >& $LOG/multiple_plugins.txt
if test $? -ne 0; then
    echo "Multiple-plugins test failed."
else
    echo "Multiple-plugins test passed."
fi >> summary.txt
echo -e "\nTesting hdgeant ..." >> summary.txt
timeout 180 hdgeant >& $LOG/hdgeant.txt
if test $? -ne 0; then
    echo "hdgeant failed."
else
    echo "hdgeant passed."
fi >> summary.txt
cd $initial_dir
