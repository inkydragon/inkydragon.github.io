# Using `libffi` to replace LLVM at runtime

https://github.com/JuliaLang/julia/pull/41936

> The only parts of the language that actually need the compiler are ccall, cfunction and llvmcall.  
> For call and maybe cfunction [libffi](https://github.com/libffi/libffi) might provide an LLVM less solution  
> _Originally posted by `@vchuravy` in https://github.com/JuliaLang/julia/issues/41936#issuecomment-908922141_

> re-implement _ccall_ via _libffi_ maybe a nice move.  
> I tried Julia 1.8.0 (2021-12-06)  Commit 30fe8cc2c1*, and found there exists such a dependency chain:  
> LinearAlgebra --> Linearlibblastrampoline_jll --> OpenBLAS_jll -->  ccall --> compiler  
> which makes LLVM a must-have library at runtime.
>
> _Originally posted by `@pemryan` in https://github.com/JuliaLang/julia/issues/41936#issuecomment-987665320_
