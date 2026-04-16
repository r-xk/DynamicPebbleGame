SUBROUTINE markov
    implicit none

    call swendsen_wang_topology


    return
END SUBROUTINE markov

include "Simu/swendsen_wang_topology.f90"
include "Simu/pebble.f90"
include "Simu/gather_pebble.f90"
include "Simu/site.f90"
