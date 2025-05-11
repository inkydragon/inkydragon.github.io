---
title: Metapost 入门指南
date: 2017-03-29 21:56:30
categories: 
  - LaTeX
  - Metapost
tags:
  - Metapost
---
**目前** 只有Metapost 入门的一些资料合集(非教程)

联动 [Metapost 入门资料(并不是教程)](http://wenda.latexstudio.net/article/1022)

<!-- truncate -->

# 0x0 前言

我参加数学建模美赛时，由于要根据数据画很多图(类似热力图，根据数值有颜色渐变)，正好用LaTeX写论文，就学习了下用mp+Python批量画图(其实是3M用的都不熟)。
**简单说没有刚需不是很推荐用mp**，
主要是学习曲线较陡，毕竟写起来像伪代码。简单的图可以用几何画板、AxGlyph、Viso，计算结果绘图用3M(MATLAB、Maple、Mathmatica)自带的plot就好，同为LaTeX绘图的还有PGF/TikZ, ~~据说是mp的封装，要好写/理解一些~~。

# 0x1 入门资料

## 原版资料
你可以把mp看做一个宏包，它在常见的发行版中都有，用texlive系列肯定是自带metapost的。

学一个宏包最好的资料就是他的说明文档，对mp来说有：

- [mpman](http://texdoc.net/texmf-dist/doc/metapost/base/mpman.pdf) - 
   MetaPost：A User's Manual
- [mpintro](http://texdoc.net/texmf-dist/doc/metapost/base/mpintro.pdf) - 
   A Beginner's Guide to MetaPost for Creating High-Quality Graphics
- [mpgraph](http://texdoc.net/texmf-dist/doc/metapost/base/mpgraph.pdf) - 
   Drawing Graphs with MetaPost
- [mpboxes](http://tug.org/metapost/src/manual/mpboxes.pdf) - 
   Drawing Boxes with MetaPost
- [mplibapi](http://tug.org/metapost/src/manual/mplibapi.pdf) - 
   这个讲的是API相关，暂时用不到

你可以在 `texlive\2016\texmf-dist\doc\metapost\base` 下找到他们。

**英语不好也没关系，看图！** 看到喜欢的图就去看他的代码，就算PDF里面没有也不要紧，官方文档自带TeX源代码啊，就在相同目录下 source-manual 和 source-tutorial 

## 图
说到图，推荐一波图

- 【神器】[MetaPost Previewer](http://www.tlhiv.org/mppreview/) - 
   在线预览mp代码，支持下载生成的图片
- [Metapost : exemple](http://tex.loria.fr/prod-graph/zoonekynd/metapost/metapost.html) - 
   305 个mp例子，附代码
- [A Very Brief Tutorial](http://www.ursoswald.ch/metapost/tutorial.html) - 
   一些mp图片，附代码


## 第三方教程
### Eng

- [Learning METAPOST by Doing](http://www.latexstudio.net/archives/455) - 
   介绍了METAPost的基本使用，附全部的示例代码
- [MetaPost on the Web](https://www.tug.org/metapost.html) - 
   我仿佛听到有人说: "干货太少，我收藏夹还没满"


### 中文

- [METAPOST 使用说明](http://www.latexstudio.net/old/books/metapost/METAPOSTcn.pdf) - 
   PDF 中文
- [MetaPost: 强大的图形语言](http://www.ctex.org/documents/shredder/metapost.html) - 
   在线 中文



# 0x2 可能的坑

有时候 mpost 编译出的图片是 .0 .1 之类的数字后缀，你可以把他重命名为 .eps 就可以在LaTeX里导入了。



如果图片过多，可以在 .mp 文件最前面加一行 
```
filenametemplate "%j-%c.eps"; % 文件名-编号.eps
```
这样就可以自动重命名了



另：
\*.log 和 \*.mpx 文件都是临时文件可以删掉


Bat编译脚本

另存为 get-fig_mps.bat

```
@echo off
mpost myfig.mp
del  *.log  /s
del  *.mpx  /s
exit
```

其中 myfig.mp 是你的mp源代码文件名

