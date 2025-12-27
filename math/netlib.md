# Modern Netlib

- [Netlib Master Index](https://www.netlib.org/master/expanded_liblist.html)
- [Freely Available Software for Linear Algebra (August 2021)](https://docs.google.com/spreadsheets/d/11ESR3uucNvVKEoIcalP9gR7ApaOElLwmE5sAS-VRMOM/edit?gid=90156307#gid=90156307)

## TODO

- [Build]: `fn`, `vfnlib`; amos, specfun; cephes
- [wrap] slatec
  - `slatec/fn -> fn`

## A

- a: algorithms for numerical approximation
  - `a/sf/bessfin.f90`
- access: netlib access tools, such as unshar
  - `webget`: Use `wget`, `curl`
  - `unshar`: unpacking shell archives from netlib
  - `stree`: C source for Unix programs that collapse (restore) file trees into (from) a single file
- aicm: selected material from Advances in Computational Mathematics
  - `aicm/smmp`: sparse matrix multiply, transpose, format conversion.
    https://github.com/ivan-pi/SMMP
- alliant: programs collected from Alliant users
- `amos`: Bessel functions of complex argument and nonnegative order
  - https://github.com/scipy/xsf
- `ampl`: linear and nonlinear programming, https://ampl.com/
- anl-reports: Reports from the MCS division at Argonne
- apollo: programs collected from Apollo users
- `arpack`: large-scale eigenvalue problems
  - https://github.com/opencollab/arpack-ng
  - https://github.com/m-reuter/arpackpp
  - (ARPACK in C)   https://github.com/scipy/scipy/tree/main/scipy/sparse/linalg/_eigen/arpack
- `atlas`: Autmatically Tuned Linear Algebra Subroutines
  - https://math-atlas.sourceforge.net/
  - https://github.com/math-atlas/math-atlas

## B

- benchmark: contains benchmark programs and the table of Linpack timings.
- bib: bibliographies
- bibnet: BibNet -- Netlib Bibliography Project
- `bihar`: biharmonic equation in rectangular geometry and polar coordinates
- `blacs`: Basic Linear Algebra Communication Subprograms
  - https://github.com/Reference-ScaLAPACK/scalapack  
    the BLACS are used as the communication layer of ScaLAPACK
- `blas`:
  - C++ API: https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2023/p1673r13.html
  - https://github.com/OpenMathLib/OpenBLAS
  - https://github.com/flame/blis
- blast: Communications of the BLAST mailing lists
- `bmp` (`MP`), Brent's multiple-precision arithmetic package.  
    [In general, we recommend the use of a more modern package](https://maths-people.anu.edu.au/~brent/pub/pub043.html),
  - [MPFR](https://www.mpfr.org/)
  - [MPFUN](https://www.davidhbailey.com/dhbsoftware/) by David H. Bailey

## C

- c: miscellaneous codes written in C
- c++: miscellaneous codes in C++
- `cephes`: special functions and IEEE floating point arithmetic
  - https://github.com/scipy/xsf
- `chammp`: DOE Computer Hardware, Advanced Mathematics and Model Physics program
- cheney-kincaid: Ward Cheney & David Kincaid, Numerical Mathematics and Computing, 2nd ed., 1985.
- `clapack`: C version of LAPACK
- commercial: advertising material for commercial math software
- confdb: conferences database
- conformal: the "parameter problem" associated with conformal mapping
- contin: continuation and limit points
- control: generation of examples of continuous-time algebraic Riccati equations
- crc: checksums for netlib files
- cumulvs: Collaborative User Migration User Library for Visualization and Steering

## D

- `ddsv`: Linear Algebra Computations on Vector and Parallel Computers
- dierckx (`FITPACK`): spline fitting routines for various kinds of data and geometries
  - https://github.com/perazz/fitpack
  - (Rewrite in C) [scipy/interpolate/src/dfitpack.h](https://github.com/scipy/scipy/blob/d92f54e6f606d43e5ceeb9a4dd3f157288883bb6/scipy/interpolate/src/dfitpack.h)
- `diffpack`: removed;  Diffpack is now a commercial package
- `domino`: multiple tasks to communicate and schedule local tasks for execution

## E

- `eispack`: EISPACK has been superseded for the most part by `LAPACK`.
- `elefunt`: testing elementary function programs provided with Fortran compilers
- env: integrated problem solving environments
  - `Algae`: a programming language for numerical analysis.
    https://algae.sourceforge.net/
  - `mathomatic`: a portable, command-line, educational CAS and calculator software.
    https://github.com/mfillpot/mathomatic
  - `yorick`: an interactive programming language for scientific computing.
    https://github.com/LLNL/yorick
- etemplates: Electronic templates

## F

- `f2c`: converting Fortran to C
- `fdlibm`: C math library for machines that support IEEE 754 floating-point
  - https://github.com/freemint/fdlibm
  - https://github.com/JuliaMath/openlibm
- `fftpack`:
  - https://github.com/fortran-lang/fftpack
- `fishpack`: finite differences for elliptic boundary value problems
  - https://github.com/jlokimlin/fishpack
  - https://github.com/jlokimlin/fishpack90
- `fitpack`: splines under tension, By Alan K. Cline
- `floppy`: fortan code syntax and flow control checker
  - [PlasmaFAIR/fortitude: A Fortran linter, written in Rust and installable with Python.](https://github.com/PlasmaFAIR/fortitude)
  - [cphyc/fortran-linter: A simple fortran syntax checker, including automatic fixing of the code.](https://github.com/cphyc/fortran-linter)
- `fmm`: (Book) Computer Methods for Mathematical Computations
- `fn` (fnlib): special functions
- fortran: tools specific to Fortran
- fortran-m: small set of extensions to f77 that supports modular message-passing
- fp: floating point arithmetic

## G

- gcv
- gmat
- gnu
- go
- graphics

## H
  
- harwell: 404
- hence
- `hompack`: The latest version of this package is HOMPACK90, in netlib at TOMS 777.
- hpf
- hypercube
- ieeecss

## I

- ijsa: International Journal of Supercomputer Applications
- image: image processing
- intercom: Interprocessor Collective Communications (InterCom) Library
- `itpack`: Iterative Linear System Solvers

## J

- jakef: automatic differentiation
- java: miscellaneous codes written in java

## K

- kincaid-cheney

## L

- lanczos: a few eigenvalues/eigenvectors of a large (sparse) symmetric matrix
- la-net: SIAG/LA news and conference arrangements
- lanz: Large Sparse Symmetric Generalized Eigenproblem
- `lapack`:     https://github.com/Reference-LAPACK/lapack
  - `lapack++`:   https://github.com/icl-utk-edu/lapackpp
  - `lapack3e`
  - `lapack90`:   404
- laso: a few eigenvalues/eigenvectors of a large (sparse) symmetric matrix
- lawson-hanson: least squares
- linalg: various functions complementing the bigger linear algebra libraries
- `linpack`: LINPACK has been largely superceded by LAPACK
- list: various databases searched by netlib's "find" and "who is" commands.
- lp: linear programming test problems
- lyapack: Riccati and Lyapunov eqations, optimal control

## M

- machines
- magic
- maspar
- math77
- mds
- microscope
- `minpack`:
  - https://github.com/fortran-lang/minpack
  - (Rewrite in C)  [scipy/optimize/src/minpack.h](https://github.com/scipy/scipy/blob/d92f54e6f606d43e5ceeb9a4dd3f157288883bb6/scipy/optimize/src/minpack.h)
- misc
- mpfun: multiple precision arithmetic
- mpi: message passing interface draft standard.
  - https://github.com/open-mpi/ompi
- mpicl

## N

- na-digest-html
- napack
- netsolve
- news: netlib column for SIAM News
- `numeralgo`: algorithms from the new journal "Numerical Algorithms"
  - https://link.springer.com/journal/11075

## O

- `ode`
- `odepack`: ODE package
  (LSODE, LSODES, LSODA, LSODAR, LSODPK, LSODKR, LSODI, LSOIBT, LSODIS)
  - https://github.com/Nicholaswogan/odepack
  - https://github.com/jacobwilliams/odepack
  - (LSODA in C) [scipy/integrate/src/lsoda.h](https://github.com/scipy/scipy/blob/f77b58ae6f30e2249c5702d9879ede1c3cc503f4/scipy/integrate/src/lsoda.h)
- `odrpack`: Orthogonal Distance Regression
  - https://github.com/HugoMVale/odrpack95
- opt: nonlinear optimization and zero-finding

## P

- p4
paragraph
paranoia
parkbench
parmacs
pascal
pdes
performance
photo
picl
pltmg
poly2
polyhedra
popi
port
posix
pppack
presto
problem-set
pvm3

## Q

- `quadpack`: definite univariate integrals
  - https://github.com/jacobwilliams/quadpack
  - (Rewrite in C) [scipy/integrate/__quadpack.h](https://github.com/scipy/scipy/blob/v1.17.0rc1/scipy/integrate/__quadpack.h)

## R

- random: random number generators
- research: small tools from Computing Science Research, Bell Labs
- rib: software package for creating WWW metadat repositories

## S

- `scalapack`: MIMD distributed memory computers for some of the lapack routines
  - https://github.com/Reference-ScaLAPACK/scalapack
  - https://github.com/amd/aocl-scalapack
  - https://github.com/dftbplus/scalapackfx
- sched: the Schedule package
- `scilib`: a portable FORTRAN emulation of CRAY SCILIB
- `seispack`: a collection of single-precision Fortran subroutines that compute the eigenvalues and eigenvectors of matrices
  The double-precision versions are in `eispack`.
  `EISPACK` has been superseded for the most part by `LAPACK`.
- sequent
- `sfmm`: (Book) Computer Methods for Mathematical Computations
- `slap`: Sparse Linear Algebra
  - https://github.com/DrTimothyAldenDavis/SuiteSparse
  - https://github.com/SparseLinearAlgebra/spla
- `slatec`: SLATEC Common Mathematical Library
  - https://github.com/MehdiChinoune/SLATEC
  - https://github.com/Zaneham/SLATEC
- sminpack
- `sodepack`: move to `netlib/odepack`
- sparse
- sparse-blas
- sparspak: 404, withdrawn by authors' request
- `specfun`:
  - https://github.com/jacobwilliams/specfun
  - (Rewrite in C) https://github.com/scipy/xsf
- spin
- srwn
- stoeplitz
- stringsearch
- svdpack

## T

- templates
- tennessee
- textbook
  - `textbook/mathews`: Numerical Methods for Math. Sci. & Eng., 2nd ed., 1992
- toeplitz
- toms: Collected Algorithms of the ACM, https://calgo.acm.org/
- tomspdf: https://dl.acm.org/journal/toms
- transform
- typesetting

## U

- uncon: unconstrained optimization

## V

- `vanhuffel`: total least squares, Partial Singular Value Decomposition
  - https://github.com/ivan-pi/vanhuffel
- `vfftpack`: a vectorized version of fftpack, for multiple sequences.
  - https://github.com/dmey/vfftpack-cmake
- `vfnlib`: vectorized evaluation of special functions
- `voronoi`: Voronoi regions and Delaunay triangulations

## X

- `xblas`: Extra Precise Basic Linear Algebra Subroutines
- `xmagic`: X windows front-end to [MaGIC](https://gjclokhorst.nl/magic.html)
  (Matrix Generator for Implication Connectives)
  - https://github.com/arranstewart/magic
- `xnetlib`: 404, Distribution of Xnetlib has been discontinued.

## Y

- `y12m`: solves sparse systems of linear algebraic equations by Gaussian elimination.
  - https://github.com/ivan-pi/y12m
