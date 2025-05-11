// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';

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

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

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
          editUrl: 'https://github.com/sig-a11y/memo/tree/main/site/',
        },
        blog: {
          showReadingTime: true,
          feedOptions: {
            type: ['rss', 'atom'],
            xslt: true,
          },
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl: 'https://github.com/sig-a11y/memo/tree/main/site/',
          // Useful options to enforce blogging best practices
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
    ],
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
            label: '备忘录导航',
            to: '/docs/intro',
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
                to: '/docs/intro',
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
