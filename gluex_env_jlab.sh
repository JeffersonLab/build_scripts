#!/bin/tcsh
#
# only allow user variation in BUILD_SCRIPTS, JANA, HDDS, HALLD, HALLD_MY, and CCDB
#
if [ -z "$BUILD_SCRIPTS" ]; then export BUILD_SCRIPTS=/group/halld/Software/scripts/build_scripts ; fi
export BMS_OSNAME=`$BUILD_SCRIPTS/osrelease.pl`
# xerces-c
export XERCESCROOT=/group/halld/Software/builds/$BMS_OSNAME/xerces-c/xerces-c-3.1.1
# Jana
if [ -z "$JANA_HOME" ]; then export JANA_HOME=/group/halld/Software/builds/$BMS_OSNAME/jana/jana_0.7.2/$BMS_OSNAME; fi
# ROOT
export ROOTSYS=/group/halld/Software/builds/$BMS_OSNAME/root/root_5.34.26
# CERNLIB
export CERN_CUE=`$BUILD_SCRIPTS/cue_cernlib.pl`
export CERN=$CERN_CUE
export CERN_LEVEL=2005
# HDDS
if [ -z "$HDDS_HOME" ]; then export HDDS_HOME=/group/halld/Software/builds/$BMS_OSNAME/hdds/hdds-3.1 ; fi
# Hall D
if [ -z "$HALLD_HOME" ]; then export HALLD_HOME=/group/halld/Software/builds/$BMS_OSNAME/sim-recon/sim-recon-1.1.0 ; fi
if [ -z "$HALLD_MY" ]; then export HALLD_MY=$HOME/halld_my; fi
# CCDB
if [ -z "$CCDB_HOME" ]; then export CCDB_HOME=/group/halld/Software/builds/$BMS_OSNAME/ccdb/ccdb_1.05; fi
# CLHEP
export CLHEP=/group/halld/Software/builds/$BMS_OSNAME/clhep/2.0.4.5/$BMS_OSNAME
# EVIO
export EVIOROOT=/group/halld/Software/builds/$BMS_OSNAME/evio/evio-4.3.1/`uname -s`-`uname -m`
# finish the rest of the environment
. $BUILD_SCRIPTS/gluex_env.sh
export JANA_CALIB_URL=$CCDB_CONNECTION
# python on the cue
export PATH=/apps/python/PRO/bin:$PATH
export LD_LIBRARY_PATH=/apps/python/PRO/lib:$LD_LIBRARY_PATH
