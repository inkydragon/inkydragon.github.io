---
unlisted: true
authors: claude-code
tags: [ai, research, programming-languages, language-design, formal-verification, numerical-computing]
---

# AI 时代数值计算语言改造：选择哪个基础语言？

> 承接 [[AI时代数值计算编程语言选择.md]]——那篇讨论了"直接使用现有语言，怎么选"。本篇讨论一个不同的问题：
>
> **如果要对现有语言进行改造——增强静态类型标注、编译到静态 DLL、增加形式化验证支持（库级或语言级）——应该以哪个语言为基础？**
>
> 这不是"哪个语言最好用"，而是**"哪个语言的基底最适合被改造"**。
>
> **讨论日期：2026-07-02**

---

## 〇、改造维度的定义

假设我们要在现有语言上叠加以下能力：

| 改造目标 | 含义 | 难度等级 |
|---------|------|---------|
| **增强静态类型标注** | 在类型中编码数值不变量（如 `Nat`、`{x: f64 \| x > 0}`、`{a: [f64] \| len(a) == n}`） | 高（涉及类型检查器） |
| **静态编译到 DLL** | 生成小型、可重定位、无运行时依赖的共享库 | 中（取决于语言现有编译模型） |
| **形式化验证（库级）** | 不修改编译器，通过库/框架提供 pre/post-condition 检查和 SMT 验证 | 中（可在任何语言上层构建，但有语法噪音） |
| **形式化验证（语言级）** | 编译器内建契约检查、SMT 集成、或可选的证明模式 | 高（涉及编译器修改） |
| **可移植部署** | 跨芯片架构、跨操作系统的一致行为（bit-exact 或 ULP 约束） | 中-高（取决于语言的浮点模型） |

核心问题：**哪个现有语言的基底，让这些改造的阻力最小？**

---

## 一、候选语言评估

### 1.1 Haskell：类型系统最可扩展的候选

**基底优势：**

Haskell 是目前主流语言中**唯一允许在编译器层面扩展类型检查逻辑**的系统。GHC 的插件架构（GHC Plugins）允许第三方代码在类型检查阶段介入——添加新的约束、生成证明义务、注入 SMT 验证。

- **Liquid Haskell** 是一个 GHC 插件，证明了 refinement types（如 `{v:Int | v > 0}`）可以在不修改 GHC 的情况下作为**库**加入。类型检查时，LH 将 refinement 约束转换为 SMT 查询（Z3/CVC5），验证通过后 GHC 正常编译。这正是"语言级形式化验证"的典范——它实际上扩展了语言的类型系统，但通过插件实现。
- **GHC 9.14 的 SIMD 原生支持**（`DoubleX4#`）是颠覆性的：这使 Haskell 可以直接生成 AVX2 向量指令，而不依赖 C FFI。`linear-massiv` 项目证明了纯 Haskell 数值代码可以**超越** OpenBLAS 的性能（GEMM 500×500 快 10.2×、QR 分解快 48×）。消除了"Haskell 数值计算性能不行"的核心反驳。
  - 来源：[linear-massiv](https://github.com/NadiaYvette/linear-massiv), [Haskell Weekly Issue 483](https://haskellweekly.news/issue/483.html)
- **静态编译成熟。** GHC 通过 LLVM 后端生成原生代码，产生静态链接的二进制文件。共享库（`.so`/`.dylib`/`.dll`）也支持。

**需要改造的部分：**

| 改造目标 | 现状 | 改造难度 |
|---------|------|---------|
| 增强静态类型标注 | Liquid Haskell 已有 refinement types，但语法与 Haskell 本体分离（`{-@ ... @-}` 注释语法） | **低**：只需统一语法、改进 DX |
| 静态 DLL | 已支持，但 GHC RTS（运行时系统）仍绑定在二进制中 | **中**：需要裁剪 RTS，类似 Asterius 的无 GC 模式 |
| 形式化验证（语言级） | Liquid Haskell 插件已有 SMT 集成 | **低-中**：已有基础，需深化 DX 和标准库覆盖 |
| 形式化验证（库级） | QuickCheck + SmallCheck + Hedgehog 生态成熟 | **低**：已有 |

**关键证据——AI 可以自动标注 refinement types：**

ICSE 2025 的 LHC（Liquid Haskell + Codex）项目表明，一个 3B 参数的 StarCoder LLM 可以在数小时内为整个 Haskell 库自动生成 refinement type 标注，覆盖率达 94%。Liquid Haskell 作为 oracle 验证生成的标注是否正确。
- 来源：[ICSE 2025 — Neurosymbolic Modular Refinement Type Inference](https://ieeexplore.ieee.org/document/11029908)

这意味着：**在 Haskell 基底上，AI 可以帮助完成大部分类型标注工作，人类只需审查和修正。** 这与"判断型资产"的理念完全一致——AI 生成标注，人类做判断。

**需要克服的问题：**

- **惰性求值在数值计算中是一个可控的问题。** `linear-massiv` 使用严格（strict）的 `massiv` 数组库，配合 GHC 的 `StrictData` 和 `BangPatterns`，实际上实现了严格的、可预测的求值。惰性求值不是数值计算的障碍——它是一个可以通过库和语言扩展绕过的默认选项。
- **数值计算生态仍然偏小。** 虽然有 `hmatrix`、`massiv`、`linear-massiv`、`hTensor` 等，但远不如 Julia/Python/C++ 丰富。但注意——如果目标是从零构建，生态大小不如语言的正确性基础设施重要。
- **二进制大小。** GHC 编译的二进制包含 RTS（GC、调度器），通常 ≥ 几 MB。对于 DLL 场景，需要裁剪 RTS。

**小结：Haskell 是"可改造性"最强的候选。** 它的 GHC 插件架构、已有的 Liquid Haskell refinement types、GHC 9.14 的 SIMD 性能突破、以及 AI 自动标注研究——这些都指向一个结论：在 Haskell 的基底上构建"带 refinement types + SMT 验证的数值计算语言"的技术风险是最低的，因为大部分基础设施已经存在。

---

### 1.2 OCaml：形式化验证工具链最深的候选

**基底优势：**

OCaml 的形式化验证生态独具一格，因为它**本身就是**形式化方法工具的实现语言：

- **Why3** 验证平台完全用 OCaml 编写。Why3 的 WhyML 语言提供 pre/post-condition、loop invariant、以及自动 SMT 求解（Alt-Ergo、Z3、CVC5）。WhyML 程序可以**提取**为正确性保证的 OCaml 代码。
  - 来源：[Why3 1.8.2 on OCaml Package Registry](https://ocaml.org/p/why3/1.8.2)
- **Coq/Rocq** 用 OCaml 编写。**Frama-C**（C 代码验证）用 OCaml 编写。**CompCert**（验证 C 编译器）用 Coq+OCaml 编写。整个形式化验证基础设施的"母语"就是 OCaml。
- **原生编译成熟。** `ocamlopt` 生成高效原生代码，可作为共享库导出。没有虚拟机，没有 JIT。
- **模块系统强大。** OCaml 的 module system（functors、first-class modules）本身就是一个强大的抽象工具，可以在类型层面编码不变量（虽然不如 dependent types 灵活）。

**需要改造的部分：**

| 改造目标 | 现状 | 改造难度 |
|---------|------|---------|
| 增强静态类型标注 | 无原生 refinement types。需通过 Why3/WhyML 间接提供 | **高**：需要将 refinement types 嵌入 OCaml 的类型系统，或在 OCaml 上构建 pre-processor |
| 静态 DLL | 已支持（`ocamlopt -output-obj`），但二进制也包含 OCaml 运行时 | **中**：与 Haskell 类似的问题 |
| 形式化验证（语言级） | Why3 提供了独立的 WhyML 语言，不是 OCaml 本身 | **中-高**：需要将 WhyML 的契约语法嵌入 OCaml（如 `[@contract ...]` 属性 + pre-processor） |
| 形式化验证（库级） | QCheck（PBT）+ 通过 Why3 FFI | **中** |

**关键问题——OCaml 的类型系统缺乏"扩展点"：**

与 Haskell 不同，OCaml 编译器没有 GHC-style 插件系统。你不能在不修改编译器的情况下向类型检查器注入新逻辑。这意味着 refinement types 需要一个**外部 pre-processor**（类似 Liquid Haskell 的注释语法），或者分叉编译器。

**数值计算生态的现状：**

- `owl`（科学计算库）是成熟的选择，但近年来维护不够活跃。
- `lacaml` 提供 BLAS/LAPACK 绑定。
- 整体生态远不如 Python/Julia，但比 Haskell 略好（在科学计算方面）。

**小结：** OCaml 的形式化验证血统无可匹敌——它是形式化方法工具的作者们选择的语言。但它的编译器不像 GHC 那样可以扩展，这意味着"增强静态类型"需要在**编译器之外**构建——pre-processor、独立的验证工具、或者 DSL。这条路可行的证据是 Why3 本身——WhyML 就是一个独立于 OCaml 的验证语言，可以提取到 OCaml。但将它"融合"进 OCaml 本身是一个更大的工程。

---

### 1.3 Julia：生态最强，基底最不适合被改造

**基底优势：**

- 数值计算生态在科学计算语言中遥遥领先（DifferentialEquations.jl、SciML、Flux.jl 等）。
- 多重派发（multiple dispatch）是表达数值算法的**自然抽象**——比面向对象或纯函数式更贴合数值计算。

**基底劣势（作为改造基础）：**

**1. 静态编译是 Julia 最痛苦的技术负债。**

- **二进制大小：** 500 个包的程序 → **1.3 GB**。简单的 GUI 应用 → **300 MB+**。这是因为 Julia 必须将整个运行时（GC、JIT 编译器、所有可能被调用的方法的 LLVM IR）打包进二进制。
  - 来源：[Julia Discourse — Creating fully self-contained and pre-compiled library](https://discourse.julialang.org/t/creating-fully-self-contained-and-pre-compiled-library/131374/11)
- **不可重定位：** 生成的 `.so`/`.dll` 不能在不同 `glibc` 版本的机器上运行。交叉编译不支持。
  - 来源：[Julia Discourse — Will juliac solve the relocatability issue?](https://discourse.julialang.org/t/will-juliac-solve-the-relocatabiliy-issue/131780/10)
- **StaticCompiler.jl** 可以生成小二进制（~200 KB），但**不支持 GC 分配**——不能用 Array、String、Dict。这等于废掉了 Julia 的核心优势。
  - 来源：[Julia Discourse — StaticCompiler: Generating small binaries](https://discourse.julialang.org/t/new-on-forem-staticcompiler-generating-small-binaries/130464/3)
- **线程限制：** Julia 1.11 中 PackageCompiler 生成的共享库**只能从主线程调用**。1.12 + JuliaC.jl 才移除这个限制。
  - 来源：[Julia Discourse — Using a shared library generated by PackageCompiler in a multi-threaded program](https://discourse.julialang.org/t/using-a-shared-library-generated-by-packagecompiler-in-a-multi-threaded-program/133972/6)

这意味着"编译 Julia 到静态 DLL"不是"需要改进"的问题——它需要**对 Julia 编译模型进行根本性的重新设计**。这不是一个可以"逐步改造"的东西。

**2. 类型系统不适合编码不变量。**

- Julia 的类型格子（type lattice）只有 `Const` 和 `PartialConst`——没有 "Set of Values" 或 "Range of Values" 表示。没有 refinement types、dependent types、或 GADTs。
  - 来源：[Julia Discourse — Would it make sense for Julia to adopt refinement types?](https://discourse.julialang.org/t/would-it-make-sense-for-julia-to-adopt-refinement-types/113586/14)
- 多重派发是 Julia 的核心设计，修改类型系统会动摇它的语义基础——这与 Haskell（在已有类型系统上叠加 refinement）有本质不同。
- Julia 的类型不稳定性是**运行时**问题——`@code_warntype` 是事后工具，不是编译期保证。增加静态类型标注需要从根本上改变 Julia 的编译模型（从 JIT 偏向到提前编译）。

**3. 形式化验证几乎空白。**

- `Supposition.jl` 是优秀的 PBT 框架（灵感来自 Python Hypothesis），但它明确声明"不能提供正确性的形式化证明"。
  - 来源：[Supposition.jl](https://seelengrab.github.io/Supposition.jl/dev/)
- `Satisfiability.jl`（GSoC 2025）正将 SMT 求解器接入 Julia，但这是**库级**的工具——没有语言级集成。
  - 来源：[Julia GSoC 2025 — Satisfiability.jl](https://julialang.org/jsoc/gsoc/satisfiability/)
- "Tests as Contracts"讨论（Julia Discourse，2025 年 5 月）表明社区有意愿，但实现还很遥远。

**小结：Julia 可以作为灵感来源和学习目标（它的多重派发和科学计算生态是最好的），但它作为"改造基础"的适用性是最差的。你需要先修复它的编译模型，再改造它的类型系统，然后从零构建形式化验证——每一步都是根本性的重新设计。**

---

### 1.4 Rust：综合基础最好，但类型系统的可扩展性受限

**优势在上一篇文档中已详细讨论：** 类型安全、Kani bounded verification、MPFR oracle 集成、跨平台确定性、成熟的静态编译。

**作为"改造基础"的关键限制：**

**Rust 的类型系统几乎没有可扩展的接口。** Rust 的 proc macro（过程宏）只能扩展**语法**——它们生成 AST 节点，但不能修改类型检查的逻辑。你不能写一个 proc macro 来添加 refinement types，因为 proc macro 在类型检查之前就运行完了。

Rust 的 trait 系统可以编码一些不变量（如 `num-valid` crate 用 trait 保证无 NaN/Inf），但：
- Trait 约束是**结构性的**（"这个类型实现了 `Finite` trait"），不是**数值性的**（"这个值 ∈ (0, 1)"）
- 更细粒度的约束（如 "数组 A 和 B 的长度相等"）在 Rust 的类型系统中**极其笨拙**（需要 const generics + 复杂的 trait bound）

**如果你要改造 Rust：**
- 增强静态类型 → 需要修改 `rustc` 的类型检查器（`chalk` / trait solver）——这是一个大的编译器工程
- 形式化验证（语言级）→ 需要集成 SMT 到编译流程中——比从 Haskell/GHC 起步更困难，因为 Rust 的 trait 解析和 borrow checker 增加了 SMT 化的复杂度
- 静态 DLL → **已完美支持**（这是 Rust 最强的维度）

**跟 Haskell 的关键差异：**

| 维度 | Haskell (GHC) | Rust (rustc) |
|------|--------------|--------------|
| 类型系统可扩展性 | GHC Plugins：第三方代码可介入类型检查 | Proc Macros：只能扩展语法，不能介入类型检查 |
| 已有 refinement types | Liquid Haskell（成熟，SMT 集成） | num-valid（只能标记 NaN/Inf，不能约束数值范围） |
| 添加 SMT 验证的门槛 | 已有 GHC 插件先例 | 无插件系统，需改造编译器本身 |
| 静态编译 | 成熟，但二进制含 RTS | 成熟，二进制精简，无 GC |

**小结：** Rust 作为"直接使用"的语言是最优的。但作为"改造基础"——尤其是"增强静态类型标注"和"语言级形式化验证"——它的编译器缺乏 GHC 那样的插件化扩展点。如果改造的重点是"在类型系统中编码更强的数值不变量"，Rust 比 Haskell 和 OCaml 需要更多的编译器工作量。

---

### 1.5 TypeScript：概念验证优雅，但物理基底不适合

**如果目标是"快速探索语言设计"：** TypeScript 的类型系统表达能力出色（conditional types、template literal types、mapped types），可以作为 refinement types 语法设计的原型平台。LemmaScript 项目（2025）将 TypeScript + 验证注解编译到 Dafny/Lean 后端——证明了 TS 作为"验证规范的书写前端"是可行的。

但 JS 运行时作为数值计算的物理基底是根本性限制：
- `number` 即 `f64`——没有 `f32`、没有 SIMD（虽然 TC39 在推进，但还不可用）
- 不同 JS 引擎的 `Math` 函数实现不同
- 静态编译到 DLL 需要 Deno/Bun 的 AOT 编译，仍不成熟
- 没有形式化验证的直接路径（TS 的类型系统不参与运行时行为——`as` 可以绕过一切）

**小结：** TypeScript 可以作为语法设计的实验场和原型平台，但**不适合作为最终产物的物理基底**。它的价值在"设计阶段"而非"实现阶段"。

---

### 1.6 不在讨论范围内但值得提及的

- **Mojo（Modular）：** 设计上最接近"数值计算 + 静态类型 + 所有权"的理想组合。1.0 beta（2026）有 Rust 级的所有权模型、Python 级的语法亲近性、一等的 SIMD 支持。但它不开源、形式化验证不是设计目标、生态为零。**它是最值得关注但还不能下注的语言。**
  - 来源：[InfoWorld — Mojo 1.0 mixes Python and Rust](https://www.infoworld.com/article/4173158/first-look-mojo-1-0-mixes-python-and-rust.html)

- **Ada/SPARK：** 已经做到了形式化验证 + 静态编译——不需要改造。是你"想要达到的目标"的参考——证明这是可行的——但 SPARK 本身不适合作为"改造基础"，因为它的语言设计是封闭的、不面向扩展的。

- **Zig：** comptime 是一种激进且有效的范式，但 Zig 社区**刻意避免**扩展性（no DSLs, no custom syntax, no macros）。comptime 不能替代形式化验证（没有 SMT 集成）。如果你需要的是"在编译器里加验证逻辑"，Zig 的哲学恰好是你不需要的。
  - 来源：[matklad — Things Zig comptime Won't Do (2025)](https://matklad.github.io/2025/04/19/things-zig-comptime-wont-do.html)

- **F★ / Low★：** 已经证明了提取到 C 的路径——HACL★（验证密码学库）被 Firefox、Linux 内核、Python 使用。但 Low★ 是为整数/位操作设计的，浮点验证不是它的强项，生态也仅限于密码学。

---

## 二、综合对比

| 评估维度 | Haskell | OCaml | Rust | Julia | TypeScript |
|---------|:-------:|:-----:|:----:|:-----:|:----------:|
| **类型系统可扩展性** | ★★★★★ (GHC Plugins) | ★★☆ (无插件系统) | ★★☆ (proc macro 不能改类型检查) | ★★☆ (类型格子固定) | ★★☆ |
| **已有 refinement types** | ★★★★★ (Liquid Haskell) | ★☆☆☆ (Why3/WhyML 是外部语言) | ★★☆ (num-valid) | ★☆☆☆ | ★★☆ (LemmaScript 外部) |
| **静态 DLL 成熟度** | ★★★☆ (含 RTS) | ★★★★ | ★★★★★ (精简便携) | ★☆☆☆ (1.3GB，不可重定位) | ★☆☆☆ (AOT 不成熟) |
| **形式化验证生态深度** | ★★★★ (LH + SMT + QuickCheck) | ★★★★★ (Why3 + Coq + Alt-Ergo) | ★★★☆ (Kani + Verus) | ★★☆ (Supposition.jl) | ★★☆ (fast-check) |
| **SMT 集成难度** | ★★★★★ (LH 已有，GHC Plugin 先例) | ★★★☆ (Why3 可用，但与 OCaml 本体分离) | ★★☆ (需修改编译器) | ★☆☆☆ (Satisfiability.jl 早期) | ★☆☆☆ |
| **数值计算性能** | ★★★★ (linear-massiv 击败 BLAS) | ★★★ | ★★★★★ | ★★★★★ | ★★☆ |
| **数值计算生态** | ★★☆ | ★★☆ | ★★★☆ | ★★★★★ | ★★☆ |
| **AI 友好度（类型标注自动化）** | ★★★★★ (LHC 94% 覆盖) | ★★☆ | ★★☆ | ★★☆ | ★★★ |
| **语法噪音（契约表达）** | ★★★☆ (LH 注释语法) | ★★☆ (WhyML 是另一个语言) | ★★☆ | ★★☆ | ★★★★ |
| **跨平台确定性** | ★★★★ | ★★★★ | ★★★★★ | ★★ | ★★☆ |

---

## 三、核心结论

### 3.1 Haskell 是最适合被"改造"的基础

如果目标是**在现有语言上构建更强的正确性保证**（静态不变量标注 + SMT 验证），Haskell 是阻力最小的基底。原因：

1. **GHC Plugins 是唯一的可用机制**（在所有主流语言中），允许在不修改编译器的情况下扩展类型检查逻辑。Liquid Haskell 已经证明了这条路可以走到 refinement types + SMT 验证。

2. **"已经有了，只需要优化"比"需要从零构建"可靠得多。** Liquid Haskell 的 refinement types 已经存在并工作——它的问题不是"不可用"，而是"语法分离"（LH 注释 vs Haskell 代码）和"DX 不完美"。改造工作的起点是已有系统，不是空白画布。

3. **GHC 9.14 的 SIMD 突破**消除了 Haskell 数值性能的历史弱势。纯 Haskell 可以击败 BLAS——这在一两年前还是不可想象的。

4. **AI 自动标注（LHC 项目）**意味着向现有 Haskell 代码添加 refinement types 的成本可以大幅降低——AI 做 94% 的标注工作，人类审查和修正。

### 3.2 但目标决定了选择

- **如果目标是"探索形式化验证在数值计算中的适用性"** → Haskell + Liquid Haskell，已有基础，快速迭代。
- **如果目标是"生产可用的数值库"** → Rust（用现有的 Kani + proptest + MPFR oracle），不要改造语言，直接用现有工具。
- **如果目标是"设计一个新的数值计算语言"** → 从 Haskell 的 GHC Plugin 生态学习扩展性的设计；从 Julia 的多重派发学习数值抽象的语法；从 SPARK 的契约系统学习 SMT 集成的最佳实践。
- **如果目标是"为现有数值模型增加验证"**（如 Fortran/C++ 模拟代码）→ 走"增强领域语言"路线（F-IKOS、Assert、VeriNum），不要从零开始。

### 3.3 两阶段路径

如果认真考虑语言改造，最务实的路径可能是分两个阶段：

**第一阶段：Haskell + Liquid Haskell 原型。**
在这个阶段验证以下假设：
- refinement types 对数值计算不变量（单调性、范围、守恒律）的表达力是否足够？
- SMT 求解器对浮点约束的处理是否实用？
- AI 自动标注在数值计算场景下的覆盖率能达到多少？

这个阶段产出的是知识——你知道"语言应该长什么样"。

**第二阶段：基于学到的知识，决定下一步。**

三个可能的方向：
- **继续深化 Haskell：** 如果 Liquid Haskell 足以支撑所有需要的正确性保证。
- **将 Haskell + LH 的经验迁移到 Rust：** 如果发现 Rust 的生态优势和跨平台确定性是 Haskell 无法替代的，那么在 Rust 上构建类似 LH 的 refinement type 系统（或等待 Verus 成熟）。
- **设计新的 DSL：** 如果发现没有现有语言能同时满足"用多重派发表达数值算法"和"用 refinement types 编码不变量"两个需求，那么就设计一个新的语言——用第一阶段学到的知识来决定它的形态。

---

## 四、开放问题

1. **Liquid Haskell 对浮点的支持深度。** LH 可以表达 `{x:Float | x > 0.0}` 这样的约束，但能否表达 `{x:Double | abs(sin(x) - oracle_sin(x)) < 1e-16}`？能否表达"这个函数在 binary32 上正确舍入"？如果可以，意味着 Haskell + LH 可以直接做数值函数验证。

2. **GHC 9.14 SIMD 的普及时间表。** `linear-massiv` 依赖 `DoubleX4#` primops 和 LLVM 17 后端才能在纯 Haskell 中击败 BLAS。这些特性何时成为主流 GHC 版本的标准配置？

3. **LHC（AI 自动标注）能否迁移到其他语言？** ICSE 2025 的 LHC 项目证明了 LLM 可以为 Haskell 生成 refinement types。同样的方法能用于 Rust（生成 Kani contracts）、OCaml（生成 WhyML specs）吗？如果能，改造其他语言的成本也会下降。

4. **"融合"还是"分离"？** Liquid Haskell 的注释语法（`{-@ ... @-}`）意味着 refinement types 和 Haskell 的类型系统是**分离的**。OCaml + Why3 的 WhyML 也是分离的。这种分离是"必要的恶"（因为不修改编译器）还是"长期可接受的架构"？如果选择 Haskell，是否需要统一语法——让 `{x:Float | x > 0}` 成为 Haskell 的一等类型？

5. **社区和治理风险。** GHC 的开发节奏由 Haskell 社区驱动，不以数值计算为中心。Liquid Haskell 由学术团队维护（UCSD）。如果这些项目转向不同的优先级，建立在它们之上的工作会受到什么影响？

---

## 五、相关文档

- [[AI时代数值代码的正确性来源.md]] — 五种正确性锚点与分层测试策略
- [[AI时代数值计算编程语言选择.md]] — 不改造语言、直接使用的选择分析
- [[数值函数形式化验证-想法与约束.md]] — PureLibm-rs 设计与 L0–L5 五级验证
- [[Rust科学计算生态调研.md]] — LLVM 浮点约束与 Rust libm 现状

---

*本文基于 2026 年 7 月的公开信息。Haskell 和 OCaml 的形式化验证生态进展迅速，特别值得关注的是 GHC 9.14 SIMD 的普及速度以及 Liquid Haskell 在数值计算领域的后续研究。*
