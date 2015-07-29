#!/bin/bash
if [ -z "$LD_LIBRARY_PATH" ]; then export LD_LIBRARY_PATH=''; fi
if [ `echo $LD_LIBRARY_PATH | grep -c $CCDB_HOME/lib` -eq 0 ]
    then export LD_LIBRARY_PATH=$CCDB_HOME/lib:$LD_LIBRARY_PATH
fi
if [ -z "$PYTHONPATH" ]; then export PYTHONPATH=''; fi
if [ `echo $PYTHONPATH | grep -c $CCDB_HOME/python` -eq 0 ]
    then export PYTHONPATH=$CCDB_HOME/python:$CCDB_HOME/python/ccdb/ccdb_pyllapi:$PYTHONPATH
fi
if [ `echo $PATH | grep -c $CCDB_HOME/bin` -eq 0 ]
    then export PATH=$CCDB_HOME/bin:$PATH
fi

