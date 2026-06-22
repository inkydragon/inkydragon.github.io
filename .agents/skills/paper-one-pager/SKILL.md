---
name: paper-one-pager
description: >
  Generate a single-page structured reading note for an academic paper — distilling
  contribution, method, critical judgment, and actionable next steps. Use when the user
  asks to summarize a paper, take paper notes, digest a research article, or mentions
  读论文 / 论文笔记 / paper note / one-pager / summarize paper / 论文总结.
compatibility: Designed for Claude Code
license: MIT
metadata:
  version: "1.0.0"
  author: Chengyu HAN
when_to_use: |
  Triggers on: read paper, paper note, one-pager, summarize paper, paper summary,
  take notes on, digest this paper, 读论文, 论文笔记, 论文总结, 总结论文, 一页纸笔记, 文献笔记.
---

# Paper One-Pager — 论文单页笔记

把一篇论文的精华压缩到一页纸内：不只是摘要，而是**理解 + 判断 + 行动**。
写完后一周不读原文也能准确复述 contribution 和局限。

> **终极检验**：写完这篇 One-Pager，一周后的你还能不读原文就准确复述核心
> contribution 和局限吗？如果不能，现在就没真懂。

## Quick Start

**输入**：一篇论文的 PDF / URL / 引用信息
**产出**：一页纸结构化笔记（7 个必填栏目）
**流程**：通读 → 逐栏填写（不准抄原文）→ 强编辑到一页内 → 冷读自测

## Mode Selection

| User Intent | Mode | Output |
|---|---|---|
| "总结这篇论文" / "summarize this paper" | `full` | 7-column one-pager |
| "快速过一下这篇" / "quick overview" | `quick` | TL;DR + Contribution + My Judgment only |
| "这篇和我的研究方向有关吗" | `relevance-check` | Full one-pager, focus Column 6 |
| 批量处理多篇 | `batch` | Quick scan first, then full for priority papers |

---

## 7 栏结构

每篇论文必须包含以下 7 个栏目。栏目不可跳过。

```
┌─────────────────────────────────────────────────────────────┐
│ 📎 元信息                                                    │
│    标题 · 作者 · 年份 · 发表地 · DOI                         │
│    Why this paper:（一句话——为什么选中这篇来读）               │
│                                                             │
│ 1️⃣ 一句话（They did what?）                                  │
│    用自己的话，≤2行。                                        │
│    公式：［做了什么］＋［和前人相比的关键区别］                  │
│                                                             │
│ 2️⃣ 问题（Why should I care?）                                │
│    没这篇之前大家怎么凑合？痛点是什么？                        │
│                                                             │
│ 3️⃣ 核心方法（How?）                                         │
│    ≤5 bullets。画链路：输入 → 关键变换 → 输出                 │
│                                                             │
│ 4️⃣ 关键数据（Does it work?）                                 │
│    2–3个最重要数字 + 我信/疑标注。                            │
│                                                             │
│ 5️⃣ 假设与边界（When does it break?）                         │
│    关键假设 + 失效条件 + 作者未说的局限                        │
│                                                             │
│ 6️⃣ 我的判断（The hard part）                                 │
│    贡献级别 | 和我的关系 | 我会抄/不会抄 | 认知改变            │
│                                                             │
│ 7️⃣ 下一步（Action）                                          │
│    复现？读reference？做baseline？新idea？                    │
└─────────────────────────────────────────────────────────────┘
```

---

## Column-by-Column Writing Rules

### C0 — 元信息

```
[编号] 标题
Author (Year). Venue. DOI: xxx
Why this paper: （一句话说明为什么选中这篇）
```

**反模式**：元信息不全，后面想引用时找不到出处。

### C1 — 一句话

用动词驱动：proposes / proves / demonstrates / challenges / systematizes。
不要写「研究了 X」「探讨了 Y」——这不是贡献，是过程。

- ❌ 「本文研究了知识蒸馏在目标检测中的应用」
- ✅ 「提出基于特征图注意力的知识蒸馏方法，首次让检测 student 模型超越 teacher」

### C2 — 问题

回答两个子问题：
1. 没有这篇之前大家怎么做的？痛点在哪？
2. 问题是真实的还是论文自己造的？

用「虽然 A……但 A 的局限是……」结构，引用 2-3 个关键前人工作锚定位置。

### C3 — 核心方法

**铁律**：画链路，不画伪代码。伪代码 ≠ 理解。

```
输入（什么数据/特征）→ 关键变换（THE trick）→ 输出（什么结果）
```

- ≤5 bullets，每 bullet ≤2 行
- 标注哪个步骤是真正的 novelty（通常只有 1-2 个）
- 如果有个 trick 看起来像炼丹但不知道为什么 work，标出来

### C4 — 关键数据

```
| Metric | Baseline | Ours | Gain | 我信？ |
|--------|----------|------|------|--------|
| xxx    | xx.x     | xx.x | +x.x | 信/疑/需复现 |
```

**为什么需要「我信吗」**：SOTA 数字不一定是真的——可能过拟合、cherry-pick、
unfair comparison。养成质疑数字的习惯是 research taste 的起点。

### C5 — 假设与边界

**这是区分「读过」和「读懂了」的关键栏目。**

三个子问题：
1. 方法依赖哪些关键假设？（显式 + 隐式）
2. 什么条件下会失效？
3. 作者承认的局限 vs 你看出来但作者没说的

用「如果 X 不成立，那么 Y 结论就不成立」的格式。

### C6 — 我的判断

| 维度 | 问题 | 选项 |
|------|------|------|
| 贡献级别 | 这篇论文的贡献是？ | `incremental` / `solid engineering` / `new insight` / `opens a direction` |
| 关系 | 和我的研究方向？ | `支撑` / `竞争` / `技法可借鉴` / `暂无关` |
| 取与舍 | 我会抄什么？不会抄什么？ | 具体到某个 technique / setup / writing pattern |
| 认知变化 | 读完改变了什么？ | 如果没有，诚实写「无」 |

**为什么必须填**：你没有无限阅读时间。每读一篇必须榨取出对你有用的东西。
如果你读完只能说「好」，说明没有判断坐标系。

### C7 — 下一步

**没有行动的笔记只是信息缓存。** 至少填一项：
- 复现关键实验？
- 读它的某篇 reference？（标出具体是哪篇 + 为什么）
- 用它作为 baseline？
- 读完才想到的新 idea？（写成一句话）

---

## 写作纪律

| # | 规则 | 违规 | 纠正 |
|---|------|------|------|
| 1 | **用自己的话写** | 从 abstract 改写 | 合上论文，凭记忆先写 |
| 2 | **禁止 weasel words** | "可能""或许""大概" | 写"我认为 X，依据 Y"或删掉 |
| 3 | **一句一事** | 一句话塞三个 idea | 拆成 bullets |
| 4 | **写结论不写过程** | "先做 A 再做 B 最后 C" | "核心发现是 X，关键手段是 Y" |
| 5 | **问题先于方案** | 上来就讲方法细节 | 先写清为什么需要这个方法 |
| 6 | **诚实标注不知道** | 跳过一个想不明白的推导 | 标注"此处没看懂，需回头看" |
| 7 | **一页上限** | 写成三页 mini-review | 强编辑：只留真正重要的 |

---

## Cold Read Protocol

写完 One-Pager 后执行三步：

1. **自测（10 分钟后）**：合上论文和笔记，口头复述。卡住的地方就是没真懂。
2. **同组测试（推荐）**：给不了解这篇的人看，问他「论文做了什么、能信几分」。
3. **一月重读**：一个月后翻出来，3 分钟内能重建理解吗？不能——笔记不合格。

---

## 批量处理

写 related work 时的两级策略：

**第一轮 Quick Scan（每篇 5-10 分钟）**：
- 元信息 + 一句话 + 问题（1行）+ 和我的关系 + 优先级（必读/选读/跳过）

**第二轮 Full One-Pager（每篇 20-30 分钟）**：
只对第一轮标记「必读」的论文做完整 7 栏。

---

## Anti-Patterns

| # | Anti-Pattern | Why It Fails | Correct |
|---|-------------|-------------|---------|
| 1 | **抄 abstract** | 没真正理解，只是翻译 | 合上论文，凭记忆写 |
| 2 | **方法栏变伪代码** | 复述步骤 ≠ 理解思想 | 追问"关键变换是什么" |
| 3 | **跳过 C5（边界）** | 不懂适用范围 = 不懂方法 | 至少写 1 个关键假设 |
| 4 | **跳过 C6（判断）** | 不形成判断 = 读个热闹 | 哪怕写"实验设计值得参考"也比空着强 |
| 5 | **每篇都说好** | 没有判断坐标系 | 读 30+ 篇后应能说出至少 10 篇的局限 |
| 6 | **C7 永远空** | 笔记变信息坟场 | 哪怕下一步是"不继续深入"也写下来 |
| 7 | **字数失控** | 没做取舍 | 强编辑：如果只能留 3 栏，留哪 3 栏？ |
| 8 | **C6 让 AI 代写** | AI 没有你的研究上下文 | C6 必须自己写；AI 可帮填 1-5 |

---

## Quality Standards

**必填检查（IRON RULE — 7/7 栏不可空）**：
- [ ] C1: 外人能读懂贡献
- [ ] C2: 有具体痛点而非泛泛的"很重要"
- [ ] C3: 有输入→变换→输出链路
- [ ] C4: 有数字 + 有信/疑标注
- [ ] C5: 至少有 1 个关键假设或失效条件
- [ ] C6: 至少有 1 个"我会抄/不会抄"的具体判断
- [ ] C7: 至少有 1 个可执行的下一步

**理解深度检查**：
- [ ] 每栏用自己的话（可抽查和 abstract 的相似度）
- [ ] 方法栏不含伪代码或公式复制
- [ ] C6 含至少一个具体判断（非"值得学习"）

**压缩质量**：
- [ ] ≤1 页（正文约 500-800 字）
- [ ] 无重复表述

---

## 领域适配

| 论文类型 | 重点栏目 | 轻量栏目 |
|---------|---------|---------|
| 理论/证明 | C3（方法）+ C5（假设） | C4（数据可能只有 toy example） |
| 系统/工程 | C3（方法）+ C4（数据） | C5（边界通常是工程约束） |
| 实证/实验 | C4（数据）+ C5（边界） | C3（方法可能是标准组合） |
| Survey/Review | C6（判断 taxonomy 是否有用） | C3、C4 |
| 立场/观点 | C2（问题）+ C6（判断） | C3、C4 |

---

## 累积效应：One-Pager → Related Work

30+ 篇 One-Pager 后，写 related work = 拼卡片：
1. 筛选 C6 中标记「支撑」「竞争」的论文
2. 抽取每篇 C1（一句话）作为素材
3. 串叙事线：「共识 → 局限 → 本文定位」
4. 用 C5（边界）论证 gap
5. 用 C4（数据）选对比 baseline

---

## Templates & Examples

- **空白模板**：[assets/template.md](assets/template.md)
- **填写示例**：[assets/example-hinton.md](assets/example-hinton.md)（Hinton 知识蒸馏）
- **Amazon 叙事法原则**：[references/principles.md](references/principles.md)
