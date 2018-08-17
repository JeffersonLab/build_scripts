#!/bin/bash

echo "For usage message, type \"$(basename "$0") -h\""

usage="$(basename "$0") [-h] [-x filename] [package_1] [package_2] ...

where:
    -h        show this help text
    -x        set name of version set XML file
              (default: /group/halld/www/halldweb/html/dist/version_jlab.xml)
    -n        set number of threads (default: 1)
    package_n package name, choose from:
                  hdds
                  sim-recon
                  halld_recon
                  halld_sim
                  hdgeant4
                  gluex_root_analysis
              if no package name supplied all except sim-recon will be built"

mydir=`pwd`
mydate=`date +%F`

if [ -z "$BUILD_SCRIPTS" ]
    then export BUILD_SCRIPTS=/group/halld/Software/build_scripts
fi

cmd="$BUILD_SCRIPTS/customize_version.pl -o ${USER}_$mydate.xml"
list=""

while [[ $# -gt 0 ]]
do
key=$1
case $key in
    -h)
	echo "$usage"
	exit 0
	;;
    -x)
	xmlfile="$2"
	shift
	shift
	;;
    -n)
	threads_option="-j$2"
	shift
	shift
	;;
    hdds)
	cmd="$cmd -g $mydir/hdds"
	list="$list hdds"
	shift
	;;
    sim-recon)
	cmd="$cmd -s $mydir/sim-recon"
	list="$list sim-recon"
	shift
	;;
    halld_recon)
	cmd="$cmd -r $mydir/halld_recon"
	list="$list halld_recon"
	shift
	;;
    halld_sim)
	cmd="$cmd -m $mydir/halld_sim"
	list="$list halld_sim"
	shift
	;;
    hdgeant4)
	cmd="$cmd -4 $mydir/hdgeant4"
	list="$list hdgeant4"
	shift
	;;
    gluex_root_analysis)
	cmd="$cmd -a $mydir/gluex_root_analysis"
	list="$list gluex_root_analysis"
	shift
	;;
    *)
	echo error: unknown package name or option = $key
	exit 1
	;;
esac
done

if [ -z "$xmlfile" ]
    then xmlfile=/group/halld/www/halldweb/html/dist/version_jlab.xml
fi
if [ -z "$list" ]
    then
    list="hdds halld_recon halld_sim hdgeant4 gluex_root_analysis"
    cmd="$cmd -g $mydir/hdds"
    cmd="$cmd -r $mydir/halld_recon"
    cmd="$cmd -m $mydir/halld_sim"
    cmd="$cmd -4 $mydir/hdgeant4"
    cmd="$cmd -a $mydir/gluex_root_analysis"
fi
cmd="$cmd -i $xmlfile"
$cmd

prompt="Will build the following packages in the local directory:

$list

Is this OK? "
while true; do
    read -p "$prompt" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo source $BUILD_SCRIPTS/gluex_env_jlab.sh $mydir/${USER}_$mydate.xml \
    > setup_gluex.sh
echo source $BUILD_SCRIPTS/gluex_env_jlab.csh $mydir/${USER}_$mydate.xml \
    > setup_gluex.csh
source $BUILD_SCRIPTS/gluex_env_jlab.sh $mydir/${USER}_$mydate.xml

set -e
if [[ $list = *hdds* ]]
    then make -f $BUILD_SCRIPTS/Makefile_hdds
fi
if [[ $list = *sim-recon* ]]
    then make -f $BUILD_SCRIPTS/Makefile_sim-recon SIM_RECON_SCONS_OPTIONS="$threads_option"
fi
if [[ $list = *halld_recon* ]]
    then make -f $BUILD_SCRIPTS/Makefile_halld_recon HALLD_RECON_SCONS_OPTIONS="$threads_option"
fi
if [[ $list = *halld_sim* ]]
    then make -f $BUILD_SCRIPTS/Makefile_halld_sim HALLD_SIM_SCONS_OPTIONS="$threads_option"
fi
if [[ $list = *hdgeant4* ]]
    then make -f $BUILD_SCRIPTS/Makefile_hdgeant4
fi
if [[ $list = *gluex_root_analysis* ]]
    then make -f $BUILD_SCRIPTS/Makefile_gluex_root_analysis
fi
