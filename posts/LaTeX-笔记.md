---
title: LaTeX 笔记
date: 2017-04-12 19:13:27
categories:
tags:
  - Note
  - LaTeX
description:
  目前看 Inote2 做点笔记
---

<!--more-->

# 简介
## 数字排版
-------------------------------------------------
标记语言    PDL   RIP          输出设备
---------  ---- ----------    -----------
troff 系列  PS    硬件RIP       激光照排机
SGML 系列   PDF   固件RIP       直接制版机
TEX 系列    DVI   软件RIP       打印机
-------------------------------------------------


{% codeblock Hello World! lang:latex  https://github.io 2.1-hello_world_cn.tex %}
\documentclass[UTF8,a4paper]{ctexart}

\begin{document}
	你好 LaTeX!
\end{document}
{% endcodeblock %}

## TeX 文件的结构

### 物理结构

#### 序言与正文
``` latex 文档基本格式
\documentclass[options]{class} % 文档类声明
\usepackage[options]{package} % 引入宏包
...
\begin{document} % 正文
...
\end{document}
```

#### 文档类
常用的 **文档类(documentclass)** 有三种 `article, report, book` ，基本选项见下表：

:基本文档类选项 [加粗选项为默认]

---------------------------------------------------------------------
选项                     作用
--------------------     --------------------------------------------
**10pt**, 11pt, 12pt        正文字号。LATEX 会根据正文字号选择标题、
                            上下标等的字号。                    
                        
**letterpaper**, a4paper    纸张尺寸。

**notitlepage**,            标题后是否另起新页。article 缺省notitlepage，
**titlepage**, report       book 缺省用titlepage。

**onecolumn**, twocolumn    栏数。

**oneside**                 单面双面。article 和 report 缺省用单面，
, **twoside**               book 缺省用双面。    
                        
landscape                   横向打印，缺省是纵向。

**openany**                 此选项只用于report 和 book。report 缺省 
, **openright**             openany，book 缺省openright。

draft                       草稿模式。有时某些行排得过满，draft 模式可
                            以在它们右边标上粗黑线提醒用户。
                        
--------------------------------------------------------------------


### 逻辑结构
#### 标题、作者、日期

各命令用法如下，**注意`\maketitle` 命令要放在最后**。

``` latex 标题、作者和日期
\title{LaTeX Notes}
\author{Alpha Huang}
\date{\today}
\maketitle
```

#### 摘要
article 和 report 可以有摘要，**book 里没有摘要**。
摘要环境用法如下：

``` latex 生成摘要
\begin{abstract}
...
\end{abstract}
```

#### 结构层次
LATEX 提供了七种层次结构命令，每个高级层次可以包含若干低级层次。
**article 中没有 chapter**，而 report 和 book 则支持所有层次。

``` latex 结构层次
\part{...}             %Level -1
\chapter{...}          %Level 0
\section{...}          %Level 1
\subsection{...}       %Level 2
\subsubsection{...}    %Level 3
\paragraph{...}        %Level 4
\subparagraph{...}     %Level 5
```

#### 生成各种目录
可以用以下命令来生成目录、插图/表格目录。
这三种目录也都需要编译两遍。

``` latex 生成目录、图/表目录
\tableofcontents
\listoffigures
\listoftables
```

比如下面的命令指定目录深度为2，也就是只显示subsection 及以上层次的目录。
注意: **设定目录深度命令要放在列目录命令的前面**。

``` latex 生成目录
\setcounter{tocdepth}{2} % 设定目录深度
\tableofcontents % 列出目录
```

如果我们不想让某些层次的标题出现在目录里，则可以给例2.2 中的命
令加上星号。

``` latex 
\chapter*{...}
\section*{...}
\subsection*{...}
\subsubsection*{...}
```





<div style="display: none;">
{% raw %}


{% blockquote [author[, source]] [link] [source_link_title] %}
content
{% endblockquote %}


{% codeblock [title] [lang:language] [url] [link text] %}
code snippet
{% endcodeblock %}

``` [language] [title] [url] [link text] 
code snippet 
```


{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}

{% asset_img slug [title] %}


{% endraw %}
</div>
