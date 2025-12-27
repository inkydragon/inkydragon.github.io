# Build with GC debug flags

## build

Build with debug+assert version:

```makefile
# Make.user
FORCE_ASSERTIONS=1
WITH_GC_VERIFY:=1
```

```c
// options.h
MEMDEBUG
GC_ASSERT_PARENT_VALIDITY
GC_FINAL_STATS
MEMPROFILE
GC_TIME
```

## Test

```sh
usr/bin/julia-debug.exe --threads 1 --gcthreads=1,0 --check-bounds=yes --startup-file=no --depwarn=error ../test/runte
sts.jl gc
```
