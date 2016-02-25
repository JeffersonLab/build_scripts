#!/bin/tcsh
setenv BUILD_DATE $1
setenv BMS_OSNAME `/group/halld/Software/build_scripts/osrelease.pl` # boot strap from official build_scripts directory
if (! $?NIGHTLY_DIR) set NIGHTLY_DIR=/u/scratch/gluex/nightly/$BUILD_DATE/$BMS_OSNAME
setenv BUILD_SCRIPTS $NIGHTLY_DIR/build_scripts
setenv GLUEX_TOP /group/halld/Software/builds/$BMS_OSNAME
# perl the cue
setenv PATH /apps/perl/bin:$PATH
# set version variables
eval `$BUILD_SCRIPTS/version.pl $NIGHTLY_DIR/version.xml`
# overwrite variables set by version.xml to get latest versions of hdds and sim-recon
unsetenv HDDS_VERSION SIM_RECON_VERSION
setenv HDDS_HOME $NIGHTLY_DIR/hdds
setenv HALLD_HOME $NIGHTLY_DIR/sim-recon
# finish the rest of the gluex environment
source $BUILD_SCRIPTS/gluex_env.csh
setenv JANA_CALIB_URL $CCDB_CONNECTION
# python on the cue
setenv PATH /apps/python/PRO/bin:$PATH
setenv LD_LIBRARY_PATH /apps/python/PRO/lib:$LD_LIBRARY_PATH
