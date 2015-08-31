#!/bin/tcsh
set VERSION_XML=/group/halld/www/halldweb/html/dist/version.xml
setenv BUILD_SCRIPTS /group/halld/Software/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
setenv GLUEX_TOP /group/halld/Software/builds/$BMS_OSNAME
# finish the rest of the gluex environment
source $BUILD_SCRIPTS/gluex_env_version.csh $VERSION_XML
setenv JANA_CALIB_URL $CCDB_CONNECTION
# python on the cue
setenv PATH /apps/python/PRO/bin:$PATH
setenv LD_LIBRARY_PATH /apps/python/PRO/lib:$LD_LIBRARY_PATH
exit
