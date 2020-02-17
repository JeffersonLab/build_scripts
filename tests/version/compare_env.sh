#!/bin/bash
xml=$1
rm -f old.tmp new.tmp
~/build_scripts/version.pl $xml > old.tmp
#~/build_scripts_debug_control/version.pl $xml | grep -v _DEBUG_LEVEL > new.tmp
~/build_scripts_debug_control/version.pl $xml > new.tmp
echo --- $xml ---
diff old.tmp new.tmp
