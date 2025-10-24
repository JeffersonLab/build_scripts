if ( "$1" != "--bs" ) then
    setenv BUILD_SCRIPTS /group/halld/Software/build_scripts
else
    setenv BUILD_SCRIPTS $2
endif
setenv HALLD_VERSIONS /group/halld/www/halldweb/html/halld_versions
alias gxclean 'source $BUILD_SCRIPTS/gluex_env_clean.csh'
alias gxclean_all 'source $BUILD_SCRIPTS/gluex_env_clean.csh; unsetenv BUILD_SCRIPTS; unsetenv HALLD_VERSIONS; unalias gxclean gxclean_all gxenv'
alias gxenv 'gxclean; source $BUILD_SCRIPTS/gluex_env_jlab.csh \!*'
