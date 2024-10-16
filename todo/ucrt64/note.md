# UCRT

## issue

- [Support ucrt C library via MSYS2 UCRT64 on Windows · Issue #44006 · JuliaLang/julia](https://github.com/JuliaLang/julia/issues/44006)


## pr


## UCRT support

## R-4.4.1 for Windows

64-bit UCRT only

> Since R 4.2.0, 32-bit builds are no longer provided.
> https://cran.asia/bin/windows/base/rw-FAQ.R-4.4.1.html#Can-I-use-R-on-64_002dbit-Windows_003f

### Python

https://devguide.python.org/getting-started/setup-building/#windows

Use Microsoft Visual Studio, support 32-bit and 64-bit.

### Rust

Use
- Mingw-w64 32-bit or 64-bit
- Visual Studio 2017 (or later)

https://github.com/rust-lang/rust/blob/master/INSTALL.md#building-on-windows

### JavaScript

Visual Studio 2022

https://github.com/nodejs/node/blob/main/BUILDING.md#windows

### Ruby

Ruby supports a few native build platforms for Windows.

- mswin: Build using Microsoft Visual C++ compiler with vcruntimeXXX.dll
- mingw-msvcrt: Build using compiler for Mingw with msvcrtXX.dll
- mingw-ucrt: Build using compiler for Mingw with Windows Universal CRT

https://docs.ruby-lang.org/en/master/windows_md.html
