#!/bin/sh
# process arguments
if [ "$1" = "-v" ]; then
    gluex_env_verbose=1
else
    gluex_env_verbose=0
fi
echo $gluex_env_verbose
exit
# general stuff
if (! $?GLUEX_TOP) setenv GLUEX_TOP /usr/local/gluex
if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS $GLUEX_TOP/build_scripts
if (! $?LD_LIBRARY_PATH) setenv LD_LIBRARY_PATH ''
# xerces-c++
if (! $?XERCESCROOT) setenv XERCESCROOT $GLUEX_TOP/xerces-c/prod
setenv XERCES_INCLUDE $XERCESCROOT/include
echo $LD_LIBRARY_PATH | grep $XERCESCROOT/lib > /dev/null
if ($status) setenv LD_LIBRARY_PATH  $XERCESCROOT/lib:$LD_LIBRARY_PATH
# root
if (! $?ROOTSYS) setenv ROOTSYS $GLUEX_TOP/root/prod
echo $PATH | grep $ROOTSYS/bin > /dev/null
if ($status) setenv PATH $ROOTSYS/bin:$PATH
echo $LD_LIBRARY_PATH | grep $ROOTSYS/lib > /dev/null
if ($status) setenv LD_LIBRARY_PATH  $ROOTSYS/lib:$LD_LIBRARY_PATH
# cernlib
if (! $?CERN ) setenv CERN $GLUEX_TOP/cernlib
if (! $?CERN_LEVEL) setenv CERN_LEVEL 2006
setenv CERN_ROOT $CERN/$CERN_LEVEL
echo $PATH | grep $CERN_ROOT/bin > /dev/null
if ($status) setenv PATH $CERN_ROOT/bin:$PATH
# clhep
if (! $?CLHEP) setenv CLHEP $GLUEX_TOP/clhep/prod
setenv CLHEP_INCLUDE $CLHEP/include
setenv CLHEP_LIB $CLHEP/lib
echo $LD_LIBRARY_PATH | grep $CLHEP_LIB > /dev/null
if ($status) setenv LD_LIBRARY_PATH ${CLHEP_LIB}:${LD_LIBRARY_PATH}
# hdds
if (! $?HDDS_HOME) setenv HDDS_HOME $GLUEX_TOP/hdds/prod
# halld
if (! $?HALLD_HOME) setenv HALLD_HOME $GLUEX_TOP/sim-recon/prod
if (! $?HALLD_MY) setenv HALLD_MY $HOME/halld_my
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
echo $PATH | grep $HALLD_HOME/bin/$BMS_OSNAME > /dev/null
if ($status) setenv PATH $HALLD_HOME/bin/${BMS_OSNAME}:$PATH
echo $PATH | grep $HALLD_MY/bin/$BMS_OSNAME > /dev/null
if ($status) setenv PATH $HALLD_MY/bin/${BMS_OSNAME}:$PATH
# jana (JANA_GEOMETRY_URL depends on HDDS_HOME)
if (! $?JANA_HOME) setenv JANA_HOME $GLUEX_TOP/jana/prod
if (! $?JANA_CALIB_URL) setenv JANA_CALIB_URL file://$GLUEX_TOP/calib
if (! $?JANA_GEOMETRY_URL) setenv JANA_GEOMETRY_URL \
    xmlfile://$HDDS_HOME/main_HDDS.xml
# ccdb
if (! $?CCDB_HOME) setenv CCDB_HOME $GLUEX_TOP/ccdb/prod
source $CCDB_HOME/environment.csh
# refresh the list of items in the path
rehash
# report environment
if ($gluex_env_verbose) then
    echo ===gluex_env.csh report===
    echo BMS_OSNAME =  $BMS_OSNAME
    echo BUILD_SCRIPTS = $BUILD_SCRIPTS
    echo CERN_ROOT =  $CERN_ROOT
    echo CLHEP = $CLHEP
    echo GLUEX_TOP = $GLUEX_TOP
    echo HALLD_HOME =  $HALLD_HOME
    echo HALLD_MY = $HALLD_MY
    echo HDDS_HOME = $HDDS_HOME
    echo JANA_CALIB_URL = $JANA_CALIB_URL
    echo JANA_GEOMETRY_URL = $JANA_GEOMETRY_URL
    echo JANA_HOME =  $JANA_HOME
    echo LD_LIBRARY_PATH = $LD_LIBRARY_PATH
    echo PATH = $PATH
    echo ROOTSYS =  $ROOTSYS
    echo XERCESCROOT =  $XERCESCROOT
    echo CCDB_HOME = $CCDB_HOME
endif
