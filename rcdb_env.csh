#!/bin/csh

if (! $?LD_LIBRARY_PATH) then
    setenv LD_LIBRARY_PATH $RCDB_HOME/cpp/lib
else
    setenv LD_LIBRARY_PATH "$RCDB_HOME/cpp/lib":$LD_LIBRARY_PATH
endif

if ( ! $?PYTHONPATH ) then
    setenv PYTHONPATH "$RCDB_HOME/python"
else
    setenv PYTHONPATH "$RCDB_HOME/python":$PYTHONPATH
endif
setenv PATH "$RCDB_HOME":"$RCDB_HOME/bin":"$RCDB_HOME/cpp/bin":$PATH
set RCDB_MINOR_VERSION=`echo "$RCDB_VERSION" | awk -F '.' '{printf "%d", $2}'`
if ( "$RCDB_MINOR_VERSION" > 8 ) then
    setenv RCDB_SCHEMA_2 true
else
    setenv RCDB_SCHEMA_2 false
endif
