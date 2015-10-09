#!/bin/bash
export BUILD_SCRIPTS=/home/gluex/build_scripts
nohup $BUILD_SCRIPTS/pull_request/build_pull_request_service.sh $1 $2 >/work/halld/pull_request_test/ssh_log^$1 2>&1 &
