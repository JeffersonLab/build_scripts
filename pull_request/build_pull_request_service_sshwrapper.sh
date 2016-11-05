#!/bin/bash
branch=$(echo $1 | sed -r 's/\//_/g')
export BUILD_SCRIPTS=/group/halld/Software/build_scripts
nohup $BUILD_SCRIPTS/pull_request/build_pull_request_service.sh $1 $2 $3 >/work/halld/pull_request_test/ssh_log^$branch 2>&1 &
