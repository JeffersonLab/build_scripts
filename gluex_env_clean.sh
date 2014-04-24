if [ -n "$BUILD_SCRIPTS" ]; then
    # clean PATH
    if [ -n "$BMS_OSNAME" ]; then
	if [ -n "$HALLD_MY" ]; then eval `$BUILD_SCRIPTS/delpath.pl $HALLD_MY/bin/$BMS_OSNAME`; fi
	if [ -n "$HALLD_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl $HALLD_HOME/$BMS_OSNAME/bin`; fi
    fi
    if [ -n "$CERN_ROOT" ]; then eval `$BUILD_SCRIPTS/delpath.pl $CERN_ROOT/bin`; fi
    if [ -n "$ROOTSYS" ]; then eval `$BUILD_SCRIPTS/delpath.pl $ROOTSYS/bin`; fi
    if [ -n "$CCDB_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl $CCDB_HOME/bin`; fi
    # clean LD_LIBRARY_PATH
    if [ -n "$CLHEP_LIB" ]; then eval `$BUILD_SCRIPTS/delpath.pl -l $CLHEP_LIB`; fi
    if [ -n "$ROOTSYS" ]; then eval `$BUILD_SCRIPTS/delpath.pl -l $ROOTSYS/lib`; fi
    if [ -n "$XERCESCROOT" ]; then eval `$BUILD_SCRIPTS/delpath.pl -l $XERCESCROOT/lib`; fi
    if [ -n "$CCDB_HOME" ]; then eval `$BUILD_SCRIPTS/delpath.pl -l $CCDB_HOME/lib`; fi
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
unset CCDB_HOME
unset AMPTOOLS_HOME
unset AMPTOOLS
unset AMPPLOTTER
unset CLHEP_INCLUDE_DIR
unset CLHEP_LIB_DIR
