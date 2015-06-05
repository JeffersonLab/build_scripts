#!/bin/tcsh
# go to the target directory
setenv TODAYS_DATE `date +%F`
setenv TARGET_DIR /u/scratch/gluex/nightly/$TODAYS_DATE
mkdir -p $TARGET_DIR
cd $TARGET_DIR
# get build scripts
svn checkout file:///group/halld/Repositories/svnroot/trunk/scripts/build_scripts
cp -v /group/halld/www/halldweb/html/dist/version.xml .
source build_scripts/gluex_env_nightly.csh $TODAYS_DATE
# make hdds
make -f $BUILD_SCRIPTS/Makefile_hdds sconstruct
# make sim-recon
make -f $BUILD_SCRIPTS/Makefile_sim-recon sconstruct
# exit
exit
