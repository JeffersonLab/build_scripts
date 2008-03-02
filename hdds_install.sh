#!/bin/sh
#
# install hdds from scratch
#
BUILDDIR=/usr/local
cd $BUILDDIR
svn checkout --username marki https://phys12svn.jlab.org/repos/trunk/src/HDDS
cd HDDS
make
