!==============Initialization ======================================
SUBROUTINE initialize
    implicit none
    !-- order should be changed --------------------------------------
    call tst_and_prt
    call set_RNG
    call def_latt
    call def_prob
    call def_szHis

    !-- measurement initialization -----------------------------------
    Obs = 0.d0;   Quan = 0.d0
    Ave = 0.d0;   Dev  = 0.d0;     Cor = 0.d0
    return
END SUBROUTINE initialize
!===================================================================
include "Init/tst_and_prt.f90"
include "Init/def_latt.f90"
include "Init/def_prob.f90"
include "Init/def_His.f90"
