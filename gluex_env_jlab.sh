#!/bin/tcsh
#
# only allow user variation in JANA, HDDS, HALLD, HALLD_MY, and CCDB
#
export BUILD_SCRIPTS=/group/halld/Software/scripts/build_scripts
export BMS_OSNAME=`$BUILD_SCRIPTS/osrelease.pl`
# xerces-c
export XERCESCROOT=/group/halld/Software/ExternalPackages/xerces-c-src_2_7_0.$BMS_OSNAME
# Jana
if [ -z "$JANA_HOME" ]; then export JANA_HOME=/group/12gev_phys/builds/jana_0.6.3/$BMS_OSNAME; fi
export JANA_CALIB_URL=file:///group/halld/Software/calib/latest
# ROOT
export ROOTSYS=`$BUILD_SCRIPTS/cue_root.pl`
# CERNLIB
export CERN_CUE=`$BUILD_SCRIPTS/cue_cernlib.pl`
export CERN=/apps/cernlib/$CERN_CUE
export CERN_LEVEL=2005
# HDDS
if [ -z "$HDDS_HOME" ]; then export HDDS_HOME=/group/halld/Software/builds/hdds/hdds-1.3 ; fi
# Hall D
if [ -z "$HALLD_HOME" ]; then export HALLD_HOME=/group/halld/Software/builds/sim-recon/sim-recon-2012-07-26 ; fi
if [ -z "$HALLD_MY" ]; then export HALLD_MY=$HOME/halld_my; fi
# CCDB
if [ -z "$CCDB_HOME" ]; then export CCDB_HOME=/group/halld/Software/builds/ccdb/prod; fi
# CLHEP
export CLHEP=/group/halld/Software/builds/clhep/2.0.4.5/$BMS_OSNAME
# finish the rest of the environment
. $BUILD_SCRIPTS/gluex_env.sh
