# general stuff
setenv OS `/bin/uname -s`
setenv ARCH `/bin/uname -p`
setenv OSNAME ${OS}-${ARCH}
if (! $?LD_LIBRARY_PATH) setenv LD_LIBRARY_PATH ''
# xerces-c++
if (! $?XERCESCROOT) setenv XERCESCROOT /usr/local/xerces-c/prod
setenv XERCES_INCLUDE $XERCESCROOT/include
echo $LD_LIBRARY_PATH | grep $XERCESCROOT/lib > /dev/null
if ($status) setenv LD_LIBRARY_PATH  $XERCESCROOT/lib:$LD_LIBRARY_PATH
# root
if (! $?ROOTSYS) setenv ROOTSYS /usr/local/root/prod
echo $PATH | grep $ROOTSYS/bin > /dev/null
if ($status) setenv PATH $ROOTSYS/bin:$PATH
echo $LD_LIBRARY_PATH | grep $ROOTSYS/lib > /dev/null
if ($status) setenv LD_LIBRARY_PATH  $ROOTSYS/lib:$LD_LIBRARY_PATH
# cernlib
if (! $?CERN ) setenv CERN /usr/local/cernlib
if (! $?CERN_LEVEL) setenv CERN_LEVEL 2006
echo $PATH | grep $CERN/$CERN_LEVEL/bin > /dev/null
if ($status) setenv PATH $CERN/$CERN_LEVEL/bin:$PATH
# jana
if (! $?JANA_HOME) setenv JANA_HOME /usr/local/jana/prod
setenv JANA_CALIB_URL file:///usr/local/gluex/calib
setenv JANA_GEOMETRY_URL \
    xmlfile:///usr/local/halld/prod/src/programs/Simulation/hdds/main_HDDS.xml
# halld
if (! $?HALLD_HOME) setenv HALLD_HOME /usr/local/halld/prod
if (! $?HALLD_MY) setenv HALLD_MY $HOME/halld_my
# report environment
echo ===gluex_env.csh report===
echo JANA_HOME =  $JANA_HOME
echo OSNAME =  $OSNAME
echo HALLD_HOME =  $HALLD_HOME
echo ROOTSYS =  $ROOTSYS
echo XERCESCROOT =  $XERCESCROOT
echo CERN =  $CERN
echo CERN_LEVEL =  $CERN_LEVEL
echo JANA_CALIB_URL = $JANA_CALIB_URL
echo JANA_GEOMETRY_URL = $JANA_GEOMETRY_URL
echo HALLD_MY = $HALLD_MY
echo PATH = $PATH
echo LD_LIBRARY_PATH = $LD_LIBRARY_PATH
