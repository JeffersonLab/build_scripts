if [ -z "$BUILD_SCRIPTS" ]
    then export BUILD_SCRIPTS=/group/halld/Software/build_scripts
fi
export DIST=/group/halld/www/halldweb/html/dist
export HALLD_VERSIONS=/group/halld/www/halldweb/html/halld_versions
function gxenv() { bs_save=$BUILD_SCRIPTS; \
    source $BUILD_SCRIPTS/gluex_env_clean.sh; \
    export BUILD_SCRIPTS=$bs_save; \
    source $BUILD_SCRIPTS/gluex_env_jlab.sh $1; \
    unset bs_save; }
function gxclean() { source $BUILD_SCRIPTS/gluex_env_clean.sh; }
if [ `echo $PATH | grep -c $BUILD_SCRIPTS` -eq 0 ]
    then export PATH=$BUILD_SCRIPTS:$PATH
fi
