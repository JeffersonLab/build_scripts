#!/bin/tcsh
setenv TODAYS_DATE `date +%F`
setenv TARGET_DIR /group/halld/Software/builds/sim-recon/nightly/$TODAYS_DATE
# hdds
setenv HDDS_HOME $TARGET_DIR/hdds
# Hall D
setenv HALLD_HOME $TARGET_DIR/sim-recon
setenv HALLD_MY $HALLD_HOME
# finish the rest of the environment
source /group/halld/Software/scripts/build_scripts/gluex_env_jlab.csh
# do the build
mkdir -p $TARGET_DIR
cd $TARGET_DIR
make -f $BUILD_SCRIPTS/Makefile_hdds make_hdds
make -f $BUILD_SCRIPTS/Makefile_hdds make_hdds DEBUG=1
make -f $BUILD_SCRIPTS/Makefile_sim-recon make_halld
make -f $BUILD_SCRIPTS/Makefile_sim-recon make_halld DEBUG=1

# Create environment setup script based on what was just used for building
# (added 2010-09-03 DL)
cd $HALLD_HOME
unsetenv HALLD_MY
$BUILD_SCRIPTS/../mk_setenv.csh

exit
