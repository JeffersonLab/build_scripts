#!/bin/sh
# process arguments
if [ "$1" = "-v" ]; then
    gluex_env_verbose=1
else
    gluex_env_verbose=0
fi
# general stuff
if [ -z "$GLUEX_TOP" ]; then export GLUEX_TOP=/usr/local/gluex; fi
if [ -z "$BUILD_SCRIPTS" ]
    then export BUILD_SCRIPTS=$GLUEX_TOP/build_scripts
fi
if [ -z "$LD_LIBRARY_PATH" ]; then export LD_LIBRARY_PATH=''; fi
# xerces-c++
if [ -z "$XERCESCROOT" ]; then export XERCESCROOT=$GLUEX_TOP/xerces-c/prod; fi
export XERCES_INCLUDE=$XERCESCROOT/include
if [ `echo $LD_LIBRARY_PATH | grep -c $XERCESCROOT/lib` -eq 0 ]
    then export LD_LIBRARY_PATH=$XERCESCROOT/lib:$LD_LIBRARY_PATH
fi
