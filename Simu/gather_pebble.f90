subroutine  find_rigid_site_Va_Vb(Va, Vb, Eab, site_label, finded_num, finded_cluster, max_root)
    implicit none
    integer :: Va, Vb, Eab
    integer :: p, active, edge, nb, site_label
    integer(4), intent(inout) :: finded_num, max_root
    integer(4), dimension(MxB/10), intent(inout) :: finded_cluster
    integer :: have_found_1
    integer :: site_label_f
    integer :: i, j, root, Va_root, Vb_root, dire, i_root
    integer :: isin, temp, index, root2, k1, k2, tk, changed, max_root_old

    call collect_three_pebble(Va, Vb)

    finded_num = 1
    finded_cluster(finded_num) = Eab

    !! `value_site == site_label`     : rigid
    !! `value_site == site_label + 1` : searched
    !! `value_site == site_label + 2` : floppy
    !! `value_site < site_label`      : not visited
    !! `visited_cluster == site_label`     : visited
    !! `visited_cluster == site_label + 1` : searched

    value_site(Va) = site_label
    value_site(Vb) = site_label
    site_label_f = site_label + 2

    visited_label = visited_label + 1

    visited(Va) = visited_label
    visited(Vb) = visited_label

    p = 1
    max_root = Eab
    i_root = 1
    changed = 0
    do while(p <= finded_num)
        ! if max_root has been changed, search old max_root
        if(changed == 0) then
            active = finded_cluster(p)
        else
            active = max_root_old
            changed = 0
            p = p - 1
        endif
        ! if some clusters are merged, skip search of the largest cluster
        if(active == max_root .and. finded_num > 1) then
            p = p + 1
            cycle
        endif
        if(visited_cluster(active) == site_label + 1) then
            p = p + 1
            cycle
        else
            visited_cluster(active) = site_label + 1
        endif
        nb = Cluster(1, active)
        do while(nb /= 0)
            if(value_site(nb) <= site_label) then
                value_site(nb) = site_label + 1
                do j = 1, Site(0, 1, nb)
                    edge = Site(j, 1, nb)
                    if(visited_cluster(edge) >= site_label)     cycle
                    visited_cluster(edge) = site_label
                    dire = (edge-1)/Vol + 1
                    k1 = mod(edge, Vol)
                    if(k1 == 0)		k1 = Vol
                    tk = Typ(k1)
                    k2 = k1 + V2V(dire, tk)
                    if(value_site(k1) == site_label+2 .or. value_site(k2) == site_label+2)    cycle
                    if(value_site(k1) < site_label)    then
                        nchanged_path = 0
                        nvisited = 0
                        call depth_first_search_2(k1, 1, have_found_1, site_label_f)
                        call label_sites(k1, have_found_1, site_label)
                        if(have_found_1 == 1)   cycle
                    endif
                    if(value_site(k2) < site_label)    then
                        nchanged_path = 0
                        nvisited = 0
                        call depth_first_search_2(k2, 1, have_found_1, site_label_f)
                        call label_sites(k2, have_found_1, site_label)
                        if(have_found_1 == 1)   cycle
                    endif
                    finded_num = finded_num + 1
                    finded_cluster(finded_num) = edge
                    if(-Parent(edge) > -Parent(max_root)) then
                        ! in a search, if max_root is changed more than once, max_root_old should be the oldest max_root
                        if(changed == 0)    max_root_old = max_root        
                        max_root = edge
                        i_root = finded_num
                        changed = 1
                    endif
                enddo
            endif
            call cluster_index(nb, active, index)
            nb = Site(index, 2, nb)
        enddo
        p = p + 1
    enddo

    incre_in_merge = -Parent(max_root)
    root = max_root
    dire = (root-1)/Vol + 1
    Va_root = mod(root, Vol)
    if(Va_root == 0)		Va_root = Vol
    Vb_root = Va_root + V2V(dire, Typ(Va_root))
    call collect_three_pebble(Va_root, Vb_root)
    do i = 1, finded_num
        if(i /= i_root ) then
            root2 = finded_cluster(i)
            p = Cluster(1, root2)
            do while(p /= 0)
                call cluster_index(p, root2, index)
                temp = Site(index, 2, p)
                call check_inclus(p, index, root, isin)
                if(isin == 0) then
                    digraph(p, 1) = Va_root
                    digraph(p, 2) = Vb_root
                    digraph(p, 3) = 0
                    call add_cluster(p, root)
                endif
                p = temp
            enddo
        endif
    enddo

    incre_in_merge = -Parent(max_root) - incre_in_merge

    call Union_Batch(Parent, max_root, i_root, finded_num)

end subroutine find_rigid_site_Va_Vb

subroutine collect_three_pebble(x, y)
    implicit none
    integer:: x, y
    integer:: freex, freey, have_collected_1, zong

    freex = digraph(x, 3)
    freey = digraph(y, 3)
    zong = freex + freey
    if(zong == 3)    return
    do while (freex < 2)
        call collect_one_pebble(x, y, have_collected_1)
        if(have_collected_1 == 1) then
            freex = freex + 1
            zong = zong + 1
            if(zong == 3)    return
        else
            exit
        endif
    enddo

    do while (freey < 2)
        call collect_one_pebble(y, x, have_collected_1)
        if(have_collected_1 == 1) then
            freey = freey + 1
            zong = zong + 1
            if(zong == 3)    return
        else
            exit
        endif
    enddo

    return
end subroutine collect_three_pebble

recursive subroutine depth_first_search_2(V,state, have_found_1, site_label_f)
    implicit none
    integer:: V, have_found_1
    integer:: x, y
    integer:: state
    integer:: site_label_f

    visited(V) = visited_label;
    nvisited = nvisited + 1
    visited_list(nvisited) = V

    if (digraph(V, 3) > 0  .or. value_site(V) == site_label_f) then
        have_found_1 = 1
        return
    else
        x = digraph(V, 1)
        if (value_site(x) /= site_label_f - 2 .and. value_site(x) /= site_label_f - 1) then
            if (visited(x) /= visited_label) then
                path(V) = x
                nchanged_path = nchanged_path + 1
                changed_path_list(nchanged_path) = V
                call depth_first_search_2(x, 1, have_found_1, site_label_f)
                if (have_found_1 == 1) then
                    return
                endif
            endif
        endif

        y = digraph(V, 2)
        if (value_site(y) /= site_label_f - 2 .and. value_site(y) /= site_label_f - 1) then
            if (visited(y) /= visited_label) then
                path(V) = y
                nchanged_path = nchanged_path + 1
                changed_path_list(nchanged_path) = V
                call depth_first_search_2(y, 1, have_found_1, site_label_f)
                if (have_found_1 == 1) then
                    return
                endif
            endif
        endif

        have_found_1 = 0
        return
    endif

end subroutine depth_first_search_2


subroutine label_sites(V, have_found_1, site_label)
    implicit none
    integer:: V, V_bk
    integer:: V_prev, V_next, index_wv
    integer:: i, Vi, have_found_1, site_label

    !! If one free pebble is found, mark the sites on the path as floppy.
    !! These sites should not stay marked with the current `visited_label`.
    if (have_found_1 == 1) then
        V_bk = V
        do while (path(V) /= -1)
            if(value_site(V) < site_label) then
                value_site(V) = site_label + 2
            endif
            V = path(V)
        enddo

        if(value_site(V) < site_label) then
            value_site(V) = site_label + 2
        endif

        V= V_bk
    endif

    !! If no free pebble is found, all visited sites are rigid.
    if(have_found_1 == 0)then
        do i = 1, nvisited
            Vi = visited_list(i)
            if(value_site(Vi) < site_label) then
                value_site(Vi) = site_label
            endif
        enddo
    endif

    !! Restore the search path.
    do i = 1, nchanged_path
        Vi = changed_path_list(i)
        path(Vi) = -1
    enddo


    !! Reset visited marks for sites classified as floppy.
    if(have_found_1 == 1)then
        do i = 1, nvisited
            Vi = visited_list(i)
            if(value_site(Vi) /= site_label .and. value_site(Vi) /= site_label + 1) then
                visited(Vi) = visited_label - 1
            endif
        enddo
    endif

end subroutine label_sites

