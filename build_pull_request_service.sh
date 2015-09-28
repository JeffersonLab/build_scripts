#!/bin/bash
branch=$1
echo build_pull_request_service.sh: building branch $branch
report_file=report_${branch}.txt
export BUILD_SCRIPTS=/home/gluex/build_scripts
echo build_pull_request_service.sh: using BUILD_SCRIPTS = $BUILD_SCRIPTS
command="$BUILD_SCRIPTS/build_pull_request.sh $branch"
echo build_pull_request_service.sh: executing $command
$command
pushd /u/scratch/$USER/pull_request_test/sim-recon^$branch
rm -f $report_file
echo build_pull_request_service.sh: create $report_file
$BUILD_SCRIPTS/build_pull_request_report.sh make_${branch}.log > $report_file
