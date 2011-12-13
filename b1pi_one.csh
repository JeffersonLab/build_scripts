#!/bin/tcsh
setenv TODAYS_DATE `date +%F`
setenv BUILD_DIR /group/halld/Software/builds/sim-recon/nightly/$TODAYS_DATE
setenv BUILD_SCRIPTS /group/halld/Software/scripts/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
setenv RUN_DIR /u/scratch/gluex/b1pi/$TODAYS_DATE/$BMS_OSNAME
# xerces-c
setenv XERCESCROOT /group/halld/Software/ExternalPackages/xerces-c-src_2_7_0.$BMS_OSNAME
# Jana
setenv JANA_HOME /group/12gev_phys/builds/jana_0.6.2/$BMS_OSNAME
setenv JANA_CALIB_URL file:///group/halld/calib
# ROOT
setenv ROOTSYS `$BUILD_SCRIPTS/cue_root.pl`
# CERNLIB
setenv CERN_CUE `$BUILD_SCRIPTS/cue_cernlib.pl`
setenv CERN /apps/cernlib/$CERN_CUE
setenv CERN_LEVEL 2005
# Hall D
setenv HALLD_HOME $BUILD_DIR/sim-recon
setenv HALLD_MY $HALLD_HOME
# HDDS
setenv HDDS_HOME $BUILD_DIR/hdds
# CCDB
setenv CCDB_HOME /group/halld/Software/builds/ccdb/prod
# finish the rest of the environment
source $BUILD_SCRIPTS/gluex_env.csh
# do the build
mkdir -p $RUN_DIR
cd $RUN_DIR
cp $BUILD_SCRIPTS/../b1pi_macros/* .
./mkevents.sh
setenv PLOTDIR /group/halld/www/halldweb1/html/b1pi/$TODAYS_DATE/$BMS_OSNAME
mkdir -p $PLOTDIR
cp -v *.pdf *.gif *.html $PLOTDIR
cp -v ../../../b1pi*.log $PLOTDIR/../
exit
