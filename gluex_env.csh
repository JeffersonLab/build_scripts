# general stuff
if (! $?GLUEX_TOP) setenv GLUEX_TOP /usr/local
if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS $GLUEX_TOP/build_scripts
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
# halld
if (! $?HALLD_HOME) setenv HALLD_HOME $GLUEX_TOP/halld/prod
if (! $?HALLD_MY) setenv HALLD_MY $HOME/halld_my
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
echo $PATH | grep $HALLD_HOME/bin/$BMS_OSNAME > /dev/null
if ($status) setenv PATH $HALLD_HOME/bin/${BMS_OSNAME}:$PATH
echo $PATH | grep $HALLD_MY/bin/$BMS_OSNAME > /dev/null
if ($status) setenv PATH $HALLD_MY/bin/${BMS_OSNAME}:$PATH
echo $PATH | grep $HALLD_HOME/src/programs/Utilities/hddm > /dev/null
if ($status) setenv PATH  $HALLD_HOME/src/programs/Utilities/hddm:$PATH
# jana (JAMA_GEOMETRY_URL depends on HALLD_HOME)
if (! $?JANA_HOME) setenv JANA_HOME $GLUEX_TOP/jana/prod
setenv JANA_CALIB_URL file://$GLUEX_TOP/gluex/calib
setenv JANA_GEOMETRY_URL \
    xmlfile://$HALLD_HOME/src/programs/Simulation/hdds/main_HDDS.xml
# refresh the list of items in the path
rehash
# report environment
echo ===gluex_env.csh report===
echo BMS_OSNAME =  $BMS_OSNAME
echo BUILD_SCRIPTS = $BUILD_SCRIPTS
echo CERN_ROOT =  $CERN_ROOT
echo GLUEX_TOP = $GLUEX_TOP
echo HALLD_HOME =  $HALLD_HOME
echo HALLD_MY = $HALLD_MY
echo JANA_CALIB_URL = $JANA_CALIB_URL
echo JANA_GEOMETRY_URL = $JANA_GEOMETRY_URL
echo JANA_HOME =  $JANA_HOME
echo LD_LIBRARY_PATH = $LD_LIBRARY_PATH
echo PATH = $PATH
echo ROOTSYS =  $ROOTSYS
echo XERCESCROOT =  $XERCESCROOT
