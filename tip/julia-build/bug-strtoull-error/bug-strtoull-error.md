# undefined reference to `strtoull`

## mingw64
使用 mingw64 编译 master (7caa499038)
```sh
make O=julia-mingw64 configure
make -C julia-mingw64 -j`nproc`
# throw errors
make -C julia-mingw64
# still throw errors
```

workaround
```sh
mv  /v/julia/julia-mingw64/usr/lib/libmsvcrt.a /v/julia/julia-mingw64/usr/lib/libmsvcrt.a.OLD

echo 'USE_SYSTEM_CSL := 1' > julia-mingw64/Make.user
```


### test 
- precompile
- compiler/inline
- loading
- 

报错
```sh
$ make -C julia-mingw64 VERBOSE=1
make: 进入目录“/v/julia/julia-mingw64”
make[1]: Entering directory '/v/julia/julia-mingw64/deps'
make[1]: Leaving directory '/v/julia/julia-mingw64/deps'
make[1]: Entering directory '/v/julia/julia-mingw64/stdlib'
make[1]: Leaving directory '/v/julia/julia-mingw64/stdlib'
make[1]: Entering directory '/v/julia/julia-mingw64/base'
sh /v/julia/base/version_git.sh /v/julia/base > version_git.jl.phony
make[1]: Leaving directory '/v/julia/julia-mingw64/base'
make[1]: Entering directory '/v/julia/julia-mingw64/cli'
make[1]: Nothing to be done for 'release'.
make[1]: Leaving directory '/v/julia/julia-mingw64/cli'
make[1]: Entering directory '/v/julia/julia-mingw64/src'
make[1]: Nothing to be done for 'julia_flisp.boot.inc.phony'.
make[1]: Leaving directory '/v/julia/julia-mingw64/src'
make[1]: Entering directory '/v/julia/julia-mingw64/src'
/v/julia/contrib/install.sh 644 /v/julia/julia-mingw64/usr/include/uv/errno.h /v/julia/julia-mingw64/usr/include/uv/threadpool.h /v/julia/julia-mingw64/usr/include/uv/tree.h /v/julia/julia-mingw64/usr/include/uv/version.h /v/julia/julia-mingw64/usr/include/uv/win.h /v/julia/julia-mingw64/usr/include/julia/uv
/v/julia/contrib/install.sh 644 /v/julia/julia-mingw64/usr/include/uv/errno.h /v/julia/julia-mingw64/usr/include/uv/threadpool.h /v/julia/julia-mingw64/usr/include/uv/tree.h /v/julia/julia-mingw64/usr/include/uv/version.h /v/julia/julia-mingw64/usr/include/uv/win.h /v/julia/julia-mingw64/usr/include/julia/uv
/v/julia/contrib/install.sh 644 /v/julia/julia-mingw64/usr/include/uv/errno.h /v/julia/julia-mingw64/usr/include/uv/threadpool.h /v/julia/julia-mingw64/usr/include/uv/tree.h /v/julia/julia-mingw64/usr/include/uv/version.h /v/julia/julia-mingw64/usr/include/uv/win.h /v/julia/julia-mingw64/usr/include/julia/uv
/v/julia/contrib/install.sh 644 /v/julia/julia-mingw64/usr/include/uv/errno.h /v/julia/julia-mingw64/usr/include/uv/threadpool.h /v/julia/julia-mingw64/usr/include/uv/tree.h /v/julia/julia-mingw64/usr/include/uv/version.h /v/julia/julia-mingw64/usr/include/uv/win.h /v/julia/julia-mingw64/usr/include/julia/uv
 g++ -m64 -shared   -Wl,--out-implib,/v/julia/julia-mingw64/usr/lib/libjulia-internal.dll.a -pipe  -fno-rtti -std=c++14   -O3 -ggdb2 -falign-functions -momit-leaf-frame-pointer -D_GNU_SOURCE -I. -I/v/julia/src -I/v/julia/src/flisp -I/v/julia/src/support -I/v/julia/julia-mingw64/usr/include -I/v/julia/julia-mingw64/usr/include -I/v/julia/deps/valgrind -Wall -Wno-strict-aliasing -fno-omit-frame-pointer -fvisibility=hidden -fno-common -Wno-comment -Wpointer-arith -Wundef -Wno-unused-result -DJL_BUILD_ARCH='"x86_64"' -DJL_BUILD_UNAME='"NT"' -IV:\julia\julia-mingw64\usr\include -DLLVM_SHLIB -DLIBRARY_EXPORTS "-DJL_SYSTEM_IMAGE_PATH=\"../lib/julia/sys.dll\"" "-DJL_LIBJULIA_SONAME=\"libjulia.dll\"" ./jltypes.o ./gf.o ./typemap.o ./smallintset.o ./ast.o ./builtins.o ./module.o ./interpreter.o ./symbol.o ./dlload.o ./sys.o ./init.o ./task.o ./array.o ./staticdata.o ./toplevel.o ./jl_uv.o ./datatype.o ./simplevector.o ./runtime_intrinsics.o ./precompile.o ./jloptions.o ./threading.o ./partr.o ./stackwalk.o ./gc.o ./gc-debug.o ./gc-pages.o ./gc-stacks.o ./gc-alloc-profiler.o ./method.o ./jlapi.o ./signal-handling.o ./safepoint.o ./timing.o ./subtype.o ./rtutils.o ./gc-heap-snapshot.o ./crc32c.o ./APInt-C.o ./processor.o ./ircode.o ./opaque_closure.o ./codegen-stubs.o ./coverage.o ./runtime_ccall.o ./win32_ucontext.o  -o /v/julia/julia-mingw64/usr/bin/libjulia-internal.dll -Wl,--stack,8388608  -L/v/julia/julia-mingw64/usr/lib -L/v/julia/julia-mingw64/usr/bin -Wl,--whole-archive ./flisp/libflisp.a -Wl,--whole-archive ./support/libsupport.a -ljulia -Wl,--whole-archive /v/julia/julia-mingw64/usr/lib/libuv.a -Wl,--whole-archive /v/julia/julia-mingw64/usr/lib/libutf8proc.a -Wl,--no-whole-archive  -LV:\julia\julia-mingw64\usr/lib  -lLLVMSupport -lLLVMDemangle -lpsapi -lshell32 -lole32 -luuid -ladvapi32 -lz -luuid -lole32 -Wl,--export-all-symbols -Wl,--version-script=/v/julia/src/julia.expmap -Wl,--no-whole-archive -lpsapi -lkernel32 -lws2_32 -liphlpapi -lwinmm -ldbghelp -luserenv -lsecur32 -latomic -lssp
E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: ./flisp/libflisp.a(flisp.o): in function `strtoull_0b0o':
    V:/julia/src/flisp/read.c:29: undefined reference to `strtoull'
E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: ./flisp/libflisp.a(flisp.o): in function `isnumtok_base':
    V:/julia/src/flisp/read.c:92: undefined reference to `strtoll'
E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../lib/libmingwex.a(lib64_libmingwex_a-mingw_vfscanf.o): in function `__mingw_sformat':
    C:/M/mingw-w64-crt-git/src/mingw-w64/mingw-w64-crt/stdio/mingw_vfscanf.c:1081: undefined reference to `strtoll'
E:/dev/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/12.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: C:/M/mingw-w64-crt-git/src/mingw-w64/mingw-w64-crt/stdio/mingw_vfscanf.c:1083: undefined reference to `strtoull'
collect2.exe: error: ld returned 1 exit status
make[1]: *** [/v/julia/src/Makefile:367: /v/julia/julia-mingw64/usr/bin/libjulia-internal.dll] Error 1
make[1]: Leaving directory '/v/julia/julia-mingw64/src'
make: *** [/v/julia/Makefile:91: julia-src-release] Error 2
make: 离开目录“/v/julia/julia-mingw64”
```

last step:
```sh
# cd /v/julia/julia-mingw64/src
g++ -m64 -shared   -Wl,--out-implib,/v/julia/julia-mingw64/usr/lib/libjulia-internal.dll.a -pipe  -fno-rtti -std=c++14   -O3 -ggdb2 -falign-functions -momit-leaf-frame-pointer -D_GNU_SOURCE -I. -I/v/julia/src -I/v/julia/src/flisp -I/v/julia/src/support -I/v/julia/julia-mingw64/usr/include -I/v/julia/julia-mingw64/usr/include -I/v/julia/deps/valgrind -Wall -Wno-strict-aliasing -fno-omit-frame-pointer -fvisibility=hidden -fno-common -Wno-comment -Wpointer-arith -Wundef -Wno-unused-result -DJL_BUILD_ARCH='"x86_64"' -DJL_BUILD_UNAME='"NT"' -IV:\julia\julia-mingw64\usr\include -DLLVM_SHLIB -DLIBRARY_EXPORTS "-DJL_SYSTEM_IMAGE_PATH=\"../lib/julia/sys.dll\"" "-DJL_LIBJULIA_SONAME=\"libjulia.dll\"" ./jltypes.o ./gf.o ./typemap.o ./smallintset.o ./ast.o ./builtins.o ./module.o ./interpreter.o ./symbol.o ./dlload.o ./sys.o ./init.o ./task.o ./array.o ./staticdata.o ./toplevel.o ./jl_uv.o ./datatype.o ./simplevector.o ./runtime_intrinsics.o ./precompile.o ./jloptions.o ./threading.o ./partr.o ./stackwalk.o ./gc.o ./gc-debug.o ./gc-pages.o ./gc-stacks.o ./gc-alloc-profiler.o ./method.o ./jlapi.o ./signal-handling.o ./safepoint.o ./timing.o ./subtype.o ./rtutils.o ./gc-heap-snapshot.o ./crc32c.o ./APInt-C.o ./processor.o ./ircode.o ./opaque_closure.o ./codegen-stubs.o ./coverage.o ./runtime_ccall.o ./win32_ucontext.o  -o /v/julia/julia-mingw64/usr/bin/libjulia-internal.dll -Wl,--stack,8388608  -L/v/julia/julia-mingw64/usr/lib -L/v/julia/julia-mingw64/usr/bin -Wl,--whole-archive ./flisp/libflisp.a -Wl,--whole-archive ./support/libsupport.a -ljulia -Wl,--whole-archive /v/julia/julia-mingw64/usr/lib/libuv.a -Wl,--whole-archive /v/julia/julia-mingw64/usr/lib/libutf8proc.a -Wl,--no-whole-archive  -LV:\julia\julia-mingw64\usr/lib  -lLLVMSupport -lLLVMDemangle -lpsapi -lshell32 -lole32 -luuid -ladvapi32 -lz -luuid -lole32 -Wl,--export-all-symbols -Wl,--version-script=/v/julia/src/julia.expmap -Wl,--no-whole-archive -lpsapi -lkernel32 -lws2_32 -liphlpapi -lwinmm -ldbghelp -luserenv -lsecur32 -latomic -lssp
```

```sh
# cd /v/julia/julia-mingw64/src
g++ -m64 -shared   \
    -Wl,--out-implib,/v/julia/julia-mingw64/usr/lib/libjulia-internal.dll.a -pipe  -fno-rtti -std=c++14   -O3 -ggdb2 -falign-functions -momit-leaf-frame-pointer -D_GNU_SOURCE \
    -I. -I/v/julia/src -I/v/julia/src/flisp -I/v/julia/src/support -I/v/julia/julia-mingw64/usr/include -I/v/julia/deps/valgrind \
    -Wall -Wno-strict-aliasing -fno-omit-frame-pointer -fvisibility=hidden -fno-common -Wno-comment -Wpointer-arith -Wundef -Wno-unused-result \
    -DJL_BUILD_ARCH='"x86_64"' -DJL_BUILD_UNAME='"NT"'  -DLLVM_SHLIB -DLIBRARY_EXPORTS "-DJL_SYSTEM_IMAGE_PATH=\"../lib/julia/sys.dll\"" "-DJL_LIBJULIA_SONAME=\"libjulia.dll\"" \
    ./jltypes.o ./gf.o ./typemap.o ./smallintset.o ./ast.o ./builtins.o ./module.o ./interpreter.o ./symbol.o ./dlload.o ./sys.o ./init.o ./task.o ./array.o ./staticdata.o ./toplevel.o ./jl_uv.o ./datatype.o ./simplevector.o ./runtime_intrinsics.o ./precompile.o ./jloptions.o ./threading.o ./partr.o ./stackwalk.o ./gc.o ./gc-debug.o ./gc-pages.o ./gc-stacks.o ./gc-alloc-profiler.o ./method.o ./jlapi.o ./signal-handling.o ./safepoint.o ./timing.o ./subtype.o ./rtutils.o ./gc-heap-snapshot.o ./crc32c.o ./APInt-C.o ./processor.o ./ircode.o ./opaque_closure.o ./codegen-stubs.o ./coverage.o ./runtime_ccall.o ./win32_ucontext.o  \
    -o /v/julia/julia-mingw64/usr/bin/libjulia-internal.dll -Wl,--stack,8388608  \
    -L/v/julia/julia-mingw64/usr/lib -L/v/julia/julia-mingw64/usr/bin \
    -Wl,--whole-archive ./flisp/libflisp.a -Wl,--whole-archive ./support/libsupport.a -ljulia -Wl,--whole-archive /v/julia/julia-mingw64/usr/lib/libuv.a -Wl,--whole-archive /v/julia/julia-mingw64/usr/lib/libutf8proc.a \
    -Wl,--no-whole-archive  \
    -lLLVMSupport -lLLVMDemangle -lpsapi -lshell32 -lole32 -luuid -ladvapi32 -lz -luuid -lole32 \
    -Wl,--export-all-symbols -Wl,--version-script=/v/julia/src/julia.expmap -Wl,--no-whole-archive \
    -lpsapi -lkernel32 -lws2_32 -liphlpapi -lwinmm -ldbghelp -luserenv -lsecur32 -latomic -lssp
# -lmsvcrt
```

```
$(build_shlibdir)/libjulia-internal.$(JL_MAJOR_MINOR_SHLIB_EXT)
```

print-VAR:
```sh
$ make -C julia-mingw64/src/ print-SHIPFLAGS
make: 进入目录“/v/julia/julia-mingw64/src”
SHIPFLAGS=-O3 -ggdb2 -falign-functions -momit-leaf-frame-pointer -D_GNU_SOURCE -I. -I/v/julia/src -I/v/julia/src/flisp -I/v/julia/src/support -I/v/julia/julia-mingw64/usr/include -I/v/julia/julia-mingw64/usr/include -I/v/julia/deps/valgrind -Wall -Wno-strict-aliasing -fno-omit-frame-pointer -fvisibility=hidden -fno-common -Wno-comment -Wpointer-arith -Wundef -Wno-unused-result -DJL_BUILD_ARCH='"x86_64"' -DJL_BUILD_UNAME='"NT"' -IV:\julia\julia-mingw64\usr\include -DLLVM_SHLIB -DLIBRARY_EXPORTS "-DJL_SYSTEM_IMAGE_PATH=\"../lib/julia/sys.dll\"" "-DJL_LIBJULIA_SONAME=\"libjulia.dll\""

$ make -C julia-mingw64/src/ print-FLAGS
make: 进入目录“/v/julia/julia-mingw64/src”
FLAGS=-D_GNU_SOURCE -I. -I/v/julia/src -I/v/julia/src/flisp -I/v/julia/src/support -I/v/julia/julia-mingw64/usr/include -I/v/julia/julia-mingw64/usr/include -I/v/julia/deps/valgrind -Wall -Wno-strict-aliasing -fno-omit-frame-pointer -fvisibility=hidden -fno-common -Wno-comment -Wpointer-arith -Wundef -Wno-unused-result -DJL_BUILD_ARCH='"x86_64"' -DJL_BUILD_UNAME='"NT"' -IV:\julia\julia-mingw64\usr\include -DLLVM_SHLIB


$ make -C julia-mingw64/src/ print-RT_RELEASE_LIBS
make: 进入目录“/v/julia/julia-mingw64/src”
RT_RELEASE_LIBS=-L/v/julia/julia-mingw64/usr/lib -L/v/julia/julia-mingw64/usr/bin -Wl,--whole-archive ./flisp/libflisp.a -Wl,--whole-archive ./support/libsupport.a -ljulia -Wl,--whole-archive /v/julia/julia-mingw64/usr/lib/libuv.a -Wl,--whole-archive /v/julia/julia-mingw64/usr/lib/libutf8proc.a -Wl,--no-whole-archive  -LV:\julia\julia-mingw64\usr/lib  -lLLVMSupport -lLLVMDemangle -lpsapi -lshell32 -lole32 -luuid -ladvapi32 -lz -luuid -lole32 -Wl,--export-all-symbols -Wl,--version-script=/v/julia/src/julia.expmap -Wl,--no-whole-archive -lpsapi -lkernel32 -lws2_32 -liphlpapi -lwinmm -ldbghelp -luserenv -lsecur32 -latomic -lssp
```

## mingw32
使用 mingw32 编译 master (7caa499038)
```sh
make O=julia-mingw32 configure
make -C julia-mingw32 -j`nproc`
# throw errors
make -C julia-mingw32
# still throw errors
```

报错
```sh
$ make -C julia-mingw32
make: 进入目录“/v/julia/julia-mingw32”
    LINK julia-mingw32/usr/bin/libjulia-internal.dll
E:/dev/msys64/mingw32/bin/../lib/gcc/i686-w64-mingw32/12.2.0/../../../../i686-w64-mingw32/bin/ld.exe: ./flisp/libflisp.a(flisp.o): in function `strtoull_0b0o':
    V:/julia/src/flisp/read.c:29: undefined reference to `strtoull'
E:/dev/msys64/mingw32/bin/../lib/gcc/i686-w64-mingw32/12.2.0/../../../../i686-w64-mingw32/bin/ld.exe: ./flisp/libflisp.a(flisp.o): in function `isnumtok_base':
    V:/julia/src/flisp/read.c:92: undefined reference to `strtoll'
E:/dev/msys64/mingw32/bin/../lib/gcc/i686-w64-mingw32/12.2.0/../../../../i686-w64-mingw32/bin/ld.exe: E:/dev/msys64/mingw32/bin/../lib/gcc/i686-w64-mingw32/12.2.0/../../../../lib/libmingwex.a(lib32_libmingwex_a-mingw_vfscanf.o): in function `_mingw_sformat':
    C:/M/mingw-w64-crt-git/src/mingw-w64/mingw-w64-crt/stdio/mingw_vfscanf.c:1081: undefined reference to `strtoll'
E:/dev/msys64/mingw32/bin/../lib/gcc/i686-w64-mingw32/12.2.0/../../../../i686-w64-mingw32/bin/ld.exe: C:/M/mingw-w64-crt-git/src/mingw-w64/mingw-w64-crt/stdio/mingw_vfscanf.c:1083: undefined reference to `strtoull'
collect2.exe: error: ld returned 1 exit status
make[1]: *** [/v/julia/src/Makefile:367: /v/julia/julia-mingw32/usr/bin/libjulia-internal.dll] Error 1
make: *** [/v/julia/Makefile:91: julia-src-release] Error 2
make: 离开目录“/v/julia/julia-mingw32”
```

## cygwin
```sh
make O=julia-cyg configure
echo 'XC_HOST = x86_64-w64-mingw32' > julia-cyg/Make.user
make -C julia-cyg -j 6
```

无报错
