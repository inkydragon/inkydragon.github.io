// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';
// https://docusaurus.io/docs/markdown-features/math-equations#configuration
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: "Cyhan's Memo & Blog",
  tagline: 'Cyhan 的技术笔记与博客',
  favicon: 'img/favicon.ico',

  /* DOC:  https://docusaurus.io/docs/deployment#deploying-to-github-pages */
  // Set the production url of your site here
  url: 'https://cyhan.dev',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'inkydragon', // Usually your GitHub org/user name.
  projectName: 'inkydragon.github.io', // Usually your repo name.

  onBrokenLinks: 'warn',
  markdown: {
    hooks: {
      onBrokenMarkdownLinks: 'warn',
      onBrokenMarkdownImages: 'throw',
    },
  },

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'zh-Hans',
    locales: ['zh-Hans'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: './sidebars.js',
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl: 'https://github.com/inkydragon/inkydragon.github.io/tree/main/site/',
          showLastUpdateTime: true,
          // KaTeX
          remarkPlugins: [remarkMath],
          rehypePlugins: [rehypeKatex],
        },
        blog: {
          showReadingTime: true,
          feedOptions: {
            type: ['rss', 'atom'],
            xslt: true,
          },
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl: 'https://github.com/inkydragon/inkydragon.github.io/tree/main/site/',
          // Useful options to enforce blogging best practices
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
          showLastUpdateTime: true,
          // https://docusaurus.io/docs/blog#blog-sidebar
          blogSidebarTitle: '最近的博客',
          blogSidebarCount: 30,  // ‘ALL’
          // KaTeX
          remarkPlugins: [remarkMath],
          rehypePlugins: [rehypeKatex],
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
    ],
  ],

  stylesheets: [
    // KaTeX
    {
      href: 'https://cdn.jsdelivr.net/npm/katex@0.13.24/dist/katex.min.css',
      type: 'text/css',
      integrity:
        'sha384-odtC+0UGzzFL/6PNoE8rX/SPcQDXBJ+uRepguP4QkPCm2LBxH3FA3y+fKSiJ+AmM',
      crossorigin: 'anonymous',
    },
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      // Replace with your project's social card
      image: 'img/docusaurus-social-card.jpg',
      /* 顶端导航栏 */
      navbar: {
        // 坐上 logo 和标题
        title: "Cyhan's Memo & Blog",
        logo: {
          alt: 'My Site Logo',
          src: 'img/logo.svg',
        },
        items: [
          /* 置顶【左侧】 */
          // {
          //   type: 'docSidebar',
          //   sidebarId: 'tutorialSidebar',
          //   position: 'left',
          //   label: 'Tutorial',
          // },
          {
            label: '备忘录',
            to: '/docs/memo',
            position: 'left',
          },
          {
            label: '博客文章',
            to: '/blog',
            position: 'left',
          },

          /* 置顶【右侧】 */
          {
            label: 'GitHub',
            href: 'https://github.com/inkydragon/inkydragon.github.io',
            position: 'right',
          },
        ],
      },
      /* 底端页脚 */
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Memo',
            items: [
              {
                label: '备忘录',
                to: '/docs/memo',
              },
            ],
          },
          {
            title: 'More',
            items: [
              {
                label: 'Blog',
                to: '/blog',
              },
              {
                label: "Cyhan's GitHub",
                href: 'https://github.com/inkydragon',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Cyhan. Built with Docusaurus`,
      },
      prism: {
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
      },
    }),
};

export default config;
