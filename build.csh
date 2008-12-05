#!/bin/csh
setenv GLUEX_TOP /scratch/gluex
mkdir -p $GLUEX_TOP
cd $GLUEX_TOP
svn co https://halldsvn.jlab.org/repos/trunk/scripts/build_scripts
source build_scripts/gluex_env.csh
make -f $BUILD_SCRIPTS/Makefile_all
