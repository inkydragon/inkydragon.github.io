# AGENTS.md

本文件为 Claude Code（claude.ai/code）在此仓库中工作提供指引。

## 仓库性质

这是一个**双用途仓库**：
既是部署到 GitHub Pages 的 Docusaurus 博客站点（`site/`），
也是个人思考工作区（`drafts/`、`idea/`、`Julia/`、`ai/`、`math/`、`cyhan-skill/`）。
工作区内容（想法、草稿、skill 定义）是主要提交活动；博客站点是对外展示的产物。

## 博客站点（`site/`）

Docusaurus 3.x，React 19，Node ≥20。自定义域名：`cyhan.dev`。
详细说明见 `site/README.md`。

- **开发**：`cd site && npm start`
- **构建**：`cd site && npm run build`；本地预览：`npm run serve`
- **CI**：推送到 `main` 且变更涉及 `site/**` 时，触发 `.github/workflows/ci.yml` → 构建 → 部署到 GitHub Pages。
- **Markdown**：支持 KaTeX 数学公式（`remark-math` + `rehype-katex`）。
- **语言**：`zh-Hans`。
- **博客**：`site/blog/<年份>/`；**文档**：`site/docs/`（见 `sidebars.js`）。

## 工作区目录

- `.claude/skills/` —— 指向 `cyhan-skill/` 的符号链接，使 Claude Code 能发现这些 skill。
- `.cyhan/` —— 个人环境配置（如 NVDA 屏幕阅读器集成）。
- `ai/` —— AI 相关笔记与探索。
- `Archived/` —— 不再活跃维护的内容。
- `cnblog-sync/` —— 同步内容到博客园的脚本。
- `cyhan-skill/` —— Claude Code 的 Agent Skill。详见 `cyhan-skill/README.md`。
- `drafts/` —— 草稿技术笔记。部分会打磨后发布到 `site/blog/`。不会自动发布。
- `homepage/` —— `cyhan.dev` 自定义主页的源码。
- `idea/` —— 研究方向脑暴、项目选择方法论（`个人项目选择规则.md`）、可行性分析。个人决策框架，非博客内容。
- `Julia/` —— Julia 语言笔记，按主题组织。
- `math/` —— 数学笔记。
- `proj/` —— 项目相关笔记与计划。

## 内容工作流

1. 想法和笔记写在 `drafts/` 或 `idea/` 中。
2. 草稿打磨到可发布状态后，移入 `site/blog/<年份>/` 或 `site/docs/`。
3. 涉及 `site/**` 的提交触发 CI → 构建 → 部署到 `cyhan.dev`。
4. 博客文章支持 KaTeX 数学公式和语法高亮（Prism，GitHub 主题）。

## Agent Skill

`cyhan-skill/` 中的 skill 遵循 agentskills.io 格式。详见 `cyhan-skill/README.md`。
