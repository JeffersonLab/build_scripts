#!/bin/bash
function=$1
version_cut=$2
GCC_VERSION=`gcc --version 2>&1 | head -1 | awk '{print $3}'`
GCC_MAJOR_VERSION=`echo $GCC_VERSION | awk -F. '{print $1}'`
GCC_MINOR_VERSION=`echo $GCC_VERSION | awk -F. '{print $2}'`
case "$function" in
    show)
	echo $GCC_VERSION
	;;
    major)
	echo $GCC_MAJOR_VERSION
	;;
    minor)
	echo $GCC_MINOR_VERSION
	;;
    major_test)
	if [ $GCC_MAJOR_VERSION -ge $version_cut ]
	then
	    echo true
	else
	    echo false
	fi
	;;
    *)
	echo $"usage: $0 {show|major|minor|major_test} [version_number]"
	exit 1
	;;
esac
