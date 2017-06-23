#!/bin/bash
BUILD_DATE=$1
export BMS_OSNAME=`/group/halld/Software/build_scripts/osrelease.pl`
source /group/halld/Software/build_scripts/gluex_env_jlab.sh /u/scratch/gluex/nightly/$BUILD_DATE/$BMS_OSNAME/version_$BUILD_DATE.xml
