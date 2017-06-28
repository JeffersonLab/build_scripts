#!/bin/tcsh
setenv TODAYS_DATE `date +%F`
source /group/halld/Software/hd_utilities/jlab_builds/jlab_tricks.csh
if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS /group/halld/Software/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
setenv TARGET_DIR /u/scratch/$USER/nightly/$TODAYS_DATE/$BMS_OSNAME
mkdir -pv $TARGET_DIR
# make an xml file
set xml=$TARGET_DIR/version_${TODAYS_DATE}.xml
$BUILD_SCRIPTS/customize_version.pl \
    -i /group/halld/www/halldweb/html/dist/version_jlab.xml \
    -o $xml \
    -s $TARGET_DIR/sim-recon \
    -g $TARGET_DIR/hdds \
    -4 $TARGET_DIR/hdgeant4 \
    -a $TARGET_DIR/gluex_root_analysis
# set-up the environment
source $BUILD_SCRIPTS/gluex_env_jlab.csh $xml
# go to the target directory
cd $TARGET_DIR
# make hdds
make -f $BUILD_SCRIPTS/Makefile_hdds
# make sim-recon
make -f $BUILD_SCRIPTS/Makefile_sim-recon SIM_RECON_SCONS_OPTIONS="SHOWBUILD=1"
# make hdgeant4
make -f $BUILD_SCRIPTS/Makefile_hdgeant4
# make gluex_root_analysis
make -f $BUILD_SCRIPTS/Makefile_gluex_root_analysis
# exit
exit
