# AGENTS.md

本文件为 Claude Code（claude.ai/code）在此仓库中工作提供指引。

## 仓库性质

这是一个**双用途仓库**：
既是部署到 GitHub Pages 的 Docusaurus 博客站点（`site/` 为框架，`blog/` 和 `memo/` 为内容），
也是个人思考工作区（`workspace/`、`drafts/`、`Julia/`、`cyhan-skill/`）。
工作区内容（想法、草稿、skill 定义）是主要提交活动；博客站点是对外展示的产物。

## 博客站点（`site/`）

Docusaurus 3.x，React 19，Node ≥20。自定义域名：`cyhan.dev`。
详细说明见 `site/README.md`。

- **开发**：`cd site && pnpm start`
- **构建**：`cd site && pnpm build`；本地预览：`pnpm run serve`
- **CI**：推送到 `main` 且变更涉及 `site/**`、`blog/**` 或 `memo/**` 时，触发 `.github/workflows/ci.yml` → 构建 → 部署到 GitHub Pages。
- **Markdown**：支持 KaTeX 数学公式（`remark-math` + `rehype-katex`）。
- **语言**：`zh-Hans`。
- **博客**：`blog/<年份>/`（内容在根目录，`site/blog` 为 symlink）；**备忘录**：`memo/`（`site/memo` 为 symlink，见 `sidebars.js`）。

## 工作区目录

- `.claude/skills/` —— 指向 `cyhan-skill/` 的符号链接，使 Claude Code 能发现这些 skill。
- `.cyhan/` —— 个人环境配置（如 NVDA 屏幕阅读器集成）。
- `archive/` —— 不再活跃维护的存档内容。
- `cnblog-sync/` —— 同步内容到博客园的脚本。
- `cyhan-skill/` —— Claude Code 的 Agent Skill。详见 `cyhan-skill/README.md`。
- `drafts/` —— 草稿技术笔记。部分会打磨后发布到 `blog/`。不会自动发布。
- `Julia/` —— Julia 语言笔记，按主题组织。
- `workspace/` —— 活跃工作区：研究方向脑暴、项目选择方法论、项目孵化。个人决策框架，非博客内容。

## 内容工作流

1. 想法和笔记写在 `drafts/` 或 `workspace/` 中。
2. 草稿打磨到可发布状态后，移入 `blog/<年份>/` 或 `memo/`。
3. 涉及 `site/**`、`blog/**` 或 `memo/**` 的提交触发 CI → 构建 → 部署到 `cyhan.dev`。
4. 博客文章支持 KaTeX 数学公式和语法高亮（Prism，GitHub 主题）。

## 提交规范

采用 Scope-Prefixed Commits：[scopedcommits.com](https://scopedcommits.com)。

```
<scope>: <描述>

<scope> 是变更涉及的子系统或区域，而非变更类型（如 fix/feat）。
描述本身即可传达变更性质——"修正登录超时未重试"不需要前缀 fix:。
```

### 本仓库的 scope

| Scope | 含义 |
|-------|------|
| `site` | 博客站点（Docusaurus 配置、主题、框架） |
| `blog` | 博客文章（`blog/` 下的内容） |
| `memo` | 备忘录（`memo/` 下的内容） |
| `deps` | 依赖更新（`site/package.json` 等） |
| `ci` | CI/CD 工作流 |
| `ws` | 工作区（想法、方法论、项目孵化）——`workspace/` 的缩写 |
| `draft` | 草稿技术笔记 |
| `julia` | Julia 语言相关笔记 |
| `skill` | `cyhan-skill/` 下的 Agent Skill |
| `meta` | 仓库基础设施（AGENTS.md、.gitignore 等） |

一个 commit 涉及多个 scope 时，用逗号分隔（如 `site, ci: ...`），或用更上层的 scope 概括。revert、merge 等特殊提交不强制遵循此格式。

### 为什么不用 Conventional Commits

- **scope 优先于 type**：看历史的人首先关心"改了什么区域"，而非"是 fix 还是 feat"。
- **type 冗余**：好的描述已经传达了变更性质。
- **不用于生成 changelog**：提交日志面向开发者，changelog 面向用户——两者受众不同，不应混用（[参考](https://sumnerevans.com/posts/software-engineering/stop-using-conventional-commits/)）。

## Agent Skill

`cyhan-skill/` 中的 skill 遵循 agentskills.io 格式。详见 `cyhan-skill/README.md`。
