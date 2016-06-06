#!/bin/bash
<<<<<<< HEAD
export VERSION_XML=/group/halld/www/halldweb/html/dist/version_build_jlab.xml
# gcc 4.9 on the cue (C++11 support)
# config 'modules' package by hand since the CUE configures it 
# by defualt for tcsh but not bash??
export MODULESHOME=/usr/share/Modules
source $MODULESHOME/init/bash
module load gcc_4.9.2
=======
VERSION_XML=/group/halld/www/halldweb/html/dist/version_jlab.xml
# farm-specific set-up
nodename=`uname -n`
if [[ $nodename =~ ^i*farm[0-9]* ]]
    then
    export http_proxy=http://jprox.jlab.org:8081
    export https_proxy=https://jprox.jlab.org:8081
    export MODULESHOME=/usr/share/Modules
    source $MODULESHOME/init/bash
    module load gcc_4.9.2
fi
>>>>>>> 5e800dcc53423dcee9b735c45fcc8fbd255a2b6e
export BUILD_SCRIPTS=/group/halld/Software/build_scripts
export BMS_OSNAME=`$BUILD_SCRIPTS/osrelease.pl`
export GLUEX_TOP=/group/halld/Software/builds/$BMS_OSNAME
# perl on the cue
export PATH=/apps/perl/bin:$PATH
# finish the rest of the environment
. $BUILD_SCRIPTS/gluex_env_version.sh $VERSION_XML
export JANA_CALIB_URL=$CCDB_CONNECTION
export JANA_RESOURCE_DIR=/group/halld/www/halldweb/html/resources
# python on the cue
export PATH=/apps/python/PRO/bin:$PATH
export LD_LIBRARY_PATH=/apps/python/PRO/lib:$LD_LIBRARY_PATH
