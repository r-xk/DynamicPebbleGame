!=============Pebble game algorithm for rigidity percolation on triangular lattice ================
subroutine collect_four_pebble(x, y, have_collected_4)
    implicit none
    integer:: x, y, have_collected_4
    integer:: freex, freey, have_collected_1

    freex = digraph(x, 3)
    freey = digraph(y, 3)
    do while (freex < 2)
        call collect_one_pebble(x, y, have_collected_1)
        if(have_collected_1 == 1) then
            freex = freex + 1
        else
            exit
        endif
    enddo

    do while (freey < 2)
        call collect_one_pebble(y, x, have_collected_1)
        if(have_collected_1 == 1) then
            freey = freey + 1
        else
            exit
        endif
    enddo

    if (freex == 2 .and. freey == 2) then
        have_collected_4 = 1
    else
        have_collected_4 = 0
    endif

    return
end subroutine collect_four_pebble

subroutine collect_one_pebble(x, y, have_collected_1)
    implicit none
    integer:: x, y, have_collected_1
    integer:: have_found_1

    visited_label = visited_label + 1

    visited(y) = visited_label
    nchanged_path = 0

    call depth_first_search(x, 0, have_found_1)

    if (have_found_1 == 1) then
        call rearrange_pebbles(x, have_found_1)
        have_collected_1 = 1
    else
        have_collected_1 = 0
        call rearrange_pebbles(x, have_found_1)
    endif

    return
end subroutine collect_one_pebble


recursive subroutine depth_first_search(V, state, have_found_1)
    implicit none
    integer:: V, have_found_1
    integer:: x, y
    integer:: state

    visited(V) = visited_label;

    if(digraph(V, 3) > 0  .and.  state == 1) then
        have_found_1 = 1
        return
    else
        x = digraph(V, 1)
        if(visited(x) /= visited_label) then
            path(V) = x
            nchanged_path = nchanged_path + 1			!!!nchange records the site whose path are changed
            changed_path_list(nchanged_path) = V
            call depth_first_search(x, 1, have_found_1)
            if (have_found_1 == 1) then
                return
            endif
        endif

        y = digraph(V, 2)
        if(visited(y) /= visited_label) then
            path(V) = y
            nchanged_path = nchanged_path + 1
            changed_path_list(nchanged_path) = V
            call depth_first_search(y, 1, have_found_1)
            if (have_found_1 == 1) then
                return
            endif
        endif

        have_found_1 = 0
        return
    endif

end subroutine depth_first_search

subroutine rearrange_pebbles(V, have_found_1)
    implicit none
    integer:: V, V_bk
    integer:: V_prev, V_next, index_wv
    integer:: i, Vi, have_found_1

    !! Reverse the directed path like a singly linked list.

    if(have_found_1==1) then
        V_bk = V
        V_prev = V
        digraph(V, 3) = digraph(V, 3) + 1
        do while(path(V) /= -1)
            V_next = path(V)
            call find_index(index_wv, V, V_next)
            digraph(V, index_wv) = V_prev
            V_prev = V
            V = V_next
        enddo

        call find_index(index_wv, V, V)
        digraph(V, index_wv) = V_prev
        digraph(V, 3) = digraph(V, 3) - 1

        V= V_bk
    endif

    !! Restore `path` entries touched during `depth_first_search`.
    do i = 1, nchanged_path
        Vi = changed_path_list(i)
        path(Vi) = -1
    enddo

end subroutine rearrange_pebbles


subroutine find_index(index_wv, V, V_next)
    implicit none
    integer:: index_wv, V, V_next

    if(digraph(V, 2) == V_next) then
        index_wv = 2
    elseif(digraph(V, 1) == V_next) then
        index_wv = 1
    else
        error stop "find_index: invalid digraph edge"
    endif

end subroutine find_index
