#!/bin/tcsh
#
# only allow user variation in BUILD_SCRIPTS, JANA, HDDS, HALLD, HALLD_MY, and CCDB
#
if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS /group/halld/Software/scripts/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
# xerces-c
setenv XERCESCROOT /group/halld/Software/builds/$BMS_OSNAME/xerces-c/xerces-c-3.1.1
# Jana
if (! $?JANA_HOME) setenv JANA_HOME /group/halld/Software/builds/$BMS_OSNAME/jana/jana_0.7.2/$BMS_OSNAME
# ROOT
setenv ROOTSYS /group/halld/Software/builds/$BMS_OSNAME/root/root_5.34.26
# CERNLIB
setenv CERN_CUE `$BUILD_SCRIPTS/cue_cernlib.pl`
setenv CERN $CERN_CUE
setenv CERN_LEVEL 2005
# HDDS
if (! $?HDDS_HOME) setenv HDDS_HOME /group/halld/Software/builds/$BMS_OSNAME/hdds/hdds-3.1
# Hall D
if (! $?HALLD_HOME) setenv HALLD_HOME /group/halld/Software/builds/$BMS_OSNAME/sim-recon/sim-recon-1.1.0
if (! $?HALLD_MY) setenv HALLD_MY $HOME/halld_my
# CCDB
if (! $?CCDB_HOME) setenv CCDB_HOME /group/halld/Software/builds/$BMS_OSNAME/ccdb/ccdb_1.05
# CLHEP
setenv CLHEP /group/halld/Software/builds/$BMS_OSNAME/clhep/2.0.4.5/$BMS_OSNAME
# EVIO
setenv EVIOROOT /group/halld/Software/builds/$BMS_OSNAME/evio/evio-4.3.1/`uname -s`-`uname -m`
# finish the rest of the gluex environment
source $BUILD_SCRIPTS/gluex_env.csh
setenv JANA_CALIB_URL $CCDB_CONNECTION
# python on the cue
setenv PATH /apps/python/PRO/bin:$PATH
setenv LD_LIBRARY_PATH /apps/python/PRO/lib:$LD_LIBRARY_PATH
exit
