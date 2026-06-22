# ai-gen/ 内容格式规范

`ai-gen/` 目录存放 AI 生成的内容，由 Docusaurus 构建发布。
子目录文档需遵循统一的 frontmatter 格式。

## 通用规则

- 所有文档 `unlisted: true`（不出现在站点列表和侧边栏中）
- `tags` 首项固定为 `ai`，次项为子目录名
- `authors` 使用 `ai-gen/authors.yml` 中定义的标识符

## 各类别格式

### research/ — 调研报告

基于 Web 搜索总结的、特定方向的调研报告。
Claude Code + 特定 LLM 协作产出。

```yaml
---
unlisted: true
authors: claude-code, deepseek-v4-pro
tags: [ai, research]
---
```

### reading/ — 阅读笔记

AI 辅助的博客、论文、视频阅读笔记与文献摘要。

```yaml
---
unlisted: true
authors: claude-code
tags: [ai, reading]
---
```

### generated/ — 直接生成

AI 直接生成的文档与代码片段，仅供参考。
不标注具体作者（非协作产出）。

```yaml
---
unlisted: true
tags: [ai, generated]
---
```

## 已注册的作者标识符

`ai-gen/authors.yml` 中已定义：

| 标识符 | 名称 | 说明 |
|--------|------|------|
| `claude-code` | Claude Code | AI Coding Assistant |
| `deepseek-v4-pro` | DeepSeek-V4 Pro | AI Research Model |
