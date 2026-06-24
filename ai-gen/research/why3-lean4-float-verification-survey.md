---
unlisted: true
authors: claude-code, deepseek-v4-pro
tags: [ai, research, formal-verification, floating-point, why3, lean4, coq, libm, numerical-analysis]
title: "Why3 与 Lean4 浮点数算法验证支持调研"
date: 2025-06-24
lang: zh-Hans
---

# Why3 与 Lean4 浮点数算法验证支持调研

## 摘要

调研 Why3 和 Lean4 对浮点数算法形式化验证的支持能力，重点关注数学核函数（libm 类实现）和高层数值算法的验证现状。

**核心结论**：Coq + Flocq + Gappa + Why3 构成的法国学派生态系统是目前浮点验证最成熟的体系，已有 CRlibm 全验证、CORE-MATH 辅助验证、LSE 精度验证等里程碑成果。Lean4 目前**没有可用的 IEEE 754 形式化库**，社区正在推进 Flocq 移植（FloatSpec），但距离可验证 libm 级算法还有显著差距。

---

## 1. Why3 浮点验证生态

### 1.1 核心：`ieee_float` 标准库

Why3 标准库提供了完整的 IEEE 754 形式化 ([why3.org/stdlib/ieee_float](https://why3.org/stdlib/ieee_float.html))：

- **五种舍入模式**：RNE、RNA、RTP、RTN、RTZ
- **`GenericFloat` 模块**：按指数位 `eb` 和尾数位 `sb` 参数化
- **完整 IEEE 语义**：基本运算（add/sub/mul/div/sqrt/fma）带舍入模式、比较运算处理 NaN、分类谓词（is_normal/is_subnormal/is_zero/is_infinite/is_nan）
- **到实数的转换**：`to_real` 函数及实数舍入公理
- 语义遵循 SMT-LIB 浮点理论（基于 Brain et al. 的工作）

**公理化关键性质**：
- `round_monotonic`：`x ≤ y ⟹ round m x ≤ round m y`
- `round_idempotent`：`round m₁ (round m₂ x) = round m₂ x`
- `round_down_le / round_up_ge`：下/上舍入的上下界保证
- `Exact_rounding_for_integers`：安全范围内的整数精确可表示

### 1.2 Why3 1.8.0 (2024-12) 新特性

- **新库 `ufloat`**：无界浮点数（关键：用于分离溢出问题与精度证明）
- **`ieee_float` 增强**：浮点数与有符号位向量间的转换
- **新变换 `forward_propagation`**：自动传播舍入误差
- **提取改进**：支持 C 代码提取中的浮点数

### 1.3 Gappa 作为后端证明器

[Gappa](https://gappa.gitlabpages.inria.fr/) 是自动证明浮点/定点数值程序性质的工具：
- 用区间算术 + 重写规则处理依赖效应
- 可作为 Why3 后端证明器或 Coq 自动 tactic
- 用于 CRlibm 初等函数认证和 CORE-MATH 开发

### 1.4 代表性验证案例

| 项目 | 年份 | 描述 |
|------|------|------|
| **LogSumExp 验证** (FMCAD 2024) | 2024 | 使用 Why3 + `ufloat` 验证 LSE/SLSE 舍入误差界；扩展到互信息计算 |
| **SPARK + PropaFP** | 2022 | 自动验证 SPARK 浮点程序，首次全验证 sine 和 sqrt 实现（含 Taylor 逼近 + 参数归约） |
| **区间算术算子** | 2020 | 四项区间算术算子的有效性、可靠性和紧致性验证 |

---

## 2. Lean4 浮点验证现状

### 2.1 核心问题：没有可用的 IEEE 754 库

社区共识：**Lean 4 目前没有公认的 IEEE 754 浮点形式化库**。证据：

- `Float` 类型是 `opaque` 的，无法在类型层面证明性质
- Lean 3 的 `FP.Float` 在 mathlib 中基本被弃用，大多数操作标记为 `unsafe`
- Proof Assistants StackExchange 上讨论结论：[社区建议用 `Rat`/`Real` 证明定理，用 `Float` 执行](https://proofassistants.stackexchange.com/questions/5311/what-is-the-most-accepted-library-for-floats-in-lean4)

### 2.2 主要库/项目一览

| 项目 | 状态 | 描述 |
|------|------|------|
| **[FloatSpec](https://reservoir.lean-lang.org/@Beneficial-AI-Foundation/FloatSpec)** | 开发中 (v0.7.0) | Coq Flocq 到 Lean4 的移植，提供可执行参考运算 + Hoare 三元组规约；核心格式 FLX/FLT/FTZ、舍入、ulp、误差界；IEEE 754 位级编解码。**深度证明大量标记 `sorry`** |
| **Flean** | 停滞 | 作者自述"需要重写"，写于初学 Lean 时 |
| **TorchLean** (2025-02) | 研究项目 | 带显式 Float32 语义的可执行 IEEE 754 binary32 核，用于神经网络验证 |
| **SciLean** | 活跃 | 科学计算库：形式化验证的自动微分、ODE 求解器、优化算法。**不专门做浮点验证** |
| **ComputableReal** | 实验性 | 可计算实数（Cauchy 序列 + 上下界），支持 `native_decide` 证明涉及超越函数的不等式 |

### 2.3 Lean4 社区的工作路线

目前主要方向：
1. **完成 Flocq 移植**（FloatSpec 是最主要的努力）
2. **重新定义 `Float`** 使其不那么 opaque
3. **添加 IEEE 类型类** 编码标准性质而不需完整形式化

### 2.4 Lean4 的优势领域

尽管浮点验证弱，Lean4 在以下领域有独特优势：
- **数值算法的实分析证明**：SciLean 可形式化验证 ODE 求解器、优化算法的数学正确性（在实数语义下）
- **编译时验证**：`native_decide` 可验证有界具体计算
- **生成式 AI 辅助**：LLM + Lean4 的 autoformalization 进展迅速

---

## 3. 浮点验证整体生态：法国学派技术栈

完整的验证堆栈（主要由 Inria Toccata 项目组维护）：

| 层 | 工具 | 作用 |
|----|------|------|
| 浮点模型 | **Flocq** (Coq) | 多基、多格式、多精度 IEEE 754 形式化 |
| 实分析基础 | **Coquelicot** (Coq) | 极限、导数、积分、幂级数——总体函数风格 |
| 自动不等式证明 | **CoqInterval / CoqApprox** | 区间算术 + Taylor 模型 |
| 舍入误差自动证明 | **Gappa** | 根据约束自动推导误差界 |
| 演绎验证平台 | **Why3** | 生成验证条件 → 分派到 SMT/ATP/交互式证明器 |
| C 编译器 | **CompCert** | 经形式化验证的 C 编译器，**保留浮点语义** |

### 3.1 CRlibm：libm 验证的巅峰

CRlibm（Correctly Rounded libm）：
- 双精度 C99 标准初等函数，在四种 IEEE 754 舍入模式下均正确舍入
- 使用 Gappa 验证证明脚本（替代手写纸笔证明），Coq 检查机器生成的证明
- 与 **CORE-MATH** 项目关联：CORE-MATH 是其后继，2025 年正在被整合入 glibc

### 3.2 最新进展 (2024–2025)

- **FMCAD 2024**：LSE/SLSE 舍入误差的 Why3 形式化验证
- **JAR 2024**：Runge-Kutta 方法的舍入误差形式化分析
- **CPP 2024**：VCFloat2 — Coq 中的浮点误差分析框架
- **PLDI 2024**：Numerical Fuzz — 舍入误差分析的类型系统
- **Acta Numerica 2023**：Boldo、Jeannerod、Melquiond、Muller 的浮点算术综述
- **2025**：CORE-MATH binary64 函数被提交整合入 glibc

---

## 4. 对比总结

| 维度 | Why3 (含 Gappa/Coq 后端) | Lean4 |
|------|--------------------------|-------|
| IEEE 754 形式化 | ✅ 成熟 (`ieee_float`) | ❌ 无可用库 |
| SMT 自动证明 | ✅ (CVC5, Z3, Alt-Ergo) | ❌ |
| 舍入误差自动推导 | ✅ (Gappa, PropaFP) | ❌ |
| 交互式证明后端 | ✅ (Coq) | ✅ (自身) |
| libm 级验证先例 | ✅ (CRlibm, sine/sqrt) | ❌ |
| 高层数值算法验证 | ✅ (LSE, Runge-Kutta, 波动方程) | 部分 (SciLean, 实数语义) |
| C 代码提取/编译验证 | ✅ (CompCert) | ❌ |
| LLM 辅助证明 | 一般 | ✅ 活跃 |
| 社区活跃度 | 成熟稳定 | 快速增长 |
| 学习曲线 | 陡峭（多工具组合） | 较陡（单一语言） |

---

## 5. Lean4 代码提取与 C 接口导出

### 5.1 编译模型概述

Lean4 的标准编译后端是 **C 代码生成器**（`src/Lean/Compiler/IR/EmitC.lean`）。编译流程：

```
Lean 源码 → Lean IR → C 代码 → Clang/GCC 编译 → 原生可执行文件/共享库
```

手动编译到 C：
```bash
lean foobar.lean -c foobar.c
clang foobar.c -I$(lean --print-prefix)/include -L$(lean --print-libdir) -lleanshared
```

C 后端依赖 Lean 运行时（`lean.h`、`libleanshared`）。通过 Lake 构建系统可以用 `precompileModules = true` 将模块编译为原生共享库（`.so`/`.dylib`）。

### 5.2 双向 FFI：调用 C 与被 C 调用

Lean4 提供两种核心属性实现与 C 的双向接口：

| 属性 | 方向 | 用途 |
|------|------|------|
| `@[extern "sym"]` | C → Lean | 在 Lean 中声明外部 C 函数（Lean 调用 C） |
| `@[export sym]` | Lean → C | 将 Lean 函数导出为非修饰 C 符号（C 调用 Lean） |

#### `@[extern]` —— Lean 调用 C

```lean
-- 声明外部 C 函数为 opaque
@[extern "c_my_function"] opaque myFunction : Float → Float → IO Float
```

对应的 C 端使用 `<lean/lean.h>` API：
```c
#include <lean/lean.h>
lean_obj_res c_my_function(lean_obj_arg x, lean_obj_arg y, lean_obj_arg world) {
    double a = lean_float_of(x);
    double b = lean_float_of(y);
    return lean_io_result_mk_ok(lean_float_to(a + b));
}
```

#### `@[export]` —— C 调用 Lean

```lean
-- 将 Lean 函数导出为 C 符号
@[export "lean_sin_approx"]
def sinApprox (x : Float) : Float := ...
```

生成的 C 签名遵循 Lean ABI 类型映射：

| Lean 类型 | C 类型 |
|-----------|--------|
| `Float` | `double` |
| `UInt8`…`UInt64`, `USize` | `uint8_t`…`uint64_t`, `size_t` |
| `Bool` | `uint8_t` |
| `Char` | `uint32_t` |
| `Nat`, `Int`, `String`, `List`, 其他归纳类型 | `lean_object *` |

**关键规则**：
- `IO α` 返回的函数 → C 签名多一个 `lean_obj_arg world` 参数，返回 `lean_obj_res`（即 `Result` 对象）
- 参数和返回值都遵循所有权约定（调用者转移引用计数，被调者返回拥有的对象）
- `Float` 直接映射为 `double` —— **纯数据，不携带证明**

### 5.3 构建共享库

用 Lake 构建可被外部 C 程序链接的 `.so`/`.dylib`：

```lake
-- lakefile.lean 或 lakefile.toml
-- 构建动态库
-- lake build MyLib:dynlib
```

这生成 `libMyLib.so`，C 端链接 `-lMyLib -lleanshared` 即可调用其中 `@[export]` 的函数。

**当前限制**：
- Lake 暂不支持"胖"动态库（将 stdlib 打包进同一 .so），外部调用时需同时链接 `libleanshared`
- `precompileModules` 在 Linux 上有时因 `libLake_shared.so` 加载顺序问题而失败 (Issue #9420, 2025-07)
- 动态库中可能缺少 stdlib 符号，需链接 `libleanshared.so` 解决（Zulip 2025-01 讨论）

### 5.4 辅助工具

| 工具 | 用途 |
|------|------|
| **[Alloy](https://github.com/tydeu/lean4-alloy)** | 在 Lean 源码中内联 C FFI 代码，Lake 自动编译 shim |
| **[lean4-ctypes](https://reservoir.lean-lang.org/@alexf91/lean4-ctypes)** | 类 Python ctypes 库，用 `libffi` 在 Lean 中直接调用共享库函数，无需写 C 胶水代码 |
| **[lean-rs-sys](https://docs.rs/lean-rs-sys/)** | Rust 侧 Lean4 C ABI 绑定，可用于 Rust ↔ Lean 互操作 |

### 5.5 新后端的可能性

社区讨论中的方向（2025-11 Zulip）：
- **JS 后端**：两种路线 —— (a) 在 IR 层修改 `EmitC.lean` 输出 JavaScript（~800 LOC），(b) 通过元编程检查环境直接生成目标代码
- **WASM 后端**：可交叉编译 C 输出到 wasm32，或用 Emscripten 编译 Lean 运行时到 WASM
- 目前没有官方 JS/WASM 后端

### 5.6 对浮点验证的意义

**`@[export]` + `Float = double` 意味着**：你可以用 Lean4 证明算法在实数语义下的数学正确性，然后将算法的浮点实现编译为 C 共享库，由外部程序直接调用。但这个过程是**单向的** —— C 侧拿到的 `double` 不携带任何 Lean 证明。

对比 Why3 路线：
- **Why3** 可以提取到 C（包括浮点数，v1.8.0+），且经过 CompCert 验证编译器时保证浮点语义保留
- **Lean4** 可以导出 C 接口，但没有经过验证的编译器保证语义保留。浮点运算的实际行为由硬件/Clang 决定

实际可行的混合策略：
1. 用 Lean4 + SciLean 证明数值算法的实数语义正确性（收敛性、误差阶等）
2. 用 C/汇编实现具体浮点运算，通过 `@[extern]` 在 Lean 侧调用
3. 浮点舍入误差的精细分析仍依赖 Why3/Gappa/Flocq 体系

---

## 6. Lean4 当前实际能做到什么

### 6.1 数值计算相关能力矩阵

| 能力 | 成熟度 | 工具/库 |
|------|--------|---------|
| 实数分析形式化 | ✅ 成熟 | mathlib Analysis 部分 |
| 可计算实数（超越函数） | 🟡 实验 | ComputableReal（Cauchy 序列 + `native_decide`） |
| 自动微分（形式化验证） | 🟡 早期 | SciLean |
| ODE 求解器验证 | 🟡 早期 | SciLean |
| 优化算法验证 | 🟡 早期 | SciLean（BFGS, LBFGS, 梯度下降） |
| 对数数制误差分析 | ✅ 有先例 | IEEE 2025 论文 |
| Toom-Cook 乘法验证 | ✅ 有先例 | CPP 2025 相关 |
| 代数数论计算认证 | ✅ 成熟 | CPP 2025 Distinguished Paper |
| IEEE 754 浮点形式化 | ❌ 无 | FloatSpec (WIP, 大量 sorry) |
| 浮点舍入误差自动推导 | ❌ 无 | — |
| libm 级函数验证 | ❌ 不可行 | — |

### 6.2 适合用 Lean4 做的数值验证

1. **实数语义下的算法正确性**：收敛性、误差阶、稳定性分析 —— mathlib 的实分析库已相当成熟
2. **组合/代数类计算认证**：多项式求值方案（Estrin/Horner）、查表索引正确性
3. **参数归约的形式化验证**：将大范围输入归约到小区间这一步骤的数学正确性
4. **具体值的编译时验证**：`native_decide` 可验证有界具体浮点计算
5. **科学计算中数学模型的形式化**：SciLean 的 ODE/PDE 求解器验证

### 6.3 不适合用 Lean4 做的

1. **浮点误差逐位分析**：没有 IEEE 754 形式化 → 无工具
2. **正确舍入保证**：需要 Flocq/Gappa 级别的精细形式化
3. **混合精度算法验证**：需要多格式浮点模型
4. **编译器优化对浮点语义影响的验证**：需要 CompCert 级别的验证编译器

---

---

## 8. Lean4 能做的 Why3 能做吗？—— 能力对位与架构差异

这是理解两者定位的核心问题。答案是：**大部分各有对应，但能力边界由底层设计哲学决定**。

### 8.1 Lean4 能做、Why3 也能做（但方式不同）

| 能力 | Lean4 | Why3 |
|------|-------|------|
| 实数分析形式化 | mathlib：度量空间、Lebesgue 积分、泛函分析 | 库较小；实数用 Coq 后端可达（Coquelicot），但不直接 |
| 算法正确性证明 | 归纳类型 + 依值类型，直接在类型中编码规约 | WhyML：Hoare 逻辑 + 前后置条件；证明在 VC 层面分离 |
| 可执行代码 + 证明 | 同一语言：代码即证明对象 | 分层：WhyML（可提取）+ Coq/其他证明器。**代码和证明语言分离** |
| C 代码输出 | `@[export]` → C 共享库（未经形式化验证的编译） | Why3 C 提取 + CompCert（可选，经过验证编译器） |
| 编译时具体值验证 | `native_decide` | SMT solver 在证明时求值 |

### 8.2 Lean4 能做、Why3 做不好或做不到的

#### a. 深度数学分析

Lean4 的 mathlib 是目前最大、最活跃的形式化数学库。Why3 的标准库偏计算，缺乏：
- Lebesgue 积分、测度论
- 泛函分析、Banach/Hilbert 空间
- 复杂代数结构（Galois 群、同调代数）
- 数论成果（Apéry 定理等）

**Why3 不是设计来做数学研究的**——它是为程序验证而生的。如果你要证明数值算法的**数学收敛性**依赖于深层分析理论，Lean4 是正确的地方。

#### b. 元编程与自动化定制

Lean4 是它自己的元编程语言（`Lean.Elab`、`Lean.Meta`）。你可以：
- 写 tactic 自动化证明特定领域的目标
- 生成代码和证明模板
- 在编译时反射类型信息

Why3 有 **transformations**（程序转换和 VC 变换），但其开放性和表达能力远不如 Lean 的元编程。

#### c. LLM 辅助证明

Lean4 有活跃的 LLM 辅助证明生态：
- Aristotle（AI 定理证明器）
- GPT + Lean 的 autoformalization 管道
- NeurIPS 2025 的 Agentic Lean Autoformalization

Why3 目前没有可比的 LLM 集成。这在处理大型验证任务的"体力活"部分时可能产生巨大的生产力差异。

#### d. 科学计算库（SciLean）

SciLean 在形式化验证和科学计算之间架起了一座独特的桥梁 —— 自动微分、ODE 求解器、优化算法的**形式化正确性保证** + **实际可执行**。Why3 没有对等的项目。

#### e. 统一语言

Lean4 中规约、实现、证明在**同一个语言**中表达，不需要在 WhyML / Coq / SMT-LIB / Gappa 脚本之间切换。这降低了多工具栈的认知负荷，但也意味着失去"用正确工具做正确事"的灵活性。

### 8.3 Why3 能做、Lean4 做不好的

#### a. SMT 自动证明

Why3 的 VC 生成 + SMT 分派（CVC5、Z3、Alt-Ergo）是其核心优势：**大量浮点验证条件是自动解决的**，无需手写证明。

Lean4 没有 SMT 集成 —— 每个目标都需要构造证明项，或使用 `native_decide`（仅适用于可判定理论的有界实例）。

在 PropaFP 验证 sine 实现的案例中：158 个 VC 中 146 个由 SMT 自动解决，仅 12 个需要非线性实数证明器。**这个自动化率在 Lean4 中不可想象**。

#### b. Gappa 误差自动推导

Gappa 接收浮点表达式和误差约束，自动计算紧致误差界并生成 Coq 可检查的证明证书。这是专门为浮点误差分析设计的工具。（更准确地说，Gappa 基于区间算术 + 改写规则自动推导舍入误差界，然后将证明义务输出为 Coq 脚本或 Why3 可用的 VC。）

Lean4 没有类似的东西。在 Lean4 中分析浮点误差需要**纯手工展开每一位舍入的证明**。

#### c. SPARK/ACSL 工作流

Why3 可以验证**现有 C 代码**（通过 SPARK + ACSL 注解），不需要用 WhyML 重写。对于已经存在的 libm 实现，这意味可以用 ACSL 标注现有代码，然后 Why3 生成验证条件。

Lean4 验证任何代码都需要先在 Lean 中重新实现它 —— 这是完全不同的信任模型。

#### d. CompCert 端到端验证

Why3 路线可以从 WhyML 规约到 CompCert 验证编译器的末端给出浮点语义保留的端到端保证。这意味着**C 代码中的浮点运算确实按照 IEEE 754 执行，没有编译器优化引入的意外行为**。

Lean4 的 C 后端不提供语义保留保证。

#### e. 分离关注点的架构

Why3 的设计哲学是：
```
WhyML 写程序 + 规约
    ↓
Why3 生成验证条件 (VC)
    ↓
  ┌───────────────────────────┼───────────────────────────────┐
  │                           │                               │
CVC5/Z3/Alt-Ergo          Gappa/PropaFP                   Coq
(简单算术自动证明)        (舍入误差自动推导)            (深层数学/归纳)
```

这种**每个关注点用最合适工具**的哲学，在处理浮点验证这种跨层问题时，比单一语言更高效。

#### f. Flocq 浮点数形式化

Flocq 是目前最完整的 IEEE 754 形式化（Coq 中），提供通用的多基、多格式、多精度浮点模型。Why3 的 `ieee_float` 也受益于这一理论。Lean4 的 FloatSpec 移植尚未完成。

### 8.4 架构差异的根源

| 维度 | Why3 | Lean4 |
|------|------|-------|
| **类型系统** | 一阶多态逻辑（first-order with polymorphism） | 依值类型论（Calculus of Inductive Constructions） |
| **证明方式** | 外部（SMT、ATP、交互式后端） | 内部（证明项在类型论中构造） |
| **自动化** | SMT 求解器提供高自动化 | 元编程 tactic + `native_decide`，较低自动化 |
| **表达能力上限** | 受限于一阶逻辑 | 依值类型可表达任意数学 |
| **核心用例** | **程序验证**：代码有 bug 需要发现 | **数学证明**：理论是正确的需要确认 |
| **浮点专长** | 专为浮点/定点数值程序验证设计 | 通用数学，浮点非强项 |
| **生态成熟度** | Inria 主导，稳定 | 社区驱动，快速增长 |

### 8.5 实际选择指南

```
你要做什么？
│
├── 验证 C libm 实现的具体精度的正确舍入？
│   → Why3 + Gappa + Flocq (唯一可行路线)
│
├── 验证数值算法（ODE/PDE 解）的数学收敛性和稳定性？
│   → Lean4 + mathlib + SciLean (实数定理更丰富)
│
├── 验证混合精度算法（fp32/fp64/int 混合运算）？
│   → Why3 + Flocq (多格式模型已就绪)
│
├── 为一套浮点代码建立持续集成中的自动验证流水线？
│   → Why3 (SMT 自动化率高，人工干预少)
│
├── 对算法做深度实分析证明（涉及测度论、泛函）？
│   → Lean4 (mathlib 无可替代)
│
├── 想用一个语言搞定规约+实现+证明，拥抱 LLM 辅助？
│   → Lean4 (统一语法 + AI 生态)
│
├── 既有 C 代码不改写，只加注解验证？
│   → Why3 (SPARK/ACSL 路线) 或 Frama-C
│
└── 全面验证 libm：从数学正确性到浮点舍入到 C 实现？
    → 结合使用：Lean4 验证实数语义 + Why3/Gappa 验证浮点误差
```

---

## 9. 对 libm 实现验证的可行性评估

### 5.1 用 Why3 验证 libm 类函数

**可行且已有先例**。典型路径：

```
WhyML 实现 → Why3 VC 生成 → CVC5/Z3 自动证明（简单 VC）
                            → Gappa 处理舍入误差 VC
                            → Coq 处理复杂数学 VC
```

核心挑战：
- **参数归约的正确性**（如 Cody-Waite 归约）：需要三角函数恒等式的形式化证明
- **多项式逼近误差界**：需要 Gappa 或 CoqInterval 的 Taylor 模型
- **溢出的正确处理**：可用 `ufloat` 分离溢出与精度关注点
- **查表正确性**：代码生成 + 穷举验证

### 5.2 用 Lean4 验证 libm 类函数

**当前不可行**，需要等待：
1. FloatSpec 的 `sorry` 被填补
2. 或社区产生新的 IEEE 754 形式化方案
3. 替代路线：在实数语义下证明算法正确性，将浮点误差作为独立关注点用手工分析处理（与 Why3 路线的自动化程度差距大）

---

## 6. 推荐阅读路径

1. **入门**：Boldo & Melquiond, *Computer Arithmetic and Formal Proofs* (2017) — 完整的方法论
2. **Why3 浮点**：[ieee_float 标准库文档](https://why3.org/stdlib/ieee_float.html)
3. **Gappa**：[Gappa 主页](https://gappa.gitlabpages.inria.fr/) + de Dinechin, Lauter, Melquiond (2006) 论文
4. **Flocq**：[Flocq 文档](https://flocq.gitlabpages.inria.fr/)
5. **最新综述**：Boldo et al., *Floating-point arithmetic* (Acta Numerica, 2023)
6. **Lean4 浮点方向**：[FloatSpec 仓库](https://reservoir.lean-lang.org/@Beneficial-AI-Foundation/FloatSpec)
7. **CORE-MATH**：[CORE-MATH 项目页](https://core-math.gitlabpages.inria.fr/)

---

## 7. 关键联系人/团队

- **Guillaume Melquiond** (Inria/LMF) — Flocq、Gappa、CoqInterval、Coquelicot 的主要作者
- **Sylvie Boldo** (Inria/LMF) — Flocq 合著者，浮点验证综述
- **Claude Marché** (Inria/LMF) — Why3 核心开发者，LSE 验证
- **Paul Zimmermann** (Inria) — CORE-MATH 项目主导
- **Beneficial AI Foundation** — FloatSpec (Lean4 Flocq 移植)
- **Junaid Rasheed & Michal Konečný** — PropaFP (SPARK/Why3 浮点自动验证)
