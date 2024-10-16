# Build Steps

## Env

- MSYS2 + UCRT64
	`MINGW64_NT-10.0-22631 A309-Y9000P 3.4.10.x86_64 2023-11-30 06:09 UTC x86_64 Msys`
- gcc 13.2.0
- ld 2.41

julia souce with patchs: based on master, https://github.com/inkydragon/julia/tree/cyhan/win-ucrt64

diff: https://github.com/JuliaLang/julia/compare/1b183b93...inkydragon:julia:cyhan/win-ucrt64

deps:

```sh
pacman -S cmake diffutils git m4 make patch tar p7zip curl python
pacman -S mingw-w64-ucrt-x86_64-gcc

pacman -S unzip mingw-w64-ucrt-x86_64-gcc-fortran mingw-w64-ucrt-x86_64-nasm
# pacman -S mingw-w64-ucrt-x86_64-cmake
```

`Make.user`

```sh
# https://github.com/JuliaLang/julia/issues/51740
override HAVE_SSP := 0

# new flag
USE_WIN_UCRT := 1

USE_BINARYBUILDER=0
# TODO: build p7zip from source 
USE_BINARYBUILDER_P7ZIP:=1
```

## build steps

```sh
make -C deps/ extract
```

I get `tar` unpacking errors when building `libgit2` and `llvm`.
You need to repeat the unpacking operation manually and create the corresponding `source-extracted` file
Then you can continue to build.

```sh
make -C deps/ -j
make -j
```


## 问题

- csl/: 复制 .a
    手动修复路径: `cp -a /ucrt64/lib/gcc/x86_64-w64-mingw32/14.2.0/libgcc.a $(build_private_libdir)/`

### tar 解压问题

libgit2: tar 解压顺序问题，手动无法复现

```sh
/usr/bin/tar -C /d/jl/julia/deps/srccache/libgit2-a2bde63741977ca0f4ef7db2f609df320be67a08/ --strip-components 1 -xf /d/jl/julia/deps/srccache/libgit2-a2bde63741977ca0f4ef7db2f609df320be67a08.tar.gz
/usr/bin/tar: tests/resources/testrepo-worktree/link_to_new.txt: Cannot create symlink to 'new.txt': No such file or directory
```

llvm: tar 解压问题

```sh
mkdir -p /d/jl/julia/deps/srccache/llvm-julia-15.0.7-10/
/usr/bin/tar -C /d/jl/julia/deps/srccache/llvm-julia-15.0.7-10/ --strip-components 1 -xf /d/jl/julia/deps/srccache/llvm-julia-15.0.7-10.tar.gz
/usr/bin/tar: clang/test/Driver/Inputs/basic_cross_linux_tree/usr/bin/i386-unknown-linux-gnu-ld: Cannot create symlink to 'i386-unknown-linux-gnu-ld.gold': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/basic_cross_linux_tree/usr/bin/x86_64-unknown-linux-gnu-ld: Cannot create symlink to 'x86_64-unknown-linux-gnu-ld.gold': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/basic_cross_linux_tree/usr/i386-unknown-linux-gnu/bin/ld: Cannot create symlink to 'ld.gold': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/basic_cross_linux_tree/usr/x86_64-unknown-linux-gnu/bin/ld: Cannot create symlink to 'ld.gold': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/multilib_32bit_linux_tree/usr/bin/as: Cannot create symlink to 'i386-unknown-linux-gnu-as': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/multilib_64bit_linux_tree/usr/bin/as: Cannot create symlink to 'x86_64-unknown-linux-gnu-as': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/multilib_64bit_linux_tree/usr/bin/ld: Cannot create symlink to 'x86_64-unknown-linux-gnu-ld': No such file or directory
/usr/bin/tar: Exiting with failure status due to previous errors
make: *** [/d/jl/julia/deps/llvm.mk:12: /d/jl/julia/deps/srccache/llvm-julia-15.0.7-10/source-extracted] Error 2
make: Leaving directory '/d/jl/julia/deps'
```
