#!/bin/bash
logfile=$1
echo ================ ERRORS ================
grep -e ' Error ' -e 'Command not found' -e 'error: ' -e 'No such file' \
    $logfile
echo ================ WARNINGS ==============
grep -e ' warning: ' -e 'Warning: ' -e 'WARNING: ' $logfile | \
    grep -v hdv_mainframe_Dict.cc | grep -v 'has modification time' | \
    grep -v 'Clock skew detected' | grep -v 'Obsolete: ' | \
    grep -v 'AMPTOOLS or CLHEP is not defined' | grep -v dl_routines | \
    grep -v "variable 'pyk'" | grep -v "variable 'pychge'" | \
    grep -v "variable 'pycomp'" | grep -v "Nonconforming tab character"
