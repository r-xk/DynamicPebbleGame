!=======initialize histogram =======================================
SUBROUTINE init_His
	implicit none

	nsHis_now   = 0
	MxHis_now   = 0 
	MiHis_now   = Vol
	nmHis_now   = 0

	nsHis_csm   = 0
	MxHis_csm   = 0
	MiHis_csm   = Vol

	return
END SUBROUTINE init_His
!===================================================================



!==========define histogram ========================================
SUBROUTINE def_szHis
	implicit none
	integer(8) :: i, s, szbn
	szHis = 0
	szbn = 1; s = 0
	szHis(0) = 0
	do i = 1, MxHis
		s = s + szbn;    szHis(i) = s
		if(Mod(i,unHis)==0)   szbn = szbn*2
	enddo

	return
END SUBROUTINE def_szHis
!===================================================================





!============= function sz2bn ======================================
integer(4) FUNCTION func_bnHis(S)
	implicit none
	integer(4)       :: S
	integer(4)       :: i, bn, dbn, szbn
	func_bnHis = MxHis;    IF(S>=szHis(MxHis)) RETURN

	i  = unHis
	LP_I: DO
		IF(i>=MxHis)    EXIT LP_I
		IF(S<=szHis(i)) EXIT LP_I
		i = i + unHis
	ENDDO LP_I
	i    = i - unHis
	bn   = i;        i = i / unHis
	szbn = 2**i

	dbn  = S - szHis(bn)
	dbn  = 1 + (dbn-1) / szbn
	func_bnHis = bn + dbn
	return
END FUNCTION func_bnHis
!===================================================================





!============== Write histogram to disk==============================
SUBROUTINE writ_his
	implicit none
	character*9      :: str1
	integer(4)       :: s, i, bn, szbn, j, MxHs, MiHs, filenum, fnum
	double precision :: pro, nor, nmHs
	double precision :: val
	character*120, dimension(hisnum)    :: fnam

	write(str1,'(I8)'  )  Lx
	fnum = 1
	fnam(fnum) = 'C1p'//'_L'//trim(adjustl(str1));          fnum = fnum + 1        ! 1
	fnam(fnum) = 'C2p'//'_L'//trim(adjustl(str1));          fnum = fnum + 1
	fnam(fnum) = 'incre'//'_L'//trim(adjustl(str1));        fnum = fnum + 1
	fnam(fnum) = 'C1pmi'//'_L'//trim(adjustl(str1));        fnum = fnum + 1
	fnam(fnum) = 'C2pmi'//'_L'//trim(adjustl(str1));        fnum = fnum + 1
	fnam(fnum) = 'C1p2'//'_L'//trim(adjustl(str1));         fnum = fnum + 1        ! 6
	fnam(fnum) = 'C2m'//'_L'//trim(adjustl(str1));          fnum = fnum + 1
	fnam(fnum) = 'C1p4'//'_L'//trim(adjustl(str1));         fnum = fnum + 1
	fnam(fnum) = 'C2p4'//'_L'//trim(adjustl(str1));         fnum = fnum + 1
	fnam(fnum) = 'increp4'//'_L'//trim(adjustl(str1));      fnum = fnum + 1
    fnam(fnum) = 'unum'//'_L'//trim(adjustl(str1));         fnum = fnum + 1        ! 11
	fnam(fnum) = 'unum_max'//'_L'//trim(adjustl(str1));     fnum = fnum + 1
	fnam(fnum) = 'usize'//'_L'//trim(adjustl(str1));        fnum = fnum + 1        

	do i = 1, hisnum
		MxHs = MxHis_now(i);    MiHs = MiHis_now(i)
		nmHs = nmHis_now;       nor  = 1.d0/nmHs
		filenum = 100 * i
		open (filenum,file=fnam(i))
		write(filenum,'(i8,i12,f21.1)') vol, MxHs, nmHs
		do j = MiHs, MxHs
			bn  = (j-1)/unHis;      szbn = 2**bn
			val = func_value(i, j)
			pro = val*nor/(szbn*1.d0)
			write(filenum,51) j, szHis(j), val, pro
		enddo
		51 format(2x,i8,2x,i12,2x,2e20.10)
		close(filenum)
	enddo

	return
END SUBROUTINE writ_his
!===================================================================

!======================= value for different obs =====================
double precision FUNCTION func_value(i, j)
    implicit none
	integer(4), INTENT(IN) :: i, j
	
	if(i == 1) then
		func_value = nsck_C1p(j)
	else if(i == 2) then
		func_value = nsck_C2p(j)
    else if(i == 3) then
		func_value = nsck_incre(j)
	else if(i == 4) then
		func_value = nsck_C1pmi(j)
	else if(i == 5) then
		func_value = nsck_C2pmi(j)
	else if(i == 6) then
		func_value = nsck_C1p2(j)
	else if(i == 7) then
		func_value = nsck_C2m(j)
	else if(i == 8) then
		func_value = nsck_C1p4(j)
	else if(i == 9) then
		func_value = nsck_C2p4(j)
	else if(i ==10) then
		func_value = nsck_increp4(j)
	else if(i ==11) then
		func_value = nsck_unum(j)
	else if(i ==12) then
		func_value = nsck_unum_max(j)
	else if(i ==13) then
		func_value = nsck_usize(j)
	endif

	return
END FUNCTION func_value