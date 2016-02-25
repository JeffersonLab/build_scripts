#!/bin/tcsh
BUILD_DATE=$1
export BMS_OSNAME=`/group/halld/Software/build_scripts/osrelease.pl` # boot strap from official build_scripts directory
NIGHTLY_DIR=/u/scratch/gluex/nightly/$BUILD_DATE/$BMS_OSNAME
export BUILD_SCRIPTS=$NIGHTLY_DIR/build_scripts
export GLUEX_TOP=/group/halld/Software/builds/$BMS_OSNAME
# perl on the cue
export PATH=/apps/perl/bin:$PATH
# set version variables
eval `$BUILD_SCRIPTS/version.pl -sbash $NIGHTLY_DIR/version.xml`
# overwrite variables set by version.xml to get latest versions of hdds and sim-recon
unset HDDS_VERSION SIM_RECON_VERSION
export HDDS_HOME=$NIGHTLY_DIR/hdds
export HALLD_HOME=$NIGHTLY_DIR/sim-recon
# finish the rest of the gluex environment
source $BUILD_SCRIPTS/gluex_env.sh
export JANA_CALIB_URL=$CCDB_CONNECTION
# python on the cue
export PATH=/apps/python/PRO/bin:$PATH
export LD_LIBRARY_PATH=/apps/python/PRO/lib:$LD_LIBRARY_PATH
