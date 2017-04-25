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
if [ -z "$LD_LIBRARY_PATH" ]; then export LD_LIBRARY_PATH=''; fi
export BMS_OSNAME=`$BUILD_SCRIPTS/osrelease.pl`
# xerces-c++
if [ -z "$XERCESCROOT" ]; then export XERCESCROOT=$GLUEX_TOP/xerces-c/prod; fi
export XERCES_INCLUDE=$XERCESCROOT/include
if [ `echo $LD_LIBRARY_PATH | grep -c $XERCESCROOT/lib` -eq 0 ]
    then export LD_LIBRARY_PATH=$XERCESCROOT/lib:$LD_LIBRARY_PATH
fi
# root
if [ -z "$ROOTSYS" ]; then export ROOTSYS=$GLUEX_TOP/root/prod; fi
if [ `echo $PATH | grep -c $ROOTSYS/bin` -eq 0 ]
    then export PATH=$ROOTSYS/bin:$PATH
fi
if [ `echo $LD_LIBRARY_PATH | grep -c $ROOTSYS/lib` -eq 0 ]
    then export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH
fi
# cernlib
if [ -z "$CERN" ]; then export CERN=$GLUEX_TOP/cernlib; fi
if [ -z "$CERN_LEVEL" ]; then 					#We don't have CERN_LEVEL
	if [ ${MACHINE_TYPE} == 'x86_64' ]; then
		#on 64 bits 2005 cernlib is provided
		export CERN_LEVEL=2005; 
	else
		#on 32-bit 2006 cernlib is provided
		export CERN_LEVEL=2006;
	fi
fi

export CERN_ROOT=$CERN/$CERN_LEVEL
if [ `echo $PATH | grep -c $CERN_ROOT/bin` -eq 0 ]
    then export PATH=$CERN_ROOT/bin:$PATH
fi
## clhep
#if [ -z "$CLHEP" ]; then export CLHEP=$GLUEX_TOP/clhep/prod; fi
#export CLHEP_INCLUDE=$CLHEP/include
#export CLHEP_LIB=$CLHEP/lib
#if [ `echo $LD_LIBRARY_PATH | grep -c $CLHEP_LIB` -eq 0 ]
#    then export LD_LIBRARY_PATH=${CLHEP_LIB}:${LD_LIBRARY_PATH}
#fi
# Geant4
if [ -z "$G4ROOT" ]; then export G4ROOT=$GLUEX_TOP/geant4/prod; fi
if [ -e "$G4ROOT" ]
    then
    g4setup=`find $G4ROOT/share/ -name geant4make.sh`
    if [ -f "$g4setup" ]; then source $g4setup; fi
    unset g4setup
fi
# amptools
if [ -n "$AMPTOOLS_HOME" ]; then
    export AMPTOOLS=$AMPTOOLS_HOME/AmpTools
    export AMPPLOTTER=$AMPTOOLS_HOME/AmpPlotter
fi
# ccdb
if [ -z "$CCDB_HOME" ]; then export CCDB_HOME=$GLUEX_TOP/ccdb/prod; fi
. $BUILD_SCRIPTS/ccdb_env.sh
if [ -z "$CCDB_USER" ]
    then
    if [ -n "${USER:-}" ]; then export CCDB_USER=$USER; fi
fi
if [ -z "$CCDB_CONNECTION" ]; then export CCDB_CONNECTION=mysql://ccdb_user@hallddb.jlab.org/ccdb; fi
# rcdb
if [ -z "$RCDB_HOME" ]; then export RCDB_HOME=$GLUEX_TOP/rcdb/prod; fi
. $BUILD_SCRIPTS/rcdb_env.sh
if [ -z "$RCDB_CONNECTION" ]; then export RCDB_CONNECTION=mysql://rcdb@hallddb.jlab.org/rcdb; fi
# jana (JANA_GEOMETRY_URL depends on HDDS_HOME)
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
export JANA_GEOMETRY_URL=xmlfile://$HDDS_HOME/main_HDDS.xml
# sim-recon
if [ -z "$HALLD_HOME" ]; then export HALLD_HOME=$GLUEX_TOP/sim-recon/prod; fi
if [ -z "$HALLD_MY" ]; then export HALLD_MY=$HOME/halld_my; fi
if [ `echo $PATH | grep -c $HALLD_HOME/$BMS_OSNAME/bin` -eq 0 ]
    then export PATH=$HALLD_HOME/${BMS_OSNAME}/bin:$PATH
fi
if [ `echo $PATH | grep -c $HALLD_MY/$BMS_OSNAME/bin` -eq 0 ]
    then export PATH=$HALLD_MY/${BMS_OSNAME}/bin:$PATH
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
fi
#
# hd_utilities
#
if [ -z "$HD_UTILITIES_HOME" ]; then export HD_UTILITIES_HOME=$GLUEX_TOP/hd_utilities/prod; fi
export MCWRAPPER_CENTRAL=$HD_UTILITIES_HOME/MCwrapper
export PATH=${MCWRAPPER_CENTRAL}:$PATH
#
# gluex_root_analysis
#
if [ -n "$ROOT_ANALYSIS_HOME" ]; then
    if [ -e "$ROOT_ANALYSIS_HOME" ]; then source $ROOT_ANALYSIS_HOME/env_analysis.sh ; fi
fi
#
if [ -z "$JANA_PLUGIN_PATH" ]
    then
    jpp_save=""
else
    jpp_save=":$JANA_PLUGIN_PATH"
fi
export JANA_PLUGIN_PATH=${HALLD_MY}/${BMS_OSNAME}/plugins:${HALLD_HOME}/${BMS_OSNAME}/plugins:${JANA_HOME}/plugins:${JANA_HOME}/lib${jpp_save}
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
$BUILD_SCRIPTS/version_check.pl
