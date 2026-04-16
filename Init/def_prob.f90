!==============define flipping probability =========================
SUBROUTINE def_prob
    implicit none
    ipb = (pb-0.5d0)/tm32;  if(dabs(pb-1.d0)<1.d-8) ipb = Mxint
    write(6,40) ipb;    40 format(2x,'ipb:',4x,2i16)

    return
END SUBROUTINE def_prob
