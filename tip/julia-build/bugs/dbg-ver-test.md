# Some tests failed when testing with debug version

**env**
- build debug version with master branch.
- running tests in WSL2 on Windows


### Errors
- [ ] `compiler/codegen`
```sh
make -j `nproc`  debug
make -C test/  compiler/codegen debug
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

patch: add an if branch `ccall(:jl_is_debugbuild, Cint, ()) != 0`


- [ ] ccall
```jl
# test/ccall.jl#L1097  (issue #15408)
begin
    ccall((:get_c_int, "libccalltest"), Cint, ())
    cglobal((:finalizer_cptr, "libccalltest"))
end
```

- [ ] 