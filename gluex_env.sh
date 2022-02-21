#!/bin/sh
# process arguments
if [ "$1" = "-v" ]; then
    gluex_env_verbose=1
else
    gluex_env_verbose=0
fi

#Next lines just finds the path of the file
#Works for all versions,including
#when called via multple depth soft link,
#when script called by command "source" aka . (dot) operator.
#when arg $0 is modified from caller.
#"./script" "/full/path/to/script" "/some/path/../../another/path/script" "./some/folder/script"
#SCRIPT_PATH is given in full path, no matter how it is called.
#Just make sure you locate this at start of the script.
SCRIPT_PATH="${BASH_SOURCE[0]}";
if([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
pushd . > /dev/null
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

MACHINE_TYPE=`uname -m`

# general stuff
if [ -z "$GLUEX_TOP" ]; then export GLUEX_TOP=$(readlink -m $SCRIPT_PATH/..); fi
if [ -z "$BUILD_SCRIPTS" ]
    then export BUILD_SCRIPTS=$GLUEX_TOP/build_scripts
fi
if [ -z "$BMS_OSNAME" ]
then export BMS_OSNAME=`$BUILD_SCRIPTS/osrelease.pl`
fi
if [ -z "$LD_LIBRARY_PATH" ]; then export LD_LIBRARY_PATH=''; fi
# xerces-c++
if [ -n "$XERCESCROOT" ]
then
    export XERCES_INCLUDE=$XERCESCROOT/include
    if [ `echo $LD_LIBRARY_PATH | grep -c $XERCESCROOT/lib` -eq 0 ]
    then export LD_LIBRARY_PATH=$XERCESCROOT/lib:$LD_LIBRARY_PATH
    fi
fi
# root
if [ -n "$ROOTSYS" ]
then
    if [ `echo $PATH | grep -c $ROOTSYS/bin` -eq 0 ]
    then
	export PATH=$ROOTSYS/bin:$PATH
    fi
    if [ `echo $LD_LIBRARY_PATH | grep -c $ROOTSYS/lib` -eq 0 ]
    then
	export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH
    fi
    if [ `echo $PYTHONPATH | grep -c $ROOTSYS/lib` -eq 0 ]
    then
	export PYTHONPATH=$ROOTSYS/lib:$PYTHONPATH
    fi
fi
# cernlib
if [ -n "$CERN" ]
then
    if [ -z "$CERN_LEVEL" ]
    then 					#We don't have CERN_LEVEL
	if [ ${MACHINE_TYPE} == 'x86_64' ]
	then
	    #on 64 bits 2005 cernlib is provided
	    export CERN_LEVEL=2005; 
	else
	    #on 32-bit 2006 cernlib is provided
	    export CERN_LEVEL=2006;
	fi
    fi
    export CERN_ROOT=$CERN/$CERN_LEVEL
    if [ `echo $PATH | grep -c $CERN_ROOT/bin` -eq 0 ]
    then
	export PATH=$CERN_ROOT/bin:$PATH
    fi
fi
## clhep
#if [ -z "$CLHEP" ]; then export CLHEP=$GLUEX_TOP/clhep/prod; fi
#export CLHEP_INCLUDE=$CLHEP/include
#export CLHEP_LIB=$CLHEP/lib
#if [ `echo $LD_LIBRARY_PATH | grep -c $CLHEP_LIB` -eq 0 ]
#    then export LD_LIBRARY_PATH=${CLHEP_LIB}:${LD_LIBRARY_PATH}
#fi
# Geant4
if [ -n "$G4ROOT" ]
then
    if [ -e "$G4ROOT" ]
    then
	g4setup=`find $G4ROOT/share/ -maxdepth 3 -name geant4make.sh`
	if [ -f "$g4setup" ]
	then
	    source $g4setup
	fi
	eval `$BUILD_SCRIPTS/delpath.pl -b -l /usr/lib64`
	unset g4setup
    fi
fi
# amptools
if [ -n "$AMPTOOLS_HOME" ]
then
    export AMPTOOLS=$AMPTOOLS_HOME/AmpTools
    export AMPPLOTTER=$AMPTOOLS_HOME/AmpPlotter
fi
# ccdb
if [ -n "$CCDB_HOME" ]
then
    . $BUILD_SCRIPTS/ccdb_env.sh
    if [ -z "$CCDB_USER" ]
    then
	if [ -n "${USER:-}" ]
	then
	    export CCDB_USER=$USER
	fi
    fi
    if [ -z "$CCDB_CONNECTION" ]
    then
	export CCDB_CONNECTION=mysql://ccdb_user@hallddb.jlab.org/ccdb
    fi
fi
# rcdb
if [ -n "$RCDB_HOME" ]
then
    . $BUILD_SCRIPTS/rcdb_env.sh
    if [ -z "$RCDB_CONNECTION" ]
    then
	export RCDB_CONNECTION=mysql://rcdb@hallddb.jlab.org/rcdb
    fi
fi
# jana
if [ -z "$JANA_HOME" ]; then export JANA_HOME=$GLUEX_TOP/jana/prod/$BMS_OSNAME; fi
if [ -z "$JANA_CALIB_URL" ]
    then export JANA_CALIB_URL=$CCDB_CONNECTION
fi
if [ `echo $PATH | grep -c $JANA_HOME/bin` -eq 0 ]
    then export PATH=$JANA_HOME/bin:$PATH
fi
# EVIO
if [ -z "$EVIOROOT" ]; then export EVIOROOT=$GLUEX_TOP/evio/prod/`uname -s`-`uname -m`; fi
if [ `echo $LD_LIBRARY_PATH | grep -c $EVIOROOT/lib` -eq 0 ]
    then export LD_LIBRARY_PATH=$EVIOROOT/lib:$LD_LIBRARY_PATH
fi
# hdds
if [ -z "$HDDS_HOME" ]; then export HDDS_HOME=$GLUEX_TOP/hdds/prod; fi
export JANA_GEOMETRY_URL=ccdb:///GEOMETRY/main_HDDS.xml
# sim-recon
if [ -n "$HALLD_HOME" ]
    then
    if [ `echo $PATH | grep -c $HALLD_HOME/$BMS_OSNAME/bin` -eq 0 ]
        then export PATH=$HALLD_HOME/${BMS_OSNAME}/bin:$PATH
    fi
    export PYTHONPATH=$HALLD_HOME/$BMS_OSNAME/python2:$PYTHONPATH
fi
# halld_recon
if [ -n "$HALLD_RECON_HOME" ]
    then
    if [ `echo $PATH | grep -c $HALLD_RECON_HOME/$BMS_OSNAME/bin` -eq 0 ]
        then export PATH=$HALLD_RECON_HOME/${BMS_OSNAME}/bin:$PATH
    fi
    export PYTHONPATH=$HALLD_RECON_HOME/$BMS_OSNAME/python2:$PYTHONPATH
fi
# halld_sim
if [ -n "$HALLD_SIM_HOME" ]
    then
    if [ `echo $PATH | grep -c $HALLD_SIM_HOME/$BMS_OSNAME/bin` -eq 0 ]
        then export PATH=$HALLD_SIM_HOME/${BMS_OSNAME}/bin:$PATH
    fi
fi
# halld_my
if [ -z "$HALLD_MY" ]
    then
    export HALLD_MY=$HOME/halld_my
    if [ `echo $PATH | grep -c $HALLD_MY/$BMS_OSNAME/bin` -eq 0 ]
        then export PATH=$HALLD_MY/${BMS_OSNAME}/bin:$PATH
    fi
fi
#
# Diracxx
#
if [ -n "$DIRACXX_HOME" ]; then
    if [ `echo $LD_LIBRARY_PATH | grep -c $DIRACXX_HOME` -eq 0 ]
    then export LD_LIBRARY_PATH=$DIRACXX_HOME/lib:$DIRACXX_HOME:$LD_LIBRARY_PATH # covers both old and new Diracxx lib location
    fi
fi
#
# HDGeant4
#
if [ -n "$HDGEANT4_HOME" ]; then
    if [ -n "$G4SYSTEM" ]; then
        if [ `echo $PATH | grep -c $HDGEANT4_HOME/bin/$G4SYSTEM` -eq 0 ]; then
            export PATH=$HDGEANT4_HOME/bin/${G4SYSTEM}:$PATH
        fi
    fi
    if [ `echo $PYTHONPATH | grep -c $HDGEANT4_HOME/g4py` -eq 0 ]; then
	export PYTHONPATH=$HDGEANT4_HOME/g4py:$PYTHONPATH
    fi
fi
#
# hd_utilities
#
if [ -z "$HD_UTILITIES_HOME" ]; then export HD_UTILITIES_HOME=$GLUEX_TOP/hd_utilities/prod; fi
#
# gluex_MCwrapper
#
if [ -z "$MCWRAPPER_CENTRAL" ]; then export MCWRAPPER_CENTRAL=$HD_UTILITIES_HOME/MCwrapper; fi
export PATH=${MCWRAPPER_CENTRAL}:$PATH
#
# gluex_root_analysis
#
if [ -n "$ROOT_ANALYSIS_HOME" ]; then
    if [ -e "$ROOT_ANALYSIS_HOME" ]; then source $ROOT_ANALYSIS_HOME/env_analysis.sh ; fi
fi
#
# SQLiteCpp
#
if [ -z "$SQLITECPP_HOME" ]; then export SQLITECPP_HOME=$GLUEX_TOP/sqlitecpp/prod; fi
# hepmc
if [ -n "$HEPMCDIR" ]; then
    if [ `echo $LD_LIBRARY_PATH | grep -c $HEPMCDIR/lib` -eq 0 ]
    then export LD_LIBRARY_PATH=$HEPMCDIR/lib:$LD_LIBRARY_PATH
    fi
fi
# photos
if [ -n "$PHOTOSDIR" ]; then
    if [ `echo $LD_LIBRARY_PATH | grep -c $PHOTOSDIR/lib` -eq 0 ]
    then export LD_LIBRARY_PATH=$PHOTOSDIR/lib:$LD_LIBRARY_PATH
    fi
fi
# evtgen
if [ -n "$EVTGENDIR" ]; then
    if [ `echo $LD_LIBRARY_PATH | grep -c $EVTGENDIR/lib` -eq 0 ]
    then export LD_LIBRARY_PATH=$EVTGENDIR/lib:$LD_LIBRARY_PATH
    fi
fi
#
if [ -z "$JANA_PLUGIN_PATH" ]
    then
    jpp_save=""
else
    jpp_save=":$JANA_PLUGIN_PATH"
fi
export JANA_PLUGIN_PATH=${JANA_HOME}/plugins:${JANA_HOME}/lib${jpp_save}
if [ -n "$HALLD_HOME" ]
    then
    export JANA_PLUGIN_PATH=${HALLD_HOME}/${BMS_OSNAME}/plugins:$JANA_PLUGIN_PATH
fi
if [ -n "$HALLD_RECON_HOME" ]
    then
    export JANA_PLUGIN_PATH=${HALLD_RECON_HOME}/${BMS_OSNAME}/plugins:$JANA_PLUGIN_PATH
fi
if [ -n "$HALLD_SIM_HOME" ]
    then
    export JANA_PLUGIN_PATH=${HALLD_SIM_HOME}/${BMS_OSNAME}/plugins:$JANA_PLUGIN_PATH
fi
export JANA_PLUGIN_PATH=${HALLD_MY}/${BMS_OSNAME}/plugins:$JANA_PLUGIN_PATH
unset jpp_save
# refresh the list of items in the path
hash -r
# report environment
if [ $gluex_env_verbose -eq 1 ]
    then
    echo ===gluex_env.sh report===
    echo this script path $SCRIPT_PATH
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
fi
# check consistency of environment
if [ "$BUILD_SCRIPTS_CONSISTENCY_CHECK" != "false" ]
then $BUILD_SCRIPTS/version_check.pl
fi
