#
# Pass 1
#
ifdef XERCESCROOT
    GLUEX_PASS1_TARGETS += xerces_build
endif
ifdef LAPACK_HOME
    GLUEX_PASS1_TARGETS += lapack_build
endif
ifdef CERN_ROOT
    GLUEX_PASS1_TARGETS += cernlib_build
endif
ifdef ROOTSYS
    GLUEX_PASS1_TARGETS += root_build
endif
ifdef G4ROOT
    GLUEX_PASS1_TARGETS += geant4_build
endif
ifdef EVIOROOT
    GLUEX_PASS1_TARGETS += evio_build
endif
ifdef SQLITE_HOME
    GLUEX_PASS1_TARGETS += sqlite_build
endif
ifdef SQLITECPP_HOME
    GLUEX_PASS1_TARGETS += sqlitecpp_build
endif
ifdef RCDB_HOME
    GLUEX_PASS1_TARGETS += rcdb_build
endif
ifdef CCDB_HOME
    GLUEX_PASS1_TARGETS += ccdb_build
endif
#
# Pass 2
#
ifdef JANA_HOME
    GLUEX_PASS2_TARGETS += jana_build
endif
ifdef HDDS_HOME
    GLUEX_PASS2_TARGETS += hdds_build
endif
ifdef AMPTOOLS_HOME
    GLUEX_PASS2_TARGETS += amptools_build
endif
ifdef HEPMCDIR
    GLUEX_PASS2_TARGETS += hepmc_build
endif
ifdef PHOTOSDIR
    GLUEX_PASS2_TARGETS += photos_build
endif
ifdef EVTGENDIR
    GLUEX_PASS2_TARGETS += evtgen_build
endif
ifdef HALLD_RECON_HOME
    GLUEX_PASS2_TARGETS += halld_recon_build
endif
ifdef DIRACXX
    GLUEX_PASS2_TARGETS += diracxx_build
endif
ifdef HALLD_SIM_HOME
    GLUEX_PASS2_TARGETS += halld_sim_build
endif
ifdef HD_UTILITIES_HOME
    GLUEX_PASS2_TARGETS += hd_utilities_build
endif
ifdef HDGEANT4_HOME
    GLUEX_PASS2_TARGETS += hdgeant4_build
endif
ifdef ROOT_ANALYSIS_HOME
    GLUEX_PASS2_TARGETS += gluex_root_analysis_build
endif
ifdef MCWRAPPER_CENTRAL
    GLUEX_PASS2_TARGETS += mcwrapper_build
endif
