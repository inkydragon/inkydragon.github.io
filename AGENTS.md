# AGENTS.md

本仓库是部署到 GitHub Pages 的公开博客站点。

## 仓库结构

- `.github/workflows/`：构建、测试和 GitHub Pages 部署工作流。
- `blog/<年份>/`：公开博客文章及其附件。
- `memo/`：公开备忘录，由 Docusaurus docs 插件生成页面。
- `site/`：Docusaurus 站点框架和静态资源。具体开发与构建方式见
  [`site/README.md`](site/README.md)。

`blog/` 和 `memo/` 位于仓库根目录。
`site/docusaurus.config.js` 分别通过 `../blog` 和 `../memo` 读取它们；
不要在 `site/` 下创建内容副本。

## 内容边界

- 这里只提交可公开发布的文章、备忘录及其站点依赖。
- 新文章放入 `blog/<年份>/`；结构化参考内容放入 `memo/`。
- 移动或删除页面时，检查站内链接、侧边栏、导航、静态资源和公开 URL。

## 提交规则

详细规则见 [`.agents/commit-conventions.md`](.agents/commit-conventions.md)。

- 暂存、提交、切换分支和推送是独立操作，只执行用户明确要求的阶段。
- 未得到明确指令时不得推送。
- 更新重写后的远程历史需要单独的明确授权；禁止无保护的 `git push --force`。
- 不得擅自 amend 已推送的提交。
- 保留无关的工作树和暂存区修改；提交前核对 staged paths 和
  `git diff --cached --check`。
