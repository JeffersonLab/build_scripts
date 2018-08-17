#!/bin/bash

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
    -x)
	xmlfile="$2"
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
	echo error: unknown package name = $key
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
    then make -f $BUILD_SCRIPTS/Makefile_sim-recon
fi
if [[ $list = *halld_recon* ]]
    then make -f $BUILD_SCRIPTS/Makefile_halld_recon
fi
if [[ $list = *halld_sim* ]]
    then make -f $BUILD_SCRIPTS/Makefile_halld_sim
fi
if [[ $list = *hdgeant4* ]]
    then make -f $BUILD_SCRIPTS/Makefile_hdgeant4
fi
if [[ $list = *gluex_root_analysis* ]]
    then make -f $BUILD_SCRIPTS/Makefile_gluex_root_analysis
fi
