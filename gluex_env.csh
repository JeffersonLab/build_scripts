# process arguments
if ($1 == '-v') then
    set gluex_env_verbose=1
else
    set gluex_env_verbose=0
endif
# general stuff
if (! $?GLUEX_TOP) setenv GLUEX_TOP $HOME/gluex_top
if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS $GLUEX_TOP/build_scripts
if (! $?LD_LIBRARY_PATH) setenv LD_LIBRARY_PATH ''
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
set machine_type=`uname -m`
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
if (! $?CERN_LEVEL) then
    if ($machine_type == 'x86_64') then
        setenv CERN_LEVEL 2005
    else
	setenv CERN_LEVEL 2006
    endif
endif
setenv CERN_ROOT $CERN/$CERN_LEVEL
echo $PATH | grep $CERN_ROOT/bin > /dev/null
if ($status) setenv PATH $CERN_ROOT/bin:$PATH
# clhep
if (! $?CLHEP) setenv CLHEP $GLUEX_TOP/clhep/prod
setenv CLHEP_INCLUDE $CLHEP/include
setenv CLHEP_LIB $CLHEP/lib
echo $LD_LIBRARY_PATH | grep $CLHEP_LIB > /dev/null
if ($status) setenv LD_LIBRARY_PATH ${CLHEP_LIB}:${LD_LIBRARY_PATH}
## amptools
#if (! $?AMPTOOLS_HOME) setenv AMPTOOLS_HOME $GLUEX_TOP/AmpTools/prod
#setenv AMPTOOLS $AMPTOOLS_HOME/AmpTools
#setenv AMPPLOTTER $AMPTOOLS_HOME/AmpPlotter
#setenv CLHEP_INCLUDE_DIR $CLHEP_INCLUDE
#setenv CLHEP_LIB_DIR $CLHEP_LIB
# ccdb
if (! $?CCDB_HOME) setenv CCDB_HOME $GLUEX_TOP/ccdb/prod
source $BUILD_SCRIPTS/ccdb_env.csh
if (! $?CCDB_USER) then
    if ($?USER) then
	setenv CCDB_USER $USER
    endif
endif
if (! $?CCDB_CONNECTION) setenv CCDB_CONNECTION mysql://ccdb_user@hallddb.jlab.org/ccdb
# rcdb
if (! $?RCDB_HOME) setenv RCDB_HOME $GLUEX_TOP/rcdb/prod
source $BUILD_SCRIPTS/rcdb_env.csh
if (! $?RCDB_CONNECTION) setenv RCDB_CONNECTION mysql://rcdb@hallddb.jlab.org/rcdb
# jana (JANA_GEOMETRY_URL depends on HDDS_HOME)
if (! $?JANA_HOME) setenv JANA_HOME $GLUEX_TOP/jana/prod/$BMS_OSNAME
if (! $?JANA_CALIB_URL) setenv JANA_CALIB_URL $CCDB_CONNECTION
echo $PATH | grep $JANA_HOME/bin > /dev/null
if ($status) setenv PATH $JANA_HOME/bin:$PATH
# EVIO
if (! $?EVIOROOT) setenv EVIOROOT $GLUEX_TOP/evio/prod/`uname -s`-`uname -m`
echo $LD_LIBRARY_PATH | grep $EVIOROOT/lib > /dev/null
if ($status) setenv LD_LIBRARY_PATH  $EVIOROOT/lib:$LD_LIBRARY_PATH
# hdds
if (! $?HDDS_HOME) setenv HDDS_HOME $GLUEX_TOP/hdds/prod
setenv JANA_GEOMETRY_URL xmlfile://$HDDS_HOME/main_HDDS.xml
# halld
if (! $?HALLD_HOME) setenv HALLD_HOME $GLUEX_TOP/sim-recon/prod
if (! $?HALLD_MY) setenv HALLD_MY $HOME/halld_my
echo $PATH | grep $HALLD_HOME/$BMS_OSNAME/bin > /dev/null
if ($status) setenv PATH $HALLD_HOME/${BMS_OSNAME}/bin:$PATH
echo $PATH | grep $HALLD_MY/$BMS_OSNAME/bin > /dev/null
if ($status) setenv PATH $HALLD_MY/${BMS_OSNAME}/bin:$PATH
if (! $?JANA_PLUGIN_PATH) then
    set jpp_save=""
else
    set jpp_save=":$JANA_PLUGIN_PATH"
endif
setenv JANA_PLUGIN_PATH ${HALLD_MY}/${BMS_OSNAME}/plugins:${HALLD_HOME}/${BMS_OSNAME}/plugins:${JANA_HOME}/plugins:${JANA_HOME}/lib${jpp_save}
unset jpp_save
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
# check consistency of environment
$BUILD_SCRIPTS/version_check.pl
