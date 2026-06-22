# 提交规范

采用 Scope-Prefixed Commits：[scopedcommits.com](https://scopedcommits.com)。

```
<scope>: <描述>

<scope> 是变更涉及的子系统或区域，而非变更类型（如 fix/feat）。
描述本身即可传达变更性质——"修正登录超时未重试"不需要前缀 fix:。
```

## 本仓库的 scope

| Scope | 含义 |
|-------|------|
| `site` | 博客站点（Docusaurus 配置、主题、框架） |
| `blog` | 博客文章（`blog/` 下的内容） |
| `memo` | 备忘录（`memo/` 下不便归入子分类的通用内容，含 `memo/index.md`） |
| `memo(…)` | 备忘录下的特定子目录，括号内为目录缩写或简称。详见下方「备忘录子 scope」 |
| `deps` | 依赖更新（`site/package.json` 等） |
| `ci` | CI/CD 工作流 |
| `ws` | 工作区（想法、方法论、项目孵化）——`workspace/` 的缩写 |
| `draft` | 草稿技术笔记 |
| `ai` | AI 生成的内容（`ai-gen/` 下所有类别） |
| `skill` | `.agents/skills/` 下的 Agent Skill |
| `meta` | 仓库基础设施（AGENTS.md、.gitignore 等） |

一个 commit 涉及多个 scope 时，用逗号分隔（如 `site, ci: ...`），或用更上层的 scope 概括。revert、merge 等特殊提交不强制遵循此格式。

## 推送与修改历史

- **禁止自主推送**：没有明确指令（如"推送"、"push"），不得执行 `git push`。用户说"提交"仅指创建本地 commit，不包含推送。
- **禁止 `--force`**：不得使用 `git push --force`、`--force-with-lease`。
- **amend 规则**：未推送的提交可以自由 `git commit --amend`；已推送的提交如需 amend，需用户明确允许。

## 备忘录子 scope

当修改限定在 `memo/` 下的特定子目录时，优先使用更具体的子 scope，格式为 `memo(<缩写>)`。缩写规则：

- 取目录路径的最后一段（即主题名）作为缩写基础
- 单个 `-` 连接的复合词可缩减首字母：`game-a11y` → `game`，`sig-a11y` → `a11y`
- 普通单词可为前几个字母或全写：`archive` → `arch`，`proj` → `proj` 或省略
- 缩写应保持可辨识，避免歧义

常用示例：

| 子 scope | 对应路径 | 说明 |
|----------|----------|------|
| `memo(arch)` | `memo/archive/` | 存档内容（含 `archive/` 下直接放置的 `.md` 页面） |
| `memo(proj)` | `memo/proj/` | 项目备忘录（`proj/` 下不归属特定主题的 `.md` 页面） |
| `memo(aeg)` | `memo/archive/aeg-dev/` | Aegisub 开发 |
| `memo(jl)` | `memo/proj/julia/` | Julia 相关 |
| `memo(game)` | `memo/proj/game-a11y/` | 游戏无障碍 |
| `memo(a11y)` | `memo/proj/sig-a11y/` | 无障碍 SIG |
| `memo(cactus)` | `memo/proj/cactus/` | 仙人掌计划 |

当备忘录子页面只有一个（如 `memo/archive/3d.md`）或目录下多个文件同时修改时，直接使用其所属目录的 scope（如上表）。文件名不要作为 scope。

当修改确实分散在 `memo/` 下的多个不相关子目录时，回到通用 `memo` scope。

## 为什么不用 Conventional Commits

- **scope 优先于 type**：看历史的人首先关心"改了什么区域"，而非"是 fix 还是 feat"。
- **type 冗余**：好的描述已经传达了变更性质。
- **不用于生成 changelog**：提交日志面向开发者，changelog 面向用户——两者受众不同，不应混用（[参考](https://sumnerevans.com/posts/software-engineering/stop-using-conventional-commits/)）。
