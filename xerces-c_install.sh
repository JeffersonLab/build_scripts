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
if [ -d $TARDIR ]
then
    cd $TARDIR
    if [ ! -f $TARDIR/$TARFILE ]
    then
	wget http://www.apache.org/dist/xerces/c/sources/$TARFILE
    fi
    wget http://www.apache.org/dist/xerces/c/sources/$TARFILE.md5
    rm -f local.md5 remote.md5
    md5sum $TARFILE | perl -n -e 'split/\s+/; print $_[0], "\n";' > local.md5
    perl -n -e 'split/\s+/; print $_[0], "\n";' < $TARFILE.md5 > remote.md5
    diff local.md5 remote.md5
    if [ $? != 0 ]
    then
	echo MD5 sum does not check out
	exit 50
    fi
else
    echo "tar directory does not exist"
    exit 100
fi
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
tar zxvf $TARDIR/$TARFILE
export XERCESCROOT=$BUILDDIR/xerces-c-src_$VERSION
cd $XERCESCROOT/src/xercesc
./runConfigure -plinux -cgcc -xg++ -minmem -nsocket -tnative -rpthread
if [ $? != 0 ]
then
    echo could not run runConfigure
    exit 300
fi
make
