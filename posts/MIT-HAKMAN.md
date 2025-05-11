---
title: MIT HAKMAN
date: 2017-05-01 12:19:37
categories:
  - Books
  - MIT HAKMAN
tags:
description:
  神书，我把其中的公式用LaTeX整理了一下.  
  目前来看，这本书内容也不少，放在blog里不太合适，准备开一本gitbook
---
MIT 人工智能实验室的 memo

<!-- truncate -->
``` plain Title
                            MASSACHUSETTS INSTITUTE OF TECHNOLOGY

​                              ARTIFICIAL INTELLIGENCE LABORATORY

AIM 239                                                                       February 1972
```
# HAKMEM

by ：

- M. Beeler [beeler@bbn.com]
- R. W. Gosper [rwg@newton.macsyma.com]
- [R. Schroeppel](http://www.cs.arizona.edu/xkernel/www/people/rich.html) [rcs@cs.arizona.edu]

This report describes research done at the Artificial Intelligence Laboratory of the Massachusetts Institute of Technology. Support for the Laboratory's artificial intelligence research is provided in part by the [Advanced Research Projects Agency](http://www.arpa.mil/) of the Department of Defense under Office of Naval Research contract N00014-70-A-0362-0002.

------

## **Page 1**

Compiled with the hope that a record of the random things people do around here can save some duplication of effort -- except for fun.

Here is some little known data which may be of interest to computer hackers. The items and examples are so sketchy that to decipher them may require more sincerity and curiosity than a non-hacker can muster. Doubtless, little of this is new, but nowadays it's hard to tell. So we must be content to give you an insight, or save you some cycles, and to welcome further contributions of items, new or used.

The classification of items into sections is even more illogical than necessary. This is because later elaborations tend to shift perspective on many items, and this elaboration will (hopefully) continue after publication, since this text is retained in "machinable" form. We forgive in advance anyone deterred by this wretched typography.

People referred to are
from the A. I. Lab:

``` plain Mail List
Marvin Minsky        [minsky@ai.mit.edu]
Bill Gosper          [rwg@newton.macsyma.com]
Michael Beeler       [beeler@bbn.com]
John Roe
Richard Stallman     [rms@ai.mit.edu]
Jerry Freiberg
Rich Schroeppel      [rcs@cs.arizona.edu]
Michael Speciner     [ms@color_age.com]
Gerald Sussman       [gjs@ai.mit.edu]
Joe Cohen
David Waltz
David Silver
```

Once at the A. I. Lab but now elsewhere:

``` plain Mail List
Jan Kok                  William Henneman
Rici Liknaitzky          George Mitchell
Peter Samson             Stuart Nelson
Roger Banks              Rollo Silver
Mike Paterson            [Mike.Paterson@dcs.warwick.ac.uk]
```

at [Digital Equipment Corporation:](http://www.digital.com/)

``` plain Mail List
Jud Leonard              [leonard@tlw.com]
Dave Plumer              
Ben Gurley (deceased)
Steve Root
```

elsewhere at M.I.T.:

``` plain Mail List
Gene Salamin             [Gene_Salamin@cohr.com]
PDP-1 hackers
Eric Jensen              
Frances Yao
Edward Fredkin           
```

once at M.I.T., but now elsewhere:

``` plain Mail List
Jackson Wright           Steve Brown
Malcolm Rayfield
```

in France:

``` plain Mail List
Marco Schutzenberger     Henry Cohen
```

at Computer Corporation of America: 

``` plain Mail List
Bill Mann
```

at [BBN:](http://www.bbn.com/)

``` plain Mail List
Robert Clements
```

----

## **Page 2**

CAVEATS:

Some of this material is very inside -- many readers will have to excuse cryptic references.

The label "PROBLEM" does not always mean exercise; if no solution is given, it means we couldn't solve it. If you solve a problem in here, let us know.

Unless otherwise stated, all computer programs are in [PDP-6/10](http://home.pipeline.com/~hbaker1/pdp-10/pdp-10.html) assembly language.

# CONTENTS, HAKMEM 140

## P3 - [Geometry, Algebra, Calculus](http://home.pipeline.com/~hbaker1/hakmem/geometry.html)
  - [Item 1](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item1) Fractional factorials
  - [Item 2](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item2) N-gon diagonals
  - [Item 3](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item3) Convergence of Newton's square roots
  - [Item 4](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item4) Quartic discriminant
  - [Item 5](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item5) General discriminant
  - [Item 6](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item6) Symmetric functions
  - [Item 7](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item7) Symmetric functions
  - [Item 8](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item8) Cubic solution
  - [Item 9](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item9) Quartic solution
  - [Item 10](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item10) Trigonometric cubic solution
  - [Item 11](http://home.pipeline.com/~hbaker1/hakmem/geometry.html#item11) Conformal mappings of N-space


## P6 - [Recurrence Relations](http://home.pipeline.com/~hbaker1/hakmem/recurrence.html)
  - [Item 12](http://home.pipeline.com/~hbaker1/hakmem/recurrence.html#item12) Fast Fibonacci Transform
  - [Item 13](http://home.pipeline.com/~hbaker1/hakmem/recurrence.html#item13) Linear Recurrence Relations
  - [Item 14](http://home.pipeline.com/~hbaker1/hakmem/recurrence.html#item14) Rapid Recurrences
  - [Item 15](http://home.pipeline.com/~hbaker1/hakmem/recurrence.html#item15) Chebychev polynomials
  - [Item 16](http://home.pipeline.com/~hbaker1/hakmem/recurrence.html#item16) Tangents and arctangents
## P10 - [Boolean Algebra](http://home.pipeline.com/~hbaker1/hakmem/boolean.html)
  - [Item 17](http://home.pipeline.com/~hbaker1/hakmem/boolean.html#item17) Minimize AND's
  - [Item 18](http://home.pipeline.com/~hbaker1/hakmem/boolean.html#item18) Count monotonic Boolean functions
  - [Item 19](http://home.pipeline.com/~hbaker1/hakmem/boolean.html#item19) 2-NOT's
  - [Item 20](http://home.pipeline.com/~hbaker1/hakmem/boolean.html#item20) Venn Diagrams
  - [Item 21](http://home.pipeline.com/~hbaker1/hakmem/boolean.html#item21) Cover character raster
  - [Item 22](http://home.pipeline.com/~hbaker1/hakmem/boolean.html#item22) Binary masks
  - [Item 23](http://home.pipeline.com/~hbaker1/hakmem/boolean.html#item23) Plus and XOR
  - [Item 24](http://home.pipeline.com/~hbaker1/hakmem/boolean.html#item24) Venn Diagrams
## P12 - [Random Numbers](http://home.pipeline.com/~hbaker1/hakmem/random.html)
  - [Item 25](http://home.pipeline.com/~hbaker1/hakmem/random.html#item25) Random number generators
  - [Item 26](http://home.pipeline.com/~hbaker1/hakmem/random.html#item26) Gaussian distribution
  - [Item 27](http://home.pipeline.com/~hbaker1/hakmem/random.html#item27) Random unit vectors in N-space
## P13 - [Number Theory, Primes, Probability](http://home.pipeline.com/~hbaker1/hakmem/number.html)
  - [Item 28](http://home.pipeline.com/~hbaker1/hakmem/number.html#item28) Mersenne 125 is composite
  - [Item 29](http://home.pipeline.com/~hbaker1/hakmem/number.html#item29) Probability of largest prime factor
  - [Item 30](http://home.pipeline.com/~hbaker1/hakmem/number.html#item30) Twin Primes
  - [Item 31](http://home.pipeline.com/~hbaker1/hakmem/number.html#item31) A Ramanujan problem
  - [Item 32](http://home.pipeline.com/~hbaker1/hakmem/number.html#item32) Distribution of fractions
  - [Item 33](http://home.pipeline.com/~hbaker1/hakmem/number.html#item33) Russian doll primes
  - [Item 34](http://home.pipeline.com/~hbaker1/hakmem/number.html#item34) Factorial and integer square root
  - [Item 35](http://home.pipeline.com/~hbaker1/hakmem/number.html#item35) Arithmetic progressions
  - [Item 36](http://home.pipeline.com/~hbaker1/hakmem/number.html#item36) Squares with no zero digits
  - [Item 37](http://home.pipeline.com/~hbaker1/hakmem/number.html#item37) Numbers with each digit
  - [Item 38](http://home.pipeline.com/~hbaker1/hakmem/number.html#item38) Forward differences
  - [Item 39](http://home.pipeline.com/~hbaker1/hakmem/number.html#item39) Sequences of digits
  - [Item 40](http://home.pipeline.com/~hbaker1/hakmem/number.html#item40) Variance of a sum
  - [Item 41](http://home.pipeline.com/~hbaker1/hakmem/number.html#item41) Number of primes less than 2^18
  - [Item 42](http://home.pipeline.com/~hbaker1/hakmem/number.html#item42) Probability of PingPong winner
  - [Item 43](http://home.pipeline.com/~hbaker1/hakmem/number.html#item43) Multinomial coefficients
  - [Item 44](http://home.pipeline.com/~hbaker1/hakmem/number.html#item44) Recurrences for multinomial coefficients
  - [Item 45](http://home.pipeline.com/~hbaker1/hakmem/number.html#item45) Locus of steps
  - [Item 46](http://home.pipeline.com/~hbaker1/hakmem/number.html#item46) Distribution of bridge hands
  - [Item 47](http://home.pipeline.com/~hbaker1/hakmem/number.html#item47) Fibonacci series mod P
  - [Item 48](http://home.pipeline.com/~hbaker1/hakmem/number.html#item48) Visibility on 2D lattice
  - [Item 49](http://home.pipeline.com/~hbaker1/hakmem/number.html#item49) Magic hexagon
  - [Item 50](http://home.pipeline.com/~hbaker1/hakmem/number.html#item50) No magic cubes of order 4
  - [Item 51](http://home.pipeline.com/~hbaker1/hakmem/number.html#item51) No magic tesseract of order 5
  - [Item 52](http://home.pipeline.com/~hbaker1/hakmem/number.html#item52) Relatively prime probability
  - [Item 53](http://home.pipeline.com/~hbaker1/hakmem/number.html#item53) Lack of common divisors
  - [Item 54](http://home.pipeline.com/~hbaker1/hakmem/number.html#item54) Probability of even denominators
  - [Item 55](http://home.pipeline.com/~hbaker1/hakmem/number.html#item55) Gaussian integers
  - [Item 56](http://home.pipeline.com/~hbaker1/hakmem/number.html#item56) "Length" of a number
  - [Item 57](http://home.pipeline.com/~hbaker1/hakmem/number.html#item57) Zero digits in powers of two
  - [Item 58](http://home.pipeline.com/~hbaker1/hakmem/number.html#item58) Sum of cubes
  - [Item 59](http://home.pipeline.com/~hbaker1/hakmem/number.html#item59) Interesting square
  - [Item 60](http://home.pipeline.com/~hbaker1/hakmem/number.html#item60) Perfect numbers
  - [Item 61](http://home.pipeline.com/~hbaker1/hakmem/number.html#item61) Amicable pairs
  - [Item 62](http://home.pipeline.com/~hbaker1/hakmem/number.html#item62) Amicable pairs
  - [Item 63](http://home.pipeline.com/~hbaker1/hakmem/number.html#item63) Joys of 239
## P25 - [Automata Theory](http://home.pipeline.com/~hbaker1/hakmem/automata.html)
  - [Item 64](http://home.pipeline.com/~hbaker1/hakmem/automata.html#item64) 2-counter machines
  - [Item 65](http://home.pipeline.com/~hbaker1/hakmem/automata.html#item65) Complexity of pi(X)
  - [Item 66](http://home.pipeline.com/~hbaker1/hakmem/automata.html#item66) Space-filling curves
## P26 - [Games](http://home.pipeline.com/~hbaker1/hakmem/games.html)
  - [Item 67](http://home.pipeline.com/~hbaker1/hakmem/games.html#item67) "Poker coins"
  - [Item 68](http://home.pipeline.com/~hbaker1/hakmem/games.html#item68) *Blackout*
  - [Item 69](http://home.pipeline.com/~hbaker1/hakmem/games.html#item69) *Dots*
  - [Item 70](http://home.pipeline.com/~hbaker1/hakmem/games.html#item70) Chess problem
  - [Item 71](http://home.pipeline.com/~hbaker1/hakmem/games.html#item71) *Instant Insanity*
  - [Item 72](http://home.pipeline.com/~hbaker1/hakmem/games.html#item72) *Window-dice*
  - [Item 73](http://home.pipeline.com/~hbaker1/hakmem/games.html#item73) *Sim*
  - [Item 74](http://home.pipeline.com/~hbaker1/hakmem/games.html#item74) *Tactix*
  - [Item 75](http://home.pipeline.com/~hbaker1/hakmem/games.html#item75) *Peg solitaire*
  - [Item 76](http://home.pipeline.com/~hbaker1/hakmem/games.html#item76) *Hi-Q*
## P30 - [Proposed Computer Programs](http://home.pipeline.com/~hbaker1/hakmem/proposed.html)
## - [Problem 77](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item77) Counting polyominos
  - [Problem 78](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item78) Solve *minichess*
  - [Problem 79](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item79) Solve the *tiger puzzle*
  - [Problem 80](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item80) Find smallest *squared square*
  - [Problem 81](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item81) Counting *magic squares*
  - [Problem 82](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item82) Counting semigroups
  - [Problem 83](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item83) Counting inscribed circles
  - [Problem 84](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item84) Solve pentominos
  - [Problem 85](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item85) Geometric dissections
  - [Problem 86](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item86) Domino coverings
  - [Problem 87](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item87) Analyze *giveaway chess*
  - [Problem 88](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item88) Analyze *escalation chess*
  - [Problem 89](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item89) Analyze "4 pawns"
  - [Problem 90](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item90) Solve Scarne's game *Teeko*
  - [Problem 91](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item91) Solve "five-in-a-row"
  - [Problem 92](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item92) Solve 4x4x4 *Tic-Tac-Toe*
  - [Problem 93](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item93) Solve *checkers*
  - [Problem 94](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item94) Solve *Hex*
  - [Problem 95](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item95) Solve *chess*
  - [Problem 96](http://home.pipeline.com/~hbaker1/hakmem/proposed.html#item96) Solve *Go*
## P36 - [Continued Fractions](http://home.pipeline.com/~hbaker1/hakmem/cf.html)
  - [Item 97](http://home.pipeline.com/~hbaker1/hakmem/cf.html#item97) Sqrt(2), Sqrt(3)
  - [Item 98](http://home.pipeline.com/~hbaker1/hakmem/cf.html#item98) Minimum of factorial function
  - [Item 99](http://home.pipeline.com/~hbaker1/hakmem/cf.html#item99) Partial quotients in arithmetic progression
  - [Item 100](http://home.pipeline.com/~hbaker1/hakmem/cf.html#item100) Product
  - [Item 101A](http://home.pipeline.com/~hbaker1/hakmem/cf.html#item101a) Continued fraction representation
  - [Item 101B](http://home.pipeline.com/~hbaker1/hakmem/cf.html#item101b) Continued fraction arithmetic
  - [Item 101C](http://home.pipeline.com/~hbaker1/hakmem/cf.html#item101c) Rationals in intervals
## P45 - [Group Theory](http://home.pipeline.com/~hbaker1/hakmem/group.html)
  - [Item 102](http://home.pipeline.com/~hbaker1/hakmem/group.html#item102) Group-like definitions
  - [Item 103](http://home.pipeline.com/~hbaker1/hakmem/group.html#item103) Hamiltonian paths
  - [Item 104](http://home.pipeline.com/~hbaker1/hakmem/group.html#item104) Permuting bits on PDP-6/10
## P45 - [Set Theory](http://home.pipeline.com/~hbaker1/hakmem/group.html#item105)
  - [Item 105](http://home.pipeline.com/~hbaker1/hakmem/group.html#item105) Closure and complement
## P46 - [Quaternions](http://home.pipeline.com/~hbaker1/hakmem/quaternions.html)
  - [Item 107](http://home.pipeline.com/~hbaker1/hakmem/quaternions.html#item107) Quaternions
## P48 - [Polyominos, etc.](http://home.pipeline.com/~hbaker1/hakmem/polyominos.html)
  - [Item 108](http://home.pipeline.com/~hbaker1/hakmem/polyominos.html#item108) Counting polyominos
  - [Item 109](http://home.pipeline.com/~hbaker1/hakmem/polyominos.html#item109) Tessellating the plane
  - [Item 110](http://home.pipeline.com/~hbaker1/hakmem/polyominos.html#item110) Covering rectangles
  - [Item 111](http://home.pipeline.com/~hbaker1/hakmem/polyominos.html#item111) Domino covering
  - [Item 112](http://home.pipeline.com/~hbaker1/hakmem/polyominos.html#item112) Polyiamonds
## P51 - [Topology](http://home.pipeline.com/~hbaker1/hakmem/topology.html)
  - [Item 113](http://home.pipeline.com/~hbaker1/hakmem/topology.html#item113)
  - [Item 114](http://home.pipeline.com/~hbaker1/hakmem/topology.html#item114)
  - [Item 115](http://home.pipeline.com/~hbaker1/hakmem/topology.html#item115)
## P54 - [Series](http://home.pipeline.com/~hbaker1/hakmem/series.html)
  - [Item 116](http://home.pipeline.com/~hbaker1/hakmem/series.html#item116)
  - [Item 117](http://home.pipeline.com/~hbaker1/hakmem/series.html#item117) Gamma
  - [Item 118](http://home.pipeline.com/~hbaker1/hakmem/series.html#item118) N^N
  - [Item 119](http://home.pipeline.com/~hbaker1/hakmem/series.html#item119) Pi series
  - [Item 120](http://home.pipeline.com/~hbaker1/hakmem/series.html#item120) Accelerating series
  - [Item 121](http://home.pipeline.com/~hbaker1/hakmem/series.html#item121) Bernoulli polynomials
  - [Item 122](http://home.pipeline.com/~hbaker1/hakmem/series.html#item122) Parity number
  - [Item 123](http://home.pipeline.com/~hbaker1/hakmem/series.html#item123) Fourier clocks
  - [Item 124](http://home.pipeline.com/~hbaker1/hakmem/series.html#item124)
  - [Item 125](http://home.pipeline.com/~hbaker1/hakmem/series.html#item125) Radius of convergence
## P61 - Flows and Iterated Functions
  - [Item 126](http://home.pipeline.com/~hbaker1/hakmem/flows.html#item126) Flow for Newton's square root
  - [Item 127](http://home.pipeline.com/~hbaker1/hakmem/flows.html#item127) Polynomial functions which commute
  - [Item 128](http://home.pipeline.com/~hbaker1/hakmem/flows.html#item128) Binary/negative binary radix flow
  - [Item 129](http://home.pipeline.com/~hbaker1/hakmem/flows.html#item129) Flow power series
  - [Item 130](http://home.pipeline.com/~hbaker1/hakmem/flows.html#item130) Flow power series
  - [Item 131](http://home.pipeline.com/~hbaker1/hakmem/flows.html#item131) Arithmetic geometric mean
  - [Item 132](http://home.pipeline.com/~hbaker1/hakmem/flows.html#item132) Loop detector
  - [Item 133](http://home.pipeline.com/~hbaker1/hakmem/flows.html#item133) 3 N + 1 problem
  - [Item 134](http://home.pipeline.com/~hbaker1/hakmem/flows.html#item134) Numbers to English words flow
  - [Item 135](http://home.pipeline.com/~hbaker1/hakmem/flows.html#item135) The "C" Curve
## P67 - [Pi](http://home.pipeline.com/~hbaker1/hakmem/pi.html)
  - [Item 136](http://home.pipeline.com/~hbaker1/hakmem/pi.html#item136) Gaussian integers
  - [Item 137](http://home.pipeline.com/~hbaker1/hakmem/pi.html#item137) Arctangent formulas for pi
  - [Item 138](http://home.pipeline.com/~hbaker1/hakmem/pi.html#item138) Arctangent formulas for pi
  - [Item 139](http://home.pipeline.com/~hbaker1/hakmem/pi.html#item139) Ramanujan formulas for pi
  - [Item 140](http://home.pipeline.com/~hbaker1/hakmem/pi.html#item140) Continued fraction for pi
  - [Item 141](http://home.pipeline.com/~hbaker1/hakmem/pi.html#item141) Pi digits
  - [Item 142](http://home.pipeline.com/~hbaker1/hakmem/pi.html#item142) Pi from fast trig functions
  - [Item 143](http://home.pipeline.com/~hbaker1/hakmem/pi.html#item143) AGM for elliptic integrals, log, and pi
  - [Item 144](http://home.pipeline.com/~hbaker1/hakmem/pi.html#item144) AGM for pi
## P72 - [Programming Hacks](http://home.pipeline.com/~hbaker1/hakmem/hacks.html)
  - [Item 145](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item145) Display/sound
  - [Item 146](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item146) Munching squares
  - [Item 147](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item147) Munching squares
  - [Item 148](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item148) Munching squares
  - [Item 149](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item149) Circle algorithm
  - [Item 150](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item150) Circle algorithm
  - [Item 151](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item151) Circle algorithm
  - [Item 152](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item152) Circle algorithm
  - [Item 153](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item153) 3D solids on 2D display
  - [Item 154](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item154) Twos-complement arithmetic
  - [Item 155](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item155) Subtract right from left
  - [Item 156](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item156) Make AOBJN pointer
  - [Item 157](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item157) Make AOBJN pointer
  - [Item 158](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item158) Recursive SIN/COS
  - [Item 159](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item159) Recursive SIN/COS
  - [Item 160](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item160) Log base 2
  - [Item 161](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item161) Swap two locations
  - [Item 162](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item162) Swap two bits
  - [Item 163](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item163) Exchange two Lisp variables
  - [Item 164](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item164) Max of byte pointers
  - [Item 165](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item165) Byte pointers
  - [Item 166](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item166) Rotate 3 accumulators
  - [Item 167](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item167) Parity, count, reverse bits
  - [Item 168](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item168) PDP-1 sounds
  - [Item 169](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item169) Count ones
  - [Item 170](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item170) Decimal print routines
  - [Item 171](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item171) Division by zero
  - [Item 172](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item172) Two word Lisp CONS
  - [Item 173](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item173) Fix float
  - [Item 174](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item174) Fix point of float function
  - [Item 175](http://home.pipeline.com/~hbaker1/hakmem/hacks.html#item175) Next higher
## P82 - [Programming Algorithms, Heuristics](http://home.pipeline.com/~hbaker1/hakmem/algorithms.html)
  - [Item 176](http://home.pipeline.com/~hbaker1/hakmem/algorithms.html#item176) BANANA Phenomenon
  - [Item 177](http://home.pipeline.com/~hbaker1/hakmem/algorithms.html#item177) Drawing Curves Incrementally
  - [Item 178](http://home.pipeline.com/~hbaker1/hakmem/algorithms.html#item178) Evaluating Functions
  - [Item 179](http://home.pipeline.com/~hbaker1/hakmem/algorithms.html#item179) Searching Character Strings
  - [Item 180](http://home.pipeline.com/~hbaker1/hakmem/algorithms.html#item180) Finding Corners in Images
## P87 - [Hardware](http://home.pipeline.com/~hbaker1/hakmem/hardware.html)
  - [Item 181](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item181) Floating Point
  - [Item 182](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item182) Voltage regulators
  - [Item 183](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item183) Current mirrors
  - [Item 184](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item184) One-shot
  - [Item 185](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item185) Oscillators
  - [Item 186](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item186) FM Radio Link
  - [Item 187](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item187) Phone Line XMTR, RCVR
  - [Item 188](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item188) DC Motor Velocity Servo
  - [Item 189](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item189) Optical Coupler
  - [Item 190](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item190) Photocathode Current Oscillator
  - [Item 191](http://home.pipeline.com/~hbaker1/hakmem/hardware.html#item191) Deflection Amplifier

# Figures

- P19, 20 | [1a](http://home.pipeline.com/~hbaker1/hakmem/Figure1a.html), [1b](http://home.pipeline.com/~hbaker1/hakmem/Figure1b.html) | Binary integers radix *i*-1, *i*+1.
- P21       | [2](http://home.pipeline.com/~hbaker1/hakmem/Figure2.html)         | Radix *i*-1 fraction parts (Knuth).
- P31, 32 | [3a](http://home.pipeline.com/~hbaker1/hakmem/Figure3a.html), [3b](http://home.pipeline.com/~hbaker1/hakmem/Figure3b.html) | Squared square, rectangle.
- P34       | [4](http://home.pipeline.com/~hbaker1/hakmem/Figure4.html)         | Square, hexagon dissection.
- P50       | [5](http://home.pipeline.com/~hbaker1/hakmem/Figure5.html)         | Hexiamond solutions.
- P58, 59 | [6a](http://home.pipeline.com/~hbaker1/hakmem/Figure6a.html), [6b](http://home.pipeline.com/~hbaker1/hakmem/Figure6b.html) | "clock hands" series.
- P62       | [7](http://home.pipeline.com/~hbaker1/hakmem/Figure7.html)         | Binary numbers radix -2.
- P66       | [8](http://home.pipeline.com/~hbaker1/hakmem/Figure8.html)         | "C" curves.
- P84       | [9](http://home.pipeline.com/~hbaker1/hakmem/Figure9.html)         | Incremental curve drawing.