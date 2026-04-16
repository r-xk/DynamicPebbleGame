!==============Test and Print ======================================
SUBROUTINE tst_and_prt
    implicit none

    !-- Test and Print -----------------------------------------------
    if((NBlck>MxBlck).or.(NBlck<MnBlck)) then
      write(6,*) 'MnBlck <= NBlck <=MxBlck?';             stop
    endif

    if((NBlck>200).and.(NBlck/=MxBlck)) then
      write(6,*) '"NBlck>200" is supposed for extensive &
      & simulation. "NBlck=MxBlk" is suggested!';         stop
    endif

    if(Lx>MxLx) then
      write(6,*) 'Lx<=MxLx?';                             stop
    endif

    write(6,40) Lx, Lx 
    40 format(' Rigidity Percolation on ',i6,2x,i6,2x,'triangular lattice')

    write(6,41) pb 
    41 format(' bond probability:',f20.12)

    write(6,42) Nsamp*NBlck
    42 format(' Will simulate      ',i10,2x,'steps ')

    write(6,43) NBlck
    43 format(' #Blocks            ',i10)

    write(6,45) Mnint, Mxint
    45 format(' Mnint, Mxint       ',2i20)

    return
END SUBROUTINE tst_and_prt

