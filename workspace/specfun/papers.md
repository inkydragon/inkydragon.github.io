# Implementations

- Gamma Functions
- Exponential Integrals
- Error Functions
- Airy Functions
- Bessel Functions
- Struve Functions
- Parabolic Cylinders
- Hypergeometric Functions
- Legendre Functions
- Q Functions
- Orthogonal Polynomials
- Elliptic Functions
- Bernoulli and Euler Polynomials
- Zeta Functions
- Combinatorial Analysis
- Number Theory Functions
- Mathieu Functions
- Spheroidal Wave Functions
- Heun Functions
- Coulomb Functions

## TODO

AMOS

- Amos1983-SAND83-0086
- Amos1983-SAND83-0643
- Amos1985-SAND85-1018
  https://www.osti.gov/biblio/5249727
- Amos1986-Algo644
  https://dl.acm.org/doi/10.1145/7921.214331
- NESF2000-Ver2


## GammaFunctions

[DLMF: Chapter 5 Gamma Function](https://dlmf.nist.gov/5)
[DLMF: Chapter 8 Incomplete Gamma and Related Functions](https://dlmf.nist.gov/8)


## ExponentialIntegrals

[DLMF: Chapter 6 Exponential, Logarithmic, Sine, and Cosine Integrals](https://dlmf.nist.gov/6)

- Exponential Integral:  `E₁(z)`, `Eν(z)`, `Ei(x)`; `Li(x)`
- Trigonometric Integral:  Si, Ci, Shi, Chi

## Error Functions

- Zaghloul, M. R. (2019).
  Remark on “Algorithm 680: evaluation of the complex error function”:
    cause and remedy for the loss of accuracy near the real axis.
  ACM Transactions on Mathematical Software (TOMS), 45(2), 1-3.
- Zaghloul, M. R. (2017).
  Algorithm 985: Simple, efficient, and relatively accurate approximation for the evaluation of the Faddeyeva function.
  ACM Transactions on Mathematical Software (TOMS), 44(2), 1-9.
- Zaghloul, M. R. (2016).
  Remark on “Algorithm 916: Computing the Faddeyeva and Voigt Functions”
    Efficiency Improvements and Fortran Translation.
  ACM Transactions on Mathematical Software (TOMS), 42(3), 1-9.
- Zaghloul, M. R., & Ali, A. N. (2012).
  Algorithm 916: computing the Faddeyeva and Voigt functions.
  ACM Transactions on Mathematical Software (TOMS), 38(2), 1-22.
- Poppe, G. P., & Wijers, C. M. (1990).
  Algorithm 680: More efficient computation of the complex error function.
  ACM Transactions on Mathematical Software (TOMS), 16(1), 38-46.
- Gautschi, W. (1970).
  Efficient computation of the complex error function.
  SIAM Journal on Numerical Analysis, 7(1), 187-198.

## AiryFunctions

[DLMF: Chapter 9 Airy and Related Functions](https://dlmf.nist.gov/9)

- Airy Function:  Ai, Bi, Ai', Bi'
- Zeros of Airy Function:  Ai_zeros, Bi_zeros
- Integral of Airy Function:  Ai_int, Bi_int
- Scorer Function:  Gi, Hi, Gi', Hi'

## Bessel Functions

[DLMF: Chapter 10 Bessel Functions](https://dlmf.nist.gov/10)

Use [JuliaMath/Bessels: Bessel functions for real arguments and orders](https://github.com/JuliaMath/Bessels/)

- Bessel Function:  Jν(x), Yν(x)
- Modified Bessel Function:  Iν​(x), Kν​(x)
- Hankel Function:  Hkν​(z), H1v(z) , H2v(z)
- Spherical Bessel Function:  jν(x), yν(x), iν(x), kν(x)
- Kelvin Function:  kelvin(x), kelvin_zeros(nt); ber(x), bei(x), ker(x), kei(x)

## StruveFunctions

[DLMF: Chapter 11 Struve and Related Functions](https://dlmf.nist.gov/11)

- Struve Function:  Hν(z), Lν(z); integral of ...
- Lommel Function:  sμν(z), Sμν(z)
- Anger and Weber Function:  Jν(z), Eν(z), Aν(z)

See also:

- (Obsolete? last update 2022) [gwater/Struve](https://github.com/gwater/Struve)

## ParabolicCylinders

[DLMF: Chapter 12 Parabolic Cylinder Functions](https://dlmf.nist.gov/12)

- Dν(z), V(a, z), U(a, z)
- DLMF 12.14:  W(a, z)

See also:

- [MartinMikkelsen/FewSpecialFunctions](https://github.com/MartinMikkelsen/FewSpecialFunctions)

## HypergeometricFunctions

[DLMF: Chapter 13 Confluent Hypergeometric Functions](https://dlmf.nist.gov/13)
[DLMF: Chapter 15 Hypergeometric Function](https://dlmf.nist.gov/15)
[DLMF: Chapter 16 Generalized Hypergeometric Functions and Meijer 𝐺-Function](https://dlmf.nist.gov/16)

Use [JuliaMath/HypergeometricFunctions: A Julia package for calculating hypergeometric functions](https://github.com/JuliaMath/HypergeometricFunctions)

- Hypergeometric Function:  ₂F₁(a,b,c,x)
- Confluent Hypergeometric Function:  ₀F₁(a,z), ₁F₁(a,b,z), U(a,b,x), M(a,b,x)
- Kummer Functions:  `₁F₁(a,b,z)`; `M(a,b,x)` (Olver’s confluent hypergeometric function); `U(a,b,z)`
- Whittaker Functions:  Mκμ(z), Wκμ(z)
- Generalized Hypergeometric Function:  pFq(A, B, z); MeijerG

## LegendreFunctions

[DLMF: Chapter 14 Legendre and Related Functions](https://dlmf.nist.gov/14)

- Legendre functions:  Pn(z), Qn(z)
- Associated Legendre Function:  Pmn(z), Qmn(z)

See also:

- [jishnub/LegendrePolynomials](https://github.com/jishnub/LegendrePolynomials)
- [jmert/AssociatedLegendrePolynomials](https://github.com/jmert/AssociatedLegendrePolynomials)

## QFunctions

[DLMF: Chapter 17 𝑞-Hypergeometric and Related Functions](https://dlmf.nist.gov/17)

- TODO

## OrthogonalPolynomials

[DLMF: Chapter 18 Orthogonal Polynomials](https://dlmf.nist.gov/18)

- Jacobi polynomials
- Gegenbauer polynomials (Ultraspherical)
- Chebyshev polynomials
- Legendre polynomials
- Laguerre polynomials
- Hermite polynomials
- Bessel polynomials
- classical discrete orthogonal polynomials
  - Hahn
  - Krawtchouk
  - Meixner
  - Charlier
- Other Orthogonal Polynomials

See also:

- [jverzani/SpecialPolynomials](https://jverzani.github.io/SpecialPolynomials/dev/#Implemented-polynomial-types)
- [JuliaApproximation/ClassicalOrthogonalPolynomials](https://juliaapproximation.github.io/ClassicalOrthogonalPolynomials/stable/)
- [sciml/PolyChaos](https://docs.sciml.ai/PolyChaos/stable/functions/)

## EllipticFunctions

[DLMF: Chapter 19 Elliptic Integrals](https://dlmf.nist.gov/19)
[DLMF: Chapter 20 Theta Functions](https://dlmf.nist.gov/20)
[DLMF: Chapter 22 Jacobian Elliptic Functions](https://dlmf.nist.gov/22)
[DLMF: Chapter 23 Weierstrass Elliptic and Modular Functions](https://dlmf.nist.gov/23)

- Legendre Integral:  K(m), E(m), Π(u, m); F(Φ, m), E(Φ, m), Π(Φ, u, m)
- Symmetric Integral:  RF(x, y, z), RG(x, y, z), RJ(x, y, z, p), RD(x, y, z), RC(x, y)
- Theta Functions:  θ(n, z, q)
- Jacobian Elliptic Functions:  sn(z, k), cn(z, k), dn(z, k)
- Weierstrass Elliptic Functions:  WeierstrassP(z), WeierstrassZeta(z), WeierstrassSigma(x)

See also:

- [EllipticFunctions documentation · EllipticFunctions](https://stla.github.io/EllipticFunctions/)
- [JacobiElliptic API · JacobiElliptic](https://dominic-chang.com/JacobiElliptic/stable/api/) for Jacobian Elliptic Functions
- (Obsolete, last update 2020) [nolta/Elliptic: Elliptic integral and Jacobi elliptic special functions](https://github.com/nolta/Elliptic)

## Bernoulli and Euler Polynomials

[DLMF: Chapter 24 Bernoulli and Euler Polynomials](https://dlmf.nist.gov/24)

- Bernoulli Numbers and Polynomials:  B(n), Bn(x)
- Euler Numbers and Polynomials:  En, En(x)

## ZetaFunctions

[DLMF: Chapter 25 Zeta and Related Functions](https://dlmf.nist.gov/25)

- Riemann Zeta Function: ζ(s), ζ(s, a)
- Dilogarithm:  `Li₂(z)` (dilogarithm), `Liₛ(z)` (polylogarithm)
- Lerch’s Transcendent:  Φ(z, s, a)
- Dirichlet L-function:  `L(s, χ)`; `η(s)` (Dirichlet eta function)

See also:

- Polylogarithm
  - [Expander/PolyLog: Implementation of polylogarithms in Julia](https://github.com/Expander/PolyLog)
  - [mroughan/Polylogarithms: Polylogarithm function and related special functions and sequences.](https://github.com/mroughan/Polylogarithms)

## Combinatorial Analysis

[DLMF: Chapter 26 Combinatorial Analysis](https://dlmf.nist.gov/26)

Use [JuliaMath/Combinatorics: A combinatorics library for Julia](https://github.com/JuliaMath/Combinatorics)

## NumberTheoryFunctions

## Mathieu Functions


## Spheroidal Wave Functions
