#!/bin/tcsh
#
# only allow user variation in JANA, HDDS, HALLD, HALLD_MY, and CCDB
#
setenv BUILD_SCRIPTS /group/halld/Software/scripts/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
# xerces-c
setenv XERCESCROOT /group/halld/Software/ExternalPackages/xerces-c-3.1.1.$BMS_OSNAME
# Jana
if (! $?JANA_HOME) setenv JANA_HOME /group/12gev_phys/builds/jana_0.6.5/$BMS_OSNAME
setenv JANA_CALIB_URL file:///group/halld/Software/calib/latest
# ROOT
setenv ROOTSYS `$BUILD_SCRIPTS/cue_root.pl`
# CERNLIB
setenv CERN_CUE `$BUILD_SCRIPTS/cue_cernlib.pl`
setenv CERN $CERN_CUE
setenv CERN_LEVEL 2005
# HDDS
if (! $?HDDS_HOME) setenv HDDS_HOME /group/halld/Software/builds/hdds/hdds-1.4
# Hall D
if (! $?HALLD_HOME) setenv HALLD_HOME /group/halld/Software/builds/sim-recon/sim-recon-2012-11-16
if (! $?HALLD_MY) setenv HALLD_MY $HOME/halld_my
# CCDB
if (! $?CCDB_HOME) setenv CCDB_HOME /group/halld/Software/builds/ccdb/$BMS_OSNAME/ccdb_0.06
# CLHEP
setenv CLHEP /group/halld/Software/builds/clhep/2.0.4.5/$BMS_OSNAME
# finish the rest of the environment
source $BUILD_SCRIPTS/gluex_env.csh
exit
