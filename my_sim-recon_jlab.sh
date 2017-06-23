#!/bin/bash
if [ -z "$BUILD_SCRIPTS" ]
    then export BUILD_SCRIPTS=/group/halld/Software/build_scripts
fi
mydir=`pwd`
mydate=`date +%F`
$BUILD_SCRIPTS/customize_version.pl \
    -i /group/halld/www/halldweb/html/dist/version_jlab.xml \
    -o ${USER}_$mydate.xml \
    -g $mydir/hdds \
    -s $mydir/sim-recon \
    -4 $mydir/hdgeant4 \
    -a $mydir/gluex_root_analysis
echo source $BUILD_SCRIPTS/gluex_env_jlab.sh $mydir/${USER}_$mydate.xml \
    > setup_gluex.sh
echo source $BUILD_SCRIPTS/gluex_env_jlab.csh $mydir/${USER}_$mydate.xml \
    > setup_gluex.csh
source $BUILD_SCRIPTS/gluex_env_jlab.sh $mydir/${USER}_$mydate.xml
set -e
make -f $BUILD_SCRIPTS/Makefile_hdds
make -f $BUILD_SCRIPTS/Makefile_sim-recon SIM_RECON_SCONS_OPTIONS="-j4"
make -f $BUILD_SCRIPTS/Makefile_hdgeant4
make -f $BUILD_SCRIPTS/Makefile_gluex_root_analysis
