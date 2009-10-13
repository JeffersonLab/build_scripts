#!/bin/tcsh
setenv TODAYS_DATE `date +%F`
setenv TARGET_DIR /work/halld/builds/$TODAYS_DATE
setenv BUILD_SCRIPTS /home/marki/halld/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
# xerces-c
setenv XERCESCROOT /group/halld/Software/ExternalPackages/xerces-c-src_2_7_0.$BMS_OSNAME
# Jana
setenv JANA_HOME /group/12gev_phys/builds/jana_0.5.2/$BMS_OSNAME
setenv JANA_CALIB_URL file:///group/halld/calib
# ROOT
setenv ROOTSYS /apps/root/5.18-00/root
# CERNLIB
setenv CERN /apps/cernlib/i386_fc8
setenv CERN_LEVEL 2005
source $BUILD_SCRIPTS/gluex_env.csh
# do the build
mkdir -p $TARGET_DIR
cd $TARGET_DIR
make -f $BUILD_SCRIPTS/Makefile_halld
exit
