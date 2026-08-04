---
unlisted: true
authors: claude-code
tags: [ai, reading]
zotero:
  key: 57F6ZABA
  title: "1.5万字速通LLM主流模型结构（Llama、Qwen、GLM、Deepseek...）"
  author: 魔法学院的Chilia
  date: 2026-08-04
  url: https://zhuanlan.zhihu.com/p/2060741715095560795
  platform: 知乎专栏
---

# 阅读笔记：《1.5万字速通LLM主流模型结构》

> **来源**：[知乎专栏](https://zhuanlan.zhihu.com/p/2060741715095560795) · 魔法学院的Chilia · 2026-08-04 · 15,674 字

## 文章主旨

沿一个 token 的完整生命旅程，从 Tokenizer → Embedding → Norm + Attention + FFN → LM Head，综述了 Llama、DeepSeek、GLM、Qwen 等主流 LLM 的模型结构设计。核心论点是：**从 2023 年 Llama 到 2026 年 GLM 5.2，模型结构并无翻天地覆的变化——真正的演变逻辑是"可接受成本下持续放大模型能力的效率革命"**，衡量标准不是 token 数而是时间。

## 要点纵览

### Tokenizer

| 工具 | 算法 | 特点 |
|------|------|------|
| SentencePiece | BPE / Unigram | Google 出品，不依赖预分词，多语言统一处理（空格为 ▁） |
| tiktoken | Byte-level BPE | OpenAI 出品，Rust 实现极快，正则预切分块后 BPE |

评估指标：**Fertility**（每词被拆分 token 数，中文差的分词器可达 4-6）和 **Parity**（跨语言 token 数对等度，影响 API 计费公平性）。

### Normalization & Residual

- **LayerNorm → RMSNorm**：去掉均值计算，仅保留 RMS 缩放。计算更高效，现为主流标配。
- **Post-Norm → Pre-Norm**：Pre-Norm 让残差路径贡献 +1 恒等映射，梯度无损直达底层，解决深层训练发散。代价是激活值随层膨胀，由 Final RMSNorm 兜底。

### Attention：三条路径

**路径一 — KV Cache 压缩：MHA → GQA → MLA**

| 方案 | 机制 | 效果 |
|------|------|------|
| MHA | 每 head 独立 K/V | KV Cache 大 |
| GQA | n_h 头分 G 组共享 K/V | 折中，KV 缩减 4× |
| **MLA** (DeepSeek-V2) | K/V 低秩压缩到 latent space，仅缓存压缩向量，推理时解压 | 全新路径，配合解耦 RoPE |

**路径二 — 计算量削减：Sparse Attention**

**DSA**（DeepSeek Sparse Attention, V3.2）：轻量 Lightning Indexer（少头数、FP8、ReLU）对历史 token 打分 → 只选 top-2048 进入真实 attention。复杂度 O(L²) → O(Lk)。

**路径三 — IO 优化：Flash Attention**

分块计算（Tiling），完整 N×N 注意力矩阵从未全局显形，仅在 SRAM 中以碎片短暂存在。在线 softmax 增量更新输出。

**其他关键组件：**

- **RoPE**：乘法式旋转位置编码，内积天然依赖相对位置。当前标配。
- **QK-Norm**（源自 ViT-22B）：强制控制 Q/K 范数防 logits 爆炸 → softmax 退化 one-hot。已成标配，多用 RMSNorm 实现。

### FFN：SwiGLU

`output = (W_up · x ⊙ SiLU(W_gate · x)) · W_down`

- **SiLU 取代 GELU**：sigmoid 替 erf，更廉价
- **GLU 取代 MLP**：三矩阵（gate/up/down）门控逐元素乘 → 增强非线性和条件计算
- 中间维度 8d/3 保持总参数量不变

### LM Head 与解码

LM Head 映射到词表 logits → softmax → 概率分布。解码策略：贪心、束搜索、Top-K/Top-P 采样，温度缩放调陡峭度。

Embedding 与 LM Head 共享参数：小模型（≤3B）可大幅降参数量；大模型不值得为此牺牲表达力。

### Multi-Token Prediction (MTP)

每个位置预测未来 D 个 token：
1. 增加训练信号密度（同等数据更多监督信号）
2. 促使前瞻性表示（增强长程把握能力）

推理时丢弃 MTP 模块，主模型独立运行；也可用作投机解码的 draft model。

### MoE（Mixture of Experts）

**核心**：FFN → 多并行专家 + Router，每个 token 激活少数专家。参数↑↑ 计算→，参数与计算解耦。

| 设计点 | 问题 | 方案 |
|--------|------|------|
| 细粒度专家 | 大专家知识混杂 | 1 大拆 m 小，总参数量不变，可选组合暴增 |
| 共享专家 | 多专家重复学共性知识 | Ks 个共享专家始终激活，路由专家聚焦独特知识 |
| Dense/MoE 混合 | 前几层学共性语义更适合 Dense | DeepSeek V3.2 前三层 Dense + 后全 MoE；Llama 4 交替 |

**三层负载均衡体系：**

```
专家级均衡 → 微观：每个专家收到 token 均匀，防路由坍塌
设备级均衡 → 宏观：每 GPU 计算量相当，防算力瓶颈
通信均衡   → 网络：每 GPU 收发数据量相当，防通信瓶颈
```

- **Auxiliary Loss** 的问题：加多损害性能（违背数据自然分布），加少失衡。两难。
- **Aux-Loss-Free**：引入专家偏置 bias，只影响路由选择不影响权重，动态调整（过载降、欠载升）。
- **Token Drop**：超出 capacity 的 token 丢弃仅走残差。问题：信息丢失 + 训推不一致。**主流已趋向无 Token Drop 设计。**

**All-to-All 通信**：MoE 两次 All-to-All（Scatter 分发 + Gather 汇聚），复杂度 O(N²)，是限制大规模扩展的主要瓶颈。

## 判断

**优点：**
1. 沿 data flow 叙述结构清晰，每个组件讲清了"为什么要有这个改进"
2. "效率革命"主线贯穿始终，各改进方向统一在一个框架下
3. 工程细节到位：Post-Norm 雅可比问题、All-to-All 瓶颈、Token Drop 训推不一致
4. 三层负载均衡体系讲得透彻——区分了发送/接收侧通信不均，多数中文资料讲不清楚

**局限：**
1. 深度有限，属提纲级别，缺少量化对比（MLA 究竟省多少？DSA k=2048 在多大长度上有效？）
2. 缺少实验数据佐证结论
3. Qwen、GLM 具体结构着墨太少，实际主要讲 DeepSeek 和 Llama
4. infra 层面细节缺失（MLA 解耦 RoPE 后通信量变化、细粒度专家导致的 all-to-all 加剧等）
5. 笔记中图片缺失（仅 img src）

**适合谁读：** 对 Transformer 有基础了解、想快速建立主流 LLM 结构设计全景图的读者。对 DeepSeek 系列结构有兴趣尤其值得读。
