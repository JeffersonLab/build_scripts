#!/bin/sh
wget http://cernlib.web.cern.ch/cernlib/download/2006_source/tar/2006_src.tar.gz
wget http://cernlib.web.cern.ch/cernlib/download/2006_source/tar/include.tar.gz
tar zxf 2006_src.tar.gz
tar zxf include.tar.gz
svn checkout $HDSVN/trunk/home/marki/cernlib_patches
export CERN=`pwd`
export CERN_LEVEL=2006
export CERN_ROOT=$CERN/$CERN_LEVEL
export CVSCOSRC=$CERN_ROOT/src
export PATH=$CERN_ROOT/bin:$PATH
cd $CERN_ROOT
test -f .patch_done || \
    patch -p1 < $(BUILD_SCRIPTS)/patches/cernlib/cernlib_2006_f9.txt > .patch_done
mkdir -p build bin lib
cd $CERN_ROOT/build
$CVSCOSRC/config/imake_boot
gmake bin/kuipc
gmake scripts/Makefile
cd scripts
gmake install.bin
cd $CERN_ROOT/build
gmake FC=gfortran
cd $CERN_ROOT/lib
ln -s /usr/lib/libblas.a libblas.a
ln -s /usr/lib/liblapack.a liblapack3.a
exit
# end of shell script
