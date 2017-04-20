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
    if ($?RCDB_HOME) then
	eval `$BUILD_SCRIPTS/delpath.pl $RCDB_HOME`
	eval `$BUILD_SCRIPTS/delpath.pl $RCDB_HOME/bin`
	eval `$BUILD_SCRIPTS/delpath.pl $RCDB_HOME/cpp/bin`
    endif
    if ($?G4ROOT) then
	eval `$BUILD_SCRIPTS/delpath.pl $G4ROOT/bin`
	eval `$BUILD_SCRIPTS/delpath.pl /u$G4ROOT/bin`
	eval `$BUILD_SCRIPTS/delpath.pl $G4WORKDIR/bin/$G4SYSTEM`
    endif
    if ($?HDGEANT4_HOME) eval `$BUILD_SCRIPTS/delpath.pl $HDGEANT4_HOME/bin/$G4SYSTEM`
    if ($?HD_UTILITIES_HOME) eval `$BUILD_SCRIPTS/delpath.pl $MCWRAPPER_CENTRAL`
    if ($?ROOT_ANALYSIS_HOME) eval `$BUILD_SCRIPTS/delpath.pl $ROOT_ANALYSIS_HOME/$BMS_OSNAME/bin/`
    # clean LD_LIBRARY_PATH
    if ($?CLHEP_LIB) eval `$BUILD_SCRIPTS/delpath.pl -l $CLHEP_LIB`
    if ($?ROOTSYS) eval `$BUILD_SCRIPTS/delpath.pl -l $ROOTSYS/lib`
    if ($?XERCESCROOT) eval `$BUILD_SCRIPTS/delpath.pl -l $XERCESCROOT/lib`
    if ($?CCDB_HOME) eval `$BUILD_SCRIPTS/delpath.pl -l $CCDB_HOME/lib`
    if ($?EVIOROOT) eval `$BUILD_SCRIPTS/delpath.pl -l $EVIOROOT/lib`
    if ($?RCDB_HOME) eval `$BUILD_SCRIPTS/delpath.pl -l $RCDB_HOME/cpp/lib`
    if ($?G4ROOT) then
        eval `$BUILD_SCRIPTS/delpath.pl -l $G4ROOT/lib64`
        eval `$BUILD_SCRIPTS/delpath.pl -l /u$G4ROOT/lib64`
    endif
    if ($?ROOT_ANALYSIS_HOME) eval `$BUILD_SCRIPTS/delpath.pl -l $ROOT_ANALYSIS_HOME/$BMS_OSNAME/lib/`
    eval `$BUILD_SCRIPTS/delpath.pl -l`
    # clean PYTHONPATH
    if ($?CCDB_HOME) eval `$BUILD_SCRIPTS/delpath.pl -p $CCDB_HOME/python $CCDB_HOME/python/ccdb/ccdb_pyllapi`
    if ($?RCDB_HOME) eval `$BUILD_SCRIPTS/delpath.pl -p $RCDB_HOME/python`
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
unsetenv G4ABLADATA
unsetenv G4ENSDFSTATEDATA
unsetenv G4INCLUDE
unsetenv G4INSTALL
unsetenv G4LEDATA
unsetenv G4LEVELGAMMADATA
unsetenv G4LIB_BUILD_SHARED
unsetenv G4LIB
unsetenv G4LIB_USE_GDML
unsetenv G4LIB_USE_ZLIB
unsetenv G4MULTITHREADED
unsetenv G4NEUTRONHPDATA
unsetenv G4NEUTRONXSDATA
unsetenv G4PIIDATA
unsetenv G4RADIOACTIVEDATA
unsetenv G4REALSURFACEDATA
unsetenv G4ROOT
unsetenv G4SAIDXSDATA
unsetenv G4SYSTEM
unsetenv G4UI_USE_TCSH
unsetenv G4VIS_USE_OPENGLX
unsetenv G4VIS_USE_RAYTRACERX
unsetenv G4WORKDIR
unsetenv G4UI_USE_QT
unsetenv G4UI_USE_XM
unsetenv G4VIS_USE_DAWN
unsetenv G4VIS_USE_OPENGLQT
unsetenv G4VIS_USE_OPENGLXM
unsetenv QTHOME
unsetenv QTLIBPATH
unsetenv HD_UTILITIES_HOME
unsetenv MCWRAPPER_CENTRAL
unsetenv ROOT_ANALYSIS_HOME
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
unsetenv GEANT4_VERSION
unsetenv HD_UTILITIES_VERSION
unsetenv GLUEX_ROOT_ANALYSIS_VERSION
unsetenv AMPTOOLS_VERSION
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
unsetenv HD_UTILITIES_URL
unsetenv GLUEX_ROOT_ANALYSIS_URL
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
unsetenv GEANT4_DIRTAG
unsetenv HDGEANT4_DIRTAG
unsetenv HD_UTILITIES_DIRTAG
unsetenv GLUEX_ROOT_ANALYSIS_DIRTAG
unsetenv AMPTOOLS_DIRTAG
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
unsetenv HD_UTILITIES_BRANCH
unsetenv GLUEX_ROOT_ANALYSIS_BRANCH
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
unsetenv HD_UTILITIES_HASH
unsetenv GLUEX_ROOT_ANALYSIS_HASH
