if (! $?JANA_HOME) setenv JANA_HOME /usr/local/jana/prod
setenv OS `/bin/uname -s`
setenv ARCH `/bin/uname -p`
setenv OSNAME ${OS}-${ARCH}
if (! $?HALLD_HOME) setenv HALLD_HOME /usr/local/halld/prod
if (! $?ROOTSYS) setenv ROOTSYS /usr/local/root/prod
echo $PATH | grep $ROOTSYS/bin > /dev/null
if ($status) setenv PATH $ROOTSYS/bin:$PATH
if (! $?XERCESCROOT) setenv XERCESCROOT /usr/local/xerces-c/prod
setenv XERCES_INCLUDE $XERCESCROOT/include
setenv LD_LIBRARY_PATH  $ROOTSYS/lib:$XERCESCROOT/lib
if (! $?CERN ) setenv CERN /usr/local/cernlib
if (! $?CERN_LEVEL) setenv CERN_LEVEL 2006
echo $PATH | grep $CERN/$CERN_LEVEL/bin > /dev/null
if ($status) setenv PATH $CERN/$CERN_LEVEL/bin:$PATH
echo JANA_HOME =  $JANA_HOME
echo OSNAME =  $OSNAME
echo HALLD_HOME =  $HALLD_HOME
echo ROOTSYS =  $ROOTSYS
echo XERCESCROOT =  $XERCESCROOT
echo CERN =  $CERN
echo CERN_LEVEL =  $CERN_LEVEL
echo PATH = $PATH
