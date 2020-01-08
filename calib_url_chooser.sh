#!/bin/bash
# farm-specific set-up
nodename=`uname -n`
if [[ $nodename =~ ^farm* || $nodename =~ ^qcd* ]]
    then
    echo sqlite:////work/halld/ccdb_sqlite/$((1 + RANDOM % 100))/ccdb.sqlite
else
    echo mysql://ccdb_user@hallddb.jlab.org/ccdb
fi
