#!/bin/tcsh
# go to the target directory
setenv TODAYS_DATE `date +%F`
setenv TARGET_DIR /u/scratch/$USER/nightly/$TODAYS_DATE
setenv BUILD_SCRIPTS $TARGET_DIR/build_scripts
mkdir -p $TARGET_DIR
# get build scripts
cd /group/halld/Repositories/build_scripts
git archive --prefix build_scripts/ master | tar xv -C $TARGET_DIR
cd $TARGET_DIR
cp -v /group/halld/www/halldweb/html/dist/version.xml .
setenv NIGHTLY_DIR $TARGET_DIR
source $BUILD_SCRIPTS/gluex_env_nightly.csh $TODAYS_DATE
echo BUILD_SCRIPTS = $BUILD_SCRIPTS
unsetenv HDDS_VERSION SIM_RECON_VERSION
# make hdds
cat $BUILD_SCRIPTS/Makefile_hdds
make -f $BUILD_SCRIPTS/Makefile_hdds sconstruct
# make sim-recon
make -f $BUILD_SCRIPTS/Makefile_sim-recon sconstruct
# exit
exit
