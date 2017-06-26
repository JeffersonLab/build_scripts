#!/bin/tcsh
setenv BUILD_DATE $1
setenv BMS_OSNAME `/group/halld/Software/build_scripts/osrelease.pl`
source /group/halld/Software/build_scripts/gluex_env_jlab.csh /u/scratch/gluex/nightly/$BUILD_DATE/$BMS_OSNAME/version_$BUILD_DATE.xml
