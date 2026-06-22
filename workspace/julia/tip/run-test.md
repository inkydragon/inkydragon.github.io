# Run tests

## Run All test
```sh
cd test/
julia  -t auto -p auto --check-bounds=yes --startup-file=no --depwarn=error ./runtests.jl  
```

## Run Some tests
```sh
cd test/
julia  -t auto -p auto --check-bounds=yes --startup-file=no --depwarn=error ./runtests.jl  Libdl cmdlineargs compiler/codegen misc
```

**all targets**
```sh
# run `make print-TESTS` to see a list of all tests that can be run
cd test/
make print-TESTS
TESTS=all default stdlib unicode strings compiler  abstractarray ambiguous arrayops asyncmap atexit atomics backtrace binaryplatforms bitarray bitset boundscheck boundscheck_exec broadcast cartesian ccall channels char checked choosetests client cmdlineargs combinatorics complex copy core corelogging deprecation_exec dict docs download download_exec enums env error errorshow euler exceptions fastmath file filesystem float16 floatapprox floatfuncs functional generic_map_tests gmp goto hashing int interpreter intfuncs intrinsics iobuffer iostream iterators keywordargs llvmcall llvmcall2 loading math meta misc missing mod2pi mpfr namedtuple numbers offsetarray opaque_closure operators ordering osutils parse path precompile print_process_affinity profile_spawnmany_exec ranges rational read reduce reducedim reflection regex reinterpretarray rounding ryu secretbuffer sets show simdloop smallarrayshrink some sorting spawn specificity stack_overflow stacktraces staged stress stress_fd_exec subarray subtype syntax sysinfo test_exec test_sourcepath testenv threadpool_latency threadpool_use threads threads_exec triplequote tuple vecelement version worlds  unicode/utf8  strings/basic strings/io strings/search strings/types strings/util  compiler/AbstractInterpreter compiler/codegen compiler/contextual compiler/datastructures compiler/effects compiler/inference compiler/inline compiler/interpreter_exec compiler/irpasses compiler/irutils compiler/ssair compiler/validation
```
