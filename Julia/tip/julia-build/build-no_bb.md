### MSYS2 + MINGW64

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


### no_bb

```sh
make O=julia-nobb-mingw64 configure
echo 'XC_HOST = x86_64-w64-mingw32' > julia-nobb-mingw64/Make.user
echo 'USE_BINARYBUILDER=0' >> julia-nobb-mingw64/Make.user

make -C julia-nobb-mingw64/deps -j`nproc`
make -C julia-nobb-mingw64 -j`nproc`
```


### pr
```sh
make O=julia-gcc12-mingw64 configure
# echo 'XC_HOST = x86_64-w64-mingw32' > julia-gcc12-mingw64/Make.user
# echo 'USE_BINARYBUILDER=0' >> julia-gcc12-mingw64/Make.user

make -C julia-gcc12-mingw64/deps -j`nproc`
make -C julia-gcc12-mingw64 -j`nproc`
```
