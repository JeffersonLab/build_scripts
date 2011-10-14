# clean PATH
eval `$BUILD_SCRIPTS/delpath.pl $HALLD_MY/bin/$BMS_OSNAME`
eval `$BUILD_SCRIPTS/delpath.pl $HALLD_HOME/bin/$BMS_OSNAME`
eval `$BUILD_SCRIPTS/delpath.pl $CERN_ROOT/bin`
eval `$BUILD_SCRIPTS/delpath.pl $ROOTSYS/bin`
# clean LD_LIBRARY_PATH
eval `$BUILD_SCRIPTS/delpath.pl -l $CLHEP_LIB`
eval `$BUILD_SCRIPTS/delpath.pl -l $ROOTSYS/lib`
eval `$BUILD_SCRIPTS/delpath.pl -l $XERCESCROOT/lib`
# clean_environment
unsetenv GLUEX_TOP
unsetenv BUILD_SCRIPTS
unsetenv XERCESCROOT
unsetenv XERCES_INCLUDE
unsetenv ROOTSYS
unsetenv CERN
unsetenv CERN_LEVEL
unsetenv CERN_ROOT
unsetenv CLHEP_HOME
unsetenv CLHEP_LIB
unsetenv CLHEP_INCLUDE
unsetenv HDDS_HOME
unsetenv HALLD_HOME
unsetenv HALLD_MY
unsetenv BMS_OSNAME
unsetenv JANA_HOME
unsetenv JANA_CALIB_URL
unsetenv JANA_GEOMETRY_URL
