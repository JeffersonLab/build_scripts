if [ -n "$BUILD_SCRIPTS" ]; then
    # clean PATH
    if [ -n "$BMS_OSNAME" ]; then
	if [ -n "$HALLD_MY" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $HALLD_MY/$BMS_OSNAME/bin`; fi
	if [ -n "$HALLD_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $HALLD_HOME/$BMS_OSNAME/bin`; fi
    fi
    if [ -n "$CERN_ROOT" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $CERN_ROOT/bin`; fi
    if [ -n "$ROOTSYS" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $ROOTSYS/bin`; fi
    if [ -n "$CCDB_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b $CCDB_HOME/bin`; fi
    # clean LD_LIBRARY_PATH
    if [ -n "$CLHEP_LIB" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $CLHEP_LIB`; fi
    if [ -n "$ROOTSYS" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $ROOTSYS/lib`; fi
    if [ -n "$XERCESCROOT" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $XERCESCROOT/lib`; fi
    if [ -n "$CCDB_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $CCDB_HOME/lib`; fi
    if [ -n "$EVIOROOT" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -l $EVIOROOT/lib`; fi
    eval `$BUILD_SCRIPTS/delpath.pl -b -l`
    # clean PYTHONPATH
    if [ -n "$CCDB_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -b -p $CCDB_HOME/python $CCDB_HOME/python/ccdb/ccdb_pyllapi`; fi
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
unset CCDB_HOME
unset AMPTOOLS_HOME
unset AMPTOOLS
unset AMPPLOTTER
unset CLHEP_INCLUDE_DIR
unset CLHEP_LIB_DIR
unset EVIOROOT
unset CCDB_CONNECTION
# versions
unset JANA_VERSION
unset HDDS_VERSION
unset CERNLIB_VERSION
unset XERCES_C_VERSION
unset CLHEP_VERSION
unset ROOT_VERSION
unset CCDB_VERSION
unset EVIO_VERSION
# directory tags
unset JANA_URL
unset HDDS_URL
unset CERNLIB_URL
unset XERCES_C_URL
unset CLHEP_URL
unset ROOT_URL
unset CCDB_URL
unset EVIO_URL
# urls for checkout
unset JANA_DIRTAG
unset HDDS_DIRTAG
unset CERNLIB_DIRTAG
unset XERCES_C_DIRTAG
unset CLHEP_DIRTAG
unset ROOT_DIRTAG
unset CCDB_DIRTAG
unset EVIO_DIRTAG
