if ($?BUILD_SCRIPTS) then
    # clean PATH
    if ($?BMS_OSNAME) then
	if ($?HALLD_MY) eval `$BUILD_SCRIPTS/delpath.pl $HALLD_MY/$BMS_OSNAME/bin`
	if ($?HALLD_HOME) eval `$BUILD_SCRIPTS/delpath.pl $HALLD_HOME/$BMS_OSNAME/bin`
    endif
    if ($?CERN_ROOT) eval `$BUILD_SCRIPTS/delpath.pl $CERN_ROOT/bin`
    if ($?ROOTSYS) eval `$BUILD_SCRIPTS/delpath.pl $ROOTSYS/bin`
    if ($?CCDB_HOME) eval `$BUILD_SCRIPTS/delpath.pl $CCDB_HOME/bin`
    if ($?JANA_HOME) eval `$BUILD_SCRIPTS/delpath.pl $JANA_HOME/bin`
    # clean LD_LIBRARY_PATH
    if ($?CLHEP_LIB) eval `$BUILD_SCRIPTS/delpath.pl -l $CLHEP_LIB`
    if ($?ROOTSYS) eval `$BUILD_SCRIPTS/delpath.pl -l $ROOTSYS/lib`
    if ($?XERCESCROOT) eval `$BUILD_SCRIPTS/delpath.pl -l $XERCESCROOT/lib`
    if ($?CCDB_HOME) eval `$BUILD_SCRIPTS/delpath.pl -l $CCDB_HOME/lib`
    if ($?EVIOROOT) eval `$BUILD_SCRIPTS/delpath.pl -l $EVIOROOT/lib`
    eval `$BUILD_SCRIPTS/delpath.pl -l`
    # clean PYTHONPATH
    if ($?CCDB_HOME) eval `$BUILD_SCRIPTS/delpath.pl -p $CCDB_HOME/python $CCDB_HOME/python/ccdb/ccdb_pyllapi`
    eval `$BUILD_SCRIPTS/delpath.pl -p`
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
unsetenv CERNLIB_WORD_LENGTH
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
unsetenv JANA_PLUGIN_PATH
unsetenv JANA_RESOURCE_DIR
unsetenv CCDB_HOME
unsetenv AMPTOOLS_HOME
unsetenv AMPTOOLS
unsetenv AMPPLOTTER
unsetenv CLHEP_INCLUDE_DIR
unsetenv CLHEP_LIB_DIR
unsetenv CCDB_CONNECTION
unsetenv CCDB_USER
unsetenv EVIOROOT
unsetenv RCDB_HOME
unsetenv RCDB_CONNECTION
unsetenv HDGEANT4_HOME
# versions
unsetenv SIM_RECON_VERSION
unsetenv JANA_VERSION
unsetenv HDDS_VERSION
unsetenv CERNLIB_VERSION
unsetenv XERCES_C_VERSION
unsetenv CLHEP_VERSION
unsetenv ROOT_VERSION
unsetenv CCDB_VERSION
unsetenv EVIO_VERSION
unsetenv RCDB_VERSION
unsetenv HDGEANT4_VERSION
# urls for checkout
unsetenv SIM_RECON_URL
unsetenv JANA_URL
unsetenv HDDS_URL
unsetenv CERNLIB_URL
unsetenv XERCES_C_URL
unsetenv CLHEP_URL
unsetenv ROOT_URL
unsetenv CCDB_URL
unsetenv EVIO_URL
unsetenv HDGEANT4_URL
# directory tags
unsetenv SIM_RECON_DIRTAG
unsetenv JANA_DIRTAG
unsetenv HDDS_DIRTAG
unsetenv CERNLIB_DIRTAG
unsetenv XERCES_C_DIRTAG
unsetenv CLHEP_DIRTAG
unsetenv ROOT_DIRTAG
unsetenv CCDB_DIRTAG
unsetenv RCDB_DIRTAG
unsetenv EVIO_DIRTAG
# git branches
unsetenv SIM_RECON_BRANCH
unsetenv JANA_BRANCH
unsetenv HDDS_BRANCH
unsetenv CERNLIB_BRANCH
unsetenv XERCES_C_BRANCH
unsetenv CLHEP_BRANCH
unsetenv ROOT_BRANCH
unsetenv CCDB_BRANCH
unsetenv RCDB_BRANCH
unsetenv EVIO_BRANCH
unsetenv HDGEANT4_BRANCH
# git hashes
unsetenv SIM_RECON_HASH
unsetenv JANA_HASH
unsetenv HDDS_HASH
unsetenv CERNLIB_HASH
unsetenv XERCES_C_HASH
unsetenv CLHEP_HASH
unsetenv ROOT_HASH
unsetenv CCDB_HASH
unsetenv RCDB_HASH
unsetenv EVIO_HASH
unsetenv HDGEANT4_HASH
