# Math Func Correctness Atlas

## 一句话定位

**Math Func Correctness Atlas** 是一个面向数值库工程师和高质量数值软件用户的数学函数正确性图谱。

它收录数学函数的语义合同、库实现、测试语料、误差证据、算法演化和验证线索，并同时提供：

- 人类可读的文档网站；
- 机器可读的元信息；
- 可复现实验和验证的入口。

它不是另一个数学函数库，也不是单纯的 benchmark 排行榜，而是 AI 时代用于约束、评估和解释数学函数实现的 correctness knowledge base。

## 背景动机

AI 让代码生成越来越便宜，但数值计算中的正确性仍然昂贵。

对于数学函数，真正稀缺的不是“写出一个实现”，而是：

- 函数语义是否定义清楚；
- special values 是否符合目标规范；
- branch cut、极点、溢出、下溢、subnormal 等边界是否处理正确；
- 算法选择为什么适合某个输入区间；
- 多项式近似、range reduction、table lookup、FMA 使用是否有误差依据；
- 不同库之间的行为差异是否被记录；
- 测试点、worst cases、oracle 和证明是否可复用。

AI 可以生成大量函数实现，但这些实现必须被规格、测试、误差分析和形式化证据约束。这个项目的价值在于积累这些约束和证据。

## 目标用户

### 数值库开发者

他们关心：

- 某个函数有哪些经典实现路线；
- 哪些 special cases 容易错；
- 现有库如何定义和实现该函数；
- 如何构造测试点和 oracle；
- 当前实现是否有已知误差风险；
- 能否找到可复用的证明或误差分析入口。

### 数值软件用户

他们关心：

- 某个语言或库是否支持某个函数；
- 文档声称的定义域和实际行为是否可靠；
- 函数在边界值、复数、特殊参数下是否有坑；
- 某个库版本的精度质量大致如何；
- 选择哪个库更适合自己的精度和平台需求。

### AI 和自动化工具

它们需要：

- 机器可读的函数语义；
- 可生成测试的属性描述；
- 可复用的 edge cases；
- oracle 配置；
- 已知问题和开放验证任务；
- 对实现代码的 correctness contract。

## 核心边界

主项目负责维护稳定的知识图谱和元信息。

主项目应该做：

- 函数目录：以 DLMF、Wolfram、C99、IEEE 754 等规范为主干；
- 语义合同：定义域、branch cut、poles、特殊值、错误处理、精度期望；
- 实现索引：不同语言和库提供哪些函数、API 名称、参数顺序、类型支持、文档链接；
- 测试元信息：测试属性、边界点、随机测试域、oracle 方法、已知 worst cases；
- 证据索引：误差报告、benchmark 快照、证明草稿、已知 bug、开放问题；
- 静态网站：从 Markdown 和结构化数据生成可浏览文档。

主项目暂时不做：

- 不维护完整数学函数实现库；
- 不承诺持续跑所有库和所有版本的 benchmark；
- 不承诺为所有函数提供形式化证明；
- 不做在线计算器；
- 不镜像 DLMF 或其他手册的完整内容；
- 不做“哪个库最好”的绝对排行榜；
- 不追求一次性覆盖 DLMF 全量。

## 与 DLMF 的关系

DLMF 是数学函数的权威参考，重点是数学定义、恒等式、性质、计算方法和软件链接。

本项目不是替代 DLMF，而是作为 implementation correctness companion：

- DLMF 回答“这个函数是什么”；
- 本项目回答“实际库中这个函数如何暴露、如何测试、哪里容易错、有什么证据”。

本项目重点补充工程层信息：

- 具体 API 名称和参数顺序；
- 文档语义和实际行为差异；
- special values 行为矩阵；
- 精度目标和已知失败点；
- 不同语言、库、版本的 conformance 状态；
- 可机器消费的数据；
- 可复现实验和验证入口。

## 数据分层

### L0: Canonical Function

表示标准函数概念。

可能字段：

- `id`
- `name`
- `aliases`
- `family`
- `dlmf_chapter`
- `dlmf_anchor`
- `wolfram_ref`
- `standards`
- `notes`

### L1: Semantic Contract

记录函数对外行为。

可能字段：

- `domain`
- `codomain`
- `branch_cuts`
- `poles`
- `singularities`
- `special_values`
- `error_handling`
- `rounding_expectation`
- `accuracy_target`
- `parameter_conventions`

### L2: Library API

记录具体库的用户可见实现。

可能字段：

- `library`
- `language`
- `version`
- `function_name`
- `signature`
- `type_support`
- `domain_support`
- `variant_tags`
- `docs_link`
- `source_link`
- `evidence_status`

### L3: Test Metadata

服务测试生成和属性验证。

可能字段：

- `properties`
- `edge_cases`
- `random_domains`
- `oracle`
- `known_worst_cases`
- `metamorphic_relations`
- `tolerance_policy`

### L4: Accuracy Report

由子项目定期生成，不要求主项目实时维护。

可能字段：

- `library`
- `version`
- `platform`
- `compiler`
- `flags`
- `oracle`
- `sample_strategy`
- `max_error`
- `failure_cases`
- `report_date`

### L5: Proof Artifact

记录形式化或半形式化验证资产。

可能字段：

- `tool`
- `artifact`
- `covered_domain`
- `proved_property`
- `assumptions`
- `status`
- `limitations`

## 网站页面

### 函数页

每个 canonical function 一个页面。

内容包括：

- 数学定义摘要；
- 规范引用；
- 语义合同；
- special values 表；
- branch cut / poles / singularities；
- 常见算法路线；
- 实现索引；
- 测试属性；
- 已知 worst cases；
- 误差报告入口；
- 证明或验证入口；
- 开放问题。

### 库页

每个数值库一个页面。

内容包括：

- 语言和生态；
- 版本；
- 覆盖的函数族；
- 文档质量；
- special values 行为；
- accuracy report 快照；
- 已知问题；
- 与其他库的差异。

候选库：

- glibc libm
- musl libm
- openlibm
- fdlibm
- CORE-MATH
- Julia Base / SpecialFunctions.jl
- SciPy / Cephes
- Boost.Math
- mpmath
- MPFR
- CRlibm

### 对比页

用于少量库并排比较。

适合比较：

- 函数覆盖；
- API 命名；
- 参数顺序；
- 类型支持；
- special values；
- 文档语义；
- 已知精度问题。

### 算法传记页

面向更高质量的专题内容。

例如 `sin`：

- 早期库实现如何做 range reduction；
- Cody & Waite 的算法选择；
- Payne-Hanek reduction 的意义；
- FMA、table-driven 方法和 correct rounding 的演化；
- CORE-MATH 等现代实现的前沿状态；
- 当前开放问题。

这类页面不是每个函数都必须有，但可以成为网站展示质量的核心。

### 实验报告页

记录一次可复现的测试或 benchmark。

要求明确：

- 测试日期；
- 库版本；
- 平台；
- 编译器和 flags；
- oracle；
- 输入采样策略；
- 误差指标；
- 失败点；
- 可复现命令。

### 开放问题页

收录适合社区或 AI agent 探索的问题：

- 缺少 edge cases 的函数；
- 缺少 oracle 的函数；
- 文档语义模糊的 API；
- branch cut 行为不一致；
- 某个库疑似精度退化；
- 值得形式化验证的局部分段；
- 可复现但尚未解释的失败点。

## 机器可读元信息示例

```yaml
id: log1p
name: log(1 + x)
family: elementary
references:
  dlmf: "4.2"
  standards:
    - C99
    - IEEE-754
domains:
  real:
    valid: "x >= -1"
    pole: "x = -1"
special_values:
  - input: "+0"
    output: "+0"
  - input: "-0"
    output: "-0"
  - input: "+inf"
    output: "+inf"
  - input: "x < -1"
    output: "NaN"
test_properties:
  - id: near_zero_accuracy
    description: "More accurate than log(1+x) near zero."
  - id: monotonicity
    domain: "(-1, +inf)"
  - id: inverse_relation
    relation: "expm1(log1p(x)) ~= x"
oracle:
  preferred: MPFR
accuracy_targets:
  binary64:
    default: "implementation-defined"
    correctly_rounded_reference: "CORE-MATH or MPFR rounded to nearest"
```

## 子项目拆分

### atlas-data

稳定数据仓库。

维护：

- 函数目录；
- 库目录；
- 语义合同；
- API 索引；
- 测试元信息。

### atlas-site

静态网站。

负责：

- 将 Markdown 和结构化数据编译为可读网站；
- 提供函数页、库页、对比页、专题页；
- 展示证据状态。

### atlas-cases

测试语料库。

维护：

- special values；
- edge cases；
- worst cases；
- 随机测试配置；
- metamorphic properties。

### atlas-runners

实验和 benchmark runner。

负责：

- 编译不同库；
- 调用 oracle；
- 运行误差测试；
- 生成报告。

这一层可以实验性更强，不要求像主数据一样稳定。

### atlas-reports

报告快照。

记录：

- 某日期；
- 某库版本；
- 某平台；
- 某测试策略；
- 某函数集合；
- 得到的精度结果。

### atlas-proofs

证明和验证草稿。

可包含：

- Gappa；
- Lean；
- Coq / Flocq；
- Frama-C / ACSL；
- Kani；
- interval proof；
- proof sketch。

## 第一阶段范围

第一阶段不追求 DLMF 全量，而是做一个形态完整的薄切片。

建议函数：

- `sin`
- `cos`
- `exp`
- `log`
- `log1p`
- `expm1`
- `sqrt`
- `cbrt`
- `hypot`
- `erf`

建议库：

- glibc libm
- musl libm
- CORE-MATH
- Julia Base
- MPFR

建议 M0 完成定义：

- 10 个 canonical functions；
- 5 个 libraries；
- 每个函数有 `spec.md`；
- 每个函数有机器可读 metadata；
- 每个函数至少 20 个 named edge cases；
- 每个库有 API coverage；
- 网站能浏览函数页、库页和基本对比页；
- 至少 1 个函数有完整 accuracy report；
- 至少 1 个函数有 Gappa、interval 或 proof artifact；
- 明确标注每条信息的证据来源和验证状态。

## 长期扩展

长期可以扩展到 DLMF 级别收录范围，但需要保持分层，不让主项目被 benchmark 和证明拖垮。

可扩展方向：

- DLMF 特殊函数族；
- 复数 branch cut 行为；
- 参数化变体；
- scaled / regularized / inverse variants；
- 历史算法考古；
- 数值库版本精度演化；
- 误差曲面可视化；
- WebGPU 加速误差探索；
- AI 生成测试；
- property-based testing；
- 形式化验证任务索引；
- 数值库软件索引。

## 项目价值

这个项目绕过了普通个人项目常见的 dog-food 问题。

它不依赖外部用户持续反馈来定义价值，因为数学函数正确性本身有明确评价标准：

- 语义是否清楚；
- oracle 是否可靠；
- 测试是否覆盖关键风险；
- 误差是否可复现；
- 证明是否声明了边界；
- 实现差异是否有证据；
- 元信息是否能被程序和 AI 使用。

在 AI 时代，单个实现会越来越便宜，但 correctness corpus 会越来越重要。

## 风险

### 范围膨胀

DLMF 级别范围极大，不能从全量收录开始。

缓解方式：

- 第一阶段只做 10 个函数；
- 每个函数有固定完成定义；
- 不要求每个函数都有 benchmark 和 proof；
- 数据层和实验层分离。

### 证明阻塞

形式化验证容易卡在单个 lemma 上。

缓解方式：

- proof artifact 是证据层，不是每个函数的必需项；
- 优先做 Gappa、interval、局部证明；
- Lean/Coq 作为精选探索，不作为主线阻塞项。

### benchmark 维护负担

持续跟踪所有库版本成本很高。

缓解方式：

- benchmark 作为定期快照；
- 明确版本、平台和 flags；
- 不做实时排行榜；
- runner 和 report 独立于主数据。

### 文档准确性

文档站如果没有证据来源，容易变成二手转述。

缓解方式：

- 每条信息记录来源；
- 区分 `documented`、`tested`、`proved`、`unknown`；
- 保留人工审核状态；
- AI 生成内容必须经过测试或来源校验。

## 推荐启动方式

先做一个最小样板：

```text
workspace/math-func-atlas/
  data/
    functions/
      log1p.yaml
      hypot.yaml
    libraries/
      glibc.yaml
      julia.yaml
      mpfr.yaml
  docs/
    functions/
      log1p.md
      hypot.md
    libraries/
      glibc.md
      julia.md
  cases/
    log1p.csv
    hypot.csv
  reports/
    log1p-accuracy-0001.md
  proofs/
    log1p.gappa
```

第一个函数建议从 `log1p` 或 `hypot` 开始。

`log1p` 的优点：

- 数学定义简单；
- cancellation 问题典型；
- special values 清楚；
- 和 `expm1` 有自然关系；
- 适合 oracle、测试和误差解释。

`hypot` 的优点：

- 几何意义直观；
- overflow-safe 和 underflow-safe 算法经典；
- 可视化容易；
- 多语言实现都有；
- 适合展示“正确性不只是公式等价”。

## 一句话总结

**Math Func Correctness Atlas 把数学函数的正确性从零散经验整理为可读、可测、可复现、可供 AI 使用的工程知识图谱。**
