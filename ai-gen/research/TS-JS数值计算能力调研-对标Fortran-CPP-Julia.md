---
unlisted: true
authors: claude-code
tags: [ai, research, programming-languages, typescript, javascript, numerical-computing]
---

# TypeScript/JavaScript 数值计算：能力、差距与改进潜力 —— 对标 Fortran/C++/Julia

> 承接 [[AI时代数值计算编程语言选择.md]] 和 [[AI时代数值计算语言改造基础选择.md]] 的讨论——在讨论了"AI 时代怎么选数值计算语言"和"哪个语言基底最适合被改造"之后，本文聚焦一个具体问题：
>
> **TypeScript 本身对数值计算的支持有多少？是否存在改进的空间，对比 Fortran、C++、Julia 等语言的差距在哪里？**
>
> 调研涵盖：JS/TS 数值库生态、TS 类型系统限制、JS 引擎 JIT 优化天花板、WebAssembly 桥梁、Fortran/C++/Julia 优势分析、WebGPU GPU 计算、TC39 提案进展、TS→原生编译方案。
>
> **讨论日期：2026-07-08**

---

## 1. TL;DR

JS/TS 的数值计算生态正处于快速成长期，但距 Fortran/C++/Julia 仍有**结构性差距**。WebAssembly + SIMD 已将计算密集型工作负载的差距从 50-100x 缩小至 1.3-2.5x（服务端最高可达原生 90%+）；numpy-ts、jax-js 等新库在浏览器中实现了 NumPy 级 API 覆盖率与 7000+ GFLOPS 的 WebGPU 性能；Static Hermes 和 LLTS 证明了**带类型标注的 TS 可达原生 C++ 同等性能**。然而，JS 语言语义从根本上限制了编译器优化空间——无运算符重载、无 no-alias 保证、无值类型、无 256-bit SIMD 路径——这些并非 JIT 质量问题，而是语言设计问题。JS/TS **不是通用 HPC 语言**，但在浏览器端交互式数值应用、ML 推理、教育/可视化等领域已具备独特且不可替代的优势。

## 2. JS/TS 数值计算现状

### 2.1 核心库生态（2025-2026）

| 库 | 定位 | 亮点 | 局限 |
|---|---|---|---|
| **numpy-ts** (v1.5.0) | NumPy 浏览器平替 | Zig 编译 WASM SIMD，93.9% API 覆盖，平均 1.25x 快于 NumPy，零依赖 | 一人项目，社区小 |
| **jax-js** (v0.1.16) | JAX 风格的浏览器编译框架 | jit/grad/vmap，WebGPU 核融合，M4 Max 上 7000+ GFLOPS，80KB gzip | 需 WebGPU，浏览器覆盖率受限 |
| **stdlib-js** (v0.4.1) | 最雄心勃勃的 NumPy+SciPy 复制 | TypedArray 构造器、BLAS 绑定、35+ 概率分布、含 C 实现的热路径 | 精度保证牺牲了速度（exp 慢 189%），生态仍不完整 |
| **TensorFlow.js** (v4.x) | 浏览器 ML | WebGL/WebGPU 后端、自动微分、预训练模型 | 仅限 ML，非通用数值库 |
| **math.js** (v15.2.0) | 通用数学库 | 大整数、复数、矩阵、单位、符号计算、表达式解析器 | 性能中等，不适合大规模计算 |
| **ndarray** (scijs) | 模块化多维数组 | 分层视图避免拷贝，TypedArray 底层存储 | 散装生态，需手动组装管道 |
| **numpy-node** | Node.js 原生 BLAS | C++ N-API，macOS Accelerate / Linux OpenBLAS，SVD/QR/LU/Cholesky | 仅 Node.js |
| **jsndarray** | Go-WASM 数值库 | Go 写 WASM 核，SVD/QR/LU/Cholesky/FFT/卷积 | 调用开销 |

### 2.2 功能覆盖矩阵

| 领域 | 现状 | 关键缺失 |
|---|---|---|
| **线性代数** | ✅ 较完善 | numpy-ts/numpy-node/jsndarray 分别提供 SVD/QR/LU/Cholesky，但无统一标准 |
| **FFT** | ⚠️ 新兴 | numpy-ts 通过 WASM 支持，jsndarray 支持，但不如 FFTW/MKL 成熟 |
| **统计** | ⚠️ 分散 | stdlib-js 覆盖分布函数，远不及 SciPy 广度 |
| **优化 (optimize)** | ❌ 空白 | **无通用优化库**，仅 TF.js 有 SGD/Adam（仅 ML 场景） |
| **ODE/积分 (integrate)** | ❌ 空白 | 仅有散落的 `ode-rk4` 等小包，无 SciPy 替代品 |
| **插值 (interpolate)** | ❌ 碎片化 | ndarray-linear-interpolate 等分散模块 |
| **信号处理 (signal)** | ❌ 薄弱 | 从底层组装，无统一方案 |
| **稀疏矩阵** | ❌ 极少 | 仅 math.js SparseMatrix，无稀疏求解器 |
| **空间算法 (spatial)** | ❌ 空白 | 无 KDTree、凸包、Delaunay 三角剖分 |
| **自动微分** | ✅ 有 | TF.js 和 jax-js 均支持，但仅限 ML 框架内 |
| **GPU 加速** | ✅ 可用 | WebGPU (CR)、WebGL、jax-js、WgPy |

### 2.3 性能层级

```
原生 C/C++/Rust (SSE/AVX/NEON)            ████████████████████ 1.00x
Wasmtime/Wasmer + SIMD + wide_arithmetic   ██████████████████▌  0.70–0.95x
浏览器 Wasm + SIMD                          ██████████████▊     ~0.69x
浏览器 Wasm 标量                             ████████████▌       ~0.65x
高度优化 JS (单态 TypedArray + SoA)          ████▌               ~0.02–0.10x
典型 JS 数值代码                             ██                  <0.01x
朴素 JS                                     █                   可忽略
```

**关键数据点**：
- Wasm SIMD 向量加法达 **154 GB/s**（手动展开），纯 JS 为 15 GB/s
- DuckDB-WASM 在 TPC-H 查询上比纯 JS 快 **10-30x**
- jax-js 在 Apple M4 Max 上达到 **7000+ GFLOPS**
- numpy-ts **平均比 Python NumPy 快 1.25x**（7200 个基准）
- Pyodide 优化 NumPy 达到原生 **90-95%** 速度

## 3. 与 Fortran/C++/Julia 的差距

### 3.1 类型系统

| 维度 | Fortran | C++ | Julia | JS/TS |
|---|---|---|---|---|
| **原生数值类型** | `integer(4)`, `real(8)`, `complex` | `int32_t`, `double`, `std::complex` | `Int32`, `Float64`, `Complex{Float64}` | 仅有 `number` (binary64) 和 `bigint` |
| **值类型 / 无装箱** | 是，数组元素直接存储 | 是，`struct` 和 `std::array` 是值类型 | 是，`isbits` 类型 | ❌ 无。TypedArray 在运行时有未装箱存储，但 TS 类型系统视作 `number` |
| **编译时类型级算术** | 编译器原生支持 | 模板元编程（表达式模板） | LLVM 原生类型推断 | ❌ 仅能通过元组/字符串 hack 模拟，限制 ~50 层递归 |
| **运算符重载** | 语言原生（`+`, `*` 等数组运算） | 全面支持 | 全面支持，多重分派 | ❌ TC39 提案已撤回（2023），不太可能复活 |
| **Decimal 支持** | 有限 | 库级 | 原生（`Dec64`） | ❌ TC39 停留在 Stage 1，分裂为 Decimal/Amount 两个提案 |
| **类型擦除** | 编译到机器码，无擦除 | 编译到机器码，无擦除 | JIT 特化，无擦除 | **TS 全部擦除**——`Int8Array` 中的值在 TS 中仍是 `number`，写入 `3.14` 不报警 |

**核心矛盾**：TS 设计目标 #3——"不对生成产物施加运行时开销"——意味着编译时的 `int`/`float` 区分无法改变运行时存储或计算。品牌类型可防止单位混淆（`EUR` vs `USD`），但 `+`、`*` 等运算符完全忽略品牌检查。

### 3.2 性能

这里列出的是**结构性差距**，而非 JIT 实现质量差距：

| 差距 | 来源 | 量级 | 根本原因 |
|---|---|---|---|
| **无别名保证** | Fortran 默认 no-alias | 部分情况下 **26x** | JS 每个对象引用都可能指向任何地方；V8 必须发射形状守卫、去优化检查 |
| **无自动向量化** | V8 不向量化 JS 循环 | **4-10x** | 动态类型系统无法在编译时提供安全类型推断和内存别名分析 |
| **无表达式模板/循环融合** | C++ Eigen 风格 | 3-5x（复合表达式） | JS `a + b` 立即求值，无法构建惰性表达式树；运算符重载已撤回 |
| **GC 暂停** | GC 堆上的 TypedArray 后备存储 | 不可预测（>100ms 暂停） | Wasm 线性内存不受 GC 影响；Fortran/C++ 无 GC |
| **去优化悬崖** | 类型不稳定性 | 2-100x | 一次类型变更触发：编译→执行→类型意外→去优化→重编译 |
| **寄存器压力** | 引擎保留寄存器 | 1.4-2.0x | 加载多 2.02x，存储多 2.30x（对比原生） |
| **128-bit SIMD 上限** | 无 256/512-bit SIMD | 内存带宽受限内核 2-4x 潜在差距 | Flexible Vectors 提案停滞；浏览器中无法利用 AVX2/AVX-512 |
| **线程开销** | Web Worker 创建开销 | 动态并行受限 | 固定线程池大小，实例每线程模型 |

**2025 年波茨坦大学 HPC 基准**（归一化到 Julia app）：

| 语言/编译器 | 归一化运行时间 | 归一化能耗 |
|---|---|---|
| C (icx) | 1.20 | 1.20 |
| Fortran (ifx) | 1.73 | 1.51 |
| C++ (icpx) | 1.89 | 1.81 |
| Fortran (gfortran) | 2.86 | 2.26 |
| Julia (pkg) | 13.32 | 10.66 |

**重要说明**：编译器选择的影响大于语言选择——Intel icx 与 gfortran 之间有 2.4x 差异。JS/TS 未能进入此基准，但通过 Static Hermes 已经在小规模基准（光线追踪）实现 **与原生 C++ 同等性能**。

### 3.3 生态

| 生态维度 | Fortran/C++/Julia | JS/TS |
|---|---|---|
| **统一数组标准** | LAPACK/BLAS → NumPy → SciPy（Python 生态清晰） | 无统一标准。TensorFlow.js / ndarray / mathjs / numpy-ts / stdlib-js 各用各的 |
| **核心库维护者** | 领域科学家（Fortran 社区）、学术贡献者（Eigen）、SciML 团队（Julia） | 主要为个人/小团队；numpy-ts 和 jax-js 均是一人项目 |
| **社区成熟度** | NumPy ~20 年、Eigen ~15 年、Julia SciML ~8 年 | 多数库 <3 年，math.js 最老（~12 年） |
| **文档与问答** | 数千篇 Stack Overflow、专著、课程 | 有限；stdlib-js 在 HPSFCon 2026 才开始引起 HPC 圈子注意 |
| **REPL 探索文化** | Jupyter（Python）、Juno/VSCode（Julia） | Observable 最接近但侧重可视化/数据，非数值探索 |

### 3.4 编译器优化能力

Fortran、C++ 和 Julia 在编译器层面的优势并非来自更聪明的优化器，而是来自**语言语义允许编译器看到更多信息**：

| 编译器需要看到的信息 | Fortran/C++/Julia 如何提供 | JS/TS 为什么无法表示 |
|---|---|---|
| "这些数组不重叠" | Fortran 默认 no-alias；C `restrict` | 每个 `ArrayBuffer` 引用可能指向任何地方 |
| "此循环无副作用" | `do concurrent`、`constexpr`、类型稳定推断 | 属性访问可能触发 Proxy、getter、原型链遍历 |
| "此表达式可以一次遍历完成" | 表达式模板（编译时惰性求值） | `a + b` 立即求值；无惰性表达式的表示层 |
| "此函数总是返回 Float64" | 静态返回类型 | JS 函数可以返回任何东西；无运行时返回类型契约 |
| "这些运算是可交换/可结合的" | 编译器了解 `+`、`*` 的代数性质 | `+` 在对象上调用 `valueOf()`/`Symbol.toPrimitive`；无代数法则 |

**Static Hermes 的启示**——光线追踪基准测试展示了类型信息的分层效应：
1. 无类型 Hermes 字节码：1300ms
2. 添加类型注解：350ms（**3.7x**）
3. 类型 + 内联：210ms（**6.2x**）
4. 类型 + 内联 + 对象消除：120ms（**10.8x，达到原生 C++ 同等性能**）

关键洞察：**提升性能的不是"编译"，而是利用类型信息进行优化的能力**。

## 4. 正在进行的改进

### 4.1 TC39 提案现状

| 提案 | 阶段 | 状态 | 对数值计算的影响 |
|---|---|---|---|
| **Decimal / Decimal128** | Stage 1 | 分裂为多个提案；2026.06 有活跃草案 | 原生高精度十进制（金融），但距落地至少 2-3 年 |
| **Amount** (单位+精度) | Stage 2.7 | 活跃推进 | 比 Decimal 简单，可能先落地；仅格式化/转换，无算术 |
| **Structs / Shared Structs** | Stage 2.7 | 活跃但缓慢；上次推送 2024.04 | **数值计算最重要的活跃提案**——固定布局对象，类似 WasmGC 的 JS 映射，实现无形状多态的数据布局 |
| **运算符重载** | **已撤回** (2023.11) | 已死。引擎实现者表示"不可能不降低每个 JS 程序的性能" | 向量/矩阵自然语法的希望彻底破灭 |
| **SIMD.js** | **已撤回** | 已死。委员会认为 WebAssembly 更合适 | 使用 Wasm SIMD 替代 |
| **Records & Tuples** | **已撤回** (2025.04) | 已死。深度相等性能不切实际 | 探索 `Object.isEqual()` 替代方案 |
| **Math.clamp** | Stage 2 (2025.05) | 活跃 | 小改进 |
| **SeededPRNG** | Stage 2 (2025.05) | 活跃 | 可复现随机数 |

**时间线预估**：Structs 不早于 2027-2028；Decimal 不早于 2028-2029。短期内（2-3 年）JS 语言层面的数值改进将极为有限。

### 4.2 WebAssembly 进展

**已实现**：
- **Fixed-width SIMD 128** (Phase 5)：全浏览器支持，2-4x DSP 加速，3.94x 图像卷积加速
- **Relaxed SIMD** (Phase 5, Wasm 3.0)：硬件 FMA、整数点积、BF16 点积，消除模拟开销
- **Threads & Atomics** (Phase 4)：Web Worker + SharedArrayBuffer，4 线程图像处理 ~4x 加速
- **wide_arithmetic** (Phase 3)：128 位整数运算，使 Wasmer 从 2.08x 降到 1.33x 原生

**进行中**：
- **Shared-Everything Threads** (Phase 2)：真正的共享内存线程，将缩小动态并行差距
- **Wasm GC** (Wasm 3.0)：对托管语言有益，但对数值代码不适用——堆对象对 JS 不可见，多字节读取效率差 4x

**停滞**：
- **Flexible Vectors** (Phase 1-2)：256/512-bit SIMD，浏览器中无法利用 AVX2/AVX-512

**运行时性能排名**（libsodium 算术密集型，2026.06）：

| 运行时 | 最佳构建 | 对比原生减速 |
|---|---|---|
| Wasmer 7.1.0 | +wide_arithmetic | **1.33x** |
| WAVM nightly | 基线 | ~1.41x |
| Wasmtime 46.0.0 | +wide_arithmetic | **1.46x** |
| WAMR 2.3.1 AOT | 基线 | 1.57x |
| WasmEdge AOT | 基线 | 1.74x |
| Node 26.3.1 | 基线 | 7.95x |
| Bun 1.3.14 | 基线 | 8.77x |

**最佳运行时的选择比任何其他决策都重要——差距高达 6.6x。**

### 4.3 GPU 计算

WebGPU 已于 2026 年达到 W3C **Candidate Recommendation**，全主流浏览器支持（Chrome v113+、Safari v18+、Firefox v141+），全球覆盖率 ~95%。

**性能指标**：
- 矩阵乘法：376 GFLOPS (webgpu-blas, 4096x4096)、1+ TFLOPS（优化核, M2 Pro）、7000+ GFLOPS (jax-js, M4 Max)
- 约**50% 慢于原生 CUDA**（优化内核），但对较少优化的内核有竞争力
- Firefox 比 Chrome **慢 ~10x**（全平台）；Linux 比 Windows/macOS **慢 ~10x**

**关键限制**：
- 无可移植的 f64 硬件支持；f16 需 `shader-f16` 特性检测
- 浮点和的求和次序随工作线程调度变化——非确定性
- 安全限制：maxStorageBufferBindingSize 128MB、workgroup 共享内存 16KB、无 subgroup、无 wave 指令

### 4.4 编译到原生

| 方案 | 路径 | 对标 C++ 的性能 | 状态 |
|---|---|---|---|
| **Static Hermes** | 类型化 JS → ARM64/x86 原生 | 光线追踪: **1.0x**（与 C++ 完全同等） | 实验性 (`static_h` 分支) |
| **LLTS** | TS → LLVM IR → 原生 | 浮点密集型: **~1.0x**（8/5 个基准中胜出） | v0.1.0 (2026.02) |
| **AssemblyScript** | TS 子集 → Wasm | **慢 4-10x**（对比 C/C++） | 生产可用 |
| **Porffor** | JS → Wasm → C → 原生 | 无公测数值数据；冷启动比 Node 快 12x | 预 Alpha (~59% Test262) |
| **Bun** (`--compile`) | JS/TS → 字节码 + JSC 运行时 | 无本质提升（仍是 JIT） | 生产可用 |

**关键结论**：Static Hermes 和 LLTS 证明了**带健全类型标注的 TypeScript 可以在小规模实现原生 C++ 同级性能**，但这依赖于**改变语言语义**（健全类型 → RangeError 替代 undefined；无 GC → 编译时引用计数）。

## 5. 改进空间与可行路径

按可行性与影响力排序：

### 5.1 高影响力 + 短期可行（1-2 年）

| 路径 | 描述 | 已有先例 | 对生态的影响 |
|---|---|---|---|
| **Ndarray 互操作标准** | 统一的 `__array_interface__` 协议，借鉴 Python 的 `__array_interface__`/DLPack | Python 生态证明此模式极其成功 | 消除库之间的数组拷贝；TensorFlow.js、ndarray、mathjs、numpy-ts 可共享缓冲区 |
| **语言级数组原语** | `Float64Array.prototype.matmul`、`.dot`、`.axpy` 作为规范定义的引擎优化内在函数 | V8 已经对 `Math` 函数有此模式 | 绕过表达式模板问题——不尝试让 `a * b` 编译为融合循环，而是让操作本身成为语言原语，V8/SpiderMonkey/JSC 各用自己的代码生成绩效 |
| **Wasm SIMD 库工厂** | 建立 BLAS/LAPACK 核心函数的预编译 Wasm 库分发渠道（类似 Pyodide 的 wheel 分发） | Pyodide、numpy-ts、jax-js 都证明了此路径有效 | 让 JS 库作者无需自己编译 Wasm——引用 CDN 托管的预编译 BLAS kernel 即可 |
| **GPU.js 重振或 WebGPU 通用计算库** | 一个 GPU.js 的精神继承者，原生 WebGPU 后端，自动 JS→WGSL 转译，融合 kernel | jax-js 的 `jit()` 模式可参考 | 填补 GPU.js 停滞后的空白，让非 ML 的 GPU 计算（科学计算、物理模拟）易于接入 |

### 5.2 中期可投入（2-4 年）

| 路径 | 描述 | 依赖 |
|---|---|---|
| **Static Hermes 开放给通用 JS** | 将 Static Hermes 的类型化原生编译从 React Native 语境中解放出来，使其成为通用的 "类型化 JS → 原生" 工具链 | 需要 Meta 投入或社区分支；健全类型的 TypeScript 编码规范需要形成 |
| **LLTS 达到 v1.0 生产可用** | 引用计数优化（当前 fib 慢 2x）、GC 集成（当前无 GC）、Node.js 互操作 | 社区采纳、LLVM 版本稳定性 |
| **Shared-Everything Threads 落地** | 真正的共享内存线程 → 动态并行（TBB/OpenMP 风格的工作窃取调度）、Wasm-JS 线程间零拷贝 | Wasm Phase 4 标准化 |
| **完善 JS 的科学计算上层生态** | `scipy-js`：优化、积分、插值、信号处理、空间算法。可以从现有的 Wasm 原语组装 | Ndarray 互操作标准 + Wasm 预编译内核 |

### 5.3 长期结构性改变（5+ 年）

| 路径 | 描述 | 可能性 |
|---|---|---|
| **Structs 落地** | 固定布局对象 → 引擎消除形状守卫 → 寄存器分配模式接近 Fortran 编译器 | 提案在 Stage 2.7，**至少 2027-2028** |
| **Decimal128 标准化** | 原生十进制算术 → 金融、国际货币转换 | 提案停留在 Stage 1，**至少 2028-2029** |
| **值类型 + 数字专用运算符重载复活** | 仅限数字场景的最小化运算符重载（`+`、`-`、`*`、`/` 仅对 struct value types）→ 惰性表达式求值 | **极低**。原提案 2023 年撤回，委员会认为不可能不影响全局性能 |
| **Flexible Vectors 复活** | 256/512-bit SIMD → 利用 AVX2/AVX-512 → 内存带宽束缚内核受益 | **低**。生态已转向固定 128-bit + Relaxed SIMD |

### 5.4 不推荐的方向

- **复制 NumPy**：JS/TS 有 Python 生态无法复制的独特优势——浏览器端可视化（D3.js、WebGL、WebGPU）、CDN 即时加载、实时交互。目标是**计算原语**（computational primitives），不是生态克隆。
- **在纯 JS 中追求 HPC 性能**：语言语义决定了编译器优化天花板。Wasm 是更实际的路径。
- **等待 TC39 拯救数值计算**：Structs 还需 2-3 年，Decimal 更久。短期内改进主要来自 Wasm 和编译工具链。

## 6. 结论

### TS 是否是可行的数值计算语言？

**分层回答**：

1. **作为"粘合剂"和交互层** —— **是，且是唯一选择**。JS/TS 在浏览器中拥有无可替代的优势：零安装、即刻可用、原生可视化（D3/WebGL/WebGPU/Canvas）、用户交互、CDN 分发。科学计算 Notebook（Observable）、教育工具（math.js）、SQL 数据分析（DuckDB-WASM）、ML 推理（WebLLM）——这些场景 JS/TS 不仅可行，而且是最佳选择。

2. **作为"计算引擎"语言** —— **有条件可行**。通过 Wasm SIMD + WebGPU，浏览器中的数值计算已达到原生的 65-95%。numpy-ts 证明了 Wasm SIMD 可以匹敌原生 NumPy；jax-js 证明了 WebGPU 可以提供 TFLOPS 级性能。关键在于：**热路径用 Wasm，而非纯 JS 手写**。

3. **作为"通用 HPC 语言"** —— **否，且短期内不会改变**。缺少 no-alias 语义、无运算符重载、无自动向量化、无 256-bit SIMD——这些都是**语言设计层面的限制**，而非 JIT 质量或库覆盖面的问题。Fortran/C++/Julia 在 HPC 领域的主导地位在可预见的未来不会被挑战。

### 需要哪些改变才能使其可行？

| 改变 | 所需层面 | 难度 |
|---|---|---|
| 健全的静态数值类型 | TS 语言设计 / Static Hermes 风格的类型窄化 | **高**——与 TS 类型擦除理念冲突 |
| 运算符重载（数值专用） | TC39 | **极高**——2023 年已被明确否决 |
| 语言级 no-alias 保证 | TC39 + 引擎 | **极高**——与 JS 动态对象模型冲突 |
| 统一的 Ndarray 互操作协议 | 社区标准化 | **低-中**——先例充分，需社区共识 |
| 引擎对数值 Pattern 的自动向量化 | V8/SpiderMonkey/JSC | **中-高**——需要突破类型推断限制 |
| Stable SIMD 路径（Wasm 256-bit）| WebAssembly CG | **中**——Flexible Vectors 提案停滞 |

### 最终判断

JS/TS 正在成为**浏览器端数值计算的最佳平台**——不是因为它比 Fortran/C++ 快（它不快），而是因为它融合了"够用的计算性能 + 不可替代的可视化和交互能力"。Wasm 已将计算差距从 50-100x 缩小到 1.3-2.5x，WebGPU 提供了 TFLOPS 级并行算力，numpy-ts 和 jax-js 证明了 API 覆盖率可以接近 100%。

但是，JS/TS **不能**、也**不应**尝试成为通用 HPC 语言的替代品。它不需要赢 Fortran 或 C++——它只需要在**自己的主场**（浏览器、交互式应用、教育、可视化、ML 推理）提供足够好的数值计算能力。从这个标准来看，2025-2026 年的进展是令人鼓舞的：生态正在成熟，差距正在缩小，而 JavaScript 独特的交付和交互优势是任何其他语言无法复制的。
