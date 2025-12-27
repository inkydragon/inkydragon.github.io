# Source Build

Old issue: https://github.com/JuliaLang/julia/issues/45645

> git checkout wo/no-bb-build

*need check*
> 待检查

*need patch*
> 需要 patch 补丁

- [x] blastrampoline
    - 上游补丁
- [ ] csl
- [x] libgit2
    - mbedtls
    - libssh2
    - TODO: patch OR https://github.com/JuliaLang/julia/pull/48793
- [x] llvm
    - 安装时出错
- [x] objconv
    note: cygwin 需要 `unzip`
- [x] p7zip
    - 不支持直接在 win 上构建，需要使用 7z
- [ ] unwind
    - zlib
    - llvm

*nothing todo*
> 可以正常工作
- [x] curl
    - zlib
    - libssh2
    - nghttp2
- [x] dsfmt
- [x] gmp
- [x] libssh2
    - mbedtls
- [x] libsuitesparse
    - blastrampoline
- [x] libuv
- [x] mbedtls
- [x] mpfr
    - gmp
- [x] nghttp2
- [x] openblas
- [x] openlibm
- [x] pcre
- [x] utf8proc
- [x] zlib


## build
### cygwin

```sh
make O=julia-nobb-cyg configure
echo 'XC_HOST = x86_64-w64-mingw32' > julia-nobb-cyg/Make.user
# echo 'USE_BINARYBUILDER=0' >> julia-nobb-cyg/Make.user

make -C julia-nobb-cyg/deps -j`nproc`  compile-zlib
make -C julia-nobb-cyg/deps -j`nproc`
make -C julia-nobb-cyg -j`nproc`
```

### mingw-w64

```sh
make O=julia-nobb-mingw64 configure
echo 'XC_HOST = x86_64-w64-mingw32' > julia-nobb-mingw64/Make.user
# echo 'USE_BINARYBUILDER=0' >> julia-nobb-mingw64/Make.user

make -C julia-nobb-mingw64/deps -j`nproc`  compile-zlib
make -C julia-nobb-mingw64/deps -j`nproc`
make -C julia-nobb-mingw64 -j`nproc`
```

### wsl
```sh
make O=julia-nobb-wsl configure
echo '' > julia-nobb-wsl/Make.user
make -C julia-nobb-wsl -j`nproc`
```

## Errors

### blastrampoline
```sh
$ make -C julia-nobb-cyg/deps  compile-blastrampoline VERBOSE=1
make: 进入目录“/cygdrive/v/julia/julia-nobb-cyg/deps”
cd blastrampoline-d00e6ca235bb747faae4c9f3a297016cae6959ed//src && make DESTDIR="" prefix=/cygdrive/v/julia/julia-nobb-cyg/usr bindir=/cygdrive/v/julia/julia-nobb-cyg/usr/tools libdir=/cygdrive/v/julia/julia-nobb-cyg/usr/lib shlibdir=/cygdrive/v/julia/julia-nobb-cyg/usr/bin libexecdir=/cygdrive/v/julia/julia-nobb-cyg/usr/libexec datarootdir=/cygdrive/v/julia/julia-nobb-cyg/usr/share includedir=/cygdrive/v/julia/julia-nobb-cyg/usr/include sysconfdir=/cygdrive/v/julia/julia-nobb-cyg/usr/etc O= CC="x86_64-w64-mingw32-gcc -m64 " CFLAGS="" LDFLAGS="" ARCH="x86_64" OS="WINNT"
make[1]: Entering directory '/cygdrive/v/julia/julia-nobb-cyg/deps/blastrampoline-d00e6ca235bb747faae4c9f3a297016cae6959ed/src'
make[1]: *** No rule to make target 'build/libblastrampoline.dll', needed by 'all'.  Stop.
make[1]: Leaving directory '/cygdrive/v/julia/julia-nobb-cyg/deps/blastrampoline-d00e6ca235bb747faae4c9f3a297016cae6959ed/src'
make: *** [/cygdrive/v/julia/deps/blastrampoline.mk:18: blastrampoline-d00e6ca235bb747faae4c9f3a297016cae6959ed/build-compiled] Error 2
make: 离开目录“/cygdrive/v/julia/julia-nobb-cyg/deps”
```

### libgit2

```sh
$ make -C julia-nobb-cyg/deps  compile-libgit2 VERBOSE=1
make: 进入目录“/cygdrive/v/julia/julia-nobb-cyg/deps”
mkdir -p libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/
cd libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/ && \
cmake /cygdrive/v/julia/deps/srccache/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/ -DCMAKE_INSTALL_PREFIX:PATH=/cygdrive/v/julia/julia-nobb-cyg/usr -DCMAKE_PREFIX_PATH=/cygdrive/v/julia/julia-nobb-cyg/usr -DLIB_INSTALL_DIR=/cygdrive/v/julia/julia-nobb-cyg/usr/bin -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_C_COMPILER="$(which x86_64-w64-mingw32-gcc)" -DCMAKE_C_COMPILER_ARG1="-m64 " -DCMAKE_CXX_COMPILER="x86_64-w64-mingw32-g++" -DCMAKE_CXX_COMPILER_ARG1="-m64 " -DCMAKE_LINKER="$(which x86_64-w64-mingw32-ld)" -DCMAKE_AR="$(which x86_64-w64-mingw32-ar)" -DCMAKE_RANLIB="$(which x86_64-w64-mingw32-ranlib)" -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_RC_COMPILER="$(which x86_64-w64-mingw32-windres)" -DCMAKE_BUILD_TYPE=Release -DUSE_THREADS=ON -DUSE_BUNDLED_ZLIB=ON -DUSE_SSH=ON -DBUILD_CLI=OFF -DWIN32=ON -DMINGW=ON -DBUILD_CLAR=OFF -DDLLTOOL=`which x86_64-w64-mingw32-dlltool` -DCMAKE_FIND_ROOT_PATH=/usr/x86_64-w64-mingw32 -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
Re-run cmake no build system arguments
-- Could NOT find GSSAPI (missing: GSSAPI_LIBRARIES GSSAPI_INCLUDE_DIR)
-- Could NOT find OpenSSL, try to set the path to OpenSSL root folder in the system variable OPENSSL_ROOT_DIR (missing: OPENSSL_CRYPTO_LIBRARY OPENSSL_INCLUDE_DIR)
-- http-parser version 2 was not found or disabled; using bundled 3rd-party sources.
-- Could NOT find PCRE (missing: PCRE_LIBRARY PCRE_INCLUDE_DIR)
CMake Error at cmake/FindPkgLibraries.cmake:17 (message):
  could not resolve bcrypt
Call Stack (most recent call first):
  cmake/SelectSSH.cmake:3 (find_pkglibraries)
  src/CMakeLists.txt:44 (include)


-- Configuring incomplete, errors occurred!
See also "/cygdrive/v/julia/julia-nobb-cyg/deps/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/CMakeFiles/CMakeOutput.log".
See also "/cygdrive/v/julia/julia-nobb-cyg/deps/libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/CMakeFiles/CMakeError.log".
make: *** [/cygdrive/v/julia/deps/libgit2.mk:57: libgit2-fbea439d4b6fc91c6b619d01b85ab3b7746e4c19/build-configured] Error 1
make: 离开目录“/cygdrive/v/julia/julia-nobb-cyg/deps”
```


### llvm

```sh
$ make -C julia-nobb-cyg/deps  install-llvm VERBOSE=1
make: 进入目录“/cygdrive/v/julia/julia-nobb-cyg/deps”
rm -rf /cygdrive/v/julia/julia-nobb-cyg/usr-staging/llvm-julia-14.0.6-2/build_Release
mkdir -p /cygdrive/v/julia/julia-nobb-cyg/usr-staging/llvm-julia-14.0.6-2/build_Release/cygdrive/v/julia/julia-nobb-cyg/usr
cd ./llvm-julia-14.0.6-2/build_Release && mkdir -p /cygdrive/v/julia/julia-nobb-cyg/usr-staging/llvm-julia-14.0.6-2/build_Release/cygdrive/v/julia/julia-nobb-cyg/usr/tools && cp -r /cygdrive/v/julia/deps/srccache/llvm-julia-14.0.6-2/llvm/utils/lit /cygdrive/v/julia/julia-nobb-cyg/usr-staging/llvm-julia-14.0.6-2/build_Release/cygdrive/v/julia/julia-nobb-cyg/usr/tools/ && cmake -DCMAKE_INSTALL_PREFIX="/cygdrive/v/julia/julia-nobb-cyg/usr-staging/llvm-julia-14.0.6-2/build_Release/cygdrive/v/julia/julia-nobb-cyg/usr" -P cmake_install.cmake && cp /cygdrive/v/julia/julia-nobb-cyg/usr-staging/llvm-julia-14.0.6-2/build_Release/cygdrive/v/julia/julia-nobb-cyg/usr/bin/libLLVM-14jl.dll /cygdrive/v/julia/julia-nobb-cyg/usr-staging/llvm-julia-14.0.6-2/build_Release/cygdrive/v/julia/julia-nobb-cyg/usr/tools
cp: cannot create regular file '/cygdrive/v/julia/julia-nobb-cyg/usr-staging/llvm-julia-14.0.6-2/build_Release/cygdrive/v/julia/julia-nobb-cyg/usr/tools/lit/tests/Inputs/use-llvm-tool/build/case2': File exists
cp: cannot create regular file '/cygdrive/v/julia/julia-nobb-cyg/usr-staging/llvm-julia-14.0.6-2/build_Release/cygdrive/v/julia/julia-nobb-cyg/usr/tools/lit/tests/Inputs/lld-features/ld64.lld': File exists
make: *** [/cygdrive/v/julia/deps/llvm.mk:277: /cygdrive/v/julia/julia-nobb-cyg/usr-staging/llvm-julia-14.0.6-2/build_Release.tar] Error 1
make: 离开目录“/cygdrive/v/julia/julia-nobb-cyg/deps”
```

```patch
--LLVM_INSTALL = \
-	cd $1 && mkdir -p $2$$(build_depsbindir) && \
-	cp -r $$(SRCCACHE)/$$(LLVM_SRC_DIR)/llvm/utils/lit $2$$(build_depsbindir)/ && \
-	$$(CMAKE) -DCMAKE_INSTALL_PREFIX="$2$$(build_prefix)" -P cmake_install.cmake
+LLVM_INSTALL = cd $1 && mkdir -p $2$$(build_depsbindir)
+ifeq ($(OS), WINNT)
+# https://stackoverflow.com/questions/58048185/cygwin-cp-cant-copy-file-abc-because-destination-dir-contains-file-abc-exe
+# ON Windows (Cygwin/MSYS), you need to copy none-ext files first,
+#	then copy `.exe` files.
+LLVM_INSTALL += && cd $$(SRCCACHE)/$$(LLVM_SRC_DIR)/llvm/utils/ \
+	&& find lit/ ! -name '*.exe'  -exec cp --parents \{\} $2$$(build_depsbindir)/ \; \
+	&& find lit/   -name '*.exe'  -exec cp --parents \{\} $2$$(build_depsbindir)/ \; \
+	&& cd $(build_prefix)/../deps/$1
+else
+LLVM_INSTALL += && cp -r $$(SRCCACHE)/$$(LLVM_SRC_DIR)/llvm/utils/lit $2$$(build_depsbindir)/
+endif
+LLVM_INSTALL += && $$(CMAKE) -DCMAKE_INSTALL_PREFIX="$2$$(build_prefix)" -P cmake_install.cmake
```


### unwind

```sh
$ make -C julia-nobb-cyg/deps compile-unwind VERBOSE=1
make: 进入目录“/cygdrive/v/julia/julia-nobb-cyg/deps”
mkdir -p libunwind-1.5.0/
cd libunwind-1.5.0/ && \
/cygdrive/v/julia/deps/srccache/libunwind-1.5.0//configure --prefix=/cygdrive/v/julia/julia-nobb-cyg/usr --build=x86_64-pc-cygwin --libdir=/cygdrive/v/julia/julia-nobb-cyg/usr/lib --bindir=/cygdrive/v/julia/julia-nobb-cyg/usr/tools  --host=x86_64-w64-mingw32 LDFLAGS=" -Wl,--stack,8388608" F77="x86_64-w64-mingw32-gfortran -m64" CC="x86_64-w64-mingw32-gcc -m64 " CXX="x86_64-w64-mingw32-g++ -m64 " LD="x86_64-w64-mingw32-ld" CPPFLAGS=" " CFLAGS=" -U_FORTIFY_SOURCE  -lz " --enable-shared --disable-minidebuginfo --disable-tests --enable-zlibdebuginfo --disable-conservative-checks
checking build system type... x86_64-pc-cygwin
checking host system type... x86_64-w64-mingw32
checking target system type... x86_64-w64-mingw32
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for x86_64-w64-mingw32-strip... x86_64-w64-mingw32-strip
checking for a thread-safe mkdir -p... /usr/bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make supports nested variables... yes
checking whether to enable maintainer-specific portions of Makefiles... no
checking for x86_64-w64-mingw32-gcc... x86_64-w64-mingw32-gcc -m64
checking whether the C compiler works... no
configure: error: in `/cygdrive/v/julia/julia-nobb-cyg/deps/libunwind-1.5.0':
configure: error: C compiler cannot create executables
See `config.log' for more details
make: *** [/cygdrive/v/julia/deps/unwind.mk:54: libunwind-1.5.0/build-configured] Error 77
make: 离开目录“/cygdrive/v/julia/julia-nobb-cyg/deps”
```
