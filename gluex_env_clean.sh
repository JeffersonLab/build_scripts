if [ -n "$BUILD_SCRIPTS" ]; then
    # clean PATH
    if [ -n "$BMS_OSNAME" ]; then
	if [ -n "$HALLD_MY" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $HALLD_MY/$BMS_OSNAME/bin`; fi
	if [ -n "$HALLD_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $HALLD_HOME/$BMS_OSNAME/bin`; fi
    fi
    if [ -n "$CERN_ROOT" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $CERN_ROOT/bin`; fi
    if [ -n "$ROOTSYS" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $ROOTSYS/bin`; fi
    if [ -n "$CCDB_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $CCDB_HOME/bin`; fi
    if [ -n "$JANA_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $JANA_HOME/bin`; fi
    if [ -n "$RCDB_HOME" ]
        then
        eval `$BUILD_SCRIPTS/delpath.pl -b $RCDB_HOME`
        eval `$BUILD_SCRIPTS/delpath.pl -b $RCDB_HOME/bin`
        eval `$BUILD_SCRIPTS/delpath.pl -b $RCDB_HOME/cpp/bin`
    fi
    if [ -n "$G4ROOT" ]
	then
        eval `$BUILD_SCRIPTS/delpath.pl -b $G4ROOT/bin`
        eval `$BUILD_SCRIPTS/delpath.pl -b /u$G4ROOT/bin`
        eval `$BUILD_SCRIPTS/delpath.pl -b $G4WORKDIR/bin/$G4SYSTEM`
    fi
    if [ -n "$HDGEANT4_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $HDGEANT4_HOME/bin/$G4SYSTEM`; fi
    if [ -n "$HD_UTILITIES_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $MCWRAPPER_CENTRAL`; fi
    if [ -n "$ROOT_ANALYSIS_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $ROOT_ANALYSIS_HOME/$BMS_OSNAME/bin`; fi
    # clean LD_LIBRARY_PATH
    if [ -n "$CLHEP_LIB" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $CLHEP_LIB`; fi
    if [ -n "$ROOTSYS" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $ROOTSYS/lib`; fi
    if [ -n "$XERCESCROOT" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $XERCESCROOT/lib`; fi
    if [ -n "$CCDB_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $CCDB_HOME/lib`; fi
    if [ -n "$EVIOROOT" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $EVIOROOT/lib`; fi
    if [ -n "$RCDB_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $RCDB_HOME/cpp/lib`; fi
    if [ -n "$G4ROOT" ]
	then
        eval `$BUILD_SCRIPTS/delpath.pl -b -l $G4ROOT/lib64`
        eval `$BUILD_SCRIPTS/delpath.pl -b -l /u$G4ROOT/lib64`
    fi
    if [ -n "$ROOT_ANALYSIS_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $ROOT_ANALYSIS_HOME/$BMS_OSNAME/lib`; fi
    eval `$BUILD_SCRIPTS/delpath.pl -b -l`
    # clean PYTHONPATH
    if [ -n "$CCDB_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -p $CCDB_HOME/python $CCDB_HOME/python/ccdb/ccdb_pyllapi`; fi
    if [ -n "$RCDB_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -p $RCDB_HOME/python`; fi
    eval `$BUILD_SCRIPTS/delpath.pl -b -p`
fi
# clean_environment
unset GLUEX_TOP
unset BUILD_SCRIPTS
unset XERCESCROOT
unset XERCES_INCLUDE
unset ROOTSYS
unset CERN
unset CERN_LEVEL
unset CERN_ROOT
unset CLHEP
unset CERNLIB_WORD_LENGTH
unset CLHEP_LIB
unset CLHEP_INCLUDE
unset HDDS_HOME
unset HALLD_HOME
unset HALLD_MY
unset BMS_OSNAME
unset JANA_HOME
unset JANA_CALIB_URL
unset JANA_GEOMETRY_URL
unset JANA_PLUGIN_PATH
unset JANA_RESOURCE_DIR
unset AMPTOOLS_HOME
unset AMPTOOLS
unset AMPPLOTTER
unset CLHEP_INCLUDE_DIR
unset CLHEP_LIB_DIR
unset EVIOROOT
unset CCDB_HOME
unset CCDB_CONNECTION
unset CCDB_USER
unset RCDB_HOME
unset RCDB_CONNECTION
unset HDGEANT4_HOME
unset G4ABLADATA
unset G4ENSDFSTATEDATA
unset G4INCLUDE
unset G4INSTALL
unset G4LEDATA
unset G4LEVELGAMMADATA
unset G4LIB_BUILD_SHARED
unset G4LIB
unset G4LIB_USE_GDML
unset G4LIB_USE_ZLIB
unset G4MULTITHREADED
unset G4NEUTRONHPDATA
unset G4NEUTRONXSDATA
unset G4PIIDATA
unset G4RADIOACTIVEDATA
unset G4REALSURFACEDATA
unset G4ROOT
unset G4SAIDXSDATA
unset G4SYSTEM
unset G4UI_USE_TCSH
unset G4VIS_USE_OPENGLX
unset G4VIS_USE_RAYTRACERX
unset G4WORKDIR
unset G4UI_USE_QT
unset G4UI_USE_XM
unset G4VIS_USE_DAWN
unset G4VIS_USE_OPENGLQT
unset G4VIS_USE_OPENGLXM
unset QTHOME
unset QTLIBPATH
unset HD_UTILITIES_HOME
unset MCWRAPPER_CENTRAL
unset ROOT_ANALYSIS_HOME
# versions
unset SIM_RECON_VERSION
unset JANA_VERSION
unset HDDS_VERSION
unset CERNLIB_VERSION
unset XERCES_C_VERSION
unset CLHEP_VERSION
unset ROOT_VERSION
unset CCDB_VERSION
unset EVIO_VERSION
unset RCDB_VERSION
unset HDGEANT4_VERSION
unset GEANT4_VERSION
unset HD_UTILITIES_VERSION
unset GLUEX_ROOT_ANALYSIS_VERSION
unset AMPTOOLS_VERSION
# urls for checkout
unset SIM_RECON_URL
unset JANA_URL
unset HDDS_URL
unset CERNLIB_URL
unset XERCES_C_URL
unset CLHEP_URL
unset ROOT_URL
unset CCDB_URL
unset RCDB_URL
unset EVIO_URL
unset HDGEANT4_URL
unset HD_UTILITIES_URL
unset GLUEX_ROOT_ANALYSIS_URL
# directory tags
unset SIM_RECON_DIRTAG
unset JANA_DIRTAG
unset HDDS_DIRTAG
unset CERNLIB_DIRTAG
unset XERCES_C_DIRTAG
unset CLHEP_DIRTAG
unset ROOT_DIRTAG
unset CCDB_DIRTAG
unset RCDB_DIRTAG
unset EVIO_DIRTAG
unset GEANT4_DIRTAG
unset HDGEANT4_DIRTAG
unset HD_UTILITIES_DIRTAG
unset GLUEX_ROOT_ANALYSIS_DIRTAG
unset AMPTOOLS_DIRTAG
# git branches
unset SIM_RECON_BRANCH
unset JANA_BRANCH
unset HDDS_BRANCH
unset CERNLIB_BRANCH
unset XERCES_C_BRANCH
unset CLHEP_BRANCH
unset ROOT_BRANCH
unset CCDB_BRANCH
unset RCDB_BRANCH
unset EVIO_BRANCH
unset HDGEANT4_BRANCH
unset HD_UTILITIES_BRANCH
unset GLUEX_ROOT_ANALYSIS_BRANCH
# git hashes
unset SIM_RECON_HASH
unset JANA_HASH
unset HDDS_HASH
unset CERNLIB_HASH
unset XERCES_C_HASH
unset CLHEP_HASH
unset ROOT_HASH
unset CCDB_HASH
unset RCDB_HASH
unset EVIO_HASH
unset HDGEANT4_HASH
unset HD_UTILITIES_HASH
unset GLUEX_ROOT_ANALYSIS_HASH
