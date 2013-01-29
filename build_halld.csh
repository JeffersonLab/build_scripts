#!/bin/tcsh
setenv TODAYS_DATE `date +%F`
setenv TARGET_DIR /group/halld/Software/builds/nightly/$TODAYS_DATE
# build scripts
setenv BUILD_SCRIPTS $TARGET_DIR/build_scripts
# hdds
setenv HDDS_HOME $TARGET_DIR/hdds
# Hall D
setenv HALLD_HOME $TARGET_DIR/sim-recon
setenv HALLD_MY $HALLD_HOME
# go to the target directory
mkdir -p $TARGET_DIR
cd $TARGET_DIR
# create build scripts
svn co file:///group/halld/Resitories/svnroot/trunk/scripts/build_scripts
# finish the rest of the environment
source $BUILD_SCRIPTS/gluex_env_jlab.csh
# make hdds
make -f $BUILD_SCRIPTS/Makefile_hdds make_hdds
make -f $BUILD_SCRIPTS/Makefile_hdds make_hdds DEBUG=1
# make sim-recon
make -f $BUILD_SCRIPTS/Makefile_sim-recon make_halld
make -f $BUILD_SCRIPTS/Makefile_sim-recon make_halld DEBUG=1
# Create environment setup script based on what was just used for building
# (added 2010-09-03 DL)
cd $HALLD_HOME
unsetenv HALLD_MY
/group/halld/Software/scripts/mk_setenv.csh
#
exit
