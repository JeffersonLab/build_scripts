if (! $?GSL) setenv GSL /usr/local/gsl/prod
setenv GSL_INCLUDE $GSL/include
setenv GSL_LIB $GSL/lib
if (! $?LD_LIBRARY_PATH) setenv LD_LIBRARY_PATH ''
echo $LD_LIBRARY_PATH | grep $GSL_LIB > /dev/null
if ($status) setenv LD_LIBRARY_PATH ${GSL_LIB}:${LD_LIBRARY_PATH}
