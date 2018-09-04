#!/bin/tcsh
setenv TODAYS_DATE `date +%F`
if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS /group/halld/Software/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
if ( $BMS_OSNAME =~ *CentOS6* || $BMS_OSNAME =~ *RHEL6* ) then
    set GCC_HOME=/apps/gcc/4.9.2
    setenv PATH ${GCC_HOME}/bin:${PATH}
    setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
endif
setenv TARGET_DIR /u/scratch/$USER/nightly/$TODAYS_DATE/$BMS_OSNAME
mkdir -pv $TARGET_DIR
# make an xml file
set xml=$TARGET_DIR/version_${TODAYS_DATE}.xml
$BUILD_SCRIPTS/customize_version.pl \
    -i /group/halld/www/halldweb/html/dist/version_jlab.xml \
    -o $xml \
    -r $TARGET_DIR/halld_recon \
    -m $TARGET_DIR/halld_sim \
    -g $TARGET_DIR/hdds \
    -4 $TARGET_DIR/hdgeant4 \
    -a $TARGET_DIR/gluex_root_analysis
# set-up the environment
source $BUILD_SCRIPTS/gluex_env_jlab.csh $xml
setenv HDDS_URL file:///group/halld/Repositories/hdds
setenv HALLD_RECON_URL file:///group/halld/Repositories/halld_recon
setenv HALLD_SIM_URL file:///group/halld/Repositories/halld_sim
setenv HDGEANT4_URL file:///group/halld/Repositories/hdgeant4
setenv GLUEX_ROOT_ANALYSIS_URL file:///group/halld/Repositories/gluex_root_analysis
# go to the target directory
cd $TARGET_DIR
# make hdds
make -f $BUILD_SCRIPTS/Makefile_hdds HDDS_SCONS_OPTIONS="SHOWBUILD=1"
# make recon
make -f $BUILD_SCRIPTS/Makefile_halld_recon HALLD_RECON_SCONS_OPTIONS="SHOWBUILD=1"
# make sim
make -f $BUILD_SCRIPTS/Makefile_halld_sim HALLD_SIM_SCONS_OPTIONS="SHOWBUILD=1"
# make hdgeant4
make -f $BUILD_SCRIPTS/Makefile_hdgeant4
# make gluex_root_analysis
make -f $BUILD_SCRIPTS/Makefile_gluex_root_analysis
# exit
exit
