#!/bin/tcsh
if ( "x$1" == "x" ) then
    set VERSION_XML=/group/halld/www/halldweb/html/dist/version_jlab.xml
else
    set VERSION_XML=$1
endif
setenv BUILD_SCRIPTS /group/halld/Software/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
# farm-specific set-up
set nodename=`uname -n`
if ( $nodename =~ farm* || $nodename =~ ifarm* || $nodename =~ qcd* || $nodename =~ gluon* ) then
    setenv http_proxy http://jprox.jlab.org:8081
    setenv https_proxy https://jprox.jlab.org:8081
    if ( $BMS_OSNAME =~ *CentOS6* || $BMS_OSNAME =~ *RHEL6* )
	set GCC_HOME=/apps/gcc/4.9.2
	setenv PATH ${GCC_HOME}/bin:${PATH}
	setenv LD_LIBRARY_PATH ${GCC_HOME}/lib64:${GCC_HOME}/lib
    endif
endif
setenv GLUEX_TOP /group/halld/Software/builds/$BMS_OSNAME
# perl on the cue
setenv PATH /apps/perl/bin:$PATH
# finish the rest of the gluex environment
source $BUILD_SCRIPTS/gluex_env_version.csh $VERSION_XML
setenv JANA_CALIB_URL $CCDB_CONNECTION
setenv JANA_RESOURCE_DIR /group/halld/www/halldweb/html/resources
# python on the cue
setenv PATH /apps/python/PRO/bin:$PATH
setenv LD_LIBRARY_PATH /apps/python/PRO/lib:$LD_LIBRARY_PATH
