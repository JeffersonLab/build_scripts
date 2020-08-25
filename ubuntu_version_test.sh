#!/bin/bash
#
# Tests if this is an Ubuntu distribution with major version greater
# than or equal to the command line argument. If so echoes "true", if not
# echoes "false".
#
version_cut=$1
if [ -f "/etc/lsb-release" ]
then
    . /etc/lsb-release
    if [ "$DISTRIB_ID" == "Ubuntu" ]
    then
	major_version=`echo $DISTRIB_RELEASE | awk -F. '{print $1}'`
	if [ "$major_version" -ge "$version_cut" ]
	then
	    echo true
	else
	    echo false
	fi
    else
	echo false
    fi
else
    echo false
fi
