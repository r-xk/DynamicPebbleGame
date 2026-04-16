INCLUDE "Basi/my_vrbls.f90"
!===== Main routine ================================================
PROGRAM PercolationOnTriangular
    use my_vrbls
    implicit none
    integer:: visited(MxV), visited_size, visited_label_add, visited_label
    integer:: nchanged_path, changed_path_list(MxV)
    integer:: nvisited, visited_list(MxV), visited_cluster(MxB)

    integer:: n_redundant
    integer:: n_rigidCluster

    integer:: i
    integer :: lamda, bond_pc
    double precision :: pc

    integer :: incre_in_merge

    lamda = 1
    print *, 'Lx, Nsamp, pb, Seed, NBlck'
    read  *,  Lx, Nsamp, pb, Seed, NBlck

    Totsamp = Nsamp*NBlck/100
    Vol = Lx**D;    Bnum = Vol * nnb / 2
    wv = 1.d0/Vol;  we = 1.d0/Bnum
    pc = 0.66025
    bond_pc = int(Bnum * pc)

    print*, "pb        =", pb

    nsck_C1p =0      ; nsck_C2p =0    ;  nsck_incre =0 
    nsck_C1p2 =0    ; nsck_C2m =0    ;

    !--- Initialization ----------------------------------------------
    call initialize
    call flush(6)

    !--- Simulation --------------------------------------------------
    call init_his
    at_cri = .false.

    call cpu_time(tt0)
    DO iblck = 1, NBlck
        do isamp = 1, Nsamp
            call markov
            call measure
            call coll_data(iblck)
            call cpu_time(tt1)
        enddo
        call norm_Nsamp(iblck)
    ENDDO
    call cpu_time(tt1)

    open (100, file="time.dat",access='append')
    write(*,101)"Simulation time = ", Lx, tt1-tt0, pb
    101 format(A20, I8, 2F20.4)

    write(100,201) Lx, tt1-tt0, pb
    201 format(I8, 2F20.12)
    close(100)


    !--- Statistics --------------------------------------------------
    call stat_analy
    call write2file

    if (at_cri) call writ_his

CONTAINS
    INCLUDE "Init/initialize.f90"
    INCLUDE "Simu/markov.f90"
    INCLUDE "Meas/measure.f90"
    INCLUDE "Meas/statistics.f90"
    INCLUDE "RNG/my_rng.f90"

END PROGRAM PercolationOnTriangular
!=====================================================================
