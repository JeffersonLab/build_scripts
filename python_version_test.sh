#!/bin/bash
python_command=$1
function=$2
version_cut=$3
which $python_command >& /dev/null
status=$?
if [ $status -ne 0 ]
then
    echo $"$python_command not found in PATH"
    exit 2
fi
PYTHON_VERSION=`$python_command --version 2>&1 | head -1 | awk '{print $2}'`
PYTHON_MAJOR_VERSION=`echo $PYTHON_VERSION | awk -F. '{print $1}'`
PYTHON_MINOR_VERSION=`echo $PYTHON_VERSION | awk -F. '{print $2}'`
case "$function" in
    show)
	echo $PYTHON_VERSION
	;;
    major)
	echo $PYTHON_MAJOR_VERSION
	;;
    minor)
	echo $PYTHON_MINOR_VERSION
	;;
    major_test)
	if [ $PYTHON_MAJOR_VERSION -ge $version_cut ]
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
