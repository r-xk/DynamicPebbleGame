!=============Site array-related  algorithm ==============================
!! Return codes for `independent`:
!! 0 = redundant, 1 = independent, 2 = does not connect two rigid clusters.
SUBROUTINE indep_bond(Va, Vb, independent, root)
    implicit none
    integer:: Va, Vb, independent, root
    integer:: x, y

    if(Site(0, 1, Va) == 0 .or. Site(0, 1, Vb) == 0) then
        independent = 2
        return
    else
        do x = 1, Site(0, 1, Va)
            do y = 1, Site(0, 1, Vb)
                if(Site(x, 1, Va) == Site(y, 1, Vb)) then
                    independent = 0
                    root = Site(x, 1, Va) 
                    return
                endif
            enddo
        enddo
    endif

    independent = 1
    return

end subroutine indep_bond

!! Add new cluster info to `Site`.
SUBROUTINE add_cluster(Va, root)
    implicit none
    integer:: Va, root
    integer:: x, y, index, last_site, last_index
    
    if(Cluster(1, root) == 0) then
        Cluster(1, root) = Va
        Cluster(2, root) = Va
    else
        last_site = Cluster(2, root)
        call cluster_index(last_site, root, index)
        Site(index, 2, last_site) = Va
        Cluster(2, root) = Va
    endif
    Site(0, 1, Va) = Site(0, 1, Va) + 1
    last_index = Site(0, 1, Va)
    Site(last_index, 1, Va) = root
    Site(last_index, 2, Va) = 0
    Parent(root) = Parent(root) - 1

end subroutine add_cluster

!! Find the index in `Site` that stores cluster `root`.
SUBROUTINE cluster_index(Va, root, index)
    implicit none
    integer:: Va, root, index
    integer:: x, count
    
    count = Site(0, 1, Va)

    do x = 1, count
        if(Site(x, 1, Va) == root) then
            index = x
            return
        ENDIF
    enddo

    index = 0
    return

end subroutine cluster_index

!! Add a pebble to an independent bond.
SUBROUTINE add_pebble(Va, Vb, pos)
    implicit none
    integer:: Va, Vb, pos
    integer:: have_collected_1, x, y, num, sum
    
    if(digraph(Va, 3) > 0) then
        if(digraph(Va, 1) == Va) then
            digraph(Va, 1) = Vb
            digraph(Va, 3) = digraph(Va, 3) - 1
        else
            digraph(Va, 2) = Vb
            digraph(Va, 3) = digraph(Va, 3) - 1
        endif
    elseif(digraph(Vb, 3) > 0) then
        if(digraph(Vb, 1) == Vb) then
            digraph(Vb, 1) = Va
            digraph(Vb, 3) = digraph(Vb, 3) - 1
        else
            digraph(Vb, 2) = Va
            digraph(Vb, 3) = digraph(Vb, 3) - 1
        endif
    else
        call collect_one_pebble(Va, Vb, have_collected_1)
        if(digraph(Va, 1) == Va) then
            digraph(Va, 1) = Vb
            digraph(Va, 3) = digraph(Va, 3) - 1
        else
            digraph(Va, 2) = Vb
            digraph(Va, 3) = digraph(Va, 3) - 1
        endif
    endif

end subroutine add_pebble

!! Remove one cluster entry and check whether `Va` is in `root`.
SUBROUTINE check_inclus(Va, index, root, isin)
    implicit none
    integer :: Va, root, isin, index
    integer :: i, last_index

    last_index = Site(0, 1, Va)
    if(index /= last_index) then
        Site(index, 1, Va) = Site(last_index, 1, Va)
        Site(index, 2, Va) = Site(last_index, 2, Va)
    endif
    Site(0, 1, Va) = last_index - 1
    
    do i = 1, Site(0, 1, Va)
        if(Site(i, 1, Va) == root) then
            isin = 1
            return
        endif
    enddo
    isin = 0
    return

end subroutine check_inclus