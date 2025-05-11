---
title: 7 Languages in 7 weeks - Io
date: 2017-04-29 19:03:01
categories:
tags:
description:
---
>问题不是“我们要干点儿什么”而是“我们有什么不能干”。
>—— Ferris Bueller


<!--more-->

# Install
google搜索 `io-lang` ，找到官网 [io / binaries via jake peck](http://iolanguage.org/binaries.html)
下载合适的安装包，按照其中的readme安装。


## summary

- 没有任何语法糖，核心元素也没有
    - 好处：不必记住很多语法
    - 坏处：难以阅读代码

## TODO
**Find**

- 一些Io的示例问题。
- 一个可解答问题的Io社区。
- 带有Io惯用法的风格指南。
    - [Io Programming/Io Style Guide](https://en.wikibooks.org/wiki/Io_Programming/Io_Style_Guide)

**Answer**

- 对1+1求值，然后对1 + "one"求值。Io是强类型还是弱类型？用代码证实你的答案。
  -  强类型, 数字不能与字符/字符串进行运算
    ``` plain Io 
    Io> 1+1
    ==> 2
    Io> 1+'one'

      Exception: Number does not respond to '+''
      ---------
      Number +'                            Command Line 1

    Io> 1+"one"

      Exception: argument 0 to method '+' must be a Number, not a 'Sequence'
      ---------
      message '+' in 'Command Line' on line 1
  ```
- 0是true还是false？空字符串是true还是false？nil是true还是false？用代码证实你的答案。
  - `0` is `true`
    ``` plain Io 
    Io> 0 or 0
    ==> true
    ```
  - `""` is `ture`
    ``` plain Io
    Io> '' or ''

      Exception: Object does not respond to ''''
      ---------
      Object ''                            Command Line 1

    Io> "" or ""
    ==> true
    ```
  - `nil` is `false`
    ``` plain Io 
    Io> nil or nil
    ==> false
    ```
- 如何知道某个原型都支持哪些槽？
- =（等号）、:=（冒号等号）、::=（冒号冒号等号）之间有何区别？你会在什么情况下使用它们？


**Do**

- 从文件中运行Io程序。
- 给定槽的名称，执行该槽中的代码。
- 花上点时间熟悉槽和原型。理解原型的运行方式。

# --------- Day 1 ---------

# --------- Day 2 ---------

# --------- Day 3 ---------

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
