#!/bin/bash
# go to the target directory
branch_git=$1
branch=$(echo $branch_git | sed -r 's/\//_/g')
#target_dir=/u/scratch/$USER/pull_request_test
target_dir=/work/halld/pull_request_test
logfile=make_${branch}.log
mkdir -p -v $target_dir
pushd $target_dir
# setup environment
#source /group/halld/Software/build_scripts/gluex_env_jlab.sh
############################################
#echo === warning: using hard-wired location of build_scripts for development ===
# this is maybe redundant?
export BUILD_SCRIPTS=/group/halld/Software/build_scripts  
source $BUILD_SCRIPTS/gluex_env_jlab.sh /group/halld/www/halldweb/html/dist/version_jlab.xml
unset CPLUS_INCLUDE_PATH
############################################
unset SIM_RECON_VERSION
if [ -z "$SIM_RECON_URL" ]; then
    export SIM_RECON_URL=https://github.com/JeffersonLab/sim-recon
fi
# only run tests from the main JLab repo, not forked repos for security
echo COMPARE "$SIM_RECON_URL"
echo TO "https://github.com/JeffersonLab/sim-recon"
if [ "$SIM_RECON_URL" != "https://github.com/JeffersonLab/sim-recon" ]; then
    # create notice where the build log would be
    if [ ! -d "sim-recon^$branch" ]; then
       mkdir "sim-recon^$branch"
    fi
    echo "Tests are not run on pull requests from forked repositories." > "sim-recon^$branch/$logfile"
    exit 1
fi
export SIM_RECON_BRANCH=$branch_git
export SIM_RECON_DIRTAG=$branch
export SIM_RECON_SCONS_OPTIONS="-j8 SHOWBUILD=1"
# for testing
printenv >& env^$branch
# make sim-recon
rm -fv $logfile
if [ -d "sim-recon^$branch" ]; then
    rm -rf sim-recon^$branch
fi
make -f $BUILD_SCRIPTS/Makefile_sim-recon >& $logfile
build_exit_code=$?
mv -v $logfile sim-recon^$branch
# exit
exit $build_exit_code
