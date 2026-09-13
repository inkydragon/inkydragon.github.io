# Website

基于 [Docusaurus](https://docusaurus.io/) 3.x 构建的静态博客，部署到 GitHub Pages，自定义域名 `cyhan.dev`。

## 开发

```bash
pnpm install       # 安装依赖
pnpm start         # 启动开发服务器（热更新）
pnpm build         # 生产构建 → build/
pnpm run serve     # 本地预览构建产物
```

## 结构

```
仓库根目录/
├── blog/                      # 博客文章，按年份组织
├── memo/                      # 结构化备忘录
└── site/
    ├── src/css/custom.css     # 自定义样式（Infima 变量覆盖）
    ├── static/                # 静态资源（图片、favicon 等）
    ├── docusaurus.config.js   # 站点配置
    ├── sidebars.js            # 自动生成侧边栏
    └── package.json           # 依赖与脚本
```

`docusaurus.config.js` 通过 `../blog` 和 `../memo` 读取根目录内容。

- 博客侧边栏显示最近 30 篇（[`blogSidebarCount`](docusaurus.config.js)）。
- 侧边栏从文件结构自动生成（[`sidebars.js`](sidebars.js)）。

## 关键配置

- **语言**：`zh-Hans`（单语言站点，未国际化）
- **数学公式**：[`remark-math`](https://github.com/remarkjs/remark-math) + [`rehype-katex`](https://github.com/KaTeX/KaTeX)
- **语法高亮**：[Prism](https://prismjs.com/)（亮色 GitHub，暗色 Dracula）
- **主题**：Infima，自定义主色调 `#2e8555`（见 [`src/css/custom.css`](src/css/custom.css)）
- **`editUrl`**：指向 GitHub 上 [`site/`](https://github.com/inkydragon/inkydragon.github.io/tree/main/site/) 子目录

## CI / 部署

推送 `main` 且变更涉及 `.github/workflows/ci.yml`、`site/**`、`blog/**` 或
`memo/**` → [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) →
`pnpm install --frozen-lockfile && pnpm build` → 部署到 GitHub Pages。
