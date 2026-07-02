---
unlisted: true
authors: claude-code
tags: [ai, research, programming-languages, formal-verification, numerical-computing]
---

# AI 时代数值计算编程语言选择

> 承接 [[AI时代数值代码的正确性来源.md]] 的讨论——该文论证了在 AI 时代，正确性工程的投资重点应从"怎么写得对"转向"怎么知道它是对的"，判断型资产比代码型资产更值钱。
>
> **本文的核心问题：在这个前提下，编程语言应该如何选择？**
>
> **讨论日期：2026-07-02**

---

## 〇、问题的重新表述

上一个文档给出了正确性锚点的五种类型——规格文本、经验数据、物理约束、高精度 Oracle、对抗一致性——以及 AI 在各层能做什么、不能做什么的分化模式。

如果把语言选择问题放在这个框架下，问题就变成了：

> **哪种语言最能支撑"判断型正确性资产"的构建和维护？**

具体地说，评估维度是：

1. **能否在类型系统中编码不变量？**（L0：编译期保证）
2. **能否方便地挂接独立 Oracle？**（L2：穷举/对照测试）
3. **能否方便地编写属性测试和约束检查？**（L3：约束/性质测试）
4. **能否进行形式化验证？**（L5：形式化验证）
5. **能否实现跨平台确定性？**（使 bit-exact 测试成为可能）
6. **是否有足够大的生态可提供独立参考实现？**（对抗一致性/差分测试）
7. **性能是否足以运行穷举测试？**（binary32 穷举 ≈ 40 亿种输入，需数小时）

而关于 **AI 时代的价值韧性**——产出是否会被大模型进步所取代——答案是：

> **产出的价值不在于代码本身，而在于代码中编码的判断。** 如果你的产出是 AI 可以重新生成的标准实现，它会被取代。如果你的产出是一组精心挑选的 hard-to-round case、一套物理约束的不变量编码、一个独立于实现的 Oracle 构建方法论——这些是 AI 无法取代的，因为它们需要的是**判断**，不是生成。

---

## 一、各语言在正确性维度上的定位

### 1.1 总览矩阵

| 语言 | 类型系统强度 | PBT 生态 | 形式化验证 | 独立 Oracle | 跨平台确定性 | 数值生态 | 性能 |
|------|:----------:|:--------:|:---------:|:----------:|:----------:|:--------:|:----:|
| **Rust** | ★★★★ | ★★★★ (proptest) | ★★★☆ (Kani, Verus) | ★★★★ (MPFR, rug) | ★★★★ | ★★★☆ | ★★★★★ |
| **C/C++** | ★★☆ | ★★☆ (QuickCheck) | ★★★★ (VST, Flocq, Frama-C) | ★★★★★ (MPFR, GMP) | ★★★ | ★★★★★ | ★★★★★ |
| **Ada/SPARK** | ★★★★★ | ★★☆ | ★★★★★ (SPARK Pro) | ★★☆ | ★★★★ | ★★☆ | ★★★★ |
| **Lean 4** | ★★★★★ (依赖类型) | ★☆☆☆ | ★★★★★ (原生) | ★☆☆☆ | N/A (不是执行语言) | ★☆☆☆ | ★★★ |
| **Coq/Rocq** | ★★★★★ (依赖类型) | ★☆☆☆ | ★★★★★ (原生) | ★☆☆☆ | N/A | ★☆☆☆ | ★★☆ (提取到 C) |
| **Julia** | ★★★ | ★★★ (Supposition.jl) | ★★☆ (Satisfiability.jl) | ★★★ | ★★ | ★★★★★ | ★★★★ |
| **Fortran** | ★★☆ | ★☆☆☆ | ★★☆ (F-IKOS, Assert) | ★★★★ | ★★★★ | ★★★★★ | ★★★★★ |
| **TypeScript** | ★★☆ | ★★★★ (fast-check) | ★☆☆☆ | ★★☆ | ★☆☆☆ (引擎差异) | ★★☆ | ★★★ |
| **F★** | ★★★★★ (依赖类型) | ★☆☆☆ | ★★★★★ (原生) | ★☆☆☆ | N/A | ★☆☆☆ | ★★★★ (Low★ 提取) |

### 1.2 关键发现

**没有一种语言在所有维度上都占优。** 但不同语言的"短板"位置完全不同——而这些短板恰好定义了它们的适用场景。

---

## 二、三条路线的深度分析

### 路线 A：形式化优先语言（Lean 4 / Coq / F★）

**核心主张：** 正确性由数学证明保证，代码从证明中提取（extraction）。

**当前状态（2025-2026）：**

- **Lean 4 的浮点形式化严重不成熟。** 没有权威的 IEEE 754 浮点库。Lean 内置 `Float` 是映射到硬件的 opaque 类型——性能好但无法做形式化证明。Mathlib 中的 `FP.Float` 是 Lean 3 时代的遗留，大部分操作标记为 `unsafe`。Flean（IEEE 754 toy library）和 Interval 库存在，但都不权威、不完整。来自 Rocq 的 Flocq 库移植尚未完成。
  - 来源：[Proof Assistants StackExchange — "What is the most accepted library for floats in Lean4?"](https://proofassistants.stackexchange.com/questions/5311/what-is-the-most-accepted-library-for-floats-in-lean4/5313#5313)

- **证明是关于 ℝ 的，不是关于 f32/f64 的。** Lean 可以优雅地证明 `∀ x, exp(x) > 0` 在实数上成立，但无法说明当 `x` 是 `f32` 且 `exp` 由多项式逼近实现时会发生什么。ℝ 不是 f32——溢出、下溢、NaN 传播、舍入误差——这些在 ℝ 层面不可见但在 f32/f64 层面是核心问题。

- **提取性能不适用于数值计算。** Lean 4 编译到 C（通过 Clang/LLVM），使用引用计数，≥64 位的值装箱（pointer indirection）。在 Cedar 策略引擎的 benchmark 中 Lean 与 Rust 性能接近（~5μs vs ~7μs），但这是非数值代码。在数值计算密集场景下，缺少 SIMD、缺少 BLAS 绑定、缺少 GPU 支持——这些都是致命的。
  - 来源：[Lean Zulip — "Mysterious quote suggests that Lean is faster than Rust"](https://leanprover-community.github.io/archive/stream/113488-general/topic/Mysterious.20quote.20suggests.20that.20Lean.20is.20faster.20than.20Rust.html)

- **最成功的实践是双语言架构。** Juniper CAS（2025）在 Rust 中实现，在 Lean 4 中形式化——Lean 定理导出为 JSON → 转换为重写规则 → 在 Rust 中用 egg（equality saturation）使用。这正是规范与实现分离的模式。

**F★ 和 Coq 的情况：**

- **F★ 的 Low★ 子集** 可以提取为性能接近手写 C 的代码，已成功用于 HACL★（验证密码学库，被 Firefox、Linux 内核、Python 使用）。但这是针对**整数/位操作**密集型代码——密码学。数值计算（浮点）不是 Low★ 的强项。

- **Coq/Rocq + Flocq + VST** 是最成熟的浮点形式化验证链条。VCFloat2（CPP 2024）支持自动舍入误差界计算，带机器可查证明，支持所有 IEEE 754 精度。VeriNum 项目使用这套工具验证了稀疏矩阵转换、Jacobi 迭代法、Leapfrog ODE 积分器。但这条路的人力成本极高——每个函数需要博士级的形式化专家。
  - 来源：[VeriNum Project](https://verinum.org/)；[VCFloat2 (CPP 2024)](https://www.cs.princeton.edu/~appel/papers/vcfloat2.pdf)

**判决：** 纯形式化优先语言**不是数值计算实现的正确选择**。它们在规范层和证明层有不可替代的价值，但不能作为数值库的**实现语言**。正确的用法是双语言架构：规范 + 证明在 Lean/Coq，实现在 Rust/C。

---

### 路线 B：工程-形式化兼顾语言（Rust）

**核心主张：** 类型系统提供基线安全，测试和约束检查提供主要正确性保证，形式化验证按需渗透。

**这是 2025-2026 年最务实的数值计算语言选择。** 原因：

**1. 类型系统是 AI 生成代码的第一道安检。** Rust 的所有权模型、trait 系统、`#[deny(unsafe)]`、`clippy::float_cmp` 在编译期拦截了大量 AI 常见错误模式——隐式转换、use-after-free、数据竞争。这在 AI 生成代码量暴增的背景下特别有价值。

**2. 形式化验证工具体系最完整（相对其他系统语言）：**

| 工具 | 方法 | 浮点支持 | 成熟度 |
|------|------|---------|--------|
| **Kani** | Bounded model checking (CBMC) | ✅ 验证实际 f32/f64 代码（含 NaN/Inf/overflow/subnormal） | 生产可用（AWS 用于 Firecracker、s2n-quic） |
| **Verus** | SMT-based (Z3) | ⚠️ 支持 `real` 类型（数学实数），完整 IEEE 754 推理仍在开发中 | 活跃研究阶段 |
| **Creusot** | Deductive (Why3) | 理论支持（Why3 FP theories），实践使用极少 | 研究阶段 |
| **Prusti** | SMT-based (Viper) | ❌ 侧重内存安全和整数正确性 | 成熟 |
| **sorex-lean-macros** | Rust → Lean 4 规格生成 | ✅ 生成 Lean 证明 obligation | 早期（2025） |

Kani 是这里的关键——它是唯一能在有限输入范围内**穷举验证** f32 实现的工具。对于 binary32（~40 亿种输入），Kani 可以在 f32 子范围内做 bounded proof。
- 来源：[Rust Project Goals 2024H2 — Std Verification](https://rust-lang.github.io/rust-project-goals/2024h2/std-verification.html)

**3. 跨平台确定性的可达性。** Rust 不依赖 JIT，相同的 LLVM 后端，可以通过 `-C target-cpu` 锁定指令集。`f32`/`f64` 在 x86_64 和 ARM64 上（均使用 IEEE 754）行为一致。这使 bit-exact 测试成为可能——而 bit-exact 是可判定性的前提。

**4. 差分测试的生态基础。** Rust 可以通过 FFI 调用 glibc libm、Julia Base.Math、CORE-MATH 等，可以用 `rug` crate 绑定 MPFR 作为 oracle，可以通过 `ndarray` 与 Python/NumPy 对标。一个输入喂给五个独立实现——这是对抗一致性的基础设施。

**5. `num-valid` 等新兴 crate** 提供了类型级别的浮点安全性——`RealValidated` 和 `ComplexValidated` 包装器在类型层面保证无 NaN/Inf 传播。96%+ 测试覆盖率。

**关键限制：**

- Kani 做不了完整的 `f64` 穷举验证（$2^{64}$ 太大）。只能做 bounded check 或采样。
- Verus 的 IEEE 754 推理仍然不完整。
- 对于正确的舍入证明（L5），Rust 最终仍需要外部证明助手（Lean/Coq）。这就是 Lean+Kani 组合方法的用武之地。

**判决：** Rust 是当前**数值库实现的最佳单语言选择**。它不提供完整的端到端形式化证明，但提供了**最密集的正确性保证梯度**——从类型系统到 PBT 到 bounded verification 到外部 oracle——每一层的性价比都很好。关键的是，它使你能够构建**判断型资产**（精心构造的 proptest 策略、Kani harness、MPFR 对照测试套件），而这些比实现代码本身更值钱。

---

### 路线 C：快速迭代语言（TypeScript / Python）

**核心主张：** 实现成本低，可以快速试错、重写、替换。

**在 AI 时代这个论点被严重削弱了。** 因为 AI 已经把**所有**语言的实现成本压到了接近零——你不需要一个"快速编写"的语言，因为 AI 可以帮你生成任何语言的代码。你需要的是一种**让错误更难通过、让正确性更容易验证**的语言。

TypeScript 和 Python 在正确性维度上的问题是结构性的：

- **无法表达强不变量。** 没有 refinement types，无法在类型中编码"这个值 ∈ (0, 1)"或"这个数组长度是质数"。Zod 和 io-ts 可以在运行时验证，但不是在编译期。
- **跨平台确定性弱。** 不同 JS 引擎（V8 vs JavaScriptCore vs SpiderMonkey）的 `Math.sin` 实现不同，结果不同。
- **没有形式化验证路径。** 没有等价于 Kani/Verus 的工具。fast-check 提供了优秀的 PBT——但这只在 L3 层。
- **Oracle 独立性成问题。** 如果你的实现在 JS/TS 中，你的 oracle 几乎肯定在另一种语言中（C/Rust/Python）。这本身不是缺点——oracle 本来就该独立——但如果你只是为了"能快速重写"而选择 TS，那么重写后的验证仍然依赖外部 oracle，TS 本身不提供额外的正确性保证。

**TS 有意义的场景：** 作为"正确性测试的快速原型平台"——用 fast-check 快速探索一个算法的性质空间，找到不变量，然后将这些不变量编码到 Rust 的 proptest 中。或者作为"差分测试的编排层"——用 TS 脚本调用多个语言的实现，比较输出。

**判决：** TypeScript 不适合作为数值库的**实现语言**。它可以作为正确性测试的**编排和原型平台**，但这只是辅助角色。

---

### 路线 D：增强领域语言（Fortran / C++ / Julia）

**核心主张：** 这些语言已经有数十年的数值计算生态，不需要从零构建。在它们之上叠加验证工具是务实的进化路径。

**这个路线的可行性取决于你想做什么：**

**如果你在维护/扩展已有的 Fortran/C++ 数值库：** 这是唯一合理的路径。Fortran 最近在验证工具方面有显著进展：

- **F-IKOS**（2024）：基于抽象解释的 Fortran 静态分析器，将 Fortran 转译为 LLVM IR 后做 sound floating-point analysis，可检测除零等运行时错误。
  - 来源：[Fortran Discourse — F-IKOS](https://fortran-lang.discourse.group/t/f-ikos-an-abstract-interpretation-based-static-analyzer-for-fortran-programs/8975/2)
- **Julienne + Assert**（Berkeley Lab，2025）：Fortran 单元测试框架 + 断言框架，支持 coarray 并行特性，已被 DOE、DoD 项目采用。
  - 来源：[Berkeley Lab Computing Sciences](https://cs.lbl.gov/news-and-events/news/2025/software-highlight-julienne-and-assert-strengthen-fortran-code-reliability/)
- **Formal DSL**（Berkeley Lab，v0.1）：嵌入 Fortran 的 mimetic 离散化 DSL，为 Fortran 202Y 的类型安全模板打基础。
  - 来源：[Berkeley Lab Formal](https://github.com/berkeleylab/formal)
- **增量单位制验证**（arXiv 2024）：轻量级静态验证系统，支持渐进式标注和多态单位推导。
  - 来源：[arXiv:2406.02174](http://export.arxiv.org/abs/2406.02174)

**C++ 的验证路线最学术化也最重：**

- **VeriNum 项目**（Appel、Bindel、Jeannin，NSF $750K 2025-2029）：VCFloat2 + VST + Flocq + CompCert 的全链条形式化验证。已发表稀疏矩阵转换、Jacobi 迭代法、Leapfrog ODE 的验证结果。每条链需要博士级工作量。
  - 来源：[VeriNum](https://verinum.org/)；[NSF Grant 2446214](https://www.govalpha.com/grant/2446214/)
- **Capla**（Aarhus University，2025）：为 BLAS、GMP 等底层数值库设计的验证编译器和语言，在 Rocq 中形式化语义和编译器正确性。
  - 来源：[Aarhus University CS](https://cs.au.dk/news-events/events/show-event/artikel/default-0b87f718e9f1acd47bab46f4ff54109b)

**Julia 在正确性方面有明显的意图但缺乏成熟度：**

- **Supposition.jl** 是优秀的 PBT 框架，灵感来自 Python 的 Hypothesis，支持组合生成器、自动缩减、有状态测试。但它明确声明"不能提供正确性的形式化证明"。
  - 来源：[Supposition.jl](https://seelengrab.github.io/Supposition.jl/dev/)
- **Satisfiability.jl**（GSoC 2025）正将 SMT 求解器（Z3、CVC5）接入 Julia，目标是为 Julia 提供形式化验证能力。但仍在早期。
  - 来源：[Julia GSoC 2025 — Satisfiability.jl](https://julialang.org/jsoc/gsoc/satisfiability/)
- **"Tests as Contracts"** 讨论（Julia Discourse，2025 年 5 月）探索了在 Julia 类型系统中编码行为契约——用属性测试定义接口应满足的性质。这是一个有前景的方向，但离实现还有距离。
  - 来源：[Julia Discourse — Tests as Contracts](https://discourse.julialang.org/t/tests-as-contracts/129350/4)
- **Julia 的类型不稳定性是一个系统性问题。** 一个类型不稳定的函数在热路径上会导致性能退化——而发现类型不稳定本身需要工具（`@code_warntype`），不是编译期保证。这对于需要性能保证的数值库是一个结构性弱点。

**"增强领域语言"路线的核心张力：**

- **优势：** 可以利用数十年的数值生态（BLAS、LAPACK、SUNDIALS、PETSc 等），不需要重写。
- **劣势：** 验证工具是"外挂"的——它们不参与编译器的类型检查流程，不是语言设计的一部分。这意味着每一次工具链升级都可能破坏验证，验证和实现之间存在持续的语义鸿沟。

相比之下，Rust 从语言设计之初就把类型安全和不变量表达作为一等公民，验证工具（Kani、Verus）虽然也是"外挂"，但与编译器共享更多的语义基础设施（MIR、类型信息）。

**判决：** 如果你有大量 Fortran/C++ 遗留代码，"增强领域语言"是务实之选——而且这条路本身就在产出有价值的判断型资产（选择哪些不变量来编码、为哪些函数构建验证）。如果你是**从零开始**做新的数值库，Rust 是更好的起点——你得到的是一个从设计上就更有利于正确性保证的基底，而不是在事后往上叠加验证。

---

## 三、一个重要的旁支：Ada/SPARK

在研究过程中反复出现、但在数值计算讨论中常被忽略的选择。

**SPARK 是 Ada 的一个子集，消除了未定义行为，支持 deductive formal verification。** 它允许你在源代码中写契约（pre/post-condition），然后用 SMT 求解器自动证明这些契约对所有可能输入成立——不是测试，是数学证明。

**关键事实：**

- SPARK 能够证明**不存在运行时错误**（溢出、除零、缓冲区溢出）、**内存安全**，以及**函数式正确性**。
  - 来源：[AdaCore SPARK Pro](https://www.adacore.com/sparkpro)
- 2025 年的 TU Delft 论文系统评估了 SPARK 的能力——验证了排序算法和哈希表到最高保证级，证明开销约为 6-10 行规格/行代码。**规格设计是主导成本，不是求解器性能。**
  - 来源：[TU Delft Repository](https://repository.tudelft.nl/record/uuid:18b4b3ef-da6e-4bc8-8b2b-01f9a874a5d7)
- **GPU 验证已经在做。** Barcelona Supercomputing Center 使用 Ada SPARK 验证了 NVIDIA GPU 代码（通过 GNAT for CUDA），证明了无运行时错误，发现了等价的 C/CUDA 代码中的缺陷。
  - 来源：[HISC 2026 — Formal methods for GPU software development using Ada SPARK](https://www.his-conference.co.uk/session/formal-methods-for-gpu-software-development-and-verification-using-ada-spark-experiences-from-applications-in-aerospace)
- SPARK 已被用于 Boeing 777、F-22、铁路信号、医疗设备等安全关键系统的认证（DO-178C、ISO 26262、EN 50128）。
  - 来源：[HackerNoon 2025 — "The Language That Refuses to Crash: Why Ada Still Matters"](https://hackernoon.com/the-language-that-refuses-to-crash-why-ada-still-matters-in-2025)

**但 SPARK 在数值计算领域的生态极其薄弱。** 没有 SPARK 版本的 BLAS/LAPACK，没有 MPI 的形式化模型（对于分布式数值计算而言），浮点舍入误差的推理不如 VCFloat2/Flocq 成熟。

**为什么 SPARK 有参考价值？** 因为它证明了"在工业语言中嵌入可证明正确性"是可行的——不是只有学术证明助手（Lean/Coq）才能做形式化验证。Rust 的 Kani/Verus 路线在精神上与此一致——在工程语言中逐步渗透形式化方法——但 Rust 离 SPARK 的证明自动化程度还有距离，而 SPARK 离 Rust 的数值生态也有距离。

---

## 四、关键架构洞察：双语言是最优解

综合以上分析，一个清晰的模式浮现：

> **最优架构不是一种语言，而是两种语言的组合：一种用于规范（specification），一种用于实现（implementation）。规范是判断型资产，实现是可替换的代码型资产。**

这个模式在多个前沿项目中独立出现：

| 项目 | 规范语言 | 实现语言 | 桥接方式 |
|------|---------|---------|---------|
| **Lean+Kani 组合** | Lean 4（ℝ 层面的数学证明） | Rust（f32/f64 实现） | `stub_float`：Lean 证明的性质作为 Kani 验证的假设 |
| **VeriNum** | Coq/Rocq + VCFloat2（浮点误差界） | C + VST（实现级验证） | Flocq → VST 的端到端 Coq 证明 |
| **Juniper CAS** | Lean 4（代数性质定理） | Rust（egg 重写引擎） | JSON 导出的定理 → Rust 端重写规则 |
| **sorex-lean-macros** | Lean 4（规格 + 证明 obligation） | Rust（实现 + proptest） | Rust 宏生成 Lean 规格和证明 obligation |
| **Capla** | Rocq（语义 + 编译器正确性） | Capla 语言本身 → 编译到底层 | 验证编译器提取 |

**为什么这种分离在 AI 时代特别有价值：**

1. **规范是判断型资产。** "这个函数在 binary32 上应该正确舍入"——这个判断 AI 不能做。用 Lean/Coq 形式化这个规范需要人类判断力。
2. **实现是可替换的。** AI 可以生成实现，也可以重写实现。只要实现通过了规范的验证，它就是正确的。实现代码本身不携带长期价值。
3. **桥接层的验证是自动化的。** Oracle 比较、差分测试、Kani 验证——这些都是机械判定，AI 完全胜任。
4. **当 AI 能力提升时，你可以替换实现语言、替换实现策略、甚至替换整个实现范式——只要规范不变，正确性保证不变。**

---

## 五、推荐矩阵：按场景选择

### 如果你要做的事情是……

| 场景 | 推荐语言组合 | 正确性策略 | 关键判断型资产 |
|------|-------------|-----------|---------------|
| **新数值基础库**（如 libm 替代） | **Rust** + MPFR Oracle | L0 类型系统 + L1 特殊值 + L2 MPFR 穷举对照 + L3 性质检查 + L5 Kani bounded proof | 精心挑选的 hard-to-round cases；正确舍入的穷举测试框架 |
| **新数值算法库**（如稀疏求解器） | **Rust 实现 + Lean/Coq 规范** | L0-L3 Rust 侧验证 + L5 Lean/Coq 证明算法正确性；Kani 验证边界 case | 算法性质的数学规格；收敛性证明 |
| **ChemE/PSE 模拟框架** | **Rust 或 Julia**（性能要求决定） | 物理约束 CI（L3）为核心；MPFR oracle 验证关键热力学函数；差分测试 | 物理约束编码；标准化工 test case 集 |
| **安全关键嵌入式数值代码** | **Ada/SPARK** | 完整形式化规格 + 自动证明 | Pre/post-condition 规格（10 行规格/行代码） |
| **已有 Fortran/C++ 库的维护和加固** | **Fortran/C++** + 渐进式验证 | F-IKOS + Julienne/Assert（Fortran）；VST + VCFloat2（C++，选关键函数） | 回归测试集；哪个函数值得形式化验证的判断 |
| **正确性测试的快速原型** | **TypeScript + fast-check** | L3 性质探索 → 将发现的不变量迁移到实现语言 | 发现的不变量列表；corner case 生成策略 |
| **研究型：想探索"完全验证的数值库"** | **Coq/Rocq + Flocq + VST** 或 **Lean 4（等 Flocq 移植完成）** | 完整形式化验证链 | 每个函数的完整正确性证明 |

### 如果你只能选一种语言……

**选择 Rust。** 不是因为它完美——它的形式化验证工具仍不成熟，Verus 的浮点支持还在开发中。而是因为它在**每一个正确性维度上都有一个"足够好"的答案**，而且这些答案之间的梯度很密集：

```
类型系统 ──→ proptest ──→ MPFR oracle ──→ Kani bounded proof ──→ 差分测试 ──→ Verus/Lean 证明 obligation
  (编译期)     (CI秒级)     (nightly)        (按需)              (CI)          (关键函数)
```

没有其他语言提供这么密集的、可组合的正确性保证梯度。C++ 在高端（VST/Flocq）比 Rust 强，但在低端（类型安全、PBT 生态）比 Rust 弱。Lean 在最高端（完全证明）碾压一切，但在所有其他维度都不适用。

---

## 六、"AI 时代有价值"的判断标准

回到问题的核心——什么产出不会被大模型进步取代？

### 6.1 语言本身不是护城河

AI 可以生成 Rust 代码，也可以生成 TypeScript 代码，也可以生成 Fortran 代码。**语言的语法和生态不构成壁垒。** 构成壁垒的是你在**该语言中沉淀的判断**：

- 你为 `sin` 函数挑选的 43 个 hard-to-round cases——这些不是在标准文档里能找到的，是你跑过穷举测试后锁定的（如 [[AI时代数值代码的正确性来源.md#layer-1]] 所讨论）
- 你为 ChemE 过程模拟编码的 12 条物理不变量——这些来自你对领域知识的理解，不是 AI 能从代码库中推断的
- 你为 MPFR oracle 构建的自动化对照流水线——这套流水线的架构设计是对"怎么知道它是对的"这个问题的回答

### 6.2 判断型资产的特征

能够在 AI 时代保持价值的产出有共同特征：

1. **不可生成性：** AI 不能从训练数据中推导出它——因为正确答案不在训练数据里（如"这个 corner case 值得锁死"的判断）
2. **可自动检查性：** 一旦被编码，正确与否可以机械判定——不需要再投入人类判断（如 MPFR 对照的 pass/fail）
3. **独立性：** 不依赖于特定实现（如物理约束不关心你用哪个算法——违反就是错）
4. **可积累性：** 每一个新判断都增加系统的覆盖范围，不会过时（如回归测试集只增不减）

### 6.3 语言在"构建判断型资产"中的角色

语言不是价值的来源——语言是你构建判断型资产的**工具平台**。好的语言选择让你：

- **更快地发现不变量**（好的 PBT 框架 + 类型系统）
- **更牢地锁死 corner case**（好的 oracle 集成 + 回归测试基础设施）
- **更早地捕获错误**（编译期检查 vs 运行时崩溃 vs 静默精度退化）

这就是为什么 Rust 在当前时间点是最优解——它让你在构建判断型资产时阻力最小、反馈最快。

---

## 七、开放问题

1. **Verus 的浮点推理成熟度曲线**——Verus 已经支持 `real` 类型（数学实数），完整的 IEEE 754 浮点推理仍在开发中。两年后它会达到接近 SPARK 的浮点验证能力吗？如果会，Rust 的形式化验证故事将完全不同。

2. **Flocq 移植到 Lean 4 的前景**——如果 Lean 社区成功移植 Flocq，Lean 4 将获得权威的 IEEE 754 形式化基础。这会改变"双语言"架构的最优解吗？还是双语言架构本身就是正确的——规范语言和执行语言本来就不该是同一种？

3. **Julia 的类型系统进化**——"Tests as Contracts"的讨论暗示 Julia 社区有意愿向更强类型保证的方向演进。但 Julia 的动态派发从根本上限制了编译期验证的可能性。Julia 能否在保持其灵活性的同时提供更强的正确性保证？

4. **AI 辅助形式化验证的突破可能性**——如果 AI 能辅助写 SPARK 契约、Coq 证明脚本、Kani harness，那么形式化验证的人力成本可能大幅下降。这会改变推荐矩阵吗？尤其是对于 C++ 的 VeriNum 路线——如果 VST 证明的人力成本从"博士级"降到"高级工程师级"？

5. **Rust 与 Ada/SPARK 的融合可能**——两者都在探索"工程语言 + 形式化验证"路线。SPARK 的证明自动化程度更高（工业生产验证），Rust 的生态和社区更大。两者是否有互补空间？

6. **数值计算的新型 DSL**——Capla（2025）暗示了一种可能性：不是选择通用语言，而是设计专门用于数值库的 DSL，带有内置的验证语义。这是一个值得关注的趋势——Mojo 也在朝这个方向走（MLIR 后端 + 自动 SIMD + 类型安全）。专门的数值 DSL 是否会取代通用语言成为最优解？

---

## 八、相关文档

- [[AI时代数值代码的正确性来源.md]] — 五种正确性锚点与分层测试策略
- [[数值函数形式化验证-想法与约束.md]] — PureLibm-rs 设计与 L0–L5 五级验证
- [[Rust科学计算生态调研.md]] — LLVM 浮点约束与 Rust libm 现状
- [[项目选择判据-双视角.md]] — 判断 vs 代码的区分框架
- [[项目诊断.md]] — 手工艺项目选择与正确性方向评估

---

*本文基于 2026 年 7 月的公开信息。形式化验证领域进展迅速，建议 6-12 个月后重新评估各语言的验证工具成熟度。*
