if (! $?CLHEP_HOME) setenv CLHEP_HOME $GLUEX_TOP/clhep/prod
setenv CLHEP_INCLUDE $CLHEP_HOME/include
setenv CLHEP_LIB $CLHEP_HOME/lib
if (! $?LD_LIBRARY_PATH) setenv LD_LIBRARY_PATH ''
echo $LD_LIBRARY_PATH | grep $CLHEP_LIB > /dev/null
if ($status) setenv LD_LIBRARY_PATH ${CLHEP_LIB}:${LD_LIBRARY_PATH}
