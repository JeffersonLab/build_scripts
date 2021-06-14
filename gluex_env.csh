# process arguments
if ($1 == '-v') then
    set gluex_env_verbose=1
else
    set gluex_env_verbose=0
endif
# general stuff
if (! $?GLUEX_TOP) setenv GLUEX_TOP $HOME/gluex_top
if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS $GLUEX_TOP/build_scripts
if (! $?BMS_OSNAME) setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
if (! $?LD_LIBRARY_PATH) setenv LD_LIBRARY_PATH ''
if (! $?PYTHONPATH) setenv PYTHONPATH ''
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
echo $PYTHONPATH | grep $ROOTSYS/lib > /dev/null
if ($status) setenv PYTHONPATH $ROOTSYS/lib:$PYTHONPATH
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
## clhep
#if (! $?CLHEP) setenv CLHEP $GLUEX_TOP/clhep/prod
#setenv CLHEP_INCLUDE $CLHEP/include
#setenv CLHEP_LIB $CLHEP/lib
#echo $LD_LIBRARY_PATH | grep $CLHEP_LIB > /dev/null
#if ($status) setenv LD_LIBRARY_PATH ${CLHEP_LIB}:${LD_LIBRARY_PATH}
# Geant4
if (! $?G4ROOT) setenv G4ROOT $GLUEX_TOP/geant4/prod
if ( -e $G4ROOT) then
    set g4setup=`find $G4ROOT/share/ -maxdepth 3 -name geant4make.csh`
    if ( -f $g4setup) then
	set g4dir=`dirname $g4setup`
	source $g4setup $g4dir
	unset g4dir
    endif
    unset g4setup
endif
# amptools
if ($?AMPTOOLS_HOME) then
setenv AMPTOOLS $AMPTOOLS_HOME/AmpTools
setenv AMPPLOTTER $AMPTOOLS_HOME/AmpPlotter
endif
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
# jana
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
setenv JANA_GEOMETRY_URL ccdb:///GEOMETRY/main_HDDS.xml
# halld
if ($?HALLD_HOME) then
    echo $PATH | grep $HALLD_HOME/$BMS_OSNAME/bin > /dev/null
    if ($status) setenv PATH $HALLD_HOME/${BMS_OSNAME}/bin:$PATH
    setenv PYTHONPATH $HALLD_HOME/$BMS_OSNAME/python2:$PYTHONPATH
endif
# halld_recon
if ($?HALLD_RECON_HOME) then
    echo $PATH | grep $HALLD_RECON_HOME/$BMS_OSNAME/bin > /dev/null
    if ($status) setenv PATH $HALLD_RECON_HOME/${BMS_OSNAME}/bin:$PATH
    setenv PYTHONPATH $HALLD_RECON_HOME/$BMS_OSNAME/python2:$PYTHONPATH
endif
# halld_sim
if ($?HALLD_SIM_HOME) then
    echo $PATH | grep $HALLD_SIM_HOME/$BMS_OSNAME/bin > /dev/null
    if ($status) setenv PATH $HALLD_SIM_HOME/${BMS_OSNAME}/bin:$PATH
endif
# halld_my
if (! $?HALLD_MY) then
    setenv HALLD_MY $HOME/halld_my
    echo $PATH | grep $HALLD_MY/$BMS_OSNAME/bin > /dev/null
    if ($status) setenv PATH $HALLD_MY/${BMS_OSNAME}/bin:$PATH
endif
#
# Diracxx
#
if ($?DIRACXX_HOME) then
    echo $LD_LIBRARY_PATH | grep $DIRACXX_HOME > /dev/null
    if ($status) setenv LD_LIBRARY_PATH ${DIRACXX_HOME}:$LD_LIBRARY_PATH
endif
#
# HDGeant4
#
if ($?HDGEANT4_HOME) then
    if ($?G4SYSTEM) then
        echo $PATH | grep $HDGEANT4_HOME/bin/$G4SYSTEM > /dev/null
        if ($status) setenv PATH $HDGEANT4_HOME/bin/${G4SYSTEM}:$PATH
    endif
    echo $PYTHONPATH | grep $HDGEANT4_HOME/g4py > /dev/null
    if ($status) setenv PYTHONPATH $HDGEANT4_HOME/g4py:$PYTHONPATH
endif
#
# hd_utilities
#
if (! $?HD_UTILITIES_HOME) setenv HD_UTILITIES_HOME $GLUEX_TOP/hd_utilities/prod
#
# gluex_MCwrapper
#
if (! $?MCWRAPPER_CENTRAL) setenv MCWRAPPER_CENTRAL $HD_UTILITIES_HOME/MCwrapper
setenv PATH ${MCWRAPPER_CENTRAL}:$PATH
#
# gluex_root_analysis
#
if ($?ROOT_ANALYSIS_HOME) then
    if (-e $ROOT_ANALYSIS_HOME) source $ROOT_ANALYSIS_HOME/env_analysis.csh
endif
#
# sqlitecpp
#
if (! $?SQLITECPP_HOME) setenv SQLITECPP_HOME $GLUEX_TOP/sqlitecpp/prod
#
# hepmc
#
if ($?HEPMCDIR) then
    echo $LD_LIBRARY_PATH | grep $HEPMCDIR/lib > /dev/null
    if ($status) setenv LD_LIBRARY_PATH $HEPMCDIR/lib:$LD_LIBRARY_PATH
endif
#
# photos
#
if ($?PHOTOSDIR) then
    echo $LD_LIBRARY_PATH | grep $PHOTOSDIR/lib > /dev/null
    if ($status) setenv LD_LIBRARY_PATH $PHOTOSDIR/lib:$LD_LIBRARY_PATH
endif
#
# evtgen
#
if ($?EVTGENDIR) then
    echo $LD_LIBRARY_PATH | grep $EVTGENDIR/lib > /dev/null
    if ($status) setenv LD_LIBRARY_PATH $EVTGENDIR/lib:$LD_LIBRARY_PATH
endif
#
if (! $?JANA_PLUGIN_PATH) then
    set jpp_save=""
else
    set jpp_save=":$JANA_PLUGIN_PATH"
endif
setenv JANA_PLUGIN_PATH ${JANA_HOME}/plugins:${JANA_HOME}/lib${jpp_save}
if ($?HALLD_HOME) then
    setenv JANA_PLUGIN_PATH ${HALLD_HOME}/${BMS_OSNAME}/plugins:$JANA_PLUGIN_PATH
endif
if ($?HALLD_RECON_HOME) then
    setenv JANA_PLUGIN_PATH ${HALLD_RECON_HOME}/${BMS_OSNAME}/plugins:$JANA_PLUGIN_PATH
endif
if ($?HALLD_SIM_HOME) then
    setenv JANA_PLUGIN_PATH ${HALLD_SIM_HOME}/${BMS_OSNAME}/plugins:$JANA_PLUGIN_PATH
endif
setenv JANA_PLUGIN_PATH ${HALLD_MY}/${BMS_OSNAME}/plugins:$JANA_PLUGIN_PATH
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
set check_versions="true"
if($?BUILD_SCRIPTS_CONSISTENCY_CHECK) then
    if ($BUILD_SCRIPTS_CONSISTENCY_CHECK == "false") then
	set check_versions="false" 
    endif
endif
if ($check_versions == "true") then
    $BUILD_SCRIPTS/version_check.pl
endif
