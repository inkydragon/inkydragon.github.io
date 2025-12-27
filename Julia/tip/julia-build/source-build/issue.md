Compile from source without BB in Cygwin

Replace old issue: #45645

### todo
- [ ] `blastrampoline`: patch upstream: https://github.com/JuliaLinearAlgebra/libblastrampoline/pull/107
- [ ] `csl`
- [ ] `libgit2`
- [ ] `llvm`: Successful build, error during installation
- [x] `objconv`: need doc: install `unzip` in cygwin
- [x] `p7zip`: 
  - just download `7z`
  - OR not cross build p7zip
- [ ] `unwind`: need `llvm` 

### Build env

- Win 10 22H2
- CYGWIN_NT-10.0-19045 wos-PC 3.4.6-1.x86_64 2023-02-14 13:23 UTC x86_64 Cygwin
- cc, `gcc`, g++, x86_64-w64-mingw32-gcc, x86_64-w64-mingw32-gfortran 11.3.0
- GNU `Make` 4.4
- `cmake` version 3.23.2
- `Python` 3.9.10
