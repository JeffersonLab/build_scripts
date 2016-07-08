#!/bin/csh

if (! $?LD_LIBRARY_PATH) then
    setenv LD_LIBRARY_PATH $RCDB_HOME/cpp/lib
else
    setenv LD_LIBRARY_PATH "$RCDB_HOME/cpp/lib":$LD_LIBRARY_PATH
endif

if (! $?CPLUS_INCLUDE_PATH) then
    setenv CPLUS_INCLUDE_PATH $RCDB_HOME/cpp/include
else
    setenv CPLUS_INCLUDE_PATH "$RCDB_HOME/cpp/include":$CPLUS_INCLUDE_PATH
endif

if ( ! $?PYTHONPATH ) then
    setenv PYTHONPATH "$RCDB_HOME/python"
else
    setenv PYTHONPATH "$RCDB_HOME/python":$PYTHONPATH
endif
setenv PATH "$RCDB_HOME":"$RCDB_HOME/bin":"$RCDB_HOME/cpp/bin":$PATH
