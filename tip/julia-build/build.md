# BUILD

## MSYS2

### install

- download: https://github.com/msys2/msys2-installer/releases/
- [x] You MUST set `MSYS2_ARG_CONV_EXCL="*"`
ref: https://stackoverflow.com/questions/7250130/how-to-stop-mingw-and-msys-from-mangling-path-names-given-at-the-command-line


```sh
pacman -Syyuu
pacman -S cmake diffutils git m4 make patch tar p7zip curl python3

# mingw64
pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-gcc-fortran
# mingw32
pacman -S mingw-w64-i686-gcc mingw-w64-i686-gcc-fortran
# clang64
pacman -S mingw-w64-clang-x86_64-clang mingw-w64-clang-x86_64-flang
# ucrt64
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-gcc-fortran
```


### MINGW64
```sh
make O=julia-mingw64 configure
make -C julia-mingw64 -j`nproc`
# doc
make -C julia-mingw64 -j`nproc`  html
# install
make install  DESTDIR=/v/jl-dev
```

**Run test**
```sh
cd test/
../julia-deps-wsl/julia  -t auto -p auto --check-bounds=yes --startup-file=no --depwarn=error ./runtests.jl  
```

### MINGW32
```sh
make O=julia-mingw32 configure
make -C julia-mingw32 -j`nproc`
```

### CLANG64
BB_TRI 不正确
```sh
make O=julia-clang64 configure
echo 'USECLANG := 1'  > julia-clang64/Make.user
echo 'USEGCC := 0'    >> julia-clang64/Make.user
make -C julia-clang64 -j`nproc`
```

### UCRT64
```sh
make O=julia-ucrt configure
make -C julia-ucrt -j`nproc`
```




## cygwin ---------------------------------------------------------------------------------------------

### + deps
```sh
make O=julia-deps configure
echo 'XC_HOST = x86_64-w64-mingw32' > julia-deps/Make.user
echo 'ifeq ($(BUILDROOT),$(JULIAHOME))
        $(error "in-tree build disabled")
      endif' >> Make.user
make -C julia-deps -j 6
```


### [pr] - llvm_ver
```sh
make O=julia-llvm-ver configure
echo 'XC_HOST = x86_64-w64-mingw32' > julia-llvm-ver/Make.user
echo 'USE_BINARYBUILDER=0' >> julia-llvm-ver/Make.user
make -C julia-llvm-ver -j 6
```

### no-bb
```sh
make O=julia-no_bb configure
echo 'XC_HOST = x86_64-w64-mingw32' > julia-no_bb/Make.user
echo 'USE_BINARYBUILDER=0' >> julia-no_bb/Make.user
make -C julia-no_bb/deps -j 6  install-blastrampoline
```

### no-bb2
```sh
make O=julia-no_bb2 configure
echo 'XC_HOST = x86_64-w64-mingw32' > julia-no_bb2/Make.user
echo 'USE_BINARYBUILDER=0' >> julia-no_bb2/Make.user
make -C julia-no_bb2 -j 6  debug
```


## WSL ---------------------------------------------------------------------------------------------

**build deps**
```sh
gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 gfortran-mingw-w64-x86-64 binutils-mingw-w64-x86-64
```

### [pr] + gcov
```sh
make O=julia-wsl-gcov configure
echo 'TRACKING_COVERAGE = 1' > julia-wsl-gcov/Make.user
make -C julia-wsl-gcov -j 6 debug
```



### [pr] + deps
```sh
make O=julia-wsl-pr45918 configure
echo 'USE_SYSTEM_LIBM = 1' > julia-wsl-pr45918/Make.user
make -C julia-wsl-pr45918 -j 6
```

### + deps
```sh
make O=julia-wsl configure
echo 'ifeq ($(BUILDROOT),$(JULIAHOME))
        $(error "in-tree build disabled")
      endif' >> Make.user
make -C julia-wsl -j 6
```

### no-bb
```sh
make O=julia-wsl-no_bb configure
echo 'USE_BINARYBUILDER=0' > julia-wsl-no_bb/Make.user
make -C julia-wsl-no_bb/deps -j 6
```

### [cross] win + no-bb
```sh
make O=julia-win64-no_bb configure
echo 'XC_HOST = x86_64-w64-mingw32' > julia-win64-no_bb/Make.user
echo 'USE_BINARYBUILDER=0' >> julia-win64-no_bb/Make.user
make -C julia-win64-no_bb/deps -j 6  install-blastrampoline 
```


## macOS ---------------------------------------------------------------------------------------------

### + deps
```sh
make O=julia-mac configure
echo 'ifeq ($(BUILDROOT),$(JULIAHOME))
        $(error "in-tree build disabled")
      endif' >> Make.user
make -C julia-mac -j 8
```

### [cross] win + no-bb
```sh
make O=julia-win64-no_bb configure
echo 'XC_HOST=x86_64-w64-mingw32' > julia-win64-no_bb/Make.user
echo 'USE_BINARYBUILDER=0' >> julia-win64-no_bb/Make.user
echo 'override USECLANG=0' >> julia-win64-no_bb/Make.user
echo 'override USEGCC=1' >> julia-win64-no_bb/Make.user
make -C julia-win64-no_bb/deps -j 8  install-blastrampoline 
```
