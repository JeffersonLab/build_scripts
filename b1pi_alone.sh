#!/bin/sh
RUN_DIR=./run
mkdir -p $RUN_DIR
cd $RUN_DIR
cp $BUILD_SCRIPTS/../b1pi_macros/* .
./mkevents.sh
exit
