# Dynamic Pebble Game Algorithm for Rigidity Percolation on the Triangular Lattice

This repository contains a Fortran implementation of the dynamic pebble game algorithm for rigidity percolation on the triangular lattice.
It also includes the processed figure data and plotting scripts used for the associated article.

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

These parameters specify:

- `Lx`: system size
- `Nsamp`: number of samples in each block
- `pb`: bond density up to which bonds are added
- `Seed`: initial random seed
- `NBlck`: number of blocks

The output includes:

- a set of measured observables, defined in [`Meas/measure.f90`](./Meas/measure.f90)
- the timing file `time.dat`, which records the program runtime

## Important Files

- [`Simu/site.f90`](./Simu/site.f90): contains the important `Site` and `Cluster` arrays, which store rigid-cluster information, and includes the routines for constructing and updating them
- [`Simu/pebble.f90`](./Simu/pebble.f90): contains core parts of the pebble game implementation
- [`Simu/gather_pebble.f90`](./Simu/gather_pebble.f90): includes `find_rigid_site_Va_Vb`, which is the main routine for efficiently identifying rigid clusters

## Figure Data

The directory [`data/figures`](./data/figures) contains the raw data files and plotting scripts for the data-based figures in the article. The subdirectories follow the figure order in the manuscript (`Fig02`, `Fig03`, `Fig05`, ...). Schematic-only figures are omitted because they do not require numerical data.

Each figure directory contains:

- `raw_data/`: data files used by the figure
- `plot.plt` or `plot_gnuplot.plt`: gnuplot script for reproducing the figure

See [`data/figures/README.md`](./data/figures/README.md) for the mapping between figure numbers, manuscript figure files, plotting scripts, and data files.

## Reference

The algorithmic background and implementation details are described in:

- Mingzhong Lu, Yufeng Song, Qiyuan Shi, Ming Li, and Youjin Deng, *Dynamic Monte Carlo Study of Rigidity Percolation using an Event-Based Ensemble Approach*, <https://doi.org/10.1103/cbxz-hws6>

## License

Author: Mingzhong Lu.

If you encounter any problems in the code or have questions about the implementation, please feel free to contact the authors. If you use this code or the figure data in your research, please cite: Mingzhong Lu, Yufeng Song, Qiyuan Shi, Ming Li, and Youjin Deng, *Dynamic Monte Carlo Study of Rigidity Percolation using an Event-Based Ensemble Approach*, <https://doi.org/10.1103/cbxz-hws6>.
