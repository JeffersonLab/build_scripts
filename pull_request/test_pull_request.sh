# test sim-recon: run hd_root with various plugins, and run hdgeant
# nonzero exit code signals runtime error or mistake in env. setup
# EVIO: path to evio file to process
# plugins.txt: list of plugins to test
initial_dir=$(pwd)
BUILD_SCRIPTS=/home/gluex/build_scripts
osrelease=$(perl $BUILD_SCRIPTS/osrelease.pl)
branch=$1
target_dir=/work/halld/pull_request_test/sim-recon^$branch/tests
mkdir -p $target_dir; cd $target_dir
cp -p $BUILD_SCRIPTS/pull_request/plugins.txt .
cp -p $BUILD_SCRIPTS/pull_request/control.in .
bash $BUILD_SCRIPTS/pull_request/clean_tests.sh
LOG=log; mkdir -p $LOG
source ../$osrelease/setenv.sh
EVIO=/work/halld/pull_request_test/hd_rawdata_003180_000.evio
EVENTS=500
THREADS=8
TLIMIT=60
echo "Test summary"
for plugin in $(cat plugins.txt); do
    echo -e "\nTesting $plugin ..."
    timeout $TLIMIT hd_root -PNTHREADS=$THREADS -PEVENTS_TO_KEEP=$EVENTS $EVIO -PPLUGINS=$plugin >& $LOG/$plugin.txt
    if test $? -ne 0; then
        echo "$plugin failed."
    else
        echo "$plugin passed."
    fi
done
function join { local IFS="$1"; shift; echo "$*"; }
plugins=$(join , $(cat plugins.txt))
echo -e "\nTesting all listed plugins at the same time ..."
timeout $TLIMIT hd_root -PNTHREADS=$THREADS -PEVENTS_TO_KEEP=$EVENTS $EVIO -PPLUGINS=$plugins >& $LOG/multiple_plugins.txt
if test $? -ne 0; then
    echo "Multiple-plugins test failed."
else
    echo "Multiple-plugins test passed."
fi
echo -e "\nTesting hdgeant ..."
timeout $TLIMIT hdgeant >& $LOG/hdgeant.txt
if test $? -ne 0; then
    echo "hdgeant failed."
else
    echo "hdgeant passed."
fi
cd $initial_dir
