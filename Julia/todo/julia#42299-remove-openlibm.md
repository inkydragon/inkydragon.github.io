# Remove OpenLibm

issue:
- [Remove openlibm · Issue #26434 · JuliaLang/julia](https://github.com/JuliaLang/julia/issues/26434)

pr:
[Remove dependency on openlibm by ViralBShah · Pull Request #42299 · JuliaLang/julia](https://github.com/JuliaLang/julia/pull/42299)

## 进展

目前的依赖项
- [JuliaMath/SpecialFunctions.jl#344](https://github.com/JuliaMath/SpecialFunctions.jl/pull/344)

目前看为了解决 x86 平台上的问题，建议构建系统迁移至 UCRT
