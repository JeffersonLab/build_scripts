#!/bin/tcsh
rm -f before_setup.tmp after_setup.tmp after_clean.tmp
printenv > before_setup.tmp
echo source gluex_env.csh
source gluex_env.csh -v
printenv > after_setup.tmp
echo source gluex_env_clean.csh
source gluex_env_clean.csh
printenv > after_clean.tmp
xterm -e "diff -s before_setup.tmp after_setup.tmp | less" &
xterm -e "diff -s after_setup.tmp after_clean.tmp | less" &
xterm -e "diff -s before_setup.tmp after_clean.tmp| less" &
