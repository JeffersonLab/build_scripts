#!/bin/csh
#set our environment
if ( ! $?CCDB_HOME ) then
    setenv CCDB_HOME `pwd`
endif
if (! $?LD_LIBRARY_PATH) setenv LD_LIBRARY_PATH ''
echo $LD_LIBRARY_PATH | grep $CCDB_HOME/lib > /dev/null
if ($status) setenv LD_LIBRARY_PATH  $CCDB_HOME/lib:$LD_LIBRARY_PATH
if (! $?PYTHONPATH) setenv PYTHONPATH ''
echo $PYTHONPATH | grep $CCDB_HOME/python > /dev/null
if ($status) setenv PYTHONPATH $CCDB_HOME/python:$CCDB_HOME/python/ccdb/ccdb_pyllapi:$PYTHONPATH
echo $PATH | grep $CCDB_HOME/bin > /dev/null
if ($status) setenv PATH $CCDB_HOME/bin:$PATH
