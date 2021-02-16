#!/bin/bash

if [ ! -d $GLUEX_TOP ]
then
    echo Error: GLUEX_TOP not defined or does not exist, exiting
    exit 1
fi

if [ -z $CERNLIB_VERSION ]
then
    echo Error: CERNLIB_VERSION not defined, exiting
    exit 2
fi

if [ -L $GLUEX_TOP/cernlib/$CERN_LEVEL ]
then
    echo Error: $GLUEX_TOP/cernlib/$CERN_LEVEL is a link, nothing to fix, exiting
    exit 3
fi

cd $GLUEX_TOP
mv -v cernlib ${CERN_LEVEL}_build
mkdir cernlib
cd cernlib
mv -v ../${CERN_LEVEL}_build .
ln -s ${CERN_LEVEL}_build/$CERNLIB_VERSION $CERN_LEVEL
ls -l
