#!/bin/bash

export LD_LIBRARY_PATH="$RCDB_HOME/cpp/lib":$LD_LIBRARY_PATH
export PYTHONPATH="$RCDB_HOME/python":$PYTHONPATH
export PATH="$RCDB_HOME":"$RCDB_HOME/bin":"$RCDB_HOME/cpp/bin":$PATH
RCDB_MINOR_VERSION=$(echo "$RCDB_VERSION" | awk -F '.' '{printf "%d", $2}')
if [ "$RCDB_MINOR_VERSION" -gt 8 ]; then export RCDB_SCHEMA_2=true ; else export RCDB_SCHEMA_2=false; fi

