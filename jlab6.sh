#!/bin/bash
hostname=`hostname`
host=`host $hostname`
hn=`echo $host | awk '{print $1}'`
osrelease=`$BUILD_SCRIPTS/osrelease.pl`
if [[ "$hn" == *".jlab.org" \
    && ( "$osrelease" == "Linux_RHEL6"* || "$osrelease" == "Linux_CentOS6"* ) ]]
    then
    echo true
else
    echo false
fi

