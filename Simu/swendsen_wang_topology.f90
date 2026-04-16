!=============Swendsen-Wang algorithm ==============================
SUBROUTINE swendsen_wang_topology
    implicit none
    integer(4) :: x, tk, temp, dire
    integer(4) :: num, pos, k1, k2, root
    integer(4) :: coor1, coor2
    integer:: independent, site_label, finded_num
    integer :: max_root, redun_root
    integer :: gaps, gapz
    
    !----- initialize ------------------------------------------------
    C1 = 1
    coor1 = 1
    coor2 = 2
    incre = 0
    value_site(1:Vol) = 0
    site_label = 1
    incre_max = 0

    visited(1:Vol) = 0
    visited_label = 0
    visited_label_add = 0
    visited_cluster(1:Bnum) = 0

    n_redundant = 0.d0

    finded_num = 0
    unionnum_max = 0

    do i = 1, Vol
        digraph(i, 1:2) = i
        digraph(i, 3) = 2
    end do
    ! after an initialization, the path remains unchanged
    if(iblck == 1 .and. isamp == 1) then
        do i = 1, Vol
            path(i) = -1
        end do
    end if
    do x = 1, Bnum
        Parent(x) = -1    !init
        Bseq(x) = x
    end do
    Site(:, :, 1:Vol) = 0;    Cluster(:, 1:Bnum) = 0
    num = 1

    do x = 1, int(Bnum * pb) + 1
        pos = rn() * (Bnum - x + 1) + x     ! Site index starts from 1
        temp = Bseq(x)
        Bseq(x) = Bseq(pos)
        Bseq(pos) = temp
    enddo

    gap_zong_ave = 0.0d0;    gap_zong_S2_ave = 0.0d0
    gap_small_ave = 0.0d0;    gap_small_S2_ave = 0.0d0
    gap_zong_max = 0.0d0;    gap_small_max = 0.0d0
    gap_zong_pL = 0.0d0;    gap_zong_pL_S2 = 0.0d0
    gap_small_pL = 0.0d0;    gap_small_pL_S2 = 0.0d0

    !----- grow cluster ----------------------------------------------
    LP_LAT: do while (num <= Bnum*pb)
        pos = Bseq(num)
        dire = (pos-1)/Vol + 1
        k1 = mod(pos, Vol)
        if(k1 == 0) k1 = Vol
        tk = Typ(k1)
        k2 = k1 + V2V(dire, tk)
        call indep_bond(k1, k2, independent, redun_root)
        if(independent == 0) then
            n_redundant = n_redundant + 1.d0
            gaps = 0
            gapz = -Parent(redun_root)
            gap_zong_ave = gap_zong_ave + gapz * wv
            gap_zong_S2_ave = gap_zong_S2_ave + (gapz * wv)**2
            gap_zong_max = max(gap_zong_max, dble(gapz))
            gap_small_ave = gap_small_ave + gaps * wv
            gap_small_S2_ave = gap_small_S2_ave + (gaps * wv)**2
            gap_small_max = max(gap_small_max, dble(gaps))

            if(num == bond_pc) then
                gap_zong_pc = gapz * wv
                gap_zong_S2_pc = (gapz * wv)**2
                gap_small_pc = gaps * wv
                gap_small_S2_pc = (gaps * wv)**2
            endif

            num = num + 1
            cycle
        else
            call add_pebble(k1, k2, pos)
            root = pos
            Parent(pos) = 0
            call add_cluster(k1, pos)
            call add_cluster(k2, pos)
            if(independent /= 2) then
                site_label = site_label + 3
                call find_rigid_site_Va_Vb(k1, k2, pos, site_label, finded_num, finded_cluster, max_root)
                root = max_root
            else
                ! for unionnum
                finded_num = 1
            endif

            if(finded_num == 1) then
                gaps = 1
                gapz = 2
            else
                gaps = incre_in_merge
                gapz = -Parent(root)
            endif
        endif

        gap_zong_ave = gap_zong_ave + gapz * wv
        gap_zong_S2_ave = gap_zong_S2_ave + (gapz * wv)**2
        gap_zong_max = max(gap_zong_max, dble(gapz))
        gap_small_ave = gap_small_ave + gaps * wv
        gap_small_S2_ave = gap_small_S2_ave + (gaps * wv)**2
        gap_small_max = max(gap_small_max, dble(gaps))

        if(num == bond_pc) then
            gap_zong_pc = gapz * wv
            gap_zong_S2_pc = (gapz * wv)**2
            gap_small_pc = gaps * wv
            gap_small_S2_pc = (gaps * wv)**2
        endif

        if(finded_num > unionnum_max) then
            unionnum_max = finded_num
            prob4 = num - 1
            C1p4 = max(int(C1), -Parent(root))
            C1p4_minus = C1
            n_red4 = n_redundant
            increp4 = incre_in_merge
        endif

        if(finded_num > 1 .and. incre_in_merge > incre_max) then
            prob5 = num - 1
            incre_max = incre_in_merge
            C1p5 = max(int(C1), -Parent(root))
            C1p5_minus = C1
            n_red5 = n_redundant
            unionnum5 = finded_num

            gap_zong_pL = gapz * wv
            gap_small_pL = gaps * wv
            gap_zong_pL_S2 = (gapz * wv)**2
            gap_small_pL_S2 = (gaps * wv)**2
            ! store the accumulation up to pL
            gap_zong_ave_Up2pL = gap_zong_ave
            gap_zong_S2_ave_Up2pL = gap_zong_S2_ave
            gap_zong_max_Up2pL = gap_zong_max
            gap_small_ave_Up2pL = gap_small_ave
            gap_small_S2_ave_Up2pL = gap_small_S2_ave
            gap_small_max_Up2pL = gap_small_max
        endif

        if(-Parent(root) > C1) then
            if(-Parent(root) - C1 >= incre) then
                incre = -Parent(root) - C1
                prob = num - 1
                C1p = -Parent(root)
                C1p_minus = C1
                unionnum = finded_num
                n_red1 = n_redundant
            endif
            C1 = -Parent(root)           
        endif

        num = num + 1

    end do LP_LAT

    return
    
END SUBROUTINE swendsen_wang_topology
!===================================================================
SUBROUTINE Union(Parent, x, y)
    implicit none
    integer(4), dimension(1:Bnum), intent(inout)   :: Parent
    integer(4), intent(in) :: x, y
    integer(4) :: xr, yr
    call Find(Parent, x, xr)
    call Find(Parent, y, yr)
    if(xr /= yr) then
		if(Parent(yr) >= Parent(xr)) then
            Parent(yr) = xr
		else
            Parent(xr) = yr
		endif
	endif
END SUBROUTINE Union
!===================================================================
SUBROUTINE Find(Parent, x, xr)
    implicit none
    integer(4), dimension(1:Bnum), intent(inout)   :: Parent
    integer(4), intent(in) :: x
    integer(4), intent(inout) :: xr
    integer(4) :: next, current
    
    xr = x
    do while(Parent(xr) >= 0)
        xr = Parent(xr)
    enddo

    current = x
    do while(current /= xr)
        next = Parent(current)
        Parent(current) = xr
        current = next
    enddo
END SUBROUTINE Find
!===================================================================
SUBROUTINE Union_Batch(Parent, max_root, max_index, finded_num)
    implicit none
    integer(4), dimension(1:Bnum), intent(inout)   :: Parent
    integer(4), intent(in) :: max_root, max_index, finded_num
    integer(4) :: current_root

    if(finded_num == 1) return

    do i = 1, max_index - 1
        current_root = finded_cluster(i)
        Parent(current_root) = max_root
    enddo

    do i = max_index + 1, finded_num
        current_root = finded_cluster(i)
        Parent(current_root) = max_root
    enddo

END SUBROUTINE Union_Batch

