#!/bin/bash
export GLUEX_TOP=`pwd`
export BUILD_SCRIPTS=/group/halld/Software/scripts/build_scripts
if [ ! -f version.xml ]
    then
    echo error: no local version.xml
    exit 1
fi
eval `$BUILD_SCRIPTS/version.pl -sbash version.xml`
export CERN=`$BUILD_SCRIPTS/cue_cernlib.pl`
source $BUILD_SCRIPTS/gluex_env.sh
make -f $BUILD_SCRIPTS/Makefile_all xerces_build root_build ccdb_build \
    evio_build jana_build hdds_build sim-recon_build
exit
