#!/bin/bash
touch /work/halld/pull_request_test/ssh_log^$branch_step1
branch=$(echo $1 | sed -r 's/\//_/g')
touch /work/halld/pull_request_test/ssh_log^$branch_step2
export BUILD_SCRIPTS=/group/halld/Software/build_scripts
touch /work/halld/pull_request_test/ssh_log^$branch_step3
nohup $BUILD_SCRIPTS/pull_request/build_pull_request_service.sh $1 $2 $3 >/work/halld/pull_request_test/ssh_log^$branch 2>&1 &
