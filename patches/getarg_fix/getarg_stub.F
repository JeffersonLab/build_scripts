      subroutine getarg_stub( i, s )
      implicit none
      integer i
      character(*) s
c gfortran transforms this INTRINSIC into something different                   
c so one can't directly call it from C                                          
      intrinsic GETARG
      call GETARG(i,s)
      return
      end
      integer function iargc_stub()
      implicit none
      intrinsic IARGC
      iargc_stub = IARGC()
      return
      end
