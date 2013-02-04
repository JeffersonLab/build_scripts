#!/bin/tcsh
setenv TODAYS_DATE `date +%F`
setenv BUILD_DIR /group/halld/Software/builds/nightly/$TODAYS_DATE
setenv BUILD_SCRIPTS /group/halld/Software/scripts/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
setenv RUN_DIR /u/scratch/gluex/b1pi/$TODAYS_DATE/$BMS_OSNAME

# Setup environment based on sim-recon build we're using 
source ${BUILD_DIR}/sim-recon/setenv.csh

# CCDB (should be in above script once ccdb is fully deployed)
setenv CCDB_HOME /group/halld/Software/builds/ccdb/prod

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
