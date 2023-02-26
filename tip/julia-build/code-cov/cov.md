
### [pr] + gcov
```sh
make O=julia-gcov-wsl configure
echo 'TRACKING_COVERAGE = 1' > julia-gcov-wsl/Make.user
make -C julia-gcov-wsl -j 6 debug
```


需要 https://github.com/JuliaLang/julia/pull/48261
以使用系统的 ld
```
make[1]: Leaving directory '/mnt/v/julia/julia-gcov-wsl'
make[1]: Entering directory '/mnt/v/julia/julia-gcov-wsl'
    JULIA julia-gcov-wsl/usr/lib/julia/sys-debug-o.a
Collecting and executing precompile statements
└ Collect (Basic: ◓ , REPL 10/41: ◓ 895) => Execute ◓ 68lld: error: corrupt input file: version definition index 0 for symbol __gcov_var is out of bounds
>>> defined in /mnt/v/julia/julia-gcov-wsl/usr/lib/libjulia-internal-debug.so
```