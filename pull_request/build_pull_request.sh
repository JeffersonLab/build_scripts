#!/bin/bash
repo=$1
branch_git=$2
branch=$(echo $branch_git | sed -r 's/\//_/g')
target_dir=/work/halld/pull_request_test
logfile=make_${branch}.log
# go to the target directory
mkdir -p -v $target_dir
pushd $target_dir

export REPO_URL=https://github.com/JeffersonLab/$repo
if [ -f "$repo^$branch" ]; then
    rm "$repo^$branch"
fi
if [ ! -d "$repo^$branch" ]; then
    mkdir "$repo^$branch"
fi

# handle repo-specific options
if [ "$repo" == "sim-recon" ]; then
    export SIM_RECON_SCONS_OPTIONS="-j8 SHOWBUILD=1"
elif [ "$repo" == "halld_recon" ]; then
    export HALLD_RECON_SCONS_OPTIONS="-j8 SHOWBUILD=1"
elif [ "$repo" == "halld_sim" ]; then
    export HALLD_SIM_SCONS_OPTIONS="-j8 SHOWBUILD=1"
fi

# save environment
printenv | sort >& env^$branch
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
