## mingw64 源码编译

分支 mingw-nobb

**build**
```
make O=julia-nobb configure
echo '' > julia-nobb/Make.user
make -C julia-nobb -j`nproc`
```

**Run test**
```sh
cd test/
../julia-mingw64/julia.bat  -t auto -p auto --check-bounds=yes --startup-file=no --depwarn=error ./runtests.jl  Libdl cmdlineargs compiler/codegen misc
```


**checklist**
- [x] openlibm
- [x] dsfmt
- [x] blastrampoline
- [ ] openblas
- [x] libsuitesparse
- [x] [gmp] 
- [x] [mpfr]

- [x] [curl]
- [x] libssh2
- [x] nghttp2
- [ ] mbedtls
- [x] [libgit2]

- [ ] llvm
- [x] llvmunwind
- [x] objconv

- [x] libuv
- [x] [pcre]
- [x] zlib
- P7ZIP


## errors

### [gmp]
--srcdir 不应该自动转换路径
```sh
cd gmp-6.2.1/ && \
/v/julia/deps/srccache/gmp-6.2.1//configure --prefix=/v/julia/julia-nobb/usr --build=x86_64-w64-mingw32 --libdir=/v/julia/julia-nobb/usr/lib --bindir=/v/julia/julia-nobb/usr/tools  LDFLAGS=" -Wl,--stack,8388608" F77="gfortran -m64" CC="gcc -m64 " CXX="g++ -m64 " LD="ld" --enable-cxx --enable-shared --disable-static CC_FOR_BUILD="gcc -m64" --srcdir="//v//julia//deps//srccache//gmp-6.2.1"
configure: error: cannot find sources (gmp-impl.h) in //v//julia//deps//srccache//gmp-6.2.1
make: *** [/v/julia/deps/gmp.mk:62：gmp-6.2.1/build-configured] 错误 1
make: 离开目录“/v/julia/julia-nobb/deps”
```

need MPFR
```sh
checking size of unsigned long... 4
checking size of mp_limb_t... 0
configure: error: Oops, mp_limb_t doesn't seem to work
make: *** [/v/julia/deps/gmp.mk:64：gmp-6.2.1/build-configured] 错误 1
make: 离开目录“/v/julia/julia-nobb/deps”
```


```diff
ifeq ($(BUILD_OS),WINNT)
GMP_CONFIGURE_OPTS += --srcdir="$(SRCCACHE)/gmp-$(GMP_VER)"
# not convert src path
$(BUILDDIR)/gmp-$(GMP_VER)/build-configured: export MSYS2_ARG_CONV_EXCL = --srcdir=
endif
```

### [mpfr]
```sh
cd mpfr-4.1.0/ && \
/v/julia/deps/srccache/mpfr-4.1.0//configure --prefix=/v/julia/julia-nobb/usr --build=x86_64-w64-mingw32 --libdir=/v/julia/julia-nobb/usr/lib --bindir=/v/julia/julia-nobb/usr/tools  LDFLAGS=" -Wl,--stack,8388608" F77="gfortran -m64" CC="gcc -m64 " CXX="g++ -m64 " LD="ld" --enable-thread-safe --enable-shared-cache --disable-float128 --disable-decimal-float --enable-shared --disable-static --with-gmp=/v/julia/julia-nobb/usr
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /usr/bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make supports nested variables... yes
checking whether to enable maintainer-specific portions of Makefiles... yes
checking build system type... x86_64-w64-mingw32
checking host system type... x86_64-w64-mingw32
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for a sed that does not truncate output... /usr/bin/sed
checking whether configure options are compatible... yes
checking for gcc... gcc -m64
checking whether the C compiler works... no
configure: error: in `/v/julia/julia-nobb/deps/mpfr-4.1.0':
configure: error: C compiler cannot create executables
See `config.log' for more details
make: *** [/v/julia/deps/mpfr.mk:39：mpfr-4.1.0/build-configured] 错误 77
make: 离开目录“/v/julia/julia-nobb/deps”
```

### [mbedtls]
- 带上 .exe 后缀
- 不给出完整路径

```sh
cmake /v/julia/deps/srccache/mbedtls-2.28.0/ -DCMAKE_INSTALL_PREFIX:PATH=/v/julia/julia-nobb/usr -DCMAKE_PREFIX_PATH=/v/julia/julia-nobb/usr -DLIB_INSTALL_DIR=/v/julia/julia-nobb/usr/bin -DCMAKE_C_COMPILER="$(which gcc)" -DCMAKE_C_COMPILER_ARG1="-m64 " -DCMAKE_CXX_COMPILER="g++" -DCMAKE_CXX_COMPILER_ARG1="-m64 " -DCMAKE_LINKER="$(which ld)" -DCMAKE_AR="$(which ar)" -DCMAKE_RANLIB="$(which ranlib)" -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_RC_COMPILER="$(which windres)" -DCMAKE_C_STANDARD=99  -DUSE_SHARED_MBEDTLS_LIBRARY=ON -DUSE_STATIC_MBEDTLS_LIBRARY=OFF -DMBEDTLS_FATAL_WARNINGS=OFF -DENABLE_TESTING=OFF -DENABLE_PROGRAMS=OFF -DCMAKE_BUILD_TYPE=Release -G"MSYS Makefiles"
-- The C compiler identification is GNU 12.2.0
CMake Error at CMakeLists.txt:39 (project):
  The CMAKE_C_COMPILER:

    E:/dev/msys64/mingw64/bin/gcc

  is not a full path to an existing compiler tool.

  Tell CMake where to find the compiler by setting either the environment
  variable "CC" or the CMake cache entry CMAKE_C_COMPILER to the full path to
  the compiler, or to the compiler name if it is in the PATH.


-- Configuring incomplete, errors occurred!
See also "V:/julia/julia-nobb/deps/mbedtls-2.28.0/CMakeFiles/CMakeOutput.log".
make: *** [/v/julia/deps/mbedtls.mk:38：mbedtls-2.28.0/build-configured] 错误 1
make: 离开目录“/v/julia/julia-nobb/deps”
```

deps\tools\common.mk
```diff
ifneq (,$(findstring MINGW,$(shell uname)))
# Win + MSYS/MINGW
# Or you may add `.exe` to the full path
CMAKE_COMMON += -DCMAKE_C_COMPILER="$(CC_BASE)"
else
# The call to which here is to work around https://cmake.org/Bug/view.php?id=14366
CMAKE_COMMON += -DCMAKE_C_COMPILER="$$(which $(CC_BASE))"
endif
```

```diff
MBEDTLS_OPTS := $(CMAKE_COMMON) -DCMAKE_C_STANDARD=99 
MBEDTLS_OPTS += -DUSE_SHARED_MBEDTLS_LIBRARY=ON -DUSE_STATIC_MBEDTLS_LIBRARY=OFF
MBEDTLS_OPTS += -DMBEDTLS_FATAL_WARNINGS=OFF -DENABLE_TESTING=OFF
MBEDTLS_OPTS += -DENABLE_PROGRAMS=OFF -DCMAKE_BUILD_TYPE=Release
MBEDTLS_OPTS += -DENABLE_ZLIB_SUPPORT=OFF
```

### [curl]
ssh2 未找到
```sh
checking for sys/socket.h... (cached) no
checking for struct timeval... yes
checking run-time libs availability... failed
configure: error: one or more libs available at link-time are not available run-time. Libs used at link-time: -lssh2 -ladvapi32 -lcrypt32 -lzstd  -lws2_32
make: *** [/v/julia/deps/curl.mk:62：curl-7.84.0/build-configured] 错误 1
make: 离开目录“/v/julia/julia-nobb/deps”
```

### [libgit2]
tar 不能解压符号链接
```sh
$ make -C julia-nobb/deps/ -j`nproc`
make: 进入目录“/v/julia/julia-nobb/deps”
/v/julia/deps/tools/jlchecksum /v/julia/deps/srccache/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19.tar.gz
[ ! \( -e /v/julia/deps/srccache/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/ -o -h /v/julia/deps/srccache/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/ \) ] || rm -rf /v/julia/deps/srccache/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/
mkdir -p /v/julia/deps/srccache/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/
/usr/bin/tar -C /v/julia/deps/srccache/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/ --strip-components 1 -xf /v/julia/deps/srccache/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19.tar.gz
/usr/bin/tar: tests/resources/testrepo-worktree/link_to_new.txt: Cannot create symlink to 'new.txt': No such file or directory
/usr/bin/tar: Exiting with failure status due to previous errors
make: *** [/v/julia/deps/libgit2.mk:9：/v/julia/deps/srccache/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/source-extracted] 错误 2
make: 离开目录“/v/julia/julia-nobb/deps”
```


### [pcre]

```sh
$ make -C julia-nobb/deps/ -j`nproc`
make: 进入目录“/v/julia/julia-nobb/deps”
make -C pcre2-10.40/ CCLD="gcc -m64 -no-undefined -avoid-version"
make[1]: Entering directory '/v/julia/julia-nobb/deps/pcre2-10.40'
make  all-am
make[2]: Entering directory '/v/julia/julia-nobb/deps/pcre2-10.40'
  CCLD     pcre2grep.exe
  CCLD     pcre2test.exe
  CCLD     pcre2_jit_test.exe
E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../lib/crt2.o: in function `pre_c_init':
C:/M/mingw-w64-crt-git/src/mingw-w64/mingw-w64-crt/crt/crtexe.c:135: undefined reference to `__p__commode'
E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../lib/crt2.o: in function `pre_c_init':
C:/M/mingw-w64-crt-git/src/mingw-w64/mingw-w64-crt/crt/crtexe.c:135: undefined reference to `__p__commode'
collect2.exe: error: ld returned 1 exit status
collect2.exe: error: ld returned 1 exit status
make[2]: *** [Makefile:1789: pcre2grep.exe] Error 1
make[2]: *** Waiting for unfinished jobs....
make[2]: *** [Makefile:1777: pcre2_jit_test.exe] Error 1
E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../lib/crt2.o: in function `pre_c_init':
C:/M/mingw-w64-crt-git/src/mingw-w64/mingw-w64-crt/crt/crtexe.c:135: undefined reference to `__p__commode'
collect2.exe: error: ld returned 1 exit status
make[2]: *** [Makefile:1795: pcre2test.exe] Error 1
make[2]: Leaving directory '/v/julia/julia-nobb/deps/pcre2-10.40'
make[1]: *** [Makefile:1414: all] Error 2
make[1]: Leaving directory '/v/julia/julia-nobb/deps/pcre2-10.40'
make: *** [/v/julia/deps/pcre.mk:32：pcre2-10.40/build-compiled] 错误 2
make: 离开目录“/v/julia/julia-nobb/deps”
```

https://github.com/JuliaPackaging/Yggdrasil/blob/master/P/PCRE2/build_tarballs.jl
