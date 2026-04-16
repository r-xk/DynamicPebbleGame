
!==============Measurement =========================================
SUBROUTINE measure
	implicit none
	integer :: site_label, obsnum, bond_added
    bond_added = int(Bnum * pb)

	Quan( 1) = prob * we
	Quan( 2) = C1     * wv
	Quan( 3) = C1p    * wv
	Quan( 4) = incre  * wv
	Quan( 5) = (prob  * we)**2
	Quan( 6) = n_red1 * we
    Quan( 7) = (C1p  * wv)**2

    obsnum = 8
    Quan(obsnum) = C1p_minus * wv;              obsnum = obsnum + 1
    Quan(obsnum) = unionnum * we;               obsnum = obsnum + 1
    Quan(obsnum) = unionnum_max * we;           obsnum = obsnum + 1
    Quan(obsnum) = prob4  * we;                 obsnum = obsnum + 1        ! 11
    Quan(obsnum) = (prob4 * we)**2;             obsnum = obsnum + 1
    Quan(obsnum) = C1p4 * wv;                   obsnum = obsnum + 1
    Quan(obsnum) = n_red4 * we;                 obsnum = obsnum + 1
    Quan(obsnum) = increp4 * wv;                obsnum = obsnum + 1
    Quan(obsnum) = (unionnum_max * we) ** 2;    obsnum = obsnum + 1        ! 16
    Quan(obsnum) = C1p4_minus * wv;             obsnum = obsnum + 1

    Quan(obsnum) = prob5 * we;                  obsnum = obsnum + 1
    Quan(obsnum) = (prob5 * we)**2;             obsnum = obsnum + 1
    Quan(obsnum) = C1p5 * wv;                   obsnum = obsnum + 1
    Quan(obsnum) = n_red5 * we;                 obsnum = obsnum + 1        ! 21
    Quan(obsnum) = unionnum5 * we;              obsnum = obsnum + 1
    Quan(obsnum) = incre_max * wv;              obsnum = obsnum + 1
    Quan(obsnum) = C1p5_minus * wv;             obsnum = obsnum + 1

    Quan(obsnum) = gap_zong_ave / bond_added;               obsnum = obsnum + 1
    Quan(obsnum) = gap_zong_S2_ave / bond_added;            obsnum = obsnum + 1        ! 26
    Quan(obsnum) = gap_zong_max;                            obsnum = obsnum + 1
    Quan(obsnum) = gap_small_ave / bond_added;              obsnum = obsnum + 1
    Quan(obsnum) = gap_small_S2_ave / bond_added;           obsnum = obsnum + 1
    Quan(obsnum) = gap_small_max;                           obsnum = obsnum + 1
    Quan(obsnum) = gap_zong_pL;                             obsnum = obsnum + 1        ! 31
    Quan(obsnum) = gap_zong_pL_S2;                          obsnum = obsnum + 1
    Quan(obsnum) = gap_small_pL;                            obsnum = obsnum + 1  
    Quan(obsnum) = gap_small_pL_S2;                         obsnum = obsnum + 1
    Quan(obsnum) = gap_zong_ave_Up2pL / prob5;              obsnum = obsnum + 1
    Quan(obsnum) = gap_zong_S2_ave_Up2pL / prob5;           obsnum = obsnum + 1        ! 36
    Quan(obsnum) = gap_zong_max_Up2pL;                      obsnum = obsnum + 1
    Quan(obsnum) = gap_small_ave_Up2pL / prob5;             obsnum = obsnum + 1
    Quan(obsnum) = gap_small_S2_ave_Up2pL / prob5;          obsnum = obsnum + 1
    Quan(obsnum) = gap_small_max_Up2pL;                     obsnum = obsnum + 1        ! 40

    Quan(obsnum) = gap_zong_pc;                             obsnum = obsnum + 1
    Quan(obsnum) = gap_zong_S2_pc;                          obsnum = obsnum + 1
    Quan(obsnum) = gap_small_pc;                            obsnum = obsnum + 1
    Quan(obsnum) = gap_small_S2_pc;                         obsnum = obsnum + 1        ! 44

	return
END SUBROUTINE measure
!==============Calculate Binder ratio 1================================
!! Q=Ave(b2)/Ave(b1)^epo
SUBROUTINE cal_Q(jb,b1,b2,epo)
    implicit none
    integer, intent(in) :: jb, b1,b2
    double precision, intent(in) :: epo
    integer             :: k
    double precision    :: tmp

    !-- Average ----------------------------------------------------
      tmp = Ave(b1  )**epo;   if(dabs(tmp)>eps) tmp = Ave(b2  )/tmp
      Ave(jb  ) = tmp

    !-- Obs(j,k) series --------------------------------------------
    do k = 1, NBlck
      tmp = Obs(b1,k)**epo;   if(dabs(tmp)>eps) tmp = Obs(b2,k)/tmp
      Obs(jb,k) = tmp
    enddo
END SUBROUTINE cal_Q

!==============Calculate specific-heat-like quantity ==================
!! C = V(Ave(b2)-Ave(b1)^2)
SUBROUTINE cal_sp_heat(jb,b2,b1)
    implicit none
    integer, intent(in) :: jb, b1, b2
    integer             :: k

    !-- Average ----------------------------------------------------
      Ave(jb) = Vol*(Ave(b2)-Ave(b1)**2.d0)

    !-- Obs(j,k) series --------------------------------------------
    do k = 1, NBlck
      Obs(jb,k) =Vol*(Obs(b2,k)-Obs(b1,k)**2.d0)
    enddo
END SUBROUTINE cal_sp_heat
!==============Calculate fluctuation ==================
  SUBROUTINE cal_fluc(jb,b1,b2)
	implicit none
	integer, intent(in) :: jb, b1, b2
	integer             :: k
	double precision    :: tmp, correct

    Ave(jb) = dsqrt(Ave(b2)-Ave(b1)**2.d0)

	do k = 1, NBlck
    	Obs(jb,k) = dsqrt(Obs(b2,k)-Obs(b1,k)**2.d0)
	enddo
END SUBROUTINE cal_fluc

!==============Calculate composite observables =====================
!! call in 'stat_alan'
SUBROUTINE cal_Obs_comp
    implicit none
    integer    :: jb

    jb = NObs_b +  1;      call cal_fluc(jb, 1, 5)

    jb = NObs_b +  2;      call cal_fluc(jb, 11, 12)

    jb = NObs_b +  3;      call cal_fluc(jb, 18, 19)

    return
END SUBROUTINE cal_Obs_comp
!===================================================================
