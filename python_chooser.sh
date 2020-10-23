#!/bin/bash
#
# python_command.sh: looks at OS-related quantities and reports
# correct python-related command to use
#
## accepts one positional argument
## argument can have one of four values: command, config, scons, version, or
##     boost
### command: python command to use
### config: python-config command use
### scon: scons command to use
### version: Python major version
### boost: name of the python-boost library, without the file extension and
###    without the initial "lib"
## writes output to stdout
#
arg=$1
get_python_version() {
    version_full=`${pycommand[command]} --version 2>&1 | awk '{print $2}'`
    version_major=`echo $version_full | awk -F. '{print $1}'`
    version_minor=`echo $version_full | awk -F. '{print $2}'`
    version_subminor=`echo $version_full | awk -F. '{print $3}'`
}
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
	if grep -lq 'Red Hat' /etc/redhat-release
	then
	    dist_name=RedHat
	elif grep -lq CentOS /etc/redhat-release
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
    get_python_version
    pycommand[version]=$version_major
    pycommand[boost]=boost_python
elif [[ $dist_name == RedHat || $dist_name == CentOS ]]
then
    if [ $dist_version -le 7 ]
    then
	pycommand[command]=python
	get_python_version
	pycommand[config]=python-config
	pycommand[scons]=scons
	pycommand[boost]=boost_python
    else
	pycommand[command]=python3
	get_python_version
	pycommand[config]=python$version_major-config
	pycommand[scons]=scons-$version_major
	pycommand[boost]=boost_python$version_major
    fi
    pycommand[version]=$version_major
elif [ $dist_name == Ubuntu ]
then
    pycommand[command]=python3
    get_python_version
    pycommand[config]=python-config
    pycommand[scons]=scons
    pycommand[version]=$version_major
    pycommand[boost]=boost_python
else
    pycommand[command]=python
    get_python_version
    pycommand[config]=python-config
    pycommand[scons]=scons
    pycommand[version]=$version_major
    pycommand[boost]=boost_python
fi
#
# report the answer
#
case $arg in
    boost)
	echo ${pycommand[boost]}
	;;
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
	echo version_full = $version_full
	echo version_major = $version_major
	echo version_minor = $version_minor
	echo version_subminor = $version_subminor
	echo python command = ${pycommand[command]}
	echo config command = ${pycommand[config]}
	echo scons command = ${pycommand[scons]}
	echo version command = ${pycommand[version]}
	echo boost command = ${pycommand[boost]}
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
