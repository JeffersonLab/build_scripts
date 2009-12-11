#!/bin/csh
setenv GLUEX_TOP `pwd`
svn checkout https://halldsvn.jlab.org/repos/trunk/scripts/build_scripts
source build_scripts/gluex_env.csh
set make_targets="jana_build hdds_build halld_build"
make -f $BUILD_SCRIPTS/Makefile_all $make_targets
exit
