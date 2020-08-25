#!/bin/bash
if [ -z $1 ]
    then
    VERSION_XML=/group/halld/www/halldweb/html/halld_versions/version.xml
else
    VERSION_XML=$1
fi
if [ -z "$BUILD_SCRIPTS" ]
    then export BUILD_SCRIPTS=/group/halld/Software/build_scripts
fi
export BMS_OSNAME=`$BUILD_SCRIPTS/osrelease.pl`
if [[ $BMS_OSNAME != *CentOS7.7* ]]
    then
    if [ `echo $PATH | grep -c /apps/bin` -eq 0 ]
        then
	export PATH=/apps/bin:$PATH
    fi
fi
# farm-specific set-up
nodename=`uname -n`
if [[ $nodename =~ ^farm* || $nodename =~ ^ifarm* || $nodename =~ ^qcd* || $nodename =~ ^gluon* ]]
    then
    export http_proxy=http://jprox.jlab.org:8081
    export https_proxy=https://jprox.jlab.org:8081
fi
if [[ $BMS_OSNAME == *CentOS6* || $BMS_OSNAME == *RHEL6* ]]
    then
    GCC_HOME=/apps/gcc/4.9.2
    export PATH=${GCC_HOME}/bin:${PATH}
    export LD_LIBRARY_PATH=${GCC_HOME}/lib64:${GCC_HOME}/lib
    export BMS_OSNAME=`$BUILD_SCRIPTS/osrelease.pl`
    # python on the cue
    pypath=/group/halld/Software/builds/$BMS_OSNAME/python/Python-2.7.13
    export PATH=$pypath:$PATH
    export LD_LIBRARY_PATH=$pypath/lib:$LD_LIBRARY_PATH
fi
export GLUEX_TOP=/group/halld/Software/builds/$BMS_OSNAME
# perl on the cue
export PATH=/apps/perl/bin:$PATH
# finish the rest of the environment
. $BUILD_SCRIPTS/gluex_env_version.sh $VERSION_XML
export JANA_CALIB_URL=`$BUILD_SCRIPTS/calib_url_chooser.sh`
export JANA_RESOURCE_DIR=/group/halld/www/halldweb/html/resources
# cmake on the cue
if [[ $BMS_OSNAME != *CentOS7.7* ]]
    then
    export PATH=/apps/cmake/cmake-3.5.1/bin:$PATH
fi
