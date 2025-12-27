debug version

test target
```md
all default
## Stdlib
stdlib 
ArgTools Artifacts Base64 CRC32c Dates DelimitedFiles Distributed Downloads FileWatching Future InteractiveUtils LazyArtifacts LibCURL Libdl LibGit2 LinearAlgebra Logging Markdown Mmap NetworkOptions Pkg Printf Profile Random REPL Serialization SHA SharedArrays Sockets SparseArrays Statistics SuiteSparse Tar Test TOML Unicode UUIDs 
CompilerSupportLibraries_jll dSFMT_jll GMP_jll libblastrampoline_jll LibCURL_jll LibGit2_jll libLLVM_jll LibSSH2_jll LibUnwind_jll LibUV_jll LLVMLibUnwind_jll MbedTLS_jll MozillaCACerts_jll MPFR_jll nghttp2_jll OpenBLAS_jll OpenLibm_jll p7zip_jll PCRE2_jll SuiteSparse_jll Zlib_jll 
## runtests testdefs
read reduce cmdlineargs precompile stacktraces triplequote iobuffer reinterpretarray threadpool_use arrayops client corelogging sysinfo show threadpool_latency exceptions path checked fastmath complex ranges deprecation_exec math copy goto iterators threads_exec bitset ccall sorting syntax threads hashing channels numbers spawn cartesian rational intrinsics subtype atexit interpreter test_sourcepath secretbuffer int rounding combinatorics stress_fd_exec enums euler mod2pi asyncmap intfuncs profile_spawnmany_exec specificity test_exec bitarray choosetests some boundscheck worlds broadcast meta docs float16 ordering osutils stress iostream namedtuple env core dict binaryplatforms error download_exec atomics download gmp loading reducedim floatapprox print_process_affinity file parse misc tuple reflection abstractarray staged char llvmcall2 mpfr backtrace smallarrayshrink vecelement errorshow missing operators boundscheck_exec keywordargs simdloop functional offsetarray floatfuncs testenv stack_overflow version regex llvmcall ryu subarray sets ambiguous filesystem generic_map_tests opaque_closure  
## group
compiler
compiler/AbstractInterpreter compiler/effects compiler/inference compiler/validation compiler/interpreter_exec compiler/codegen compiler/contextual compiler/inline compiler/ssair compiler/irpasses compiler/irutils
strings
strings/io strings/util strings/search strings/types strings/basic
unicode
unicode/utf8
```

```jl
ccall(:jl_is_debugbuild, Cint, ()) != 0
```

```jl
Error During Test at /mnt/v/julia/test/testdefs.jl:21
  Got exception outside of a @test
  LoadError: could not load library "libjulia-codegen"
  libjulia-codegen.so: cannot open shared object file: No such file or directory
  Stacktrace:
    [1] dlopen(s::String, flags::UInt32; throw_error::Bool)
      @ Base.Libc.Libdl ./libdl.jl:117
    [2] dlopen (repeats 2 times)
      @ ./libdl.jl:116 [inlined]
    [3] dlpath(libname::String)
      @ Base.Libc.Libdl ./libdl.jl:240
    [4] (::Main.Test98Main_compiler_codegen.var"#36#38")(pfx::String)
      @ Main.Test98Main_compiler_codegen /mnt/v/julia/test/compiler/codegen.jl:681
    [5] mktempdir(fn::Main.Test98Main_compiler_codegen.var"#36#38", parent::String; prefix::String)
      @ Base.Filesystem ./file.jl:760
    [6] mktempdir(fn::Function, parent::String) (repeats 2 times)
      @ Base.Filesystem ./file.jl:756
    [7] top-level scope
      @ /mnt/v/julia/test/compiler/codegen.jl:679
    [8] include
      @ ./Base.jl:424 [inlined]
    [9] macro expansion
      @ /mnt/v/julia/test/testdefs.jl:24 [inlined]
   [10] macro expansion
      @ /mnt/v/julia/usr/share/julia/stdlib/v1.9/Test/src/Test.jl:1388 [inlined]
   [11] macro expansion
      @ /mnt/v/julia/test/testdefs.jl:23 [inlined]
   [12] macro expansion
      @ ./timing.jl:473 [inlined]
   [13] runtests(name::String, path::String, isolate::Bool; seed::UInt128)
      @ Main /mnt/v/julia/test/testdefs.jl:21
   [14] invokelatest(::Any, ::Any, ::Vararg{Any}; kwargs::Base.Pairs{Symbol, UInt128, Tuple{Symbol}, NamedTuple{(:seed,), Tuple{UInt128}}})
      @ Base ./essentials.jl:803
   [15] (::Distributed.var"#110#112"{Distributed.CallMsg{:call_fetch}})()
      @ Distributed /mnt/v/julia/usr/share/julia/stdlib/v1.9/Distributed/src/process_messages.jl:285
   [16] run_work_thunk(thunk::Distributed.var"#110#112"{Distributed.CallMsg{:call_fetch}}, print_error::Bool)
      @ Distributed /mnt/v/julia/usr/share/julia/stdlib/v1.9/Distributed/src/process_messages.jl:70
   [17] macro expansion
      @ /mnt/v/julia/usr/share/julia/stdlib/v1.9/Distributed/src/process_messages.jl:285 [inlined]
   [18] (::Distributed.var"#109#111"{Distributed.CallMsg{:call_fetch}, Distributed.MsgHeader, Sockets.TCPSocket})()
      @ Distributed ./task.jl:501
  in expression starting at /mnt/v/julia/test/compiler/codegen.jl:679
```


```
Test Summary:                                     |     Pass  Fail  Error  Broken     Total      Time
  Overall                                         | 40426497    20      9  352662  40779188  53m36.7s
    LinearAlgebra/schur                           |      496                            496   1m14.8s
    LinearAlgebra/eigen                           |      512                            512   2m09.7s
    LinearAlgebra/qr                              |     4705                           4705   3m32.6s
    LinearAlgebra/bunchkaufman                    |     5688                           5688   1m16.7s
    LinearAlgebra/svd                             |      566                            566   1m53.9s
    LinearAlgebra/lapack                          |      802                            802   1m00.2s
    LinearAlgebra/special                         |     2942                           2942   7m04.3s
    LinearAlgebra/tridiag                         |     1541                           1541   1m58.8s
    LinearAlgebra/cholesky                        |     2509                           2509   2m45.9s
    LinearAlgebra/dense                           |     8475                           8475  10m55.4s
    LinearAlgebra/matmul                          |     1486                           1486  11m60.0s
    LinearAlgebra/bidiag                          |     4736                           4736   6m44.9s
    LinearAlgebra/lu                              |     1368                           1368   2m55.0s
    LinearAlgebra/generic                         |      630                            630   1m36.5s
    LinearAlgebra/lq                              |     2938                           2938   1m48.8s
    LinearAlgebra/uniformscaling                  |      446                            446   2m33.8s
    LinearAlgebra/adjtrans                        |      347                            347   1m04.2s
    LinearAlgebra/hessenberg                      |      631                            631   2m38.3s
    LinearAlgebra/pinv                            |      500                            500     22.4s
    LinearAlgebra/givens                          |     1847                           1847     15.3s
    LinearAlgebra/blas                            |     1629                           1629   2m32.5s
    LinearAlgebra/ldlt                            |        8                              8      1.3s
    LinearAlgebra/factorization                   |       80                   16        96      8.5s
    ambiguous                                     |      104                    2       106     43.0s
    LinearAlgebra/structuredbroadcast             |      670                            670   2m01.9s
    compiler/effects                              |       30                             30      1.4s
    compiler/validation                           |       28                             28      0.9s
    compiler/ssair                                |       69                             69      7.9s
    LinearAlgebra/symmetric                       |     2847                           2847   7m45.0s
    compiler/irpasses                             |      139                    4       143      8.2s
    compiler/inline                               |      225                    1       226     11.7s
    LinearAlgebra/triangular                      |    37908                          37908  19m01.2s
    compiler/inference                            |     1198                    2      1200     42.8s
    compiler/contextual                           |       12                             12      7.8s
    compiler/AbstractInterpreter                  |       12                             12     14.3s
    compiler/EscapeAnalysis/interprocedural       |       32                    4        36     16.3s
    compiler/codegen                              |      168    13      1               182     48.4s
    compiler/EscapeAnalysis/local                 |      347                   21       368     36.0s
    LinearAlgebra/diagonal                        |     2877                           2877  12m42.8s
    strings/basic                                 |    87693                          87693     25.8s
    strings/search                                |      876                            876     12.0s
    unicode/utf8                                  |       19                             19      0.4s
    strings/io                                    |    12764                          12764      7.6s
    strings/types                                 |  2302691                        2302691      7.7s
    worlds                                        |       88                             88      4.6s
    keywordargs                                   |      151                            151      4.3s
    strings/util                                  |     1147                           1147     25.3s
    atomics                                       |     3448                           3448     44.5s
    char                                          |     1639                           1639      6.2s
    triplequote                                   |       29                             29      0.7s
    intrinsics                                    |      304                            304      6.2s
    subtype                                       |   337681                   19    337700     53.6s
    hashing                                       |    12519                          12519     44.6s
    iobuffer                                      |      209                            209      3.1s
    staged                                        |       65                             65      8.7s
    dict                                          |   144426                         144426   1m03.0s
    numbers                                       |  1584711                    1   1584712   2m23.2s
    tuple                                         |      666                            666     19.2s
    offsetarray                                   |      502                    3       505   1m23.6s
    reduce                                        |     8591                           8591     52.4s
    core                                          |  8445939                    3   8445942   4m09.7s
    intfuncs                                      |   227887                         227887     32.9s
    simdloop                                      |      240                            240      4.2s
    vecelement                                    |      678                            678     13.0s
    rational                                      |    98695                    2     98697     52.6s
    reducedim                                     |     1225                    6      1231   2m43.4s
    copy                                          |      544                            544      5.9s
    subarray                                      |   318323                         318323   7m21.8s
    fastmath                                      |      946                            946     13.3s
    functional                                    |       98                             98     16.2s
    arrayops                                      |     2089                    6      2095   5m30.7s
    operators                                     |    13052                          13052     42.2s
    abstractarray                                 |    57381                24795     82176   4m35.3s
    ordering                                      |       37                             37      5.5s
    math                                          |  1910266                        1910266   2m18.4s
    path                                          |      373                   12       385     13.7s
    parse                                         |    16098                          16098     10.8s
    gmp                                           |     2444                           2444     13.5s
    loading                                       |   143125                         143125   2m29.9s
    LinearAlgebra/addmul                          |     4320                           4320  14m27.4s
    backtrace                                     |       39                    1        40      6.8s
    exceptions                                    |       70                             70      3.3s
    file                                          |     1072                           1072     28.0s
    spawn                                         |      242                    4       246     51.2s
    version                                       |     2453                           2453      2.4s
    namedtuple                                    |      216                            216      7.5s
    iterators                                     |    86614                          86614   5m10.6s
    read                                          |     3812                           3812     51.5s
    mpfr                                          |     1137                    1      1138     34.5s
    floatapprox                                   |       49                             49      3.5s
    complex                                       |     8480                    2      8482     25.0s
    reflection                                    |      425                            425     19.4s
    regex                                         |      142                            142      6.0s
    float16                                       |   762093                         762093     18.4s
    sysinfo                                       |        4                              4      0.3s
    env                                           |       78                             78      1.1s
    combinatorics                                 |      170                            170     19.1s
    rounding                                      |   150016                         150016     17.1s
    mod2pi                                        |       80                             80      1.4s
    euler                                         |       12                             12      3.3s
    sorting                                       |    24191                    9     24200   5m19.1s
    client                                        |        5                              5      3.7s
    errorshow                                     |      247                            247     27.7s
    bitarray                                      |   915299                         915299   8m57.1s
    goto                                          |       19                             19      0.2s
    llvmcall                                      |       19                             19      1.1s
    llvmcall2                                     |       20                             20      0.4s
    ryu                                           |    31215                          31215      4.5s
    some                                          |       72                             72      3.2s
    meta                                          |       69                             69      4.8s
    stacktraces                                   |       48                             48      6.6s
    show                                          |   128892                    8    128900   1m33.0s
    ranges                                        | 12110732               327682  12438414   2m01.6s
    docs                                          |      239                            239     18.4s
    binaryplatforms                               |      341                            341     16.3s
    enums                                         |      100                            100     11.8s
    ccall                                         |     2885            1              2886   7m42.7s
    sets                                          |     3643                    1      3644   1m24.5s
    interpreter                                   |        3                              3     12.1s
    atexit                                        |       40                             40   1m02.2s
    bitset                                        |      195                            195      9.2s
    int                                           |   736188                         736188     31.9s
    checked                                       |     1239                           1239     23.0s
    error                                         |       33                             33      3.9s
    boundscheck                                   |                                    None     22.6s
    osutils                                       |      980                            980      2.2s
    cartesian                                     |      349                    3       352     20.9s
    iostream                                      |       50                             50      3.7s
    secretbuffer                                  |       30                             30      1.8s
    specificity                                   |      175                            175      1.0s
    broadcast                                     |      525                            525   5m10.2s
    misc                                          |  1282187     2                  1282189   2m37.1s
    channels                                      |      256                            256   1m04.7s
    syntax                                        |     1659                    1      1660     42.6s
    corelogging                                   |      235                            235     13.5s
    smallarrayshrink                              |       36                             36      1.1s
    reinterpretarray                              |      420                            420   1m00.0s
    filesystem                                    |        6                              6      0.9s
    opaque_closure                                |       66                    1        67      3.3s
    download                                      |                                    None      6.5s
    SparseArrays/ambiguous                        |        1                              1     23.9s
    asyncmap                                      |      307                            307     38.2s
    missing                                       |      574                    1       575     53.3s
    SparseArrays/sparsematrix_ops                 |      415                            415   2m04.2s
    SparseArrays/linalg                           |     1814                           1814   4m16.8s
    SparseArrays/higherorderfns                   |     7145                    1      7146   5m18.7s
    SparseArrays/issues                           |      326                            326   3m00.5s
    cmdlineargs                                   |      276     1      4       5       286   9m15.1s
    floatfuncs                                    |      232                            232   8m42.6s
    SparseArrays/linalg_solvers                   |      364                            364   1m36.5s
    SparseArrays/spqr                             |       91                             91     26.6s
    Dates/accessors                               |  7723858                        7723858     19.1s
    SparseArrays/umfpack                          |      288                            288   2m15.8s
    Dates/query                                   |     1004                           1004      2.1s
    Dates/adjusters                               |     3149                           3149     11.3s
    Dates/periods                                 |      953                            953     37.9s
    Dates/rounding                                |      315                            315      5.9s
    Dates/ranges                                  |   350639                         350639     37.3s
    Dates/types                                   |      232                            232      3.8s
    SparseArrays/cholmod                          |      611                            611   1m41.5s
    Dates/conversions                             |      160                            160      2.1s
    ArgTools                                      |      180                            180     10.8s
    Dates/arithmetic                              |      385                            385     18.7s
    Dates/io                                      |      332                            332     28.2s
    Base64                                        |     2031                           2031      7.1s
    CRC32c                                        |      664                            664      1.5s
    CompilerSupportLibraries_jll                  |        4                              4      1.1s
    Artifacts                                     |     1452                           1452     20.3s
    DelimitedFiles                                |       89                             89     19.2s
    Future                                        |                                    None      0.1s
    GMP_jll                                       |        1                              1      2.1s
    InteractiveUtils                              |      294            2               296   1m09.2s
    LLVMLibUnwind_jll                             |                                    None      4.0s
    LibGit2/libgit2                               |      760                            760   3m50.7s
    LazyArtifacts                                 |        4                              4      8.1s
    LibCURL_jll                                   |        1                              1      0.9s
    LibCURL                                       |        6                              6      2.7s
    LibSSH2_jll                                   |                                    None      1.2s
    LibUV_jll                                     |        1                              1      1.7s
    LibGit2_jll                                   |        2                              2      3.8s
    LibUnwind_jll                                 |        1                              1      1.7s
    Libdl                                         |       75                    1        76      2.7s
    MPFR_jll                                      |        1                              1      1.2s
    Logging                                       |       40                             40      5.7s
    MbedTLS_jll                                   |        1                              1      0.2s
    FileWatching                                  |      681                            681   2m02.4s
    MozillaCACerts_jll                            |        1                              1      0.1s
    Markdown                                      |      257                            257     10.4s
    OpenBLAS_jll                                  |        1                              1      0.1s
    OpenLibm_jll                                  |        1                              1      1.0s
    NetworkOptions                                |     3518                           3518      2.2s
    PCRE2_jll                                     |        2                              2      1.9s
    Printf                                        |     1017                           1017     24.8s
    Mmap                                          |      140                            140     33.4s
    Downloads                                     |      234     4                      238   2m39.5s
    REPL                                          |     1461                    3      1464   1m02.7s
    SparseArrays/sparsematrix_constructors_indexing |     1830                           1830  12m16.1s
    Serialization                                 |      129                    1       130     12.3s
    SHA                                           |      107                            107   1m15.5s
    SparseArrays/sparsevector                     |    10365                    4     10369   8m08.2s
    SuiteSparse_jll                               |        1                              1      1.2s
    SuiteSparse                                   |                                    None      7.0s
    Sockets                                       |      173                            173     30.8s
    Profile                                       |      113                            113   2m06.2s
    UUIDs                                         |     1029                           1029      1.1s
    Random                                        |   204839                         204839   1m51.0s
    Zlib_jll                                      |        1                              1      2.2s
    Unicode                                       |      795                            795     10.2s
    dSFMT_jll                                     |        1                              1      2.1s
    libblastrampoline_jll                         |        1                              1      0.2s
    nghttp2_jll                                   |        1                              1      1.1s
    p7zip_jll                                     |        1                              1      0.1s
    libLLVM_jll                                   |        1                              1      3.0s
    TOML                                          |      415                    8       423     36.4s
    Tar                                           |     3161                   11      3172     52.7s
    Test                                          |      458                   17       475   1m34.3s
    Statistics                                    |      810                            810   2m25.4s
    precompile                                    |      155                            155   1m27.4s
    SharedArrays                                  |      118                            118     43.9s
    threads                                       |       30            1                31   1m51.1s
    Distributed                                   |       15                             15   6m20.0s
    stress                                        |      118                            118     53.3s
    FAILURE
```
