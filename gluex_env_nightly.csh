#!/bin/tcsh
setenv BUILD_DATE $1
set TARGET_DIR_THIS=/u/scratch/gluex/nightly/$BUILD_DATE
setenv BUILD_SCRIPTS $TARGET_DIR_THIS/build_scripts
setenv GLUEX_TOP /group/halld/Software/builds/`$BUILD_SCRIPTS/osrelease.pl`
eval `$BUILD_SCRIPTS/version.pl $TARGET_DIR_THIS/version.xml`
if ($?TARGET_DIR) then
    if ($TARGET_DIR != $TARGET_DIR_THIS) then
        echo gluex_env_nightly.csh: error, TARGET_DIR inconsistency
        exit 1
    endif
endif
# overwrite variables set by version.xml to get latest versions of hdds and sim-recon
unsetenv HDDS_VERSION SIM_RECON_VERSION
setenv HDDS_HOME $TARGET_DIR_THIS/hdds
setenv HALLD_HOME $TARGET_DIR_THIS/sim-recon
# finish the rest of the gluex environment
source $BUILD_SCRIPTS/gluex_env.csh
setenv JANA_CALIB_URL $CCDB_CONNECTION
# python on the cue
setenv PATH /apps/python/PRO/bin:$PATH
setenv LD_LIBRARY_PATH /apps/python/PRO/lib:$LD_LIBRARY_PATH
