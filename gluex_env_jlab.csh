#!/bin/tcsh
#
# only allow user variation in BUILD_SCRIPTS, JANA, HDDS, HALLD, HALLD_MY, and CCDB
#
if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS /group/halld/Software/scripts/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
# xerces-c
setenv XERCESCROOT /group/halld/Software/ExternalPackages/xerces-c-3.1.1.$BMS_OSNAME
# Jana
if (! $?JANA_HOME) setenv JANA_HOME /group/halld/Software/builds/jana/jana_0.7.1p3-ccdb_1.02/$BMS_OSNAME
# ROOT
setenv ROOTSYS `$BUILD_SCRIPTS/cue_root.pl`
# CERNLIB
setenv CERN_CUE `$BUILD_SCRIPTS/cue_cernlib.pl`
setenv CERN $CERN_CUE
setenv CERN_LEVEL 2005
# HDDS
if (! $?HDDS_HOME) setenv HDDS_HOME /group/halld/Software/builds/hdds/hdds-2.1
# Hall D
if (! $?HALLD_HOME) setenv HALLD_HOME /group/halld/Software/builds/sim-recon/sim-recon-2014-06-30
if (! $?HALLD_MY) setenv HALLD_MY $HOME/halld_my
# CCDB
if (! $?CCDB_HOME) setenv CCDB_HOME /group/halld/Software/builds/ccdb/$BMS_OSNAME/ccdb_1.02
# CLHEP
setenv CLHEP /group/halld/Software/builds/clhep/2.0.4.5/$BMS_OSNAME
# finish the rest of the environment
source $BUILD_SCRIPTS/gluex_env.csh
setenv JANA_CALIB_URL $CCDB_CONNECTION
exit
