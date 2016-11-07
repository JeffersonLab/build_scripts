#!/bin/tcsh
# go to the target directory
setenv TODAYS_DATE `date +%F`
setenv BUILD_SCRIPTS /group/halld/Software/build_scripts
source $BUILD_SCRIPTS/gluex_env_jlab.csh
setenv TARGET_DIR /u/scratch/$USER/nightly/$TODAYS_DATE/$BMS_OSNAME
mkdir -p $TARGET_DIR
cd $TARGET_DIR
# make an xml file
set xml=version_${TODAYS_DATE}.xml
$BUILD_SCRIPTS/customize_version.pl -i /group/halld/www/halldweb/html/dist/version_jlab.xml -o $xml -d `pwd`/sim-recon -s `pwd`/hdds
source $BUILD_SCRIPTS/gluex_env_clean.csh
setenv BUILD_SCRIPTS /group/halld/Software/build_scripts
source $BUILD_SCRIPTS/gluex_env_jlab.csh $xml
# make hdds
make -f $BUILD_SCRIPTS/Makefile_hdds
# make sim-recon
make -f $BUILD_SCRIPTS/Makefile_sim-recon SIM_RECON_SCONS_OPTIONS="SHOWBUILD=1"
# exit
exit
