---
unlisted: true
authors: claude-code, deepseek-v4-pro
tags: [ai, research, formal-verification, floating-point, reproducible-computation, numerical-analysis, scientific-computing]
title: "科学计算形式化验证与确定性输出：工具生态调研"
date: 2025-07-02
lang: zh-Hans
---

# 科学计算的形式化验证与确定性输出：工具生态调研

## 摘要

调研科学计算领域（Python/NumPy、Julia、R、MATLAB、Fortran、C/C++、Ada/SPARK 等）中实现形式化验证或确定性输出的语言、库与工具。覆盖形式化验证工具链（Coq/VeriNum、SPARK、Lean4/FloatSpec）、确定性/可复现浮点计算（ReproBLAS、Intel oneMKL CNR）、数值精度工具（Herbie、Verrou、CPFloat），以及 SMT 求解器和 AI 辅助验证的新兴方向。

**核心结论**：Coq + Flocq + VST 构成的 VeriNum 工具链（Princeton, 2022–2025）是目前最全面的数值代码形式化验证体系，已产出 ODE 求解、迭代线性求解器、并行点积和稀疏矩阵转换的机器检查证明。SPARK/Ada 在浮点验证中需要多证明器组合（CVC4+Z3+Alt-Ergo），全功能正确性验证的规约开销约 6–10 行/行代码。Lean 4 的 FloatSpec 库仍不完整。确定性计算方面，ReproBLAS 通过算法层面保证跨平台误差上界，Intel oneMKL CNR 通过实现层面控制保证比特级复现但函数覆盖有限。现有形式化验证工具分类学完全忽略科学计算特有的浮点误差、数值稳定性问题——这是领域最大的系统性空白。

> **方法说明**：本报告由 Claude Code 的 deep-research 工作流生成（105 agent，2.4M tokens），经过 3 票对抗性验证（25 条声明中 16 条存活，9 条被驳回），结论附带来源。

---

## 1. 形式化验证工具

### 1.1 VeriNum 工具链（Coq 生态）

**项目定位**：Princeton/Cornell/Michigan 联合研究项目（2022–2025），DOE/NSF/Sandia 资助。目标是在 Coq 中通过分层方法对数值 C 程序进行端到端的基础验证。

**核心组件**：

| 组件 | 功能 | 成熟度 |
|------|------|--------|
| **Flocq** | Coq 中浮点算术的形式化（Boldo & Melquiond 奠基性工作，成书出版） | ★★★★★ 成熟 |
| **VCFloat2** | 在 Coq 中自动计算浮点表达式舍入误差界（Appel & Kellison, CPP 2024, DOI: `10.1145/3636501.3636953`） | ★★★☆☆ 研究级 |
| **VST**（Verified Software Toolchain） | C 程序验证工具链，基于 CompCert Clight 语义 | ★★★★☆ 成熟 |
| **LAProof** | 线性代数程序的精度与正确性证明库（ARITH 2023） | ★★★☆☆ 研究级 |

**已验证的证明案例**：

| 案例 | 来源 | 规模 |
|------|------|------|
| Leapfrog 法 ODE 求解器 | NSV 2022, GitHub: `VeriNum/VerifiedLeapfrog` | 含离散化误差 + 舍入误差双重证明 |
| Jacobi 迭代线性求解器 | CICM 2023, LNCS vol.14101 | ~40K 行 Coq，含收敛性与精度证明 |
| 并行点积（共享内存） | Appel 2022/2025, GitHub: `VeriNum/pardotprod` | — |
| COO→CSR 稀疏矩阵转换 | VSS 2025, EPTCS 432, DOI: `10.4204/EPTCS.432.3` | — |

**局限性**：
- VCFloat2 仅处理无分支直线代码，无初始误差支持，不支持 FMA
- VeriNum 不是统一的"工具"而是研究项目集合，尚未形成 product
- 无已知工业级安全关键部署案例

**来源**：[VeriNum 项目主页](https://verinum.org/)、[VCFloat2 仓库](https://github.com/VeriNum/vcfloat)、[VerifiedLeapfrog](https://github.com/VeriNum/VerifiedLeapfrog)、[pardotprod](https://github.com/VeriNum/pardotprod)

---

### 1.2 SPARK（Ada 可证明子集）

**关键数据**：

- **规约开销**：全功能正确性约 6–10 行规约/行可执行代码。来源为 TU Delft 学士论文（Blanovschi, 2025 年 6 月），n=3 序贯算法——哈希表 6.4:1、插入排序 8.3:1、快排 13.8:1，均值 9.5:1。
- **多证明器依赖**：浮点验证必须同时使用 CVC4 + Z3 + Alt-Ergo。在含 619 个证明义务的加权平均案例中，缺失任何一个证明器都需要额外人工介入（Dross & Kanig, VSTTE 2021, 同行评审, 41% 接受率）。这一多证明器依赖性被 Rasheed & Konecný (2022) 独立确认。
- **瓶颈在规约设计而非求解器性能**——论文摘要明确指出规约设计是主要成本驱动因素。
- **大规模验证**：NATS iFACTS 系统（529K 行）以较低"防崩溃"保证级别验证，约 0.29 VCs/行，98.76% 自动证明率——与全功能正确性目标的开销模式显著不同。

**⚠️ 重要提醒**：以上开销数据来自学士论文（非同行评审），仅研究 n=3 入门级算法，排除堆分配程序。快排的 `Multiset_Unchanged` 属性因 SMT 超时被迫使用 `pragma Assume`——不是完整形式证明。数据不宜外推到大型科学计算代码。

**来源**：[SPARK 浮点验证论文 (VSTTE 2021)](https://www.adacore.com/uploads/techPapers/floats_spark.pdf)、[TU Delft 论文](https://repository.tudelft.nl/record/uuid:18b4b3ef-da6e-4bc8-8b2b-01f9a874a5d7)

---

### 1.3 Lean 4 / FloatSpec

**状态**：FloatSpec v0.7.0（Beneficial AI Foundation，最后更新 2026-06-22）是从 Coq Flocq 到 Lean 4 + Mathlib 的移植项目。

**不完整证明清单**（项目自报）：
- `Core/Generic_fmt.lean` —— 舍入/通用格式引理
- `Core/Ulp.lean` —— ULP 和舍入桥接引理
- IEEE 754 编码相关文件
- 误差上界文件：`Plus_error.lean`、`Div_sqrt_error.lean` 等

构建系统显式允许 `sorry` 警告。项目文档自述"仍处于活跃开发中，尚未完成"，"许多深层证明仍为占位符"。

**结论**：Lean 4 目前无可用于生产的完整 IEEE 754 形式化库。FloatSpec 是最接近的尝试，但距离可以验证 libm 级算法还有显著差距。

**来源**：[FloatSpec Reservoir](https://reservoir.lean-lang.org/@Beneficial-AI-Foundation/FloatSpec)

---

### 1.4 分类学空白

arXiv:2002.04955（"The Space of Mathematical Software Systems"，2020）引入了五维分类法，将 Coq/Isabelle/Lean/Agda/Mizar/HOL/PVS 归为证明助理，Vampire/E/Spass 归为自动定理证明器，Z3/CVC 归为 SMT 求解器，按自动化程度与逻辑强度区分。但全文搜索确认：**零**讨论浮点误差分析、数值稳定性、区间算术、确定性浮点计算。这意味着实践者查阅该领域最广泛引用的分类学论文时，得不到任何科学计算领域特定的形式化验证指导。

**来源**：[arXiv:2002.04955](https://ar5iv.labs.arxiv.org/html/2002.04955)

---

## 2. 确定性/可复现计算

### 2.1 ReproBLAS（算法层面复现）

- **机制**：分箱浮点累加器，双精度下至少 80 位精度
- **误差上界**：n·2⁻⁸⁰·max\|xⱼ\| + 7ε·\|Σxⱼ\|（ε = 2⁻⁵³），**与求和顺序无关**
- **跨平台性**：通过算法设计保证（非编译器选项或执行环境控制）
- **当前限制**：`reproBLAS.h` 仅支持单核计算；多线程（OpenMP）和分布式（MPI）模式列为"未来工作"

论文：Demmel, Ahrens, Nguyen, UCB/EECS-2016-121 (2016 年 6 月)，Equation 1.1，证明见 Sections 6.8–6.9。SIAM News 2018 和后续出版物（至 2024）持续引用。

**来源**：[ReproBLAS 项目页](https://bebop.cs.berkeley.edu/reproblas/)

---

### 2.2 Intel oneMKL CNR（实现层面控制）

**标准 CNR**：
- 必须固定线程数：`MKL_DYNAMIC=FALSE`、`OMP_DYNAMIC=FALSE`，通过 `OMP_NUM_THREADS` 或 `MKL_NUM_THREADS` 显式指定
- 不支持 TBB 线程后端
- 需额外设置 `MKL_CBWR` 环境变量控制 ISA 代码分支（`MKL_CBWR_COMPATIBLE` 最保守）

**STRICT CNR**：
- 保证比特级一致，**不受线程数影响**
- **仅覆盖** `?gemm`、`?symm`、`?hemm`、`?trsm` 及其 CBLAS 等效接口
- 仅限 64 位库 + AVX2 或 AVX-512 代码路径
- 不保证不同 oneMKL 库版本间的一致性

**性能折衷**：Intel 文档描述为"性能可能下降 10–20%"（条件语气），原因是 CNR 限制算法选择以维持运算顺序。

**来源**：[Intel oneMKL 开发者指南 2025.1](https://www.intel.com/content/www/us/en/docs/onemkl/developer-guide-windows/2025-1/obtaining-numerically-reproducible-results.html)

---

### 2.3 编译器方案——无法保证

GCC、Clang、ICC、NVHPC 均**不提供**跨平台比特级一致的浮点结果保证。所有编译器标志（如 `-ffloat-store`、`-fp-model precise`、`--fmad=false`）仅限制破坏 IEEE 754 严格性的优化——减少但不消除不确定性。

**来源**：[TU Dresden 编译器概要](https://compendium.hpc.tu-dresden.de/software/compilers/)

---

## 3. 数值精度工具

### 3.1 Herbie —— 表达式精度改进

自动将浮点表达式重写为数学等价但数值更稳定的形式。典型转换：

```
sqrt(x+1) - sqrt(x)  →  1 / (sqrt(x+1) + sqrt(x))
```

- 由 UW PLSE 组开发，主动维护（2024–2025）
- 提供 Web 工具 + CLI
- 使用启发式搜索（采样 → 识别问题 → 重写 → 验证）
- **定位**：改进精度而非形式化验证——不提供正确性保证
- 已知局限：采样偏差可能影响精度报告，边界情况偶有 bug（GitHub issues #742, #842, #1058）

**来源**：[Herbie 主页](https://herbie.uwplse.org/)

---

### 3.2 Verrou —— 动态舍入误差分析

基于 Valgrind 动态二进制插桩，**无需重编译源码**即可检测浮点舍入误差。

**三种随机舍入模式**（异步 Monte Carlo Arithmetic 变体）：
1. **random** —— 最近邻上下等概率
2. **prandom** —— 偏置概率 p
3. **average** —— 期望值匹配精确结果

**确定性变体**（Verrou 独特优势）：
- `random_det`、`nearness_det`、`random_comdet`、`nearness_comdet`、`random_scomdet`、`nearness_scomdet`
- 使用 xxhash（默认）等哈希函数产生跨运行可复现的"随机"舍入序列
- 可选哈希函数：dietzfelbinger、multiply_shift、double_tabulation、mersenne_twister

发布记录：SCAN 2016（Févotte & Lathuilière, hal-01383417）→ NSV 2017 → Correctness 2019 → ACM TOMS 2021。列入 valgrind.org 为官方 Valgrind 变体。仅需 `-g` 调试符号用于源码级诊断，非特殊重编译。

**核心价值**：适用于无法修改源码的遗留/闭源科学计算代码。

**来源**：[Verrou GitHub](https://github.com/edf-hpc/verrou)、[官方手册](https://edf-hpc.github.io/verrou/vr-manual.html)

---

### 3.3 CPFloat —— 可定制精度低精度模拟

C 语言库，在标准 `float`/`double` 数组中存储数值，支持用户定义的精度参数（p, e_min, e_max, subnormal 支持 sigma）。

**关键特性**：
- 顺序 + OpenMP 并行实现，构建时自动调优选择最优阈值
- PCG（显式 seed）或 C 标准 `rand`/`srand` 作为 PRNG
- 顺序/并行路径消耗不同 PRNG 序列 → 相同输入不同路径产生不同结果

**可复现性**：README（155 行）中**零** "reproducible"/"deterministic"/"bit-level"/"guarantee" 声明。CPFloat 优先考虑可定制精度而非可复现性——与 Verrou 的显式确定性模式和 ReproBLAS 的算法保证形成对比。

ACM TOMS 2023 发表。

**来源**：[CPFloat GitHub](https://github.com/north-numerical-computing/cpfloat)

---

## 4. 语言生态快览

以下基于搜索阶段的发现（部分未进入验证轮次），置信度较低：

| 语言 | 形式化验证生态 | 确定性计算生态 |
|------|---------------|---------------|
| **C/C++** | Frama-C/WP + Why3、VST + CompCert、CBMC（有界模型检查） | ReproBLAS、Intel oneMKL CNR |
| **Ada/SPARK** | GNATprove + CVC4/Z3/Alt-Ergo，唯一经同行评审确认的浮点验证多证明器方案 | — |
| **Python** | 间接：通过 C 扩展（NumPy/SciPy）利用 C 生态 | JAX `jax.config.update("jax_enable_x64", True)` + `jax.numpy` 确定性模式（未进入验证轮次） |
| **Julia** | 类型系统理论上利于验证（参数化类型、多重派发），但缺乏经确认的形式化验证工具 | — |
| **Rust** | Kani（可验证 unsafe，含循环边界限制且仅单态代码）；Creusot/Prusti（可验证 safe 泛型但无法处理 unsafe，非全自动）——来自 Rust 2024h2 目标文档 | — |
| **Fortran** | 大量科学计算遗留代码，但形式化验证实践未被搜索覆盖 | 编译器标志仅限制优化，不保证比特级一致 |
| **R/MATLAB** | 未在本次调研中获得有效覆盖 | — |

**区间算术库补充**：TIGHT（C++ 库，CC 2025）扩展 NFG 库，支持正确舍入的超越函数（sin/cos/log/exp），使用 CORE-MATH 实现。

---

## 5. 新兴方向

### 5.1 SMT 求解器进展

**Grater**（PLDI 2025）：
- 基于数学优化的浮点约束求解器
- 匹配 Bitwuzla 和 CVC5 的求解数量，中位速度提升 10×
- 将浮点约束转化为连续优化问题

**parSAT**（arXiv 2025）：
- 将浮点 SMT 可满足性问题转化为全局优化
- 三个随机算法并行（Basin Hopping / CRS2 / ISRES）
- 在 Griggio 基准上 ~327× 更快，但少解约 6%

### 5.2 AI 辅助验证

**APOLLO**（NeurIPS 2025）：
- 编译器引导的 LLM 证明修复（Lean 4），利用编译器错误信息指导证明生成
- miniF2F 基准上达到 84.9% SOTA（sub-8B 模型），每个定理 <100 样本

**Cobblestone**（2024）：
- 全自动 Coq 证明合成，超越 SOTA 非 LLM 工具
- 单次运行约 $1.25 / 14.7 分钟

> **注意**：以上 AI 辅助验证工具面向数学定理证明，尚未被证明能直接应用于科学计算浮点代码的形式化验证。

---

## 6. 局限与空白

本报告的已知局限：

1. **覆盖缺口**：存活声明集中在 Coq/VeriNum、SPARK/Ada、Verrou 和可复现 BLAS。Julia、Rust、MATLAB、R 和 Fortran 的形式化验证生态未被充分代表。
2. **学术成熟度**：大多数确认来源为研究工具或厂商文档，无工业安全关键部署案例研究进入验证轮次。
3. **SPARK 数据来源**：规约开销数据来自学士论文（非同行评审），n=3 小型算法，不宜外推。
4. **FloatSpec 未完成**：Lean 4 浮点形式化能力在生产环境中未经证实。
5. **时效性**：Intel oneMKL CNR 声明引用 2025.1/2025.2 文档，厂商复现性保证可能随版本变化。

**待研究问题**：
- 区间算术库（Arb、MPFI、Boost.Interval、TIGHT）与证明助理的集成状态
- 安全关键科学计算（核模拟、航空 GNC、医疗设备）中的形式化验证工业部署
- AI 生成浮点验证所需循环不变式和 SMT 提示的方法论
- Julia 生态中利用类型系统进行可验证科学计算的框架

---

## 主要来源

| 来源 | 类型 |
|------|------|
| [VeriNum 项目](https://verinum.org/) | 研究项目主页 |
| [VCFloat2 (CPP 2024)](https://doi.org/10.1145/3636501.3636953) | 同行评审论文 |
| [FloatSpec (Lean 4)](https://reservoir.lean-lang.org/@Beneficial-AI-Foundation/FloatSpec) | 开源库（自报状态） |
| [SPARK 浮点验证 (VSTTE 2021)](https://www.adacore.com/uploads/techPapers/floats_spark.pdf) | 同行评审论文 |
| [ReproBLAS](https://bebop.cs.berkeley.edu/reproblas/) | 研究项目主页 |
| [Intel oneMKL CNR](https://www.intel.com/content/www/us/en/docs/onemkl/developer-guide-windows/2025-1/obtaining-numerically-reproducible-results.html) | 厂商文档 |
| [Herbie](https://herbie.uwplse.org/) | 研究项目主页 |
| [Verrou](https://github.com/edf-hpc/verrou) | 开源工具（EDF R&D） |
| [CPFloat](https://github.com/north-numerical-computing/cpfloat) | 开源库（ACM TOMS 2023） |
| [Grater (PLDI 2025)](https://pldi25.sigplan.org/details/pldi-2025-papers/30/Solving-Floating-Point-Constraints-with-Continuous-Optimization) | 同行评审论文 |
| [arXiv:2002.04955](https://ar5iv.labs.arxiv.org/html/2002.04955) | 综述论文（非同行评审） |
| [TU Delft 论文 (2025)](https://repository.tudelft.nl/record/uuid:18b4b3ef-da6e-4bc8-8b2b-01f9a874a5d7) | 学士论文 |
| [TU Dresden 编译器概要](https://compendium.hpc.tu-dresden.de/software/compilers/) | 教育资源 |
