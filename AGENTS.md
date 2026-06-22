# AGENTS.md

本文件为 Claude Code（claude.ai/code）在此仓库中工作提供指引。

## 仓库性质

这是一个**双用途仓库**：
既是部署到 GitHub Pages 的 Docusaurus 博客站点（`site/` 为框架，`blog/` 和 `memo/` 为内容），
个人思考工作区（`workspace/`、`drafts/`、`.agents/`）。

## 博客站点（`site/`）

Docusaurus 3.x，React 19，Node ≥20。自定义域名：`cyhan.dev`。
详细说明见 `site/README.md`。

- **开发**：`cd site && pnpm start`
- **构建**：`cd site && pnpm build`；本地预览：`pnpm run serve`
- **CI**：推送到 `main` 且变更涉及 `site/**`、`blog/**`、`memo/**` 或 `ai-gen/**` 时，触发 `.github/workflows/ci.yml` → 构建 → 部署到 GitHub Pages。
- **Markdown**：支持 KaTeX 数学公式（`remark-math` + `rehype-katex`）。
- **语言**：`zh-Hans`。
- **博客**：`blog/<年份>/`（内容在根目录，`site/blog` 为 symlink）；**备忘录**：`memo/`（`site/memo` 为 symlink，见 `sidebars.js`）。

## 工作区目录

- `.claude/skills/` —— 指向 `.agents/skills/` 的符号链接，使 Claude Code 能发现这些 skill。
- `.cyhan/` —— 个人环境配置（如 NVDA 屏幕阅读器集成）。
- `.agents/` —— Claude Code 的 Agent Skill。详见 `.agents/skills/README.md`。
- `archive/` —— 不再活跃维护的存档内容。
- `cnblog-sync/` —— 同步内容到博客园的脚本。
- `drafts/` —— 草稿技术笔记。部分会打磨后发布到 `blog/`。不会自动发布。
- `workspace/` —— 活跃工作区：研究方向脑暴、项目选择方法论、项目孵化。个人决策框架，非博客内容。
- `ai-gen/` —— AI 生成内容（会被发布）。格式要求见 `.agents/ai-gen-conventions.md`。

## 内容工作流

1. 想法和笔记写在 `drafts/` 或 `workspace/` 中。
2. 草稿打磨到可发布状态后，移入 `blog/<年份>/` 或 `memo/`。
3. 涉及 `site/**`、`blog/**` 或 `memo/**` 的提交触发 CI → 构建 → 部署到 `cyhan.dev`。
4. 博客文章支持 KaTeX 数学公式和语法高亮（Prism，GitHub 主题）。

## 提交规范

详见 [`.agents/commit-conventions.md`](.agents/commit-conventions.md)。包含：
- Scope 列表与用法
- 推送与修改历史规则（禁止自主推送、禁止 --force、amend 规则）
- 备忘录子 scope（`memo(…)` 格式）

## Agent Skill

`.agents/skills/` 中的 skill 遵循 agentskills.io 格式。详见 `.agents/skills/README.md`。
