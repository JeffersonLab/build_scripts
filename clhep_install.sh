#!/bin/sh
#
# script to install clhep from scratch
#
VERSION=1.9.3.1
TARDIR=/home/install
# get the tar file
cd $TARDIR
pwd
TARFILE=clhep-$VERSION.tgz
echo TARFILE = $TARFILE
if [ ! -f $TARFILE ]
then
  wget http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/distributions/$TARFILE
fi
# untar the distribution
CLHEPDIR=/usr/local/clhep/$VERSION
cd /usr/local/clhep
if [ ! -d $CLHEPDIR ]
then
    tar zxvf $TARDIR/$TARFILE
fi
cd $CLHEPDIR/CLHEP
./configure --prefix=$CLHEPDIR
echo ? = $?
if [ $? != 0 ]
  then
  echo error in configure
  exit
fi
make
if [ $? != 0 ]
  then
  echo error in make
  exit
fi
make install
if [ $? != 0 ]
  then
  echo error in make install
  exit
fi
exit
