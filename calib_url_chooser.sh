#!/bin/bash
# farm-specific set-up
sqliteflag=$1
if [ "$sqliteflag" == "sqlite" ]
then
    echo sqlite:////work/halld/ccdb_sqlite/$((1 + RANDOM % 100))/ccdb.sqlite
else
    nodename=`uname -n`
    if [[ $nodename =~ ^farm* || $nodename =~ ^qcd* ]]
    then
	echo mysql://ccdb_user@hallddb-farm.jlab.org/ccdb
    else
	echo mysql://ccdb_user@hallddb.jlab.org/ccdb
    fi
fi
