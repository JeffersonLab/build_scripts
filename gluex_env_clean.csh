if ($?BUILD_SCRIPTS) then
    # clean PATH
    if ($?BMS_OSNAME) then
	if ($?HALLD_MY) eval `$BUILD_SCRIPTS/delpath.pl $HALLD_MY/bin/$BMS_OSNAME`
	if ($?HALLD_HOME) eval `$BUILD_SCRIPTS/delpath.pl $HALLD_HOME/$BMS_OSNAME/bin`
    endif
    if ($?CERN_ROOT) eval `$BUILD_SCRIPTS/delpath.pl $CERN_ROOT/bin`
    if ($?ROOTSYS) eval `$BUILD_SCRIPTS/delpath.pl $ROOTSYS/bin`
    if ($?CCDB_HOME) eval `$BUILD_SCRIPTS/delpath.pl $CCDB_HOME/bin`
    # clean LD_LIBRARY_PATH
    if ($?CLHEP_LIB) eval `$BUILD_SCRIPTS/delpath.pl -l $CLHEP_LIB`
    if ($?ROOTSYS) eval `$BUILD_SCRIPTS/delpath.pl -l $ROOTSYS/lib`
    if ($?XERCESCROOT) eval `$BUILD_SCRIPTS/delpath.pl -l $XERCESCROOT/lib`
    if ($?CCDB_HOME) eval `$BUILD_SCRIPTS/delpath.pl -l $CCDB_HOME/lib`
endif
# clean_environment
unsetenv GLUEX_TOP
unsetenv BUILD_SCRIPTS
unsetenv XERCESCROOT
unsetenv XERCES_INCLUDE
unsetenv ROOTSYS
unsetenv CERN
unsetenv CERN_LEVEL
unsetenv CERN_ROOT
unsetenv CLHEP
unsetenv CLHEP_LIB
unsetenv CLHEP_INCLUDE
unsetenv HDDS_HOME
unsetenv HALLD_HOME
unsetenv HALLD_MY
unsetenv BMS_OSNAME
unsetenv JANA_HOME
unsetenv JANA_CALIB_URL
unsetenv JANA_GEOMETRY_URL
unsetenv CCDB_HOME
unsetenv AMPTOOLS_HOME
unsetenv AMPTOOLS
unsetenv AMPPLOTTER
unsetenv CLHEP_INCLUDE_DIR
unsetenv CLHEP_LIB_DIR
