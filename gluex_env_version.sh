#!/bin/sh

if [ -z "$GLUEX_TOP" ]; then export GLUEX_TOP=/home/$USER/gluex_top; fi
if [ -z "$BUILD_SCRIPTS" ]
    then export BUILD_SCRIPTS=$GLUEX_TOP/build_scripts
fi

error_message="Error in gluex_env_version.sh"
error_action="environment settings not done"

if [ -z $BUILD_SCRIPTS ]
    then
    echo ${error_message}: BUILD_SCRIPTS not defined, $error_action
    return 5
fi
if [ ! -f $BUILD_SCRIPTS/version.pl ]
    then
    echo ${error_message}: $BUILD_SCRIPTS/version.pl not found, $error_action
    return 1
fi
if [ ! -f $BUILD_SCRIPTS/gluex_env.sh ]
    then
    echo ${error_message}: $BUILD_SCRIPTS/gluex_env.sh not found, $error_action
    return 4
fi
if [ ! -z $1 ]
    then # version argument given
    if [ ! -f $1 ]
	then
        echo ${error_message}: version xml file $1 not found, $error_action
        return 2
    else
        version_file=$1
    fi
elif [ ! -f "version.xml" ]
    then # look for version.xml in current working directory
    echo ${error_message}: no argument given and no version.xml found in current working directory, $error_action
    return 3
else
    version_file=version.xml
fi

eval `$BUILD_SCRIPTS/version.pl -sbash $version_file`
source $BUILD_SCRIPTS/gluex_env.sh
