#!/bin/csh
# assume build will be in the local directory
svn co https://halldsvn.jlab.org/repos/branches/src-gcc-4.3
ln -s src-gcc-4.3 src
setenv HALLD_HOME `pwd`
setenv HALLD_MY $HALLD_HOME
source ~/halld/build_scripts/gluex_env.csh
cp -pv ~/halld/build_scripts/patches/getarg_fix/* $HALLD_HOME/src/programs/Simulation/HDGeant
cd src
make FC=gfortran DFC=gfortran
make FC=gfortran DFC=gfortran DEBUG=1
