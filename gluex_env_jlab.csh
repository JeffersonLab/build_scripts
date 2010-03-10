#!/bin/tcsh
#
# only allow user variation in JANA, HDDS, HALLD, and HALLD_MY
#
setenv BUILD_SCRIPTS /group/halld/Software/scripts/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
# xerces-c
setenv XERCESCROOT /group/halld/Software/ExternalPackages/xerces-c-src_2_7_0.$BMS_OSNAME
# Jana
if (! $?JANA_HOME) setenv JANA_HOME /group/12gev_phys/builds/jana_0.6.0/$BMS_OSNAME
setenv JANA_CALIB_URL file:///group/halld/calib
# ROOT
setenv ROOTSYS `$BUILD_SCRIPTS/cue_root.pl`
# CERNLIB
setenv CERN_CUE `$BUILD_SCRIPTS/cue_cernlib.pl`
setenv CERN /apps/cernlib/$CERN_CUE
setenv CERN_LEVEL 2005
# HDDS
if (! $?HDDS_HOME) setenv HDDS_HOME /group/halld/Software/builds/hdds/hdds-1.0
# Hall D
if (! $?HALLD_HOME) setenv HALLD_HOME /group/halld/Software/builds/release-2010-03-10
if (! $?HALLD_MY) setenv HALLD_MY $HOME/halld_my
# finish the rest of the environment
source $BUILD_SCRIPTS/gluex_env.csh
exit
