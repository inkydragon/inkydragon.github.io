
# 构建步骤
```sh
# v1.8.3
make O=julia-wsl configure
make -C julia-wsl/ -j4
```

## 构建目标顺序
你可以逐个构建这些目标，便于观察每一步的动作。

- `julia-deps`
- `julia-stdlib`
- `julia-base`
- `julia-cli-release`
- `julia-src-release`
- `julia-sysimg-release`
- `julia-base-cache`


## `make -C julia-wsl/  julia-deps`
等价于 `make -C julia-wsl/deps/`

path: `deps\Makefile`
此 makefile 文件大部分的内容在做条件判断，是使用系统的，还是 julia 编译的依赖。
makefile 的末尾有很多的 `include`，每一个单独导入的 `.mk` 文件负责构建一个指定的依赖。

总的来说大部分的依赖由 `BinaryBuilder.jl` 提前预编译好了，执行 `make` 时，只需下载预编译的工件。
少部分依赖需要现场编译。

下载缓存文件夹：`deps\srccache`

### 直接下载
BinaryBuilder 预编译的依赖会直接下载、解压到 `julia-wsl\usr\`

预编译使用的编译脚本，通过依赖名在 BB 的编译配置 repo 中查找： https://github.com/JuliaPackaging/Yggdrasil

举例：
- libblastrampoline：https://github.com/JuliaPackaging/Yggdrasil/blob/master/L/libblastrampoline/build_tarballs.jl
- curl：https://github.com/JuliaPackaging/Yggdrasil/blob/master/L/LibCURL/common.jl

### 源码编译
需要从源码编译的依赖
- `utf8proc`
- `libwhich`
- `patchelf`

源码解压、构建的文件夹在 `julia-wsl\deps`


## `make -C julia-wsl/  julia-stdlib`
等价于 `make -C julia-wsl/stdlib/`

path: `stdlib\Makefile`

很多的 julia 标准库已经移出 julia 的主 repo 了，所以需要下载。
还有一些标准库有二进制依赖，也需要下载。

julia 的包分为两种
- 普通的只有源代码的包，以 `.jl` 为后缀
- 二进制依赖的薄包装，通常是自动生成的，以 `_jll.jl` 为后缀

举例：`LibCURL.jl`, `LibCURL_jll.jl`

### 待下载的标准库
在 `julialang/julia` 之外，需要下载的**标准库列表**：
> `make -C julia-wsl/stdlib/ print-STDLIBS_EXT`

`Pkg Statistics LibCURL Downloads ArgTools Tar NetworkOptions SuiteSparse SparseArrays SHA`

- 版本号（commit）由对应的 `stdlib\*.version` 文件指定
- 下载缓存路径：`SRCCACHE = stdlib\srccache`
- 安装路径：`julia-wsl\stdlib`

## 待下载的 JLL 二进制依赖
> `make -C julia-wsl/stdlib/ print-JLL_NAMES`
```
MozillaCACerts_jll dSFMT_jll GMP_jll LibCURL_jll LibGit2_jll libLLVM_jll LibSSH2_jll LibUV_jll MbedTLS_jll MPFR_jll nghttp2_jll libblastrampoline_jll OpenBLAS_jll OpenLibm_jll p7zip_jll PCRE2_jll SuiteSparse_jll Zlib_jll LLVMLibUnwind_jll CompilerSupportLibraries_jll LibUnwind_jll
```

- 对应的薄包装已经位于 `stdlib\` 文件夹中了
- 版本号由对应的 `stdlib\*_jll\Project.toml` 指定
- 下载后解压安装到 `julia-wsl\usr\`

## 依赖的用途

参见 THIRDPARTY.md 里的说明


## `make -C julia-wsl/  julia-base`
等价于 `make -C julia-wsl/base/`

创建了很多符号链接，生成了一些包含常量的 `.jl` 文件。

## `make -C julia-wsl/  julia-cli-release`
等价于 `make -C julia-wsl/cli/ release`

构建 cli 和 loader

## `make -C julia-wsl/  julia-src-release`
等价于 `make -C julia-wsl/src/ release`

构建 julia 的核心。

构建顺序
- `julia/src`
- `julia/src/support`
- `julia/src/flisp`

## `make -C julia-wsl/  julia-sysimg-release`
> Warn: 我不太了解这一步，可能叙述的不够准确。

执行 `sysimage.mk` 构建系统镜像。将 Base+stdlib 的 jl 文件编译为二进制。

这一步还会生成 REPL 的预编译语句，并执行。


## `make -C julia-wsl/  julia-base-cache`

> Write the sys source cache in format readable by Base._read_dependency_src
> —— `etc\write_base_cache.jl`
