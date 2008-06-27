#!/bin/sh
#
# script to install Xerces-C++ from scratch
#
VERSION=2_8_0 # version to use
TARDIR=`pwd` # download distribution to this directory
BUILDDIR=`pwd` # directory where distribution is untar'ed and built
#
# get the tar file
#
TARFILE=xerces-c-src_$VERSION.tar.gz
if [ ! -d $BUILDDIR ]
then
    mkdir -p $BUILDDIR
    if [ $? != 0 ]
    then
	echo cannot make build directory
	exit 200
    fi
fi
cd $BUILDDIR
#tar zxvf $TARDIR/$TARFILE
export XERCESCROOT=$BUILDDIR/xerces-c-src_$VERSION
cd $XERCESCROOT/src/xercesc
./runConfigure -plinux -cgcc -xg++ -minmem -nsocket -tnative -rpthread
if [ $? != 0 ]
then
    echo could not run runConfigure
    exit 300
fi
make
