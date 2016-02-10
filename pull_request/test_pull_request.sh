# test sim-recon: run hd_root with various plugins, and run hdgeant
# nonzero exit code signals runtime error or mistake in env. setup
# EVIO: path to evio file to process
# plugins.txt: list of plugins to test
cwd=$(pwd)
bscripts=/home/gluex/build_scripts
osrelease=$(perl $bscripts/osrelease.pl)
branch=$1
target=/work/halld/pull_request_test/sim-recon^$branch/tests
mkdir -p $target; cd $target
cp -p $bscripts/pull_request/plugins.txt .
cp -p $bscripts/pull_request/control.in .
bash $bscripts/pull_request/clean_tests.sh
LOG=log; mkdir -p $LOG
source ../$osrelease/setenv.csh
EVIO=/work/halld/nsparks/hd_rawdata_003180_000_f2000.evio
EVENTS=500
THREADS=8
echo "Test summary"
for plugin in $(cat plugins.txt); do
    echo -e "\nTesting $plugin ..."
    hd_root -PNTHREADS=$THREADS -PEVENTS_TO_KEEP=$EVENTS $EVIO -PPLUGINS=$plugin >& $LOG/$plugin.txt
    if test $? -ne 0; then
        echo "$plugin failed."
    else
        echo "$plugin passed."
    fi
done
function join { local IFS="$1"; shift; echo "$*"; }
plugins=$(join , $(cat plugins.txt))
echo -e "\nTesting all listed plugins at the same time ..."
hd_root -PNTHREADS=$THREADS -PEVENTS_TO_KEEP=$EVENTS $EVIO -PPLUGINS=$plugins >& $LOG/multiple_plugins.txt
if test $? -ne 0; then
    echo "Multiple-plugins test failed."
else
    echo "Multiple-plugins test passed."
fi
echo -e "\nTesting hdgeant ..."
hdgeant >& $LOG/hdgeant.txt
if test $? -ne 0; then
    echo "hdgeant failed."
else
    echo "hdgeant passed."
fi
cd $cwd
