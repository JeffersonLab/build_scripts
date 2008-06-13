#!/bin/csh
# assume build will be in the local directory
svn co $P12SVN/tags/JANA_marki_freeze
cd JANA_marki_freeze
setenv JANA_HOME `pwd`
source ~/halld/build_scripts/gluex_env.csh
cd src
./configure --with-xerces=$XERCESCROOT
make
make install
