#!/bin/bash
# go to the target directory
repo=$1
branch_git=$2
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
# now start using the nightly build...
export BUILD_SCRIPTS=/group/halld/Software/build_scripts  
#source $BUILD_SCRIPTS/gluex_env_jlab.sh /group/halld/www/halldweb/html/dist/version_jlab.xml
datestring=`date +%Y-%m-%d`
export BMS_OSNAME=`$BUILD_SCRIPTS/osrelease.pl`
source $BUILD_SCRIPTS/gluex_env_jlab.sh  /u/scratch/gluex/nightly/$datestring/$BMS_OSNAME/version_$datestring.xml
unset CPLUS_INCLUDE_PATH
############################################
if [ -z "$REPO_URL" ]; then
    export REPO_URL=https://github.com/JeffersonLab/$repo
fi
# only run tests from the main JLab repo, not forked repos for security
echo COMPARE "$REPO_URL"
echo TO "https://github.com/JeffersonLab/$repo"
if [ "$REPO_URL" != "https://github.com/JeffersonLab/$repo" ]; then
    # create notice where the build log would be
    if [ -f "$repo^$branch" ]; then
       rm "$repo^$branch"
    fi
    if [ ! -d "$repo^$branch" ]; then
       mkdir "$repo^$branch"
    fi
    echo "Tests are not run on pull requests from forked repositories." > "$repo^$branch/$logfile"
    exit 1
fi

# handle repo-specific options
if [ "$repo" == "sim-recon" ]; then
    unset SIM_RECON_VERSION
    export SIM_RECON_BRANCH=$branch_git
    export SIM_RECON_DIRTAG=$branch
    export SIM_RECON_SCONS_OPTIONS="-j8 SHOWBUILD=1"
elif [ "$repo" == "halld_recon" ]; then
    unset HALLD_RECON_VERSION
    export HALLD_RECON_BRANCH=$branch_git
    export HALLD_RECON_DIRTAG=$branch
    export HALLD_RECON_SCONS_OPTIONS="-j8 SHOWBUILD=1"
elif [ "$repo" == "halld_sim" ]; then
    unset HALLD_SIM_VERSION
    export HALLD_SIM_BRANCH=$branch_git
    export HALLD_SIM_DIRTAG=$branch
    export HALLD_SIM_SCONS_OPTIONS="-j8 SHOWBUILD=1"
fi

# for testing
printenv >& env^$branch
# make sim-recon
rm -fv $logfile
if [ -d "$repo^$branch" ]; then
    rm -rf $repo^$branch
fi
make -f $BUILD_SCRIPTS/Makefile_$repo >& $logfile
build_exit_code=$?
mv -v $logfile $repo^$branch
# exit
exit $build_exit_code
