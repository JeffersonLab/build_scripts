#!/bin/sh
rm -f before_setup.tmp after_setup.tmp after_clean.tmp
printenv > before_setup.tmp
echo source gluex_env.sh
source gluex_env.sh -v
printenv > after_setup.tmp
echo source gluex_env_clean.sh
source gluex_env_clean.sh
printenv > after_clean.tmp
xterm -e "diff -s before_setup.tmp after_setup.tmp | less" &
xterm -e "diff -s after_setup.tmp after_clean.tmp | less" &
xterm -e "diff -s before_setup.tmp after_clean.tmp| less" &
