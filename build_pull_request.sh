#!/bin/bash
# go to the target directory
branch=$1
target_dir=/u/scratch/$USER/pull_request_test
logfile=make_${branch}.log
mkdir -p -v $target_dir
pushd $target_dir
# setup environment
source /group/halld/Software/build_scripts/gluex_env_jlab.sh
export BUILD_SCRIPTS=/home/gluex/build_scripts # for debugging only
unset SIM_RECON_VERSION
export SIM_RECON_URL=https://github.com/jeffersonlab/sim-recon
export SIM_RECON_BRANCH=$branch
export SIM_RECON_DIRTAG=$branch
export SIM_RECON_SCONS_OPTIONS="SHOWBUILD=1"
# make sim-recon
rm -fv $logfile
make -f $BUILD_SCRIPTS/Makefile_sim-recon >& $logfile
mv -v $logfile sim-recon^$branch
# exit
exit
