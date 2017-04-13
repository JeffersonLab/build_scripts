#!/bin/tcsh
rm -f before_setup.tmp after_setup.tmp after_clean.tmp
printenv | sort > before_setup.tmp
echo source test.csh
source test.csh
printenv | sort > after_setup.tmp
echo source gluex_env_clean.csh
source $BUILD_SCRIPTS/gluex_env_clean.csh
printenv | sort > after_clean.tmp
xterm -e "diff -s before_setup.tmp after_setup.tmp | less" &
xterm -e "diff -s after_setup.tmp after_clean.tmp | less" &
xterm -e "diff -s before_setup.tmp after_clean.tmp| less" &
