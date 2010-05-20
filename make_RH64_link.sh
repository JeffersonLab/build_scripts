#!/bin/sh
if [ -a Linux_RHEL5-x86_64-gcc4.1.2 ]
then
    echo link exists
else
    echo link does not exist
    ln -s -v Linux_CentOS5-x86_64-gcc4.1.2 Linux_RHEL5-x86_64-gcc4.1.2
fi
