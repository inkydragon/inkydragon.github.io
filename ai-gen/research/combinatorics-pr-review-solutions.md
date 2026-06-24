---
unlisted: true
authors: claude-code, deepseek-v4-pro
tags: [ai, research, combinatorics, formal-verification, lean4, coq, property-based-testing, julia]
title: "组合算法加速 PR 审阅：从测试到形式化验证的路线图"
date: 2025-06-24
lang: zh-Hans
---

# 组合算法加速 PR 审阅：从测试到形式化验证的路线图

## 问题场景

维护 Combinatorics.jl 这类组合数学库时，典型的 PR 审阅困境：

- **参考实现**（论文经典算法）正确性显然但慢
- **PR 加速实现**（CoolLex、位级状态机、闭式公式替代递推）运行快但逻辑复杂
- **审阅者**必须在脑中模拟优化版的状态迁移，与参考版做等价性论证
- **当前做法**：随机对比测试 + GAP/SageMath 等专业软件做 oracle 交叉验证

随机对比的问题是：**只能证伪，不能证实**。GAP 交叉验证的问题是：**GAP 本身是 C 内核黑盒，只是在信任 GAP 的正确性，而不是验证 Julia 代码的逻辑**。

---

## 可用方案梯队（从轻到重）

### 第一层：强化测试 —— 立即可用

#### 1.1 差分测试 (Differential Testing)

**做法**：对相同输入，比较新旧实现输出（与现有做法一致，但可系统化）。

- **局限**：只能覆盖你想到的测试输入，组合状态空间巨大

#### 1.2 GAP/SageMath/Oscar 交叉验证

**现状**：已经这样做。优势是 GAP 有 `combinat.tst` 标准测试套件，Oscar.jl 有 matroid 性质测试。

- **局限**：交叉验证只是把信任从"Julia 实现"转移到"GAP 实现"。GAP 也可能有 bug。而且 GAP 的 `Combinations` 函子大多是 C 内核实现，黑盒不可审视。

#### 1.3 变形测试 (Metamorphic Testing)

**关键突破：不需要 oracle**。

利用组合函数的**数学性质**作为测试不变量：

| 函数 | 变形关系 (MR) | 示例 |
|------|--------------|------|
| `combinations(a, k)` | `length(result) == binomial(n, k)` | 输出数量恒等于二项式系数 |
| `permutations(a)` | `length(result) == factorial(n)` | 输出数量恒等于阶乘 |
| `partitions(n)` | 每个 partition 的 sum = n | 分区定义本身 |
| `nthperm(a, k)` | `nthperm(a, k) == collect(permutations(a))[k]` | 与枚举版一致（小 n 时） |
| `parity(p)` | `parity(p) ∈ {0,1}` 且 `parity(p) == parity(reverse(p))` | parity 是排列的不变量 |
| `catalannum(n)` | `catalannum(n+1) = Σ catalannum(i)·catalannum(n-i)` | 递推关系本身 |
| `stirlings2(n, k)` | `stirlings2(n, k) = k·stirlings2(n-1,k) + stirlings2(n-1,k-1)` | 递推恒等式 |
| `bellnum(n)` | `bellnum(n) = Σ_{k} stirlings2(n, k)` | 跨函数一致性 |
| `combinations` vs `CoolLexCombinations` | 输出作为**集合**完全相等 | 等价性 oracle |

**实操**：为每个 PR 要求作者提供一组 MR 测试，且这些 MR 测试**可自动生成**（给定递推公式，自动产生小 n 的穷举检查）。Combinatorics.jl 现有的 `runtests.jl` 已经在做一部分。

**COMER 方法**（Niu et al., IEEE TSE 2022）：将变形测试与组合测试系统化结合，自动生成"变形组"——一组相关测试用例，输出相互校验而无需 oracle。对组合生成算法，这表示可以自动生成输入参数的 t-way 组合并检查跨函数一致性。

#### 1.4 有界穷举测试 (Bounded Exhaustive Testing, BET)

**做法**：对小 n ≤ N_max 穷举所有输入，逐一比对。

```julia
# 对 n ≤ 12 做完全穷举验证
for n in 0:12
    @test collect(combinations_ref(1:n, k)) == collect(combinations_fast(1:n, k))
end
```

**为什么这对组合库特别有效**：
- 组合函数通常有**许多小输入的用例**。N=8 时分区数是 22，穷举无压力；N=12 时 Bell 数约 4×10⁶，仍在 Julia 的计算范围
- **小范围假设 (Small-Scope Hypothesis)**：大多数 bug 在小输入上就已经暴露
- 绝大多数组合 bug 不需要 N=100 才能触发——逻辑错误通常在小 N 就出现

**Dubois & Giorgetti 的工作** (2018, FAOC)：论证了有界穷举测试 + 随机 PBT 的互补性。穷举覆盖所有小实例，随机测试覆盖大实例的行为模式。

**关键**：BET 的 oracle 可以是**参考实现**（慢但正确），因为小 N 时速度差异不致命。

---

### 第二层：性质导向测试 (Property-Based Testing) —— 中等投入，高回报

#### 2.1 Julia PBT 框架

- **[PropCheck.jl](https://github.com/iamrick/PropCheck.jl)**：Julia 的 QuickCheck 风格 PBT，自动生成随机输入、收缩反例
- **[Supposition.jl](https://github.com/Seelengrab/Supposition.jl)**：新一代 Julia PBT 框架

#### 2.2 组合库的 PBT 策略

对 Combinatorics.jl，PBT 性质有三类：

**A. 函数内部一致性**（单个函数的数学性质）
```julia
# 用 PropCheck.jl 风格
@testset "combinations" begin
    # 性质1：输出数量
    check(forall(randarray, randk) do a, k
        length(combinations(a, k)) == binomial(length(a), k)
    end)
    # 性质2：所有输出元素来自原集合
    # 性质3：无重复输出
end
```

**B. 函数间一致性**（多个函数互相校验）
```julia
# nthperm 与 permutations 的一致性（小 n 穷举，大 n 随机抽样）
# catalannum 与组合恒等式的一致性
# stirling1 与 stirling2 的逆关系
```

**C. 参考实现等价性**（PR 审查的核心）
```julia
# 加速版 vs 参考版的随机输入等价
check(forall(randn) do n
    catalannum_fast(n) == catalannum_ref(n)  -- 所有 n 成立
end)
```

---

### 第三层：穷举枚举器 + 形式化验证 —— 高阶投入，最高信心

#### 3.1 Why3 + 认证枚举器 (Certified Enumerators)

**Erard & Giorgetti (ICTSS 2019)** + **Dubois & Giorgetti (2016, 2018)** 的工作直接适用于此场景：

- 用 WhyML 写组合枚举程序，**形式化证明三个性质**：
  - **Soundness**（生成的所有数据满足约束）
  - **Completeness**（生成了给定大小内的所有数据）
  - **Progress**（生成顺序严格递增，保证终止性）
- 认证通过后，此枚举器可充当 BET 的可靠 oracle
- 生成的测试用例是"正确性已被证明的"

**直接应用于 Combinatorics.jl 审查**：
```
WhyML 参考枚举器（已认证 soundness/completeness/progress）
    ↓
    ↓ 作为 golden oracle
    ↓
Julia 实现 ← 对比测试（小 N 穷举 + 大 N 随机）
```

限制了为何此方法行之有效：
- 组合枚举器的形式化验证**比一般程序验证简单**——它们本质上是无状态纯函数，Why3 的 SMT 后端对此类目标成功率较高
- Why3 的认证枚举器库 (ENUM) 已存在（C/ACSL → Frama-C → WhyML 移植）
- 但对 Combinatorics.jl 的现有维护团队而言，引入 Why3/WhyML 的学习成本较高

#### 3.2 QuickChick + Coq —— 即穷举又随机

**Dubois & Giorgetti 的 QuickChick 扩展** (2018, FAOC)：

- QuickChick 原本是 Coq 的随机 PBT 插件
- 他们扩展了**有界穷举生成**——用逻辑编程（Prolog 嵌入 Coq）生成所有满足约束的数据（大小 ≤ N）
- 组合结构的生成器（排列、有根地图等）形式化定义为 Coq 函数 → 生成器的正确性被证明
- 穷举模式下：对所有大小为 N 的数据逐一验证属性，发现问题立即报告反例
- 随机模式下：对大小为任意 N 的数据随机采样

**优势**：同一框架内同时支持穷举和随机，且组合生成器本身的正确性可以在 Coq 中得到证明。

**劣势**：需要维护 Coq 代码，与 Julia 实现的鸿沟仍然存在。

#### 3.3 Lean4 —— PR 等价性证明（前述讨论）

与上述两层互补。BET/PBT 提供**证伪能力**，Lean4 提供**证实能力**。

---

## 推荐的渐进式 PR 审阅流程

结合以上所有方案，对 Combinatorics.jl 的建议路线：

### 短期（本周可开始）

```
PR 提交模板增加：
┌─────────────────────────────────────────────────────────┐
│ □ 变形关系测试 (Metamorphic Tests)                       │
│   - 列出 ≥3 个函数应满足的数学恒等式作为测试              │
│   - 如：catalannum(n+1) = Σ catalannum(i)·catalannum(n-i) │
│                                                         │
│ □ 有界穷举测试 (BET, N ≤ N_max)                          │
│   - 对小输入穷举比对 reference 实现                      │
│   - N_max 选择使得测试在 30 秒内完成                      │
│                                                         │
│ □ 跨实现一致性测试                                       │
│   - 与参考实现（论文算法）在 ≥1000 个随机输入上一致       │
│   - 与 GAP 输出在共同函数上交叉验证（≥100 随机输入）      │
│                                                         │
│ □ 反例文档                                               │
│   - 已知边界情况处理方式（溢出、空输入、边界值）          │
└─────────────────────────────────────────────────────────┘
```

### 中期（引入 Julia PBT 框架）

- 集成 Supposition.jl 或 PropCheck.jl
- 将核心数学性质定义为可自动生成的测试
- 建立 CI 上的 PBT 流水线（对快速 PR 做随机测试，夜间做 BET 穷举）

### 长期（选择性形式化）

- 对**最常被优化、也最难审查的核心函数**（如 `nthperm` 的秩编码、CoolLex 的位级操作）做 Lean4/Coq 等价性证明
- 先从 2-3 个关键函数开始，验证 ROI
- 不需要验证所有函数，只需覆盖"加速版 ≠ 参考版的明显翻译"这类最难审阅的情况

---

## 各方案对照表

| 方案 | 投入 | 信心级别 | 能否证实 | 能否证伪 | Julia 集成 | 审阅减负 |
|------|------|---------|---------|---------|-----------|---------|
| 随机对比 + GAP oracle | 已有 | 中 | ❌ | 弱 | ✅ | 小 |
| 变形测试 (Metamorphic) | 低 | 中-高 | ❌ | 强 | ✅ 可在 test/ 中直接写 | 中 |
| 有界穷举 BET | 低 | 高（对小 N） | 部分（小 N 范围内证实） | 强 | ✅ 可在 test/ 中直接写 | 中 |
| Julia PBT (Supposition.jl) | 中 | 中-高 | ❌ | 强 | ✅ | 中-高 |
| Why3 + 认证枚举器 | 高 | 极高 | ✅ | ✅ | ❌（Why3/WhyML） | 高 |
| QuickChick + Coq | 高 | 极高 | ✅ | ✅ | ❌（Coq） | 高 |
| Lean4 等价性证明 | 高 | 绝对 | ✅ | — | ❌（Lean4） | 极高 |
| GAP `combinat.tst` 对比 | 低 | 中 | ❌（信任转移到 GAP） | 中 | ✅ 调用 GAP | 小 |

---

---
## 两种形式化策略的深度对比

你提出的两个思路代表了根本不同的信任模型和工程哲学。两者都正规、都可行，但适用的 PR 类型、成本和维护负担差异巨大。

### 策略 A：证明改进算法本身正确

```
改进算法的数学理论（新论文）
    ↓ 形式化（数学层面）
改进算法的组合恒等式 / 递推关系成立
    ↓ 翻译（工程层面）
Julia 实现 ≈ 数学定义（由测试保证）
```

**证明什么**：`∀ n, fast_formula(n) = mathematical_definition(n)`

比如对 `catalan_fast` 证明它使用的闭式公式 `C(2n, n)/(n+1)` 确实等于 Catalan 数的递推定义。这是一个**组合恒等式**。

**典型工具**：Lean4 + mathlib 或 Coq + mathcomp。证明的是**数学定理**，不是程序等价性。

**优点**：
- 证明的是干净的数学，不受实现语言污染
- 证明对象是恒等式/递推关系，通常在数学库中已有大量引理支持
- 如果原论文已经给出了定理和证明，形式化就是翻译已有推理，工作可预估
- Julia 实现的正确性由 BET + 变形测试验证——实现层 bug（off-by-one、类型错误）容易在测试中暴露

**缺点**：
- 需要理解改进算法的数学推理（不是只看原来的论文公式）
- 对每种改进算法需要单独的数学证明，无法复用
- 如果改进不是"用公式替代递推"而是"用位操作替代数组索引"（如 CoolLex），数学层面两者是一样的，无法在数学层区分，根本没有可证明的"改进算法的数学定理"

**适用范围**：
- 闭式公式替代递推（`catalannum`、`bellnum` 的二项式公式）
- 新的组合恒等式（`stirling` 的生成函数恒等式）
- 渐进式/分治算法（算法有独立的理论正确性论文）
- **不适合**：CoolLex、位级状态机、查表优化——这些优化不改变数学定义，只改变计算方式

### 策略 B：证明改进算法等价于参考实现

```
参考实现（论文经典算法）
    ↓ 等价性证明（程序层面）
改进实现（优化版）
```

**证明什么**：`∀ input, optimized_impl(input) = reference_impl(input)`

两个**程序**被证明计算同一个函数，输入输出完全一致。

**典型工具**：Lean4（两个纯函数在相同类型下，证明 `∀ x, f(x) = g(x)`）或 Coq。

**优点**：
- 一条等价性定理覆盖所有类型的优化——不管是数学公式改变、数据结构改变、位操作替代、CoolLex 迭代、还是查表优化
- 审阅者只需确认 reference_impl 是"显然正确的"（直接翻译论文算法），不需要理解 optimized_impl 的复杂逻辑
- 单一证明框架适用于所有 PR

**缺点**：
- 两个**程序**都被形式化后，证明负担在等价性上。对复杂优化（如 CoolLex 的四个寄存器状态机 vs 朴素组合生成），等价性证明的归纳不变量可能非常复杂
- Lean4 的程序等价性证明需要构造两个计算过程之间的精化关系（refinement），这在依赖类型理论中是可行的但非平凡
- 如果参考实现也是复杂的（比如 `nthperm` 的秩解码涉及大量算术），证明即使参考实现正确也很费劲
- 与 Julia 实现的鸿沟：即使在 Lean 中证明了等价性，Lean 中的 `reference_impl` 和 `optimized_impl` 都是 Lean 函数，不能直接证实 Julia 中的对应实现没有翻译错误

### 核心差异逐项对比

| 维度 | 策略 A（证明算法正确） | 策略 B（证明等价性） |
|------|----------------------|---------------------|
| **证明对象** | 数学恒等式（`fast_formula = combinatorial_identity`） | 程序等价性（`∀x, impl₁(x) = impl₂(x)`） |
| **典型工具** | Lean4 mathlib, Coq mathcomp | Lean4, Coq, Why3 |
| **适用范围** | 仅闭式公式/新恒等式类优化 | **所有优化**（公式、数据结构、位操作、迭代器） |
| **证明技术** | 组合数学（生成函数、求和、二项式系数） | 程序精化（归纳不变量、模拟关系） |
| **对 CoolLex 适用？** | ❌ 不适用（CoolLex 不改变数学定义） | ✅ 理论上适用（但证明负担高） |
| **对 nthperm 秩编码适用？** | ✅ 可证明秩编码公式正确 | ✅ 可证明两种排列生成方式等价 |
| **审阅者负担** | 确认数学规格定义正确 | 确认 reference 实现忠实翻译论文 |
| **复现 PR 作者意图** | 需理解改进算法的数学 | 需理解等价性证明的归纳不变量 |
| **证明复用性** | 低（每个改进算法单独证明） | 中（等价性证明框架可复用） |
| **与 Julia 实现的关系** | 松耦合（数学证明 + 测试验证实现） | 松耦合（仍需测试确认翻译正确） |
| **证明失败意味什么** | 改进算法的数学假设有误 | 实现没有等价于参考 |

### 关键洞察：两种策略的信任边界不同

```
策略 A 的信任模型：
┌─────────────────────────────────────────────────────┐
│ 形式化证明（机器检查）                                │
│  ↓                                                    │
│ 数学定理：fast_formula(n) = combinatorial_def(n)      │
│  ↓                       ↓                            │
│ Julia 实现₁              Julia 实现₂                   │
│ (fast_formula → 代码)    (combinatorial_def → 代码)   │
│     ↓                       ↓                          │
│   测试验证                测试验证                      │
│ (BET + PBT + MR)        (BET + PBT + MR)              │
│                                                       │
│ 信任缺口：数学公式 → Julia 代码的翻译正确性              │
│ （由测试弥合——对组合函数，这个缺口很小）                 │
└─────────────────────────────────────────────────────┘

策略 B 的信任模型：
┌─────────────────────────────────────────────────────┐
│ 形式化证明（机器检查）                                │
│  ↓                                                    │
│ ∀x, optimized_lean(x) = reference_lean(x)             │
│        ↓                       ↓                      │
│  optimized_julia           reference_julia             │
│        ↓                       ↓                      │
│      测试验证                测试验证                   │
│                                                       │
│ 信任缺口：Lean 函数 → Julia 代码的翻译正确性             │
│ （由测试弥合；两个方向都有这个缺口）                     │
└─────────────────────────────────────────────────────┘
```

**共同问题**：两种策略的形式化证明都存在于 Lean/Coq/Why3 中，而 Combinatorics.jl 是 Julia 库。形式化证明建立了"两个抽象模型等价"的绝对信心，但**模型到 Julia 代码的映射**仍由测试弥合。

这是一个重要的务实让步：我们不需要端到端的形式化验证（Lean 证明自动保证 Julia 代码正确），只需要**把审阅负担从"两个复杂实现的等价性"降低到"两个独立实现各自忠实于一个简单数学定义"**。信任边界的移动是核心收益。

### 对 Combinatorics.jl 的建议

**几乎总是优先选择策略 A**，原因：

1. **组合库的优化大多有数学基础**：`catalannum` 的闭式、`nthperm` 的秩公式、`bellnum` 的 Dobiński 公式、`stirling` 的显式求和——这些都是**组合恒等式**，在 mathlib 中很可能已有部分引理。证明数学定理比证明程序等价性更自然。

2. **CoolLex 是特殊情况**：它不改变数学定义，只是迭代方式不同。对这种情况，策略 A 不适用。但有一个变通——把 CoolLex 的正确性拆成两部分：
   - (a) CoolLex 的状态机产生了所有组合（数学性质）→ Lean4 证明
   - (b) Julia 实现忠实实现了 CoolLex 状态机 → BET 穷举验证（小 N 时完全可信）
   
   这意味着 CoolLex 的验证实际上是策略 A 的变体——证明的是"CoolLex 算法的数学正确性"而非"CoolLex 实现等价于某个 reference"。

3. **维护成本更低**：数学定理一旦证明就稳定了。程序等价性证明随着 reference 实现的重构可能需要更新。

4. **实际工作流**：
   ```
   PR 提交：
   1. 数学定理（在 Lean 中）：fast_formula(n) = combinatorial_identity(n)
      → 审阅者：确认规格正确，确认 Lean 类型检查通过
   2. 测试套件（在 Julia 中）：
      → BET 穷举比对 reference（小 N 内证实）
      → 变形测试（数学恒等式对所有输入成立）
      → 随机对比 GAP（额外确认）
   3. 审阅者工作：审查 1 的规格 + 验证 2 的测试足够覆盖
      → 不需要审查优化实现的具体逻辑
   ```

### 例外：什么时候选策略 B

- PR 的优化是**纯工程性的**（缓存、内存布局、位操作、并行化），不涉及新的数学公式
- 但这种情况通常可以用 BET 完全覆盖——小 N 时穷举所有输入，大 N 时随机抽样，不需要形式化证明
- 只有当穷举不可行（输入空间对任何可计算 N 都太大）且无法用数学公式区分时，策略 B 才有独特价值

---

---

## 策略 C：Lean4 作为认证基准库（C 导出 + Julia 对比测试）

你提出的方案本质上是**第三种策略**——不是证明改进算法，也不是证明程序等价，而是**用 Lean4 建造一个经过形式化验证的"golden oracle"，通过 C FFI 导出，供 Julia 侧做差分测试**。

### 架构全景

```
┌─────────────────────────────────────────────────────────┐
│  Lean4 侧（可信计算基，Trusted Computing Base）          │
│                                                         │
│  paper_algo (x : ℕ) : ℕ := ...       -- 论文算法实现     │
│  theorem paper_algo_correct :          -- 正确性证明       │
│    paper_algo n = combinatorial_def n                    │
│                                                         │
│  @[export "catalan_ref"]                                 │
│  def catalan_ref_export (n : UInt64) : UInt64 := ...     │
│           ↓ lake build RefLib:dynlib                     │
│          libRefLib.so                                    │
└──────────────────────┬──────────────────────────────────┘
                       │ C ABI
┌──────────────────────┴──────────────────────────────────┐
│  C 薄胶水层 (thin wrapper)                               │
│                                                         │
│  uint64_t catalan_ref(uint64_t n) {                      │
│      lean_object *result = lean_catalan_ref(n);          │
│      return lean_unbox_uint64(result);                   │
│  }                                                      │
└──────────────────────┬──────────────────────────────────┘
                       │ libRefLib.so + libleanshared.so
┌──────────────────────┴──────────────────────────────────┐
│  Julia 侧                                               │
│                                                         │
│  ccall((:catalan_ref, "libRefLib"), UInt64, (UInt64,), n)│
│                                                         │
│  # CI 测试：                                             │
│  for n in 0:N_max                                        │
│      @test Combinatorics.catalannum(n) == ccall_ref(n)   │
│  end                                                    │
└─────────────────────────────────────────────────────────┘
```

### 可行性分析

#### 能直接导出什么

| Lean4 类型 | C ABI 类型 | 适合直接导出？ |
|-----------|-----------|---------------|
| `UInt64` | `uint64_t` | ✅ 直接映射，无装箱 |
| `Float` | `double` | ✅ 直接映射 |
| `Bool` | `uint8_t` | ✅ |
| `Nat` | `lean_object *` | ❌ 装箱 + 引用计数，需 wrapper |
| `Int` | `lean_object *` | ❌ 同上 |
| `List α`, `Array α` | `lean_object *` | ❌ 同上 |

**关键约束**：`Nat`（组合函数最自然的返回类型）在 C ABI 中是 `lean_object *`——一个带引用计数的堆对象。小 `Nat`（≤ `LEAN_MAX_SMALL_NAT`）用 tagged pointer 编码（值 = 2n+1），大 `Nat` 用 GMP 多精度整数。

这意味着：
- **不能直接 `ccall` 一个返回 `Nat` 的 Lean 函数**，除非 Julia 侧理解 Lean 的对象模型
- **需要 C 薄胶水层**，负责 `lean_object *` ↔ `uint64_t`（或 Julia `BigInt`）转换

#### C 薄胶水层的设计

```c
// ref_wrapper.c —— 编译进 libRefLib.so
#include <lean/lean.h>

// 对小 Nat（可装进 uint64_t），直接拆包
LEAN_EXPORT uint64_t catalan_ref_u64(uint64_t n) {
    lean_object *arg = lean_box(n);         // uint64_t → lean_object (small Nat)
    lean_object *res = lean_catalan_ref(arg); // 调用 Lean 函数
    uint64_t out = lean_unbox(res);          // lean_object → uint64_t
    lean_dec_ref(res);                       // 释放引用
    lean_dec_ref(arg);
    return out;
}

// 对大 Nat（超出 uint64），返回字符串或调用者提供缓冲区
// 对 Catalan/Bell/Stirling 数，小 n 时就溢出 uint64，需要返回 BigInt
LEAN_EXPORT char *catalan_ref_str(uint64_t n) {
    // 用 lean_obj_to_string 或 GMP 提取十进制字符串
    ...
}
```

**好消息**：Lean4 C API (`lean.h`) 提供了 `lean_box` / `lean_unbox` 处理 small `Nat`，以及 `lean_nat_big_*` 系列处理 GMP bignum。薄胶水层的编写是机械的。

**坏消息**：对组合函数来说，uint64 很快溢出。Catalan(35) ≈ 3.1×10¹⁸ 就快溢出 64 位了。所以实际需要的是 **`BigInt` 互操作路径**——要么通过十进制字符串，要么通过 GMP 的 `mpz_t` 直接传递。

#### 组合数溢出 64 位的速度

| 函数 | 何时溢出 uint64 (> 1.8×10¹⁹) |
|------|------------------------------|
| `factorial(n)` | n = 21 |
| `catalannum(n)` | n = 34 |
| `bellnum(n)` | n = 16 |
| `stirlings2(n, n/2)` | n ≈ 12-15 |
| `multinomial(...)` | 依赖参数 |

**这意味着如果你的 golden oracle 只支持 uint64，覆盖范围极小。** 实际需要 BigInt ↔ Lean `Nat` 的桥接。

#### BigInt 互操作路径

Lean4 的 `Nat` 内部对大值使用 GMP。与 Julia `BigInt`（也基于 GMP）互操作：
- 可以通过十进制字符串序列化（`Nat.repr` → string → `parse(BigInt, ...)`），但性能差
- 可以通过 GMP 的 `mpz_export` / `mpz_import` 传递二进制表示
- 或者：在 Lean 侧**限制输入域**到小 n（即使结果可能溢出），用 `Nat` 作为验证类型的返回，用 `Nat.repr` 导字符串

**务实选择**：用 `Nat` → 十进制字符串 → Julia `BigInt`。对 CI 测试来说（N ≤ 几十、几百），字符串序列化的开销可忽略。组合函数的计算本身占主导。

```c
// 返回 Lean Nat 的十进制字符串（调用者负责 free）
LEAN_EXPORT char *catalan_ref_decimal(uint64_t n) {
    lean_object *arg = lean_box_uint64(n);
    lean_object *res = lean_catalan_ref(arg);
    // lean_nat_to_string 或直接用 lean_obj_repr
    char *str = lean_nat_to_string(res);
    lean_dec_ref(res);
    lean_dec_ref(arg);
    return str;
}
```

Julia 侧：
```julia
# 通过 C 字符串接收 BigInt 结果
function catalan_ref(n::Integer)::BigInt
    cstr = ccall((:catalan_ref_decimal, "libRefLib"),
                  Ptr{Cchar}, (UInt64,), n)
    result = parse(BigInt, unsafe_string(cstr))
    Libc.free(cstr)
    return result
end
```

### 这个方案解决了什么、没解决什么

**解决的**：
- Golden oracle 的正确性有形式化证明背书，比 GAP（C 内核黑盒）可靠
- 差分测试覆盖所有 Julia 实现（参考实现 + 加速实现），CI 可自动运行
- Lean4 的参考实现和 Julia 的参考实现是**两个独立翻译**，降低同源 bug 风险
- Lean4 的 `Nat` 是任意精度的——与 Julia `BigInt` 语义一致

**没解决的（信任缺口依然存在）**：
- 薄胶水层的 C 代码未被形式化验证（但足够短，人工审查可接受）
- 对生成器函数（`combinations`、`partitions`、`permutations`），oracle 需要返回集合而非标量，复杂度更高
- Lean4 中的参考实现可能在边界情况（n=0, n=1）有 bug——但这个 bug 会被 Julia 侧 BET 捕获（两个实现都在小 n 输出了，但规格定义要求的是另一个值）

### 对标量函数 vs 生成器函数

| 函数类别 | 例子 | C oracle 可行性 |
|----------|------|----------------|
| **标量函数** | `catalannum`, `bellnum`, `stirlings1/2`, `narayana`, `factorial`, `multinomial`, `npartitions`, `derangement` | ✅ 直接：输入 `uint64_t`，输出 `BigInt` 字符串 |
| **简单向量函数** | `nthperm`, `permutations`（预知长度） | 🟡 需要序列化：返回逗号分隔列表或 JSON |
| **大枚举函数** | `combinations(a, k)`, `partitions(n)` | 🔴 n 稍大就产生海量输出，不适合全量 oracle；更适合做 **hash/invariant oracle**（返回输出的某种校验和，如加和） |

**对大枚举函数的变通**：
不是返回整个列表，而是返回**可验证的不变量**：
```lean
-- 不是返回所有 combinations，而是返回
-- (count, sum_of_indices, first_combo, last_combo, hash)
def combinations_invariant (n k : ℕ) : ℕ × ℕ × List ℕ × List ℕ × UInt64 := ...
```
Julia 侧用同样的 invariant 函数校验，避免传输海量数据。

### 实际建设路线

```
阶段 1（最小可行）：
  └── 选 3-5 个标量组合函数（catalannum, bellnum, factorial, stirling2）
      ├── Lean4 实现论文定义 + 正确性证明
      ├── C 薄胶水层（uint64→decimal string→BigInt）
      ├── 构建 libCombinatoricsRef.so
      └── Julia CI 集成：每晚对 50 个随机 n 做差分测试

阶段 2（扩展覆盖）：
  ├── 加入生成器函数（用 invariant oracle 策略）
  ├── 加入 nthperm、parity 等排列函数
  └── Julia CI 集成：每 PR 自动差分测试

阶段 3（双向验证）：
  ├── 对新优化算法，尝试在 Lean4 中证明等价性
  ├── 如果 Lean4 证明通过 → Julia 侧可跳过等价性测试（只做一致性抽查）
  └── 如果 Lean4 证明不完整 → Julia 侧 BET + oracle diff 作为补充
```

### 与其他方案的比较

| | 随机对比 GAP | 纯 BET + MR | 策略 A（Lean 证明） | **策略 C（Lean → C oracle）** |
|---|---|---|---|---|
| Oracle 可信度 | 信任 GAP 黑盒 | 信任参考实现 | 信任数学定义 | **Lean 形式化证明** |
| 覆盖 Julia 实现 | ✅ | 需维护参考实现 | NA（只证数学） | ✅ 差分测试覆盖到 |
| 覆盖生成器 | ✅ | 小 n ✅ | NA | 🟡 需 invariant 策略 |
| Julia 集成难度 | 已有 | 零（test/ 目录） | NA | 中（C lib + wrapper） |
| 维护持续投入 | GAP 版本兼容 | 低（测试代码） | 高（每个新算法的证明） | **中（C wrapper 稳定后可复用）** |
| 能否在 CI 自动运行 | ✅ | ✅ | NA | ✅ |
| 审阅减负 | 小 | 中 | 高（但范围有限） | **中→高（随时间积累）** |

### 关键风险

1. **`Nat` 到 `BigInt` 的桥接复杂度**：虽然用十进制字符串可行，但每个函数都要写对应的 C wrapper，易出错。建议只写一次工具宏/代码生成模板。

2. **Lean4 版本兼容性**：`lake build` 产生的 `.so` 与 `libleanshared.so` 绑定，后者随 Lean4 toolchain 版本变化。CI 需要锁定 Lean4 版本。

3. **组合数溢出 uint64 的问题**：对所有参数都需要用 BigInt 路径，不能偷懒用 `UInt64` 直接映射。

4. **生成器 oracle 的"不变量"设计**：需要确保不变量足够有区分力——hash 碰撞可能隐藏 bug。建议组合使用多个不变量（count + sum + cryptographic hash）。

5. **参考实现本身可能有 bug**：如果 Lean4 证明的规格定义本身就是错的（比如把 Catalan 数定义为了阶乘），那么 golden oracle 输出错的值，Julia 对比测试也只是和错误对齐。这通过**额外用已知值（OEIS 序列的首项）做冒烟测试**来捕获。

---

## 关键参考文献

1. **Erard & Giorgetti, "Bounded Exhaustive Testing with Certified and Optimized Data Enumeration Programs"** (ICTSS 2019) — Why3 认证枚举器库 ENUM，形式化证明枚举程序的 soundness/completeness/progress
2. **Dubois & Giorgetti, "Tests and proofs for custom data generators"** (FAOC 2018) — QuickChick 扩展有界穷举生成，Coq + Why3 组合生成器正确性
3. **Dubois, Giorgetti & Genestier, "Tests and proofs for enumerative combinatorics"** (2016) — 排列和有根地图的有界穷举 + 随机测试，Prolog 作为穷举引擎
4. **Niu et al., "Enhancing Combinatorial Testing with Metamorphic Relations"** (IEEE TSE 2022) — COMER：将变形测试系统化地与组合测试结合，自动生成自校验测试组
5. **Howden, "Elusive Bugs, Bounded Exhaustive Testing and Incomplete Oracles"** (2008) — BET 基础理论，不完备 oracle 的 necessity/sufficiency 分类
6. **[GAP combinat.tst](https://www.gap-system.org/)** — GAP 标准组合函数测试套件，包含 factorial、binomial、bell、stirling1/2、combinations、permutations、derangements、partitions 的预期输出
