# general stuff
if ($1 != '') setenv GLUEX_TOP $1
if (! $?GLUEX_TOP) setenv GLUEX_TOP `pwd`
if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS $GLUEX_TOP/build_scripts
setenv OS `/bin/uname -s`
setenv ARCH `/bin/uname -p`
setenv OSNAME ${OS}-${ARCH}
if (! $?LD_LIBRARY_PATH) setenv LD_LIBRARY_PATH ''
# xerces-c++
if (! $?XERCESCROOT) setenv XERCESCROOT $GLUEX_TOP/xerces-c/prod
setenv XERCES_INCLUDE $XERCESCROOT/include
echo $LD_LIBRARY_PATH | grep $XERCESCROOT/lib > /dev/null
if ($status) setenv LD_LIBRARY_PATH  $XERCESCROOT/lib:$LD_LIBRARY_PATH
# root
if (! $?ROOTSYS) setenv ROOTSYS $GLUEX_TOP/root/prod
echo $PATH | grep $ROOTSYS/bin > /dev/null
if ($status) setenv PATH $ROOTSYS/bin:$PATH
echo $LD_LIBRARY_PATH | grep $ROOTSYS/lib > /dev/null
if ($status) setenv LD_LIBRARY_PATH  $ROOTSYS/lib:$LD_LIBRARY_PATH
# cernlib
if (! $?CERN ) setenv CERN $GLUEX_TOP/cernlib
if (! $?CERN_LEVEL) setenv CERN_LEVEL 2006
setenv CERN_ROOT $CERN/$CERN_LEVEL
echo $PATH | grep $CERN_ROOT/bin > /dev/null
if ($status) setenv PATH $CERN_ROOT/bin:$PATH
# jana
if (! $?JANA_HOME) setenv JANA_HOME $GLUEX_TOP/jana/prod
setenv JANA_CALIB_URL file://$GLUEX_TOP/gluex/calib
setenv JANA_GEOMETRY_URL \
    xmlfile://$GLUEX_TOP/halld/prod/src/programs/Simulation/hdds/main_HDDS.xml
# halld
if (! $?HALLD_HOME) setenv HALLD_HOME $GLUEX_TOP/halld/prod
if (! $?HALLD_MY) setenv HALLD_MY $HOME/halld_my
echo $PATH | grep $HALLD_HOME/bin/$OSNAME > /dev/null
if ($status) setenv PATH $HALLD_HOME/bin/${OSNAME}:$PATH
echo $PATH | grep $HALLD_MY/bin/$OSNAME > /dev/null
if ($status) setenv PATH $HALLD_MY/bin/${OSNAME}:$PATH
# refresh the list of items in the path
rehash
# report environment
echo ===gluex_env.csh report===
echo GLUEX_TOP = $GLUEX_TOP
echo JANA_HOME =  $JANA_HOME
echo OSNAME =  $OSNAME
echo HALLD_HOME =  $HALLD_HOME
echo ROOTSYS =  $ROOTSYS
echo XERCESCROOT =  $XERCESCROOT
echo CERN_ROOT =  $CERN_ROOT
echo JANA_CALIB_URL = $JANA_CALIB_URL
echo JANA_GEOMETRY_URL = $JANA_GEOMETRY_URL
echo HALLD_MY = $HALLD_MY
echo PATH = $PATH
echo LD_LIBRARY_PATH = $LD_LIBRARY_PATH
echo paw = `which paw`
echo root = `which root`
