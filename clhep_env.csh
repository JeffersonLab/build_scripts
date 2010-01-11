if (! $?CLHEP) setenv CLHEP /usr/local/clhep/prod
setenv CLHEP_INCLUDE $CLHEP/include
setenv CLHEP_LIB $CLHEP/lib
if (! $?LD_LIBRARY_PATH) setenv LD_LIBRARY_PATH ''
echo $LD_LIBRARY_PATH | grep $CLHEP_LIB > /dev/null
if ($status) setenv LD_LIBRARY_PATH ${CLHEP_LIB}:${LD_LIBRARY_PATH}
