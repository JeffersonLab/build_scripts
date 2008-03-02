#!/bin/sh
#
# script to install GEANT4 from scratch
#
VERSION=9.0
TARDIR=/home/install
SCRIPTDIR=/home/install
# extend the path
export PATH=$SCRIPTDIR:$PATH
# get the tar file
cd $TARDIR
TARFILE=geant4.$VERSION.gtar.gz
echo TARFILE = $TARFILE
if [ ! -f $TARFILE ]
then
  wget http://geant4.web.cern.ch/geant4/support/source/$TARFILE
fi
# untar the distribution
G4DIR=/usr/local/geant4/geant4.$VERSION
cd /usr/local/geant4
if [ ! -d $G4DIR ]
then
    tar zxvf $TARDIR/$TARFILE
fi
# go to the source directory
cd $G4DIR
# check for an old configuration and delete it if found
if [ -d .config ]
  then
  rm -rv .config
fi
geant4.8.1.p01.tcl
if [ $? != 0 ]
  then
  echo error in tcl script
  exit
fi
exit
