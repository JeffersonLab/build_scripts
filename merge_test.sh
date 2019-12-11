#!/bin/bash
cd /u/scratch/$USER
rm -rfv merge_test
mkdir merge_test
cd merge_test
echo PWD = `pwd`
git clone https://github.com/jeffersonlab/build_scripts
export BUILD_SCRIPTS=`pwd`/build_scripts
source $BUILD_SCRIPTS/gluex_env_boot_jlab.sh
gxenv
if which hd_root
    then
    echo success
else
    echo failure
    exit 1
fi
if which mcsmear
    then
    echo success
else
    echo failure
    exit 1
fi
if which hdgeant4
    then
    echo success
else
    echo failure
    exit 1
fi
exit 0
