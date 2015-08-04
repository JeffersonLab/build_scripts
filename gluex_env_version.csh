#!/bin/tcsh

# institute defaults for missing environment variables
if (! $?GLUEX_TOP) setenv GLUEX_TOP /home/$USER/gluex_top
if (! $?BUILD_SCRIPTS) setenv BUILD_SCRIPTS $GLUEX_TOP/build_scripts

set error_message="Error in gluex_env_version.csh"
set error_action="environment settings not done"

if (! -f $BUILD_SCRIPTS/version.pl) then
    echo ${error_message}: $BUILD_SCRIPTS/version.pl not found, $error_action
    exit 1
endif
if (! -f $BUILD_SCRIPTS/gluex_env.csh) then
    echo ${error_message}: $BUILD_SCRIPTS/gluex_env.csh not found, $error_action
    exit 4
endif
if ("x$1" != "x") then # version argument given
    if (! -f $1) then
        echo ${error_message}: version xml file $1 not found, $error_action
        exit 2
    else
        set version_file=$1
    endif
else if (! -f "version.xml") then # look for version.xml in current working directory
    echo ${error_message}: no argument given and no version.xml found in current working directory, $error_action
    exit 3
else
    set version_file=version.xml
endif

eval `$BUILD_SCRIPTS/version.pl $version_file`
source $BUILD_SCRIPTS/gluex_env.csh
