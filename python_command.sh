#/bin/bash
# accepts one positional argument
# argument can have one of three values: command, config, or scons
## command: python command to use
## config: python-config command use
## scon: scons command to use
# writes output to stdout
arg=$1
uname=`uname`
echo uname = $uname
if [ $uname == "Linux" ]
then
    if [ -e /etc/fedora-release ]
    then
	fedora_version=`awk '{print $3}' < /etc/fedora-release`
	echo fedora_version = $fedora_version
	distribution=fedora$fedora_version
    elif [ -e /etc/redhat-release]
    then
	redhat_version=`awk -F 'release' '{print $2}' < /etc/redhat-release | awk '{print $1}' | awk -F. '{print $1}'`
	echo redhat_version = $redhat_version
    fi
fi
echo distribution = $distribution
