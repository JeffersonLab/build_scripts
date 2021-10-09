if [ -z "$1" ]
then
    export BUILD_SCRIPTS=/group/halld/Software/build_scripts
else
    export BUILD_SCRIPTS=$1 
fi
export HALLD_VERSIONS=/group/halld/www/halldweb/html/halld_versions
unset gxclean
function gxclean() { source $BUILD_SCRIPTS/gluex_env_clean.sh; }
unset gxclean_all
function gxclean_all() {
    source $BUILD_SCRIPTS/gluex_env_clean.sh
    unset BUILD_SCRIPTS HALLD_VERSIONS gxclean gxclean_all gxenv
}
unset gxenv
function gxenv() { gxclean; \
    source $BUILD_SCRIPTS/gluex_env_jlab.sh $1
}
