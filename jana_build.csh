#!/bin/csh
if (! $?BUILD_SCRIPTS) then
    echo set environment variable BUILD_SCRIPTS to location of build scripts
    exit 1
endif
if (! $?XERCESCROOT) then
    echo set environment variable XERCESCROOT to location of xerces-c
    exit 1
endif
# assume build will be in the local directory
svn co https://phys12svn.jlab.org/repos/tags/JANA_marki_freeze
cd JANA_marki_freeze
setenv JANA_HOME `pwd`
source $BUILD_SCRIPTS/gluex_env.csh
cd src
./configure --with-xerces=$XERCESCROOT
make
make install
