---
unlisted: true
authors: claude-code
tags: [ai, research]
---

# Why3 后端全景：浮点数约束与数学函数支持能力矩阵

> 梳理 Why3 支持的所有后端证明器，评估其浮点数约束与常用数学函数（sin/cos/exp/log 等）的支持能力。可作为 [[数值函数形式化验证-中间语言与验证平台选型.md]] 和 [[数值函数形式化验证-想法与约束.md]] 的补充参考。
>
> **整理日期：2026年6月**

---

## 一、核心问题

在数值函数形式化验证中，需要后端正交回答两个层次的问题：

1. **浮点数约束**：IEEE 754 舍入误差能否被自动证明器处理？
2. **数学函数约束**：sin/cos/exp/log 等超越函数的不等式能否被证明器处理？

**这两个层次的后端支持完全不同**——大多数 SMT solver 的浮点理论只覆盖基本运算（`+ - × ÷ √ fma`），不覆盖超越函数。

---

## 二、Why3 支持的后端完整列表

Why3 的核心架构：**WhyML 程序 + 规约 → Why3 生成验证条件 (VC) → 分派到各种后端证明器**。

### 2.1 自动证明器（SMT / ATP）

| 证明器 | 类型 | 量化 | 算术 | 位向量 | 浮点理论 | 超越函数 |
|--------|------|------|------|--------|----------|----------|
| **Alt-Ergo** (≥2.6) | SMT | ✅ | 线性/非线性 | ✅ | ⚠️ 自定义 `ae.round` | ❌ |
| **CVC4** | SMT | ✅ | ✅ | ✅ | ✅ SMT-LIB FP 原生 | ❌ |
| **cvc5** | SMT | ✅ | ✅ | ✅ | ✅ SMT-LIB FP 原生 | ❌ |
| **Z3** | SMT | ✅ | ✅ | ✅ | ✅ SMT-LIB FP 原生 | ❌ |
| **Colibri / Colibri2** | SMT (CLP) | ✅ | ✅ | ✅ | ✅ | ❌ |
| **dReal** | δ-SAT | ❌ | 非线性实数 | ❌ | ⚠️ 精确实数替代 | ✅ sin/cos/exp/log |
| **Gappa** | 区间算术 | ❌ | 浮点舍入 | ❌ | ✅ 浮点误差专用 | ⚠️ 间接 |
| **MetiTarski** | ATP + RCF | ❌ | 非线性实数 | ❌ | ⚠️ 实数替代 | ✅ 多项式上下界 |
| **Metis** | ATP | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Princess** | ATP | ❌ | 线性整数 | ❌ | ❌ | ❌ |
| **E Prover** | ATP | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Vampire** | ATP | ✅ | ❌ | ❌ | ❌ | ❌ |
| **SPASS** | ATP | ✅ | ❌ | ❌ | ❌ | ❌ |
| **veriT** | SMT | ✅ | 线性 | ❌ | ❌ | ❌ |
| **Yices2** | SMT | ❌ | ✅ | ✅ | ❌ | ❌ |
| **Beagle** | ATP | ❌ | 线性 | ❌ | ❌ | ❌ |
| **Psyche** | 模块化 | — | — | — | — | — |

### 2.2 交互式证明器（Proof Assistants）

| 证明器 | 理论基础 | 超越函数 | 特点 |
|--------|----------|----------|------|
| **Coq** | CIC (归纳构造演算) | ✅ Coquelicot 完整实分析 | 最完整的 Why3 理论实现；Flocq 浮点形式化 |
| **Isabelle/HOL** | 高阶逻辑 | ✅ `Transcendental` 理论 | 完整 Why3 理论 + `approximation` tactic |
| **PVS** | 经典类型论 | ✅ 基础库 | 较老的集成 |

### 2.3 官方建议的起步组合

`why3.org` 建议初学者安装：**Alt-Ergo + CVC5 + Z3**，必要时加 **Coq** 用于交互式证明。
SPARK 社区版默认携带：**Alt-Ergo + CVC5 + Z3**。

---

## 三、浮点数约束支持：三个梯队

### 3.1 第一梯队：原生 SMT-LIB FloatingPoint 理论 🟢

**CVC5、Z3**（以及 CVC4、Colibri）实现了完整的 SMT-LIB `FloatingPoint` 理论：

- 原生支持所有 IEEE 754 格式（binary16/32/64/128）
- 五种舍入模式（RNE、RNA、RTP、RTN、RTZ）
- 基本运算（`fp.add`、`fp.sub`、`fp.mul`、`fp.div`、`fp.sqrt`、`fp.fma`）
- 完整特殊值处理（NaN、±∞、±0、subnormal）
- 比较运算与分类谓词
- 浮点数与位向量/实数的转换

**Why3 使用方式**：`ieee_float.Float64` 模块（兼容 SMT-LIB FP 理论）→ Why3 driver 直接映射到 solver 原语。这是 Why3 浮点验证的**主力路径**。

### 3.2 第二梯队：自定义浮点理论 🟡

**Alt-Ergo** 采用不同策略（Conchon et al. "A Three-tier Strategy for Reasoning about Floating-Point Numbers in SMT", CAV 2017）：

- **不使用**标准 SMT-LIB `FloatingPoint` sort
- 采用自定义 `ae.round`：`(mantissa_size, exponent_min, rounding_mode, real) → real`
- 自 **2.5.0** 起引入 FPA 理论，**2.6.0 (2024-09)** 起默认启用
- `ae.float32` / `ae.float64` 等 SMT-LIB 格式缩写（#1135）
- **已知限制**：不支持 NaN、无穷大、overflow；underflow 被建模

**Why3 使用方式**：通过 driver 将 `ieee_float` VC 翻译为 Alt-Ergo 的 `ae.round` 原语。

### 3.3 第三梯队：实数量化 + 舍入公理 🔴

对于**不支持浮点理论**的证明器（如 E Prover、Vampire 等），Why3 提供备用方案：

- 将浮点数编码为**实数**
- 用 **`round` 函数 + 公理** 建模舍入行为
- 公理包括：`round_monotonic`、`round_idempotent`、`round_down_le` / `round_up_ge` 等

**这是不完整的**——涉及 NaN、subnormal、位级操作的性质无法表达。实际只能证明较简单的舍入误差性质。

---

## 四、常用数学函数（超越函数）支持

### 4.1 问题的本质

**浮点约束 ≠ 数学函数约束**。SMT solver 的 FP 理论只覆盖 IEEE 754 基本运算。当 VC 中出现 `sin(0.5)` 时，solver 不知道它的值是多少。

### 4.2 Why3 内置的超越函数理论

Why3 标准库提供了**公理化的**实数超越函数：

```
real/ExpLog.xml       — exp, log (自然对数)
real/Trigonometry.xml — sin, cos, pi, atan, tan
real/PowerReal.xml    — 实数幂
```

关键公理示例：
- `exp(x+y) = exp(x) * exp(y)`
- `log(exp(x)) = x`
- `sin²x + cos²x = 1`
- `sin(x+y) = sin(x)cos(y) + cos(x)sin(y)`
- 单调性、有界性等

### 4.3 各后端超越函数处理能力

| 后端 | sin/cos/exp/log | 机制 | 实际可用性 |
|------|-----------------|------|-----------|
| **Coq** | ✅ 完整 | Coquelicot 库提供完整实分析 | 可证复杂定理，需交互 |
| **Isabelle/HOL** | ✅ 完整 | `Transcendental` 理论 + `approximation` tactic | 可证复杂定理，需交互 |
| **MetiTarski** | ✅ 自动 | 多项式上下界替换 + RCF 判定过程 | 自动证不等式，≤9 变量可行 |
| **dReal** | ✅ δ-完备 | 原生支持 `sin`, `cos`, `exp`, `log` 等 | 自动，δ-近似结果 |
| **PropaFP** | ✅ (管道) | 将 FP 替换为精确实数 → 送 dReal/MetiTarski | 已验证 sine 和 sqrt 实现 |
| **CVC5** | ❌ | 仅有 Why3 公理，CVC5 无原生超越函数 | 仅能处理简单代数恒等式 |
| **Z3** | ❌ | 同上 | 同上 |
| **Alt-Ergo** | ❌ | 同上 | 同上 |
| **Gappa** | ⚠️ 间接 | 无内置超越函数；需外部提供多项式逼近的误差界 | 适合已知逼近多项式的舍入误差分析 |

### 4.4 为何 SMT solver 不支持超越函数？

根本原因是**可判定性**。带 sin/cos/exp 的非线性实数理论是不可判定的（Richardson 定理, 1968）。SMT solver 追求完全决策过程，不处理不可判定片段。

替代方案分两类：
- **δ-完备**（dReal）：放弃精度到任意 δ，换取可判定性
- **多项式上下界替换**（MetiTarski）：将超越函数替换为有理函数上下界，交给 RCF 判定过程

---

## 五、处理超越函数的四种策略

### 策略 A：Gappa 路线（CRlibm 风格）

```
超越函数 → 参数归约 → 多项式逼近 → Gappa 验证舍入误差
                ↑                      ↑
          数学证明（手工/Coq）    误差界由 Maple/Sollya 外部计算
```

- **适合**：已知多项式逼近系数，需要验证浮点实现的舍入误差界
- **局限**：Gappa 不理解 sin/cos 本身，只处理多项式
- **里程碑**：CRlibm 所有初等函数的正确舍入证明

### 策略 B：PropaFP 路线

```
SPARK 浮点程序 → Why3 VC → PropaFP 将 FP 替换为精确实数
                         → dReal / MetiTarski 直接处理含 sin/cos 的不等式
```

- **适合**：相对宽松的误差界（如 ≤0.001），含超越函数的数值算法
- **已验证案例**：Taylor 正弦逼近 (|x|≤0.5, 误差≤0.001)、Heron 平方根
- **参考**：Rasheed & Konečný, *Auto-active Verification of Floating-point Programs via Nonlinear Real Provers*, SEFM 2022

### 策略 C：Coq 交互式路线

```
WhyML → Why3 VC → Coq backend → Coquelicot + Flocq 完整形式化证明
```

- **适合**：深度数学证明（参数归约的三角函数恒等式、Taylor 余项分析）
- **代价**：大量手写证明
- **优势**：无自动化上限——理论上任何可形式化的数学都能证明

### 策略 D：MetiTarski 路线

```
Why3 VC (含 sin/cos/exp) → MetiTarski → 多项式上下界替换 → Z3/QEPCAD 解多项式不等式
```

- **适合**：中等复杂度的超越函数不等式自动证明
- **局限**：变量数 ≤9，对证明失败无反例
- **参考**：Akbarpour & Paulson, *MetiTarski: An Automatic Theorem Prover for Real-Valued Special Functions*, JAR 2010

---

## 六、组合矩阵：什么场景用什么后端

```
任务类型                           推荐后端组合
─────────────────────────────────────────────────────────────
纯浮点舍入误差（加减乘除sqrt）    CVC5 / Z3 / Alt-Ergo（任一）
浮点 + 位向量操作                  CVC5 / Z3
浮点 + 简单实数不等式              CVC5 + Z3 + Alt-Ergo 并行
浮点 + sin/cos/exp 误差界         PropaFP (dReal + MetiTarski) 或 Gappa
浮点 + 深度数学（三角恒等式等）    Coq (Coquelicot + Flocq)
多项式逼近系数的舍入误差            Gappa
参数归约正确性证明                  Coq
混合精度 (fp16+fp32+fp64)         CVC5 / Z3 (原生多格式)
大规模 VC、高自动化需求            CVC5 + Z3 + Alt-Ergo 并行分派
δ-近似验证（可容忍数值误差）       dReal
简化代数 VC（非浮点）              Alt-Ergo (擅长代数数据类型)
反例生成 / 模型搜索                CVC5 / Z3 (支持 model generation)
```

---

## 七、关键洞察

1. **CVC5 / Z3 是浮点验证的主力**——只要不涉及超越函数，它们原生支持 SMT-LIB FP 理论，自动化程度最高。在 PropaFP 验证 sine 的案例中：158 个 VC 中 146 个由 SMT 自动解决，仅 12 个需非线性实数证明器。

2. **超越函数是断崖**——一旦涉及 sin/cos/exp/log/atan，SMT solver 全线失能。必须切换到 MetiTarski、dReal、PropaFP 或交互式证明器（Coq/Isabelle）。

3. **Gappa 的定位很特殊**——它不是通用 SMT solver，而是专门的浮点误差界计算器。在处理"已知逼近多项式、需要验证舍入误差"的场景中无可替代，是 CRlibm 的核心工具。

4. **Alt-Ergo 的 FP 支持在进步**——2.6.0 (2024-09) 开始默认启用 FPA 理论，但与 SMT-LIB 标准不兼容，与 Why3 的集成需要专门的 driver 映射。在不涉及特殊值（NaN/∞）的场景中可用。

5. **PropaFP 填补了关键空白**——它让 SPARK/Why3 能够自动验证含有超越函数的浮点程序（如 sine、sqrt），这是 2022 年之前不可能的。

6. **Coq 是最终的安全网**——当所有自动证明器都失败时，Coq 可以接管任意复杂的 VC（借助 Coquelicot + Flocq）。CRlibm 的完整证明最终是由 Coq 检查的。

7. **Why3 的驱动体系允许并行分派**——同一个 VC 可以同时送到 CVC5、Z3、Alt-Ergo、dReal、MetiTarski，只要有任一解出即可。Why3 的 driver 机制负责为不同后端生成不同编码。

---

## 八、参考文献

- Why3 官方站：https://why3.org
- SMT-LIB FloatingPoint 理论：http://smtlib.cs.uiowa.edu/theories-FloatingPoint.shtml
- Conchon et al., *A Three-tier Strategy for Reasoning about Floating-Point Numbers in SMT*, CAV 2017
- de Dinechin, Lauter, Melquiond, *Assisted Verification of Elementary Functions using Gappa*, SAC 2006
- Rasheed & Konečný, *Auto-active Verification of Floating-point Programs via Nonlinear Real Provers*, SEFM 2022; PropaFP: https://github.com/rasheedja/PropaFP
- Akbarpour & Paulson, *MetiTarski: An Automatic Theorem Prover for Real-Valued Special Functions*, JAR 2010
- Boldo & Melquiond, *Computer Arithmetic and Formal Proofs*, ISTE Press - Elsevier, 2017
- Boldo, Jeannerod, Melquiond, Muller, *Floating-point arithmetic*, Acta Numerica, 2023
- Alt-Ergo 2.6 release: https://ocamlpro.com/blog/2024_09_01_alt_ergo_2_6_0_released/
- Why3 `ieee_float` 标准库：https://why3.org/stdlib/ieee_float.html
- Why3 超越函数理论：`lib/why3/real.ExpLog`、`real.Trigonometry`（Why3 源码分发包）
