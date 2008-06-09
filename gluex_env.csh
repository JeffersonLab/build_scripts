if (! $?JANA_HOME) setenv JANA_HOME /usr/local/jana/prod
setenv OS `/bin/uname -s`
setenv ARCH `/bin/uname -p`
setenv OSNAME ${OS}-${ARCH}
if (! $?HALLD_HOME) setenv HALLD_HOME /usr/local/halld/prod
if (! $?ROOTSYS) setenv ROOTSYS /usr/local/root/prod
eval `addpath.pl $ROOTSYS/bin`
if (! $?XERCESCROOT) setenv XERCESCROOT /usr/local/xerces-c/prod
setenv XERCES_INCLUDE $XERCESCROOT/include
setenv LD_LIBRARY_PATH  $ROOTSYS/lib:$XERCESCROOT/lib
if (! $?CERN ) setenv CERN /usr/local/cernlib
setenv CERN_LEVEL 2006
echo JANA_HOME =  $JANA_HOME
echo OSNAME =  $OSNAME
echo HALLD_HOME =  $HALLD_HOME
echo ROOTSYS =  $ROOTSYS
echo XERCESCROOT =  $XERCESCROOT
echo CERN =  $CERN
echo CERN_LEVEL =  $CERN_LEVEL
