#!/bin/bash
#
# python_command.sh: looks at OS-related quantities and reports
# correct python-related command to use
#
## accepts one positional argument
## argument can have one of three values: command, config, or scons
### command: python command to use
### config: python-config command use
### scon: scons command to use
## writes output to stdout
#
arg=$1
#
# get OS-related information
#
uname=`uname`
if [ $uname == "Linux" ]
then
    if [ -e /etc/fedora-release ]
    then
	dist_name=`awk '{print $1}' < /etc/fedora-release`
	dist_version=`awk '{print $3}' < /etc/fedora-release`
    elif [ -e /etc/redhat-release ]
    then
	if grep -l 'Red Hat' /etc/redhat-release
	then
	    dist_name=RedHat
	elif grep -l CentOS /etc/redhat-release
	then
	    dist_name=CentOS
	else
	    dist_name=unknown_redhat_like
	fi
	dist_version=`awk -F 'release' '{print $2}' < /etc/redhat-release \
	| awk '{print $1}' | awk -F. '{print $1}'`
    elif [ -e /etc/lsb-release ] # Ubuntu-like
    then
        dist_name=`grep DISTRIB_ID /etc/lsb-release | awk -F= '{print $2}'`
        dist_version=`grep DISTRIB_RELEASE /etc/lsb-release \
	| awk -F= '{print $2}' | awk -F. '{print $1}'`
    fi
fi
distribution=$dist_name$dist_version
#
# encode the data on which command to use on which OS
## start with old versions and work your way up
#
declare -A pycommand
if [ $dist_name == Fedora ]
then
    pycommand[command]=python
    pycommand[config]=python-config
    pycommand[scons]=scons
    if [ $dist_version -le 31 ]
    then
	pycommand[version]=2
    else
	pycommand[version]=3
    fi
elif [[ $dist_name == RedHat || $dist_name == CentOS ]]
then
    if [ $dist_version -le 7 ]
    then
	pycommand[command]=python
	pycommand[config]=python-config
	pycommand[scons]=scons
	pycommand[version]=2
    else
	pycommand[command]=python3
	pycommand[config]=python3-config
	pycommand[scons]=scons-3
	pycommand[version]=3
    fi
fi
#
# report the answer
#
case $arg in
    command)
	echo ${pycommand[command]}
	;;
    config)
	echo ${pycommand[config]}
	;;
    info)
	echo uname = $uname
	echo dist_name = $dist_name
	echo dist_version = $dist_version
	echo distribution = $distribution
	echo python command = ${pycommand[command]}
	echo config command = ${pycommand[config]}
	echo scons command = ${pycommand[scons]}
	echo version command = ${pycommand[version]}
	;;
    scons)
	echo ${pycommand[scons]}
	;;
    version)
	echo ${pycommand[version]}
	;;	
    *)
	echo python_chooser.sh error: unknown argument = \"$arg\"
	exit 1
	;;
esac
