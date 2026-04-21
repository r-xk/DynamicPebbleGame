# Dynamic Pebble Game Algorithm for Rigidity Percolation on the Triangular Lattice

This repository contains a Fortran implementation of the dynamic pebble game algorithm for rigidity percolation on the triangular lattice.

## Usage

Compile the program with:

```bash
ifort main.f90
```

The entry point is [`main.f90`](./main.f90). At runtime, the program reads the input parameters

```text
Lx, Nsamp, pb, Seed, NBlck
```

from standard input.

The output includes:

- a set of measured observables, defined in [`Meas/measure.f90`](./Meas/measure.f90)
- the timing file `time.dat`, which records the program runtime

## Important Files

- [`Simu/site.f90`](./Simu/site.f90): defines the key arrays used by the algorithm, as well as the `Site` and `Cluster` data structures that store rigid-cluster information and their related operations
- [`Simu/pebble.f90`](./Simu/pebble.f90): contains core parts of the pebble game implementation
- [`Simu/gather_pebble.f90`](./Simu/gather_pebble.f90): includes `find_rigid_site_Va_Vb`, which is the main routine for efficiently identifying rigid clusters

## Reference

The algorithmic principles and implementation details are described in:

- Mingzhong Lu, Yufeng Song, Qiyuan Shi, Ming Li, and Youjin Deng, *High-precision Dynamic Monte Carlo Study of Rigidity Percolation*, arXiv:2601.21399
- PDF: <https://arxiv.org/pdf/2601.21399>

## License

Author: Mingzhong Lu

If you use this code in your research, please cite the corresponding arXiv article above.
