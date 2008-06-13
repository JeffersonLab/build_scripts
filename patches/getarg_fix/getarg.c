#include <stdio.h>
#include <string.h>
/*                                                                              
 * gfortran transforms the INSTRINIC GETARG into __gfortran_getarg_i4           
 * so we'll supply our own                                                      
 */
void getarg_(int* pos, char* value, size_t len)
{
  getarg_stub_(pos,value,len);
}
int  iargc_()
{
  return iargc_stub_();
}
