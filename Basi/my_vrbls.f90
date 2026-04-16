!============== variable module ====================================
MODULE my_vrbls
    IMPLICIT NONE
    !-- common parameters and variables ------------------------------
    double precision, parameter :: tm32   = 1.d0/(2.d0**32)
    double precision, parameter :: eps    = 1.d-15         ! very small number
    double precision, parameter :: tol    = 0.20d0         ! tolerance for Cor
    logical                     :: prt                     ! flag for write2file
    integer,          parameter :: Mxint  = 2147483647     ! maximum integer
    integer,          parameter :: Mnint  =-2147483647     ! minimum integer

    integer,          parameter :: MxBlck = 2**10          ! maximum number of blocks for statistics
    integer,          parameter :: MnBlck = 2              ! minimum number of blocks

    integer            :: NBlck                            ! # blocks
    integer            :: Nsamp                            ! # samples in unit 'NBlck'
    integer            :: Totsamp
    integer            :: isamp, iblck

    character( 5) :: ident     = 'RigTr'                   ! identifier
    character(13) :: datafile  = 'RigTr.dat0'              ! datafile
    character(11) :: datafile1 = 'dat.big_cor'             ! datafile for big correlation
    !-----------------------------------------------------------------

    !-- parameters and variables -------------------------------------
    integer, parameter :: D    = 2                         ! dimensionality
    integer            :: Lx, Vol, Bnum
    double precision   :: wv, we                           ! 1/Vol, 1/E
    double precision   :: pb                               ! bond probability for n-th generation
    integer            :: ipb     
    !-----------------------------------------------------------------

    !-- Lattice and State --------------------------------------------
    integer, parameter :: MxLx = 3072                      ! maximum linear size
    integer, parameter :: MxV  = MxLx**D                   ! maximum volumn
    integer, parameter :: nnb  = 6                         ! coordination number
    integer, parameter :: MxB  = MxV * nnb / 2             ! maxinum bondnum

    integer(4), dimension(MxB)   :: ID                     ! state of bonds
    integer(4), dimension(MxB)   :: Parent                 ! tree structure of bond
    integer, dimension(MxB+10)   :: Bseq                   ! sequence of bond

    integer(4), dimension(MxV,3) :: digraph                ! the directed graph , 3rd column is the number of free pebbles
    integer(4), dimension(MxV )  :: value_site             ! label of site: floppy, searched or rigid
    double precision :: rs1, rs2_x, rs2_y, Rs_2, R1        ! for the calculation of ratius
    integer:: path(MxV)
    integer:: Dx(6), Dy(6)

    integer(4), dimension(0:nnb,2,MxV) :: Site               ! belong to which cluster, ponit to next site
    integer(4), dimension(2,MxB)       :: Cluster            ! store first site and last site in cluster
    integer(4), dimension(MxB/10) :: finded_cluster             ! store rigid clusters in merge process
    integer(4), dimension(MxB/10) :: tempbackup, unibackup      ! store rigid clusters in merge process

    integer(1), dimension(MxV)   :: Typ                    ! type of vertices: (1-9)
    integer(4), dimension(nnb,9) :: V2V, V2B               ! neighboring vertices 

    integer, parameter :: MxIJ = MxV 
    integer(4), dimension(-MxIJ:MxIJ) :: ijst              ! cluster in Wolff/SW simulation
    !-----------------------------------------------------------------

    !-- Histogram ----------------------------------------------------
    integer(4), parameter            :: MxHis  = 1280
    integer(4), parameter            :: unHis  = 64
    integer(8)                       :: szHis(0:MxHis)
    logical                          :: at_cri
    integer(4)                       :: nmHis_now
    integer, parameter               :: hisnum = 13
    integer(8), dimension(hisnum)    :: MiHis_now,MxHis_now
    double precision                 :: nsHis_now(MxHis)
    integer(8)                       :: MiHis_csm,MxHis_csm,nmHis_csm
    double precision                 :: nsHis_csm(MxHis)

    double precision,dimension(MxHis) :: nsck_C1p, nsck_C2p, nsck_incre, nsck_C1pmi, nsck_C2pmi
    double precision,dimension(MxHis) :: nsck_C1p2, nsck_C2m
    double precision,dimension(MxHis) :: nsck_C1p4, nsck_C2p4, nsck_increp4
    double precision,dimension(MxHis) :: nsck_unum, nsck_unum_max, nsck_usize

    !-- Observables --------------------------------------------------
    integer             :: Cwp
    double precision    :: S2, S4
    double precision    :: prob, prob4
    double precision    :: C1, C1p, incre, C1p4, increp4
    double precision    :: n_red1, n_red4
    double precision    :: C1p_minus, C1p4_minus
    double precision    :: nk, unionnum, unionnum_max
    double precision    :: incre_max, prob5, C1p5, n_red5, unionnum5, C1p5_minus

    double precision   :: gap_zong_ave, gap_zong_S2_ave, gap_small_ave, gap_small_S2_ave
    double precision   :: gap_zong_max, gap_small_max
    ! pL is defined as the time with maximal gap
    double precision   :: gap_zong_ave_Up2pL, gap_zong_S2_ave_Up2pL, gap_small_ave_Up2pL, gap_small_S2_ave_Up2pL
    double precision   :: gap_zong_max_Up2pL, gap_small_max_Up2pL
    double precision   :: gap_zong_pL, gap_zong_pL_S2, gap_small_pL, gap_small_pL_S2
    ! gap-related observables at pc
    double precision   :: gap_zong_pc, gap_zong_S2_pc, gap_small_pc, gap_small_S2_pc

    integer, parameter :: NObs_b = 44
    integer, parameter :: NObs_c = 3
    integer, parameter :: NObs = NObs_b + NObs_c


    !-- Statistics ---------------------------------------------------
    double precision, dimension(NObs_b)      :: Quan            ! Measured quantities
    double precision, dimension(NObs,MxBlck) :: Obs             ! 1st--#quan.  2nd--#block
    double precision, dimension(NObs)        :: Ave, Dev, Cor   
    ! average, error bars, and correlation of observables
    !-----------------------------------------------------------------

    !-- Random-number generator---------------------------------------
    integer, parameter           :: mult=32781
    integer, parameter           :: mod2=2796203, mul2=125
    integer, parameter           :: len1=9689,    ifd1=471
    integer, parameter           :: len2=127,     ifd2=30
    integer, dimension(1:len1)   :: inxt1
    integer, dimension(1:len2)   :: inxt2
    integer, dimension(1:len1)   :: ir1
    integer, dimension(1:len2)   :: ir2
    integer                      :: ipnt1, ipnf1
    integer                      :: ipnt2, ipnf2
    integer, parameter           :: mxrn = 10000
    integer, dimension(1:mxrn)   :: irn(mxrn)

    integer                      :: Seed                   ! random-number seed
    integer                      :: nrannr                 ! random-number counter
    !-----------------------------------------------------------------

    !!! Timing 
    double precision:: tt0,tt1

END MODULE my_vrbls
!===================================================================
