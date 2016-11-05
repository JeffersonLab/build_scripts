#!/bin/tcsh
# go to the target directory
setenv TODAYS_DATE `date +%F`
setenv TARGET_DIR /u/scratch/$USER/nightly/$TODAYS_DATE/`/group/halld/Software/build_scripts/osrelease.pl`
setenv BUILD_SCRIPTS $TARGET_DIR/build_scripts
mkdir -p $TARGET_DIR
# get build scripts
cd /group/halld/Repositories/build_scripts
git archive --prefix build_scripts/ master | tar xv -C $TARGET_DIR
cd $TARGET_DIR
# perl on the cue
setenv PATH /apps/perl/bin:$PATH
# make an xml file
$BUILD_SCRIPTS/customize_version.pl -i /group/halld/www/halldweb/html/dist/version_jlab.xml -o version_${TODAYS_DATE}.xml -d `pwd`/sim-recon -s `pwd`/hdds
source $BUILD_SCRIPTS/gluex_env_jlab.csh version_${TODAYS_DATE}.xml 
# make hdds
make -f $BUILD_SCRIPTS/Makefile_hdds
# make sim-recon
make -f $BUILD_SCRIPTS/Makefile_sim-recon SIM_RECON_SCONS_OPTIONS="SHOWBUILD=1"
# exit
exit
