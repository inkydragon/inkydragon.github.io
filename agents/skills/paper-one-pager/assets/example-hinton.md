# [P001] 用特征图注意力做检测知识蒸馏

**元信息**
- 标题：Distilling the Knowledge in a Neural Network (Hinton et al., 2015)
- 作者：Hinton, Vinyals, Dean
- 年份：2015 | 发表地：NeurIPS (NIPS 2015 Workshop) | DOI：10.48550/arXiv.1503.02531
- Why this paper: 知识蒸馏的开山之作。几乎我读的每一篇蒸馏论文都引用它。读了它才能判断后来者到底在改进什么。

---

## 1️⃣ 一句话

提出知识蒸馏（knowledge distillation）：用一个大的 teacher 网络的软标签（soft targets）来训练一个小的 student 网络，让 student 不仅能学到正确答案，还能学到 teacher 对错误答案的「相对信心分布」。后续检测领域的蒸馏几乎都站在这个肩膀上。

---

## 2️⃣ 问题

**痛点**：大模型（ensemble / 巨型 network）效果好但推理太慢、部署不了。当时大家知道小模型快但精度不够，但不知道怎么把大模型的能力「转移」给小模型。

**这个问题真实吗？** 真实。2015 年已有大量 ensemble 在 ImageNet 上刷榜，但工业界没法用。这篇论文没有凭空造问题——它直接回应了这个瓶颈。

**前人的做法**：要么直接训小模型（精度不够），要么做模型压缩（剪枝/量化），但压缩后的精度损失弥补不回来。

---

## 3️⃣ 核心方法

> 硬标签（ground truth）→ **软标签（teacher logits / temperature T）** → student 同时学硬标签 + 软标签

**关键变换**：
1. 用 temperature T 缩放 teacher 的 logits，让错误类别的相对概率凸显出来（T=1 时这些信号太弱）
2. student 同时用两个 loss：和硬标签的 cross-entropy + 和 teacher 软标签的 KL divergence
3. 训练时 student 用同一个 T，推理时 T=1（恢复正常 softmax）

**Novelty**：
- 核心 idea（用 teacher 的概率分布而非 one-hot 做监督）是新的
- temperature 这个 trick 虽简单，但它是让软标签信息量大幅增加的 key

**我的疑问**：为什么两个 loss 之间的权重是固定的？后来 FitNets 等工作改进了这里。

---

## 4️⃣ 关键数据

| 实验 | Baseline | Distilled | Gain | 我信？ |
|------|----------|-----------|------|--------|
| MNIST (soft targets only) | — | — | "works well" | 信（MNIST 是 toy） |
| Speech recognition | 58.9% WER | 57.0% WER | −1.9% | 信（但没有统计学检验） |

**评价**：这篇是 workshop paper，实验并不充分——没有大规模 ImageNet 实验，也没有统计显著性检验。但它不需要充分实验——核心 contribution 是 idea，不是 SOTA。

---

## 5️⃣ 假设与边界

**关键假设**：
- teacher 的软标签确实包含了「类间相似性」信息 → **基本成立**，类间结构是真实存在的
- student 有足够的容量吸收这些信息 → 如果 student 太小，软标签的收益递减
- teacher 和 student 在同一个数据域 → 跨域蒸馏是后来才被探索的问题

**失效条件**：
- teacher 本身就是烂模型 → 软标签提供的是噪声而非知识
- 任务本身类间差异极大（软标签没有额外信息量）

**作者承认**：仅在小规模任务上验证
**我看到的但作者没说的**：temperature 的选择没有理论指导，全靠调参——这个脆弱的点在后来工作中被反复 patch

---

## 6️⃣ 我的判断

| 维度 | 判断 |
|------|------|
| 贡献级别 | **opens a direction** —— 开创了整个蒸馏研究方向 |
| 和我的关系 | 支撑（我读的所有蒸馏检测论文都是这篇的后代） |
| 我会抄 | (1) temperature 软化概率的 idea 可以直接迁移; (2) 软标签 + 硬标签联合训练的 loss 设计模式 |
| 我不会抄 | 固定权重的 loss 组合——后来 FitNets / AT 等证明需要动态调整 |
| 认知改变 | 原来「错误答案的概率」里也有信息——这改变了我对分类器输出的理解。不是类间相似性噪音，是可迁移的结构知识 |

---

## 7️⃣ 下一步

- [x] 已读——这是回溯性笔记
- [ ] 读 FitNets (Romero et al., 2015) —— Hinton 只蒸馏 logits，FitNets 蒸馏中间层 feature，补上了 Hinton 没说的事
- [ ] 读 Cho & Hariharan (2019) —— 在检测任务上，蒸馏 logits 是不够的，他们是怎么做的？
- [ ] 复现 idea：在我自己的小分类任务上验证 temperature 对 student 精度的影响曲线——这是理解蒸馏最直接的实验
