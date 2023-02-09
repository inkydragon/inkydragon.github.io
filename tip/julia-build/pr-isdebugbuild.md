## 

**build**
```
make -C julia-mingw64 -j`nproc`
```

**Run test**
```sh
cd test/
../julia-mingw64/julia.bat  -t auto -p auto --check-bounds=yes --startup-file=no --depwarn=error ./runtests.jl  Libdl cmdlineargs compiler/codegen misc
../julia-mingw64/julia.bat  -t auto -p auto --check-bounds=yes --startup-file=no --depwarn=error ./runtests.jl  InteractiveUtils
```


add a new help function in Base: `isdebugbuild`
