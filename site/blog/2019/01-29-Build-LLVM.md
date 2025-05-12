---
slug: build-llvm-rel-ver
title: Build LLVM Release Version
date: 2019-01-29 12:01:07
authors: cyhan
tags: 
- LLVM
---
编译 Release 版 LLVM 的命令参数记录

<!-- truncate -->

background
- [关于编译时的目录结构 · Issue #2 · Becavalier/Cinderella](https://github.com/Becavalier/Cinderella/issues/2)

ref
- [Getting Started with the LLVM System — LLVM 9 documentation](https://llvm.org/docs/GettingStarted.html#local-llvm-configuration)


## 编译时的选项

`-D<variable name>=<value>`

- `CMAKE_C_COMPILER=/usr/bin/clang`
    使用 `clang` 编译，内存占用小
- `CMAKE_CXX_COMPILER=/usr/bin/clang++`
    同上
- `CMAKE_BUILD_TYPE=Release`
    编译为 release 版，带优化、空间占用小
- `LLVM_TARGETS_TO_BUILD=host`
    根据平添自动选择架构，减小空间占用

## 编译

配置
```sh
cmake -G "Unix Makefiles" \
-DCMAKE_C_COMPILER=/usr/bin/clang \
-DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
-DCMAKE_BUILD_TYPE=Release \
-DLLVM_TARGETS_TO_BUILD=host \
..
```

编译
`make -j4`
