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
# clhep
if [ -z "$CLHEP" ]; then export CLHEP=$GLUEX_TOP/clhep/prod; fi
export CLHEP_INCLUDE=$CLHEP/include
export CLHEP_LIB=$CLHEP/lib
if [ `echo $LD_LIBRARY_PATH | grep -c $CLHEP_LIB` -eq 0 ]
    then export LD_LIBRARY_PATH=${CLHEP_LIB}:${LD_LIBRARY_PATH}
fi
# hdds
if [ -z "$HDDS_HOME" ]; then export HDDS_HOME=$GLUEX_TOP/hdds/prod; fi
# sim-recon
if [ -z "$HALLD_HOME" ]; then export HALLD_HOME=$GLUEX_TOP/sim-recon/prod; fi
if [ -z "$HALLD_MY" ]; then export HALLD_MY=$HOME/halld_my; fi
export BMS_OSNAME=`$BUILD_SCRIPTS/osrelease.pl`
if [ `echo $PATH | grep -c $HALLD_HOME/bin/$BMS_OSNAME` -eq 0 ]
    then export PATH=$HALLD_HOME/bin/${BMS_OSNAME}:$PATH
fi
if [ `echo $PATH | grep -c $HALLD_MY/bin/$BMS_OSNAME` -eq 0 ]
    then export PATH=$HALLD_MY/bin/${BMS_OSNAME}:$PATH
fi
# jana (JANA_GEOMETRY_URL depends on HDDS_HOME)
if [ -z "$JANA_HOME" ]; then export JANA_HOME=$GLUEX_TOP/jana/prod; fi
if [ -z "$JANA_CALIB_URL" ]
    then export JANA_CALIB_URL=file://$GLUEX_TOP/calib
fi
if [ -z "$JANA_GEOMETRY_URL" ]
    then export JANA_GEOMETRY_URL=xmlfile://$HDDS_HOME/main_HDDS.xml
fi
# ccdb
if [ -z "$CCDB_HOME" ]; then export CCDB_HOME=$GLUEX_TOP/ccdb/prod; fi
. $BUILD_SCRIPTS/ccdb_env.sh
if [ -z "$CCDB_CONNECTION" ]; then export CCDB_CONNECTION=mysql://ccdb_user@hallddb.jlab.org/ccdb; fi
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
