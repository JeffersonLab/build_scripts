#!/bin/tcsh
setenv TODAYS_DATE `date +%F`
setenv TARGET_DIR /scratch/gluex/halld_builds/$TODAYS_DATE
setenv BUILD_SCRIPTS /group/halld/Software/scripts/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
# xerces-c
setenv XERCESCROOT /group/halld/Software/ExternalPackages/xerces-c-src_2_7_0.$BMS_OSNAME
# Jana
setenv JANA_HOME /group/12gev_phys/builds/jana_0.5.2/$BMS_OSNAME
setenv JANA_CALIB_URL file:///group/halld/calib
# ROOT
setenv ROOTSYS `$BUILD_SCRIPTS/cue_root.pl`
# CERNLIB
setenv CERN_CUE `$BUILD_SCRIPTS/cue_cernlib.pl`
setenv CERN /apps/cernlib/$CERN_CUE
setenv CERN_LEVEL 2005
# Hall D
setenv HALLD_HOME $TARGET_DIR/latest
setenv HALLD_MY $HALLD_HOME
# finish the rest of the environment
source $BUILD_SCRIPTS/gluex_env.csh
# hdds, do it here for now
setenv HDDS_HOME $TARGET_DIR/hdds/hdds_latest
# do the build
mkdir -p $TARGET_DIR/hdds
mkdir -p $TARGET_DIR/halld
cd $TARGET_DIR/hdds
make -f $BUILD_SCRIPTS/Makefile_hdds
make -f $BUILD_SCRIPTS/Makefile_hdds DEBUG=1
cd $TARGET_DIR/halld
make -f $BUILD_SCRIPTS/Makefile_halld
make -f $BUILD_SCRIPTS/Makefile_halld DEBUG=1
exit