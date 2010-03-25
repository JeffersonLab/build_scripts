#!/bin/sh
dir=$1
pushd $dir
ln -s setenv_Linux_CentOS5-x86_64-gcc4.1.2.csh setenv_Linux_RHEL5-x86_64-gcc4.1.2.csh
ls -l
popd
exit
