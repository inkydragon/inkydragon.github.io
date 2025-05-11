---
title: 'Tsinghua-MOOC-DSA in C++'
date: 2018-06-07 00:27:51
categories:
tags:
description:
---

Tsinghua MOOC DSA in C++ 示例代码

<!--more-->

# VS 更改版本

由VS打开后自动升级版本，打开一个项目生成，报错400+

```
错误(活动)	E1696	无法打开 源 文件 "stdio.h"	vector	
```

找不到基本的库，需要改一下配置：

- 批量修改：项目>配置属性>常规>Windows SDK 版本 到合适的版本。我的是`10.0.17134.0`
![](setting1.png)


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

![[title]](slug)


{% endraw %}
</div>
