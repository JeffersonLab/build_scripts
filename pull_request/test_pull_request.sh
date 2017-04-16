#!/bin/bash
# test sim-recon: run hd_root with various plugins, and run hdgeant
# nonzero exit code signals runtime error or mistake in env. setup
# EVIO: path to evio file to process
# plugins.txt: list of plugins to test
# farm-specific set-up - from gluex_env_jlab.sh
BUILD_SCRIPTS=/group/halld/Software/build_scripts
osrelease=$(perl $BUILD_SCRIPTS/osrelease.pl)
if [[ $osrelease == *CentOS6* || $osrelease == *RHEL6* ]]
    then
    GCC_HOME=/apps/gcc/4.9.2
    export PATH=${GCC_HOME}/bin:${PATH}
    export LD_LIBRARY_PATH=${GCC_HOME}/lib64:${GCC_HOME}/lib
    osrelease=$(perl $BUILD_SCRIPTS/osrelease.pl)
fi
branch=$1
target_dir=/work/halld/pull_request_test/sim-recon^$branch/tests
rm -rf $target_dir && mkdir $target_dir
pushd $target_dir
cp $BUILD_SCRIPTS/pull_request/plugins.txt .
cp $BUILD_SCRIPTS/pull_request/control.in .
LOG=log; mkdir $LOG
source ../$osrelease/setenv.sh
EVIO=/work/halld/pull_request_test/hd_rawdata_030858_8k.evio
EVENTS=500
THREADS=8
TLIMIT=180
echo LD_LIBRARY_PATH = $LD_LIBRARY_PATH
echo "Test summary" > summary.txt
for plugin in $(cat plugins.txt); do
    echo -e "\nTesting $plugin ..." >> summary.txt
    timeout $TLIMIT hd_root -PNTHREADS=$THREADS -PEVENTS_TO_KEEP=$EVENTS $EVIO -PPLUGINS=$plugin >& $LOG/$plugin.txt
    code=$?
    if [ $code -eq 124 ]; then
        echo "$plugin plugin failed with $TLIMIT seconds timeout (status=124)."
    elif [ $code -ne 0 ]; then
        echo "$plugin plugin failed with exit status $code."
    else
        echo "$plugin plugin passed."
    fi >> summary.txt
done
function join { local IFS="$1"; shift; echo "$*"; }
plugins=$(join , $(cat plugins.txt))
echo -e "\nTesting all listed plugins at the same time ..." >> summary.txt
timeout $TLIMIT hd_root -PNTHREADS=$THREADS -PEVENTS_TO_KEEP=$EVENTS $EVIO -PPLUGINS=$plugins >& $LOG/multiple_plugins.txt
code=$?
if [ $code -eq 124 ]; then
    echo "Multiple-plugins test failed with $TLIMIT seconds timeout (status=124)."
elif [ $code -ne 0 ]; then
    echo "Multiple-plugins test failed with exit status $code."
else
    echo "Multiple-plugins test passed."
fi >> summary.txt
echo -e "\nTesting hdgeant ..." >> summary.txt
export JANA_CALIB_CONTEXT="variation=mc_sim1"
timeout $TLIMIT hdgeant >& $LOG/hdgeant.txt
code=$?
if [ $code -eq 124 ]; then
    echo "hdgeant failed with $TLIMIT seconds timeout (status=124)."
elif [ $code -ne 0 ]; then
    echo "hdgeant failed with exit status $code."
else
    echo "hdgeant passed."
fi >> summary.txt
popd
