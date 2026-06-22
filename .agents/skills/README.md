# Agent Skills

本目录存放为 Claude Code 定制的 Agent Skill，遵循 [agentskills.io](https://agentskills.io) 开放标准。

## 目录约定

```
.agents/skills/
└── <skill-name>/
    ├── SKILL.md          # 必需：frontmatter 元数据 + 指令
    ├── references/       # 可选：按需加载的参考文档
    ├── assets/           # 可选：模板、示例等静态资源
    └── scripts/          # 可选：可执行脚本
```

## 如何让 Claude Code 发现 skill

本仓库中 skill 存放在 `.agents/skills/`，通过符号链接接入 Claude Code 的发现路径：

```
.claude/skills/<skill-name> → ../../.agents/skills/<skill-name>
```

Skill 目录名决定调用命令名——`.agents/skills/foo-bar/SKILL.md` → 可通过 `/foo-bar` 调用。

## 新增 skill

1. 创建 `.agents/skills/<skill-name>/SKILL.md`，按 agentskills.io 规范填写 frontmatter（至少含 `name` 和 `description`）。
2. 创建符号链接：`ln -s ../../.agents/skills/<skill-name> .claude/skills/<skill-name>`。
3. Claude Code 会自动发现该 skill（支持热检测，无需重启）。可通过 `/skill-name` 显式调用，或由 Claude 根据 `description` 匹配自动激活。

### 最低可用的 SKILL.md

```yaml
---
name: <skill-name>
description: <做什么 + 何时使用>
---

# <Skill 名称>

<指令内容>...
```

## 已有 skill

| Skill | 用途 |
|-------|------|
| [`paper-one-pager`](paper-one-pager/SKILL.md) | 生成学术论文单页结构化笔记——7 栏格式：贡献、方法、假设、判断、行动 |

## 参考资料

- [agentskills.io 规范](https://agentskills.io/specification)
- [Claude Code Skills 文档](https://code.claude.com/docs/en/skills)
- [agentskills/skills-ref 校验工具](https://github.com/agentskills/agentskills/tree/main/skills-ref)
