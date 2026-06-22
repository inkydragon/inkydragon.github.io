
source code download:
```sh
# apt-get --allow-releaseinfo-change update
apt-get update -y
apt install gfortran cmake diffutils git m4 make patch tar p7zip curl python3

git clone https://github.com/JuliaLang/julia.git
# git clone https://gitee.com/mirrors/julia-language.git
```

### ARMv8 build

```sh
make O=julia-armv8 configure
# https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
echo 'MCPU=arm8' > julia-armv8/Make.user
# echo 'MCPU=native' > julia-armv8/Make.user
make -C julia-armv8/deps/ -j4
```
### ARMv7 build

```sh
make O=julia-armv7 configure
# https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
echo 'MCPU=generic-armv7-a' > julia-armv7/Make.user
make -C julia-armv7/deps/ -j4
```



## julia

build log
```sh
Sysimage built. Summary:
Total ─────── 107.079771 seconds
Base: ───────  44.223114 seconds 41.2992%
Stdlibs: ────  62.852956 seconds 58.6973%
make[1]: Leaving directory '/root/julia/julia-armv8'
make[1]: Entering directory '/root/julia/julia-armv8'
    JULIA julia-armv8/usr/lib/julia/sys-o.a
Generating REPL precompile statements... 36/36
Executing precompile statements... 1515/1552
Precompilation complete. Summary:
Total ─────── 268.404072 seconds
Generation ── 202.938252 seconds 75.6092%
Execution ───  65.465820 seconds 24.3908%
    LINK julia-armv8/usr/lib/julia/sys.so
make[1]: Leaving directory '/root/julia/julia-armv8'
make: Leaving directory '/root/julia/julia-armv8'
```

```jl
julia> versioninfo(verbose=true)
Julia Version 1.7.3
Commit 742b9abb4d (2022-05-06 12:58 UTC)
Platform Info:
  OS: Linux (aarch64-linux-gnu)
      Ubuntu 18.04.3 LTS
  uname: Linux 4.15.0-70-generic #79-Ubuntu SMP Tue Nov 12 10:36:10 UTC 2019 aarch64 aarch64
  CPU: unknown:
              speed         user         nice          sys         idle          irq
       #1     0 MHz       3198 s         15 s        176 s      16699 s          0 s
       #2     0 MHz       4793 s         12 s        184 s      15195 s          0 s
       #3     0 MHz       3578 s         21 s        149 s      16469 s          0 s
       #4     0 MHz       1727 s          0 s        138 s      18339 s          0 s

  Memory: 15.662689208984375 GB (13314.65234375 MB free)
  Uptime: 2029.17 sec
  Load Avg:  0.61  0.9  0.77
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-12.0.1 (ORCJIT, tsv110)
Environment:
  HOME = /root
  TERM = xterm-256color
  PATH = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

```


## kunpeng env

```dotnetcli
root@hw-arm:~/julia# cat /proc/cpuinfo
processor       : 0
BogoMIPS        : 200.00
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma dcpop asimddp
CPU implementer : 0x48
CPU architecture: 8
CPU variant     : 0x1
CPU part        : 0xd01
CPU revision    : 0

root@hw-arm:~/julia# gcc -dumpmachine
aarch64-linux-gnu


root@hw-arm:~/julia# uname -a
Linux hw-arm 4.15.0-70-generic #79-Ubuntu SMP Tue Nov 12 10:36:10 UTC 2019 aarch64 aarch64 aarch64 GNU/Linux

root@hw-arm:~/julia# gcc --version
gcc (Ubuntu/Linaro 7.4.0-1ubuntu1~18.04.1) 7.4.0

root@hw-arm:~/julia# ld --version
GNU ld (GNU Binutils for Ubuntu) 2.30

root@hw-arm:~/julia# make --version
GNU Make 4.1
Built for aarch64-unknown-linux-gnu


```
