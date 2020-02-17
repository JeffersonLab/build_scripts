if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS /group/halld/Software/build_scripts
setenv DIST /group/halld/www/halldweb/html/dist
setenv HALLD_VERSIONS /group/halld/www/halldweb/html/halld_versions
alias gxenv "source $BUILD_SCRIPTS/gluex_env_clean.csh; setenv BUILD_SCRIPTS $BUILD_SCRIPTS; source $BUILD_SCRIPTS/gluex_env_jlab.csh \!*"
alias gxclean "source $BUILD_SCRIPTS/gluex_env_clean.csh"
echo $PATH | grep $BUILD_SCRIPTS > /dev/null
if ($status) setenv PATH ${BUILD_SCRIPTS}:$PATH
