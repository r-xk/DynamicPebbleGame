!==============definite Lattice ====================================
SUBROUTINE def_latt
    implicit none
    integer :: Vc, xc, yc
    integer :: xm, xp, ym, yp
    integer, dimension(Lx) :: xm_lookup, ym_lookup

    xm_lookup(1:Lx) = 1
    xm_lookup(1) = 0; xm_lookup(Lx) = 2
     
    ym_lookup(1:Lx) = 1
    ym_lookup(1) = 0; ym_lookup(Lx) = 2

    Typ(1:Vol) = 0
    Vc = 0
    do yc = 1, Lx
    do xc = 1, Lx
        Vc = Vc + 1
        Typ(Vc) = ym_lookup(yc)*3 + xm_lookup(xc) + 1
    enddo
    enddo

    V2V(:, :) = 0; V2B(:, :) = 0
    Vc = 0
    do yc = 1, 3
    do xc = 1, 3
        Vc = Vc + 1
        xm = -1;  if (xc == 1) xm = -1 + Lx
        xp = 1;   if (xc == 3) xp = 1 - Lx

        ym = -Lx; if (yc == 1) ym = -Lx + Vol
        yp = Lx;  if (yc == 3) yp = Lx - Vol

        V2V(1, Vc) = xp; V2V(2, Vc) = yp; V2V(3, Vc) = yp + xm
        V2V(6, Vc) = xm; V2V(5, Vc) = ym; V2V(4, Vc) = ym + xp
        V2B(1, Vc) = 0; V2B(2, Vc) = Vol; V2B(3, Vc) = Vol*2
        V2B(6, Vc) = xm; V2B(5, Vc) = Vol + ym; V2B(4, Vc) = Vol*2 + ym + xp
    enddo
    enddo
    
    Dx(1)= 1;   Dy(1)=0
    Dx(2)= 0;   Dy(2)=1
    Dx(3)=-1;   Dy(3)=1
    Dx(4)= 1;   Dy(4)=-1
    Dx(5)= 0;   Dy(5)=-1
    Dx(6)=-1;   Dy(6)=0

    return
END SUBROUTINE def_latt
