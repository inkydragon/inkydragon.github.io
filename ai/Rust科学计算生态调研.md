# Rust 科学计算生态调研（2026年6月）

> 关联文档：[[项目诊断.md|项目诊断]] 中的语言选择部分推荐了 Rust 作为"最值得新学的语言"——但 Rust 的科学计算生态到底多成熟？ChemE/PSE 相关的库够不够用？
>
> 以下是对 Rust 数值计算、热力学、ML、可视化和 Julia 互操作五个子生态的系统调研。

---

## 一、数值计算基础设施

### 线性代数

| crate | 定位 | 成熟度 |
|-------|------|--------|
| **nalgebra** | Rust 的"numpy 线性代数"。矩阵、向量、几何变换、特征值分解、SVD | ✅ 成熟，生态基础 |
| **faer** | 新一代纯 Rust 线性代数。比 nalgebra 快，被 diffsol 采用为后端 | ✅ 活跃，性能领先 |
| **ndarray** | NumPy 风格的 N 维数组。`jlrs-ndarray` 可直接桥接 Julia 数组 | ✅ 成熟 |

### 优化

| crate | 定位 |
|-------|------|
| **argmin** (v0.5.0) | 通用优化框架。梯度下降、牛顿法、BFGS、遗传算法、模拟退火、粒子群。可插拔 solver 架构 |
| **GlobalSearch-rs** | MATLAB GlobalSearch 的 Rust 实现。OQNLP 算法（散射搜索 + 局部 NLP），Parallel + checkpointing，JOSS 论文发表（2025.11） |

### 通用科学计算

| crate | 定位 |
|-------|------|
| **SciRS2** (v0.4.4, 2026.5) | 最接近 SciPy 的纯 Rust 替代。29 个工作区 crate，36,400+ 测试。覆盖：线性代数、统计、优化（MIP/SDP/SOCP、Bayesian、NSGA-III）、ODE/DAE/PDE、信号处理、稀疏矩阵、FFT（OxiFFT）、插值、特殊函数、**符号 CAS 模块**（梯度/黑塞/雅可比、规范形式、LaTeX 导出、符号回归）。声称 pure Rust 零 C/C++/Fortran 依赖，通过 SIMD 达到 Python 的 10–100× 性能 |
| **JMax** | 数学原生语言的 CLI 工具。2500+ 函数、82 模块、单二进制。定位为 MATLAB/Julia/Mathematica 替代。BSL 许可证（4 年后转 Apache-2.0） |

**评价：** Rust 的数值计算基础设施已经扎实。线性代数（nalgebra + faer + ndarray 三种选择覆盖不同需求）、优化（argmin 成熟，GlobalSearch-rs 对标 MATLAB）、通用科学计算（SciRS2 野心大，2026 年进展快）。对于 ChemE 的日常数值需求来说，足够。

**缺口：** 特殊函数库不如 scipy.special 或 openspecfun 完整。SciRS2 有 special functions 模块，但覆盖度和经过 battle-test 的程度不如 C/Fortran 黄金代码。

---

## 二、微分方程求解器（ChemE 核心需求）

化工过程模拟的核心是求解刚性 ODE 和 DAE 系统。这是 Rust 生态中最令人惊喜的领域。

| crate | 版本 | 求解器 | 关键特性 |
|-------|------|--------|---------|
| **diffsol** | 0.6.5 (2025.7) | BDF (变阶), SDIRK/ESDIRK (TR-BDF2, ESDIRK34) | **DAE 支持（奇异质量矩阵）**、自适应步长、稠密输出、事件处理、前向/伴随灵敏度分析、数值求积。**DiffSL DSL** — JIT 编译的领域特定语言，使用 Enzyme 自动微分 + LLVM/Cranelift 后端。通过 Robertson 化学动力学问题（SUNDIALS CVODE 经典 benchmark）验证。nalgebra 或 faer 后端，稠密/稀疏矩阵 |
| **differential_equations** | 0.3.6 (2025) | DOP853, 自适应/固定步长 | ODE + DDE（时滞微分方程）+ SDE（随机微分方程）。事件检测 |
| **ode_solvers** | 0.6.0 (2025.2) | RK4, Dopri5, Dop853 | 连续输出模型（任意时刻插值）。示例含 `chemical_reaction` |
| **RustedSciThe** | 0.2.22 (2025.2) | BDF, 后向 Euler, Newton-Raphson | 符号+数值混合。解析字符串表达式 → 符号导数 → Jacobian |

**评价：diffsol 是 standout。** 它在 Scientific Computing in Rust 2025 上发布，直接对标 SUNDIALS CVODE。对于反应器模拟、精馏动态、参数估计等 ChemE 核心需求，diffsol 提供了生产级的求解器 + 灵敏度分析（参数估计的关键）。DAE 支持意味着你可以直接模拟流程中的代数约束（相平衡、物性方程）。

**缺口：** 没有像 Aspen/gPROMS 那样的完整 flowsheeting 框架。你需要自己搭单元操作模型。但对于"手艺项目"来说这恰好是优点——你自己写每个单元操作的微分方程，diffsol 负责求解。

---

## 三、热力学与物性（ChemE 差异化生态）

这是最令人意外的发现——Rust 在化工热力学方向已经有**学术级**的库，部分达到了发表论文的质量。

| crate | 内容 | 质量 |
|------|------|------|
| **FeOs** | PC-SAFT 状态方程 + 经典密度泛函理论（DFT）。相平衡、表面张力、吸附等温线。广义（超）对偶数自动微分 — 无需手写导数。TU Darmstadt 团队，发表在 *Ind. Eng. Chem. Res.* (2023)。Pure Rust 核心 + Python bindings | ⭐⭐⭐⭐⭐ 学术级 |
| **ℜeos** (reos) | CPA（Cubic-Plus-Association）、SRK、Peng-Robinson（PR76/PR78）、体积平移变体、Twu-91 alpha。水/CO₂ 缔合模型（Tsivintzelis 参数）。相平衡、状态属性。Python bindings，`pip install reos` | ⭐⭐⭐⭐ 工业级 |
| **SEUIF97** (v2) | IAPWS-IF97 水和水蒸气性质。36 个热力学/运输性质，12 种输入状态对。比 C 版本快 ~2×，比朴素 Rust 快 5–20×。Python bindings | ⭐⭐⭐⭐ 性能领先 |
| **chemapp-rs** | ChemApp（GTT Technologies）的 Rust 安全封装。平衡计算、相图、过程模拟 | ⭐⭐⭐ 封装层 |
| **OxiPhysics-MD** | 分子动力学。75+ 模块：经典 MD、增强采样、QM/MM、粗粒化、自由能。蛋白质折叠、电池电化学、摩擦化学、聚合物 MD | ⭐⭐⭐ 研究级 |

**评价：对于物性计算手表匠（候选 I），Rust 已经有基础可以站在上面。** ℜeos 直接支持 Peng-Robinson、SRK、CPA——这些恰好是你要手写的状态方程的工业级实现。你可以把自己的手写实现和 ℜeos 对比，也可以直接向 ℜeos 贡献（补文档、补测试、加新 alpha 函数）。

**缺口：** 没有像 NIST REFPROP 那样的高精度参考物性库的 Rust 原生实现。需要依赖外部数据（DIPPR、NIST 的文本/JSON 导出）或通过 FFI 调用。UNIFAC、UNIQUAC、NRTL 等活度系数模型目前没有现成的 Rust 实现——这是你可以填补的空白。

---

## 四、机器学习

| crate | 定位 | ChemE 相关性 |
|-------|------|-------------|
| **Burn** | Pure Rust 训练+推理框架。CubeCL 后端（CUDA/ROCm/Vulkan/Metal/WebGPU），ONNX 导入。v0.21 (2026) 废弃 Candle 后端，聚焦 CubeCL + Flex | 中 — 适合嵌入式过程监测模型部署 |
| **tch-rs** | PyTorch C++ API 的 Rust 绑定。完整的 libtorch 性能（cuDNN, SDPA）。适合从 Python 训练迁移到 Rust 推理 | 中 — 软测量/异常检测模型的工业部署 |
| **candle** | HuggingFace 的轻量级推理框架。Transformer 模型推理。Burn 已废弃其作为后端 | 低 — ChemE 不需要 LLM 推理 |

**评价：** Rust ML 生态在快速收敛到 Burn（训练+推理）和 tch-rs（PyTorch 兼容）。对 ChemE 来说，如果你的软测量模型需要在边缘/嵌入式环境运行，Rust 的 ML 部署能力比 Python 强得多。但对于研究阶段的模型探索，Python/PyTorch 仍然是更好的选择。

---

## 五、可视化与绘图

| crate | 定位 | 评价 |
|-------|------|------|
| **plotters** | 最成熟的通用绘图库。多后端（PNG/SVG/GIF/WASM Canvas），Jupyter 集成（evcxr），线图/面积图/散点/直方图/箱线图/蜡烛图/3D。用户评价"扎实但不如 matplotlib 功能全" | ⭐⭐⭐⭐ 出版级静态图 |
| **egui_plot** | egui 的即时模式 2D 绘图。线图/散点/柱状/箱线图。2024.7 从 egui 独立。非常适合 GUI dashboard | ⭐⭐⭐⭐ 交互式 |
| **siplot** | silx 的科学绘图 Rust 移植。wgpu GPU 加速 + egui chrome。曲线+误差棒、彩色映射图像、散射云、ROI、曲线拟合（高斯/洛伦兹/Pseudo-Voigt）、体浏览。导出 PNG/PPM/SVG/TIFF | ⭐⭐⭐ 科学级 |
| **runmat-plot** | wgpu + egui 高性能绘图。2D + 3D（曲面、点云）。Jupyter 集成 | ⭐⭐⭐ |
| **liveplot-rs** | 实时滚动数据流绘图。FFT 频谱面板。CSV/Parquet 导出 | ⭐⭐⭐ |

**评价：** 比 Python 的 matplotlib + plotly + bokeh 组合弱，但对于 ChemE 的日常绘图（P-V 曲线、相图、塔剖面）plotters + egui_plot 够用。如果你想做精美的交互式化工可视化（候选 L），egui + egui_plot + siplot 的组合可以在 Rust 内完成。

---

## 六、Julia ↔ Rust 互操作

| 工具 | 版本 | 能力 |
|------|------|------|
| **jlrs** | 0.22 (2025 末) | 两个方向：① Rust 嵌入 Julia（从 Rust 调 Julia 函数）② Rust 导出到 Julia（`#[julia_module]` 宏，编译为 JLL）。支持 async runtime（Tokio）、多线程、N 维数组（jlrs-ndarray）、跨语言 LTO。Julia 版本自动检测。维护者活跃（Taaitaaiger） |

**实际含义：** 你可以用 Rust 写物性计算的核心（高性能 + 类型安全），通过 jlrs 导出给 Julia 生态使用。也可以在 Rust 手艺项目中直接调用 Julia 的 DifferentialEquations.jl 或 ForwardDiff.jl 作为参考实现。两者的互操作不是"二选一"，而是"哪层用什么"。

---

## 七、生态成熟度总评

| 子领域 | 成熟度 | ChemE 可用性 | 备注 |
|--------|--------|-------------|------|
| 线性代数 | ✅ | ✅ | nalgebra + faer + ndarray |
| 优化 | ✅ | ✅ | argmin + GlobalSearch-rs |
| ODE/DAE 求解 | ✅ | ✅ | diffsol 是 standout |
| 热力学 EoS | ✅ | ✅ | FeOs + ℜeos 是惊喜 |
| 活度系数模型 | ❌ | ❌ | UNIFAC/UNIQUAC/NRTL 无现成实现 |
| 物性数据库 | ❌ | ❌ | 无 NIST REFPROP 级 Rust 原生库 |
| 流程模拟框架 | ❌ | ❌ | 无 Aspen/gPROMS 级框架 |
| ML | ✅ | ⚠️ | Burn + tch-rs 可用，但 ChemE ML 生态零 |
| 绘图 | ⚠️ | ⚠️ | plotters 够用，不达 matplotlib 水平 |
| 特殊函数 | ⚠️ | ⚠️ | SciRS2 在补，不如 C/Fortran 黄金代码完整 |
| Julia 互操作 | ✅ | ✅ | jlrs 成熟，可混合使用 |
| 通用科学计算 | ✅ | ⚠️ | SciRS2 野心大、进展快，但相对年轻 |

---

## 八、数值函数的实现约束与形式化验证

> 前文中提到了"形式化验证数学库"作为候选项目方向。在考虑用 Rust 做形式化验证或高精度数值函数实现时，必须理解 Rust/LLVM 浮点运算的底层约束——这决定了"能证明什么"和"在什么假设下证明"。

---

### LLVM 对浮点运算的弱约束

Rust 通过 LLVM 生成机器码。LLVM 的浮点 IR 指令并非严格 IEEE 754——它在多个维度上提供了弱于 C 编译环境的保证。

#### 1. 舍入模式：LLVM 评级 F（完全未实现）

| 能力 | C (gcc/clang + glibc/musl) | Rust (via LLVM) |
|------|---------------------------|-----------------|
| 动态舍入模式 | `fesetround(FE_UPWARD)` via `fenv.h` | **不可用**。修改 MXCSR/FPCR 是 UB |
| 静态舍入操作 | `#pragma STDC FENV_ROUND` (C23) | **LLVM 评级 F** — 完全未实现 |
| 约束 intrinsic | — | 存在 `llvm.experimental.constrained.*`，但 Rust 不暴露 |

**实际后果：** 如果你想实现一个需要非默认舍入的数值函数（如 interval arithmetic 需要向上/向下舍入），Rust/LLVM 原生不支持。唯一的 workaround 是：
- 用 `unsafe` + inline asm 操作 MXCSR（跨平台不兼容且是 UB）
- 依赖 `fesetround` 的 FFI 绑定（不可移植，优化器可能破坏）
- 使用整数位操作模拟不同舍入方向的运算

#### 2. NaN 传播：故意非确定性

Rust RFC 3514（2024 稳定化）明确规定：

- **NaN 的符号和 payload 不是确定性的** — 相同的操作、相同的输入，在不同架构、优化级别甚至不同运行之间，可能产生不同的 NaN 位模式
- **`const fn` 和运行时求值可能产生不同的 NaN** — 这在 Rust 1.82 中被正式稳定化
- **sNaN 可以传播为 sNaN** — 违反 IEEE 754 的"操作从不输出 sNaN"规则（LLVM 优化如 `x * 1.0 → x` 需要这个行为来保持语义）

这意味着：**你不能在 Rust 中验证 NaN 传播的精确行为**，因为规范本身不承诺。如果你需要"当输入是 NaN 时输出特定的 NaN payload"（某些嵌入式或安全关键场景），Rust 不是正确的工具。

#### 3. 浮点环境：没有暴露

| C 能力 | Rust 状态 |
|--------|----------|
| `fetestexcept(FE_OVERFLOW)` | 不可用 |
| `feclearexcept(FE_ALL_EXCEPT)` | 不可用 |
| `fegetenv` / `fesetenv` | 不可用 |
| `#pragma STDC FENV_ACCESS ON` | 不存在 |

**实际后果：** 如果你的数值函数需要"检测是否发生了溢出/下溢/不精确"作为算法分支条件（某些自适应精度算法中常见），Rust 不直接支持。

#### 4. 精度收缩

| 行为 | C（`fp-contract`） | Rust |
|------|-------------------|------|
| FMA 自动收缩 | 实现定义，`#pragma STDC FP_CONTRACT` 控制 | `*` 和 `+` 相邻时**默认允许收缩**。设置 `-C target-feature=-fma` 可禁用 |

这意味着 `a * b + c` 在 Rust 中可能被优化为 `fma(a, b, c)`（一次舍入）或保留两次舍入——**不承诺具体行为**。需要严格 bitwise 可复现的场景需要用 `mul_add` 显式控制。

#### 5. 已知不兼容 IEEE 的平台

| 平台 | 问题 |
|------|------|
| 32-bit x86 无 SSE2 (`i586`) | x87 80-bit 内部精度，无法提供 IEEE 兼容结果 |
| 32-bit x86 有 SSE2 | x87 返回寄存器可能修改 NaN payload |
| 旧 MIPS | quiet/signaling bit 反了 |
| 32-bit ARM NEON | SIMD 操作总是 flush-to-zero |

---

### Rust libm 实现 vs C libm

#### Rust libm 的优势

Rust 的 `libm` crate（从 musl 移植）有比 C 生态更现代的测试基础设施：

| 特征 | 说明 |
|------|------|
| **ULP 精度框架** | 每个函数有明确的 ULP 误差阈值（标准数学函数 0-4 ULPs） |
| **MPFR 参考验证** | CI 中以高精度 MPFR 库为 golden reference |
| **边界 case 框架** | 显式的 `EdgeCases` 生成器，覆盖 ±0、±∞、NaN、渐近线、临界点 |
| **跨架构测试** | 自动检测跨平台一致性 |
| **可覆盖容忍度** | `MaybeOverride` trait 允许标记已知问题的断言失败/ULP 放宽/跳过 |

一篇 2025 年的研究（Gladman et al.）直接比较了双精度 `cosh` 的最大 ULP 误差：

| 库 | 最大 ULP 误差 |
|---|-------------|
| **musl** | **1.04** |
| OpenLibm / FreeBSD | 1.47 |
| GNU glibc | 1.93 |
| Newlib | 2.67 |

musl（和继承它的 Rust libm）在精度上**可以超过 glibc**。

#### Rust libm 的弱项

| 弱项 | 说明 |
|------|------|
| **NaN 行为取决于编译目标** | 非确定性来源于 LLVM 后端，不是 libm 代码的问题，但结果一样 |
| **交叉架构一致性弱于严格 C** | C 有 `#pragma STDC FENV_ACCESS` 来约束优化器；Rust/LLVM 没有等价机制 |
| **sNaN 处理分歧** | Rust libm 继承了 musl 的 C 标准立场（`pow(sNaN,0)=1`），glibc 的立场是返回 NaN。这种分歧在不同标准的解读之间无法消除 |
| **Rust 版本升级可能改变浮点行为** | `const fn` 浮点运算的行为在 1.82 改变过；未来 LLVM 升级可能改变 runtime 路径上的优化 |

---

### Rust 数值代码的形式化验证工具

| 工具 | 方法 | 浮点能力 | 状态 |
|------|------|---------|------|
| **Kani** | 模型检查（CBMC 后端） | v0.59-0.61 增强了浮点支持，可以验证固定输入范围的精度断言。不支持舍入模式/NaN propagation 的验证 | 对数学函数验证仍然有限 |
| **Creusot** | 演绎验证（Why3 后端） | 专注于 Rust 的类型安全和借用语义。浮点专用 support 较弱 | 不适合纯数值验证 |
| **Verus** | 演绎验证（SMT via Z3） | 通过 Rust 的 `assert!` 和 proof 函数验证。浮点公式在 SMT 中是理论难点 | 可用于辅助证明算法逻辑，而非精度 |
| **grug** | 基于 MIR 的符号执行 | 研究级，可以探索浮点路径 | 早期 |

**现状：没有一个 Rust 工具可以端到端验证"这个函数对所有 `f64` 输入的误差 ≤ 1 ULP"。** 这是一个开放的研究问题——部分因为 LLVM 的非确定性 NaN 语义使得验证的 precondition 本身就很难写。

---

### 对"形式化验证数学库"项目的实际含义

#### 在 Rust 中，你能可靠验证什么？

| 可验证 | 方法 | 局限 |
|--------|------|------|
| ✅ 固定输入输出的 bitwise 等价 | Kani + property test | 需要固定编译目标 |
| ✅ 给定输入的 ULP 误差界限 | proptest + MPFR 对照 | 非形式化证明 |
| ✅ 不 panic、不溢出、不除零 | Kani + `#[kani::proof]` | 不含浮点域约束 |
| ⚠️ 单调性 | proptest + 采样 | 全输入域的单调性是开放问题 |
| ❌ NaN propagation 行为 | — | Rust 不承诺确定性 |
| ❌ 跨所有浮点输入的 ≤ 1 ULP 保证 | — | 无现成工具，需手动证明 |

#### 你需要在证明一开始声明什么假设？

如果你要做"形式化验证"（即使是部分验证），文档开头必须声明：

1. **目标硬件平台**（如 x86_64-unknown-linux-gnu，禁止 i586）
2. **接受的 NaN 行为**（接受非确定性，仅验证非 NaN 输入路径）
3. **舍入模式假设**（默认 round-to-nearest-even，不验证其他模式）
4. **验收标准**（对 `f64` 所有非 NaN 输入，误差 ≤ 2 ULPs）

#### 这意味着什么？

> **在 Rust 中做数值函数的形式化验证，其理论完备性弱于 C + `#pragma STDC FENV_ACCESS` 组合。但 Rust libm 的测试基础设施比大多数 C libm 的实际测试更系统。**

换句话说：C 的标准环境**理论上**提供更强的浮点确定性（你可以用 `fenv.h` 告诉编译器不要越界），但实践中大多数 C libm 实现并没有 Rust libm 那种 ULP 精度框架和跨架构 CI。**理论完整性和工程验证强度之间存在一个值得注意的 trade-off。**

---

### 替代方案：如果你想追求最高浮点确定性

| 方案 | 说明 | 代价 |
|------|------|------|
| **C + `#pragma STDC FENV_ACCESS ON`** | 编译器不得跨浮点操作优化 | C 语言本身的内存安全风险 |
| **Julia** | 可以调用 `llvmcall` 加 constrained intrinsic，且 `Base.Math` 已是黄金参考 | 仍然依赖 LLVM 后端 |
| **直接在 Julia 中验证算法，在 Rust 中做工程实现** | 形式化规格用 Julia 标注，Rust 实现用 proptest + MPFR 对抗 | 两个语言的验证结果需要对齐 |
| **Ada (SPARK)** | SPARK 的浮点合约是工业级最强的，有静态精度证明 | 生态窄，不实用 |
| **Rust + 软件浮点库** | 用 `soft-float` crate 做 bit-exact 跨平台计算 | 极慢，不适合日常使用 |

---

### 综合评价

| 维度 | C libm 生态 | Rust libm 生态 | 对验证工作的影响 |
|------|-----------|---------------|----------------|
| 标准环境浮点确定性 | ⭐⭐⭐⭐ (有 fenv) | ⭐⭐ (LLVM 约束弱) | C 更强 |
| 工程测试基础设施 | ⭐⭐½ (ad-hoc) | ⭐⭐⭐⭐ (ULP 框架 + MPFR CI) | Rust 更强 |
| NaN 确定性 | ⭐⭐⭐½ | ⭐ (故意非确定) | C 大幅领先 |
| 舍入模式控制 | ⭐⭐⭐⭐ | ⭐ (基本没有) | C 大幅领先 |
| 跨架构一致性 | ⭐⭐½ (取决于编译器) | ⭐⭐½ (同样取决于 LLVM) | 持平 |
| 形式化验证工具 | ⭐⭐⭐ (Frama-C, VST) | ⭐⭐ (Kani, Creusot) | C 更成熟 |
| AI 辅助验证友好度 | ⭐⭐ (UB 多) | ⭐⭐⭐⭐ (类型安全) | Rust 更好 |

**结论：如果你的形式化验证目标是"学术级的方法论演示"（如之前建议的 Sprint），Rust 的测试基础设施和类型安全足够支撑一篇高质量的方法论文。但如果目标是"工业级的 bit-exact 证明"，你需要理解并接受 LLVM 浮点语义的约束——或在 C 环境中追加验证。**

---

## 九、Julia vs Rust：在 ChemE/PSE 语境下的分工

| 维度 | Julia | Rust |
|------|-------|------|
| **数值表达力** | ⭐⭐⭐⭐⭐ 数学公式直接写 | ⭐⭐⭐ 较 verbose |
| **性能可预测性** | ⚠️ JIT 预热 + GC 暂停 | ✅ 编译期确定，无 GC |
| **正确性保证** | ⚠️ 动态类型 + 测试 | ✅ 借用检查 + 类型系统 + 穷尽模式匹配 |
| **ChemE 生态** | ✅ 更丰富（Thermodynamics.jl 等） | ⚠️ 快速增长但仍有缺口 |
| **微分方程** | ✅ DifferentialEquations.jl 是黄金标准 | ✅ diffsol 快速追赶 |
| **绘图/可视化** | ✅ Plots.jl + Makie.jl | ⚠️ plotters 较弱 |
| **学习成本** | 你已掌握 | 需要投入时间 |
| **AI 写代码质量** | ⚠️ Julia 训练数据少，AI 质量波动 | ⚠️ borrow checker 让 AI 头疼 |
| **部署/分发** | ⚠️ 需要 Julia runtime | ✅ 单二进制，嵌入友好 |
| **手艺体验** | ⭐⭐⭐⭐⭐ 数学家的语言 | ⭐⭐⭐⭐⭐ 钟表匠的语言 |

**分工建议：**

```
手艺项目（物性手表匠）
  ├── Julia：日常函数实现，"古法编程"模式
  │     优势：数学表达自然，写完就能跑
  │
  └── Rust：当你想挑战自己时
        优势：编译器教你思考，每通过 borrow check 都是一次"做对了"的确认

简历项目（软测量/异常检测）
  ├── Python：ML 模型探索（AI 加速）
  └── Rust：如果你想展示"能部署高性能模型"（加分但不必要）

开源贡献
  ├── Julia：你已是 triage 维护者，继续
  └── Rust：可以向 ℜeos/FeOs/diffsol 补文档、补测试、加 ChemE 模型
```

## 十、对"新学 Rust"建议的确认

之前的建议仍然成立——**Rust 是你最值得新学的语言**，但理由可以更具体：

1. **borrow checker 在 AI 时代是增值工具**，不是负担。它帮你审查 AI 生成的代码
2. **Rust 的 ChemE 生态正处于"刚好可以开始用"的阶段** — 不是空白（有 ℜeos, diffsol, FeOs），不是成熟（还有大量缺口可以贡献）
3. **cargo 是手艺项目的最佳构建工具** — 零配置，`cargo test` 跑所有测试，`cargo doc` 生成漂亮文档
4. **Julia ↔ Rust 互操作已成熟** — 你不是在选择语言，而是在分配"哪层用什么"

## 关于古法编程中的 Rust

Rust 的手艺体验和 Julia 不同：
- Julia 的古法乐趣在于"数学表达的美"——代码读起来像论文公式
- Rust 的古法乐趣在于"编译通过的满足"——borrow checker 是一位严格的老师，通过它的检查意味着你真的想清楚了

两者不互斥。一个函数在 Julia 中快速原型、体验数学之美，在 Rust 中重写、体验工程之严谨——这种双份乐趣正是手艺项目最健康的状态。
