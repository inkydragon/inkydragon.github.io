---
title: Memo List @July
date: 2017-06-29 22:50:56
categories:
tags:
  - Memo List
description:
  备忘&开坑记录
---
反正经常开坑不填，为了保持版面整洁，先在Memo里开坑，待填的差不多了再单独拿出去。

<!--more-->
[2017-07-15 22:02:13]

# Some Note for FreeCodeCamp

当你遇到困惑不知道该怎么办，永远记住:Read-Search-Ask。

- Read the error
- Search Google
- Ask for help

# HTML 5 & CSS

**Say Hello to HTML Element**

HTML(Hyper Text Markup Language)(超文本标记语言)

大部分元素都有一个`开始标记`和一个`结束标记`。

`h1`就是一个HTML元素，`h1`是`header1`的简写，意思是 *一级标题*。
h1是主标题，h2是副标题，h3、h4、h5、h6依次递减字体的大小。

p是英文paragraph段落的缩写，经常被用来创建一个段落.

注释有两个功能：

1. 想让某一段代码不起作用，但你又不想删除这一段代码。
2. 就是给代码添加一些说明，方便团队合作或日后自己查看，但又不想影响代码本身。

注释的开始标记是`<!--`

结束

**Change the Color of Text**

我们可以通过修改元素的style(样式)来达到目的。
样式的属性有很多，其中color用来指定颜色。

以下是将你的h2元素的文本颜色设置为蓝色的示例代码：

``` html
<h2 style="color: blue">CatPhotoApp</h2>
```

**Use CSS Selectors to Style Elements**

样式的属性多达几千个，但别担心，按照80-20原则，常用的也就几十个，你完全可以掌握它。

当你键入<h2 style="color: red">CatPhotoApp</h2>，你就给h2元素添加了inline style(内联样式)。

内联样式是为元素添加样式的最简单有效的方式，但是更易于维护的方式是使用层叠样式表CSS（Cascading Style Sheets）。

在代码的最顶端，创建一个如下的style元素：
``` html
<style>
</style>
```
在这个style元素内, 你可以为所有的h2元素创建一个元素选择器。比如，如果你想要将所有的h2元素设置为红色, 你的代码应该看起来像这样：

``` html
<style>
  选择器 {属性名称: 属性值;}
  h2 {color: red;}
</style>
```
注意：一定要在属性值的后面加上分号`;`。

**Use a CSS Class to Style an Element**

1. 我们先声明一个类选择器：
  ``` html
  <style>
    .blue-text {
      color: blue;
    }
  </style>
  ```
  上面的代码在 `<style>` 标记中声明了一个叫做 `blue-text` 的类样式。

2. 然后在h2元素上应用我们声明的类选择器：
  ``` html
  <h2 class="blue-text">CatPhotoApp</h2>
  ```

注意：在CSS中，类选择器应该添加.为前缀。

而在HTML中，class属性不能添加.为前缀。
这是因为在CSS中如果类选择器前不添加. 浏览器就会误认为类选择器是一个元素选择器。

**Change the Font Size & Font Family of an Element**

字号是由样式属性font-size来控制的, 如下：
``` css
h1 {
  font-size: 30px;
}
```

用font-family属性来设置元素的字体。

如果你想把副标题的字体设置为Sans-serif，你可以使用下面的CSS：
``` css
h2 {
  font-family: Sans-serif;
}
```

**Import a Google Font**

现在，让我们来导入谷歌字体。

首先，你需要用`link`标签来引入谷歌`Lobster`字体。

复制下面的代码片断并将其粘贴到你的代码编辑器的顶部：
``` html
<link href="https://fonts.gdgdocs.org/css?family=Lobster" rel="stylesheet" type="text/css">
```
现在你可以将`Lobster`作为 `font-family`属性 的值应用到你的h2元素上了。


**Specify How Fonts Should Degrade**

有几种默认的字体是所有浏览器都可用的，包括`Monospace`、`Serif`和`Sans-Serif`。

当某种字体不可用时，你可以让浏览器自动降级到另一种字体。

例如，如果你想让段落的字体为`Helvetica`，但你同时想在`Helvetica`字体不可用时自动降级使用`Sans-Serif`字体，你可以使用如下CSS样式：
``` css
p {
  font-family: Helvetica, Sans-Serif;
}
```

**Add Images to your Website**

使用`img`元素来为你的网站添加图片，使用`src`属性指向一个图片的具体地址。

举例如下：
``` html
<img src="https://www.your-image-source.com/your-image.jpg">
```
注意：`img`元素是自关闭元素，不需要结束标记。

**Size your Images**

CSS包含一个控制元素宽度的`width`属性。像控制字体一样，我们使用`px`（像素）来指定图片的宽度。

例如，如果我们想要创建一个名为`larger-image`的类选择器，把HTML元素的宽度设定为500像素，我们使用：
``` html
<style>
  .larger-image {
    width: 500px;
  }
</style>
```

**Add Borders Around your Elements**

CSS 边框的属性有style(样式)、color(颜色)、width(宽度)、height(高度)等。

举个例子，如果我们想要让一个HTML元素的边框颜色为红色、边框宽度为5像素(px)、边框样式为固体(solid)，代码如下:
``` html
<style>
  .thin-red-border {
    border-color: red;
    border-width: 5px;
    border-style: solid;
  }
</style>
```

提示：你可以应用多个class到一个元素，只需要在多个class之间用 **空格** 分开即可。例如：
``` html
<img class="class1 class2">
```


----


- [计算机本科应届毕业生要有怎样的能力才算比较好的？ - 知乎](https://www.zhihu.com/question/25753307)

算法

二分搜索 Binary Search
分治 Divide Conquer
宽度优先搜索 Breadth First Search
深度优先搜索 Depth First Search
回溯法 Backtracking
双指针 Two Pointers
动态规划 Dynamic Programming
扫描线 Scan-line algorithm
快排 Quick Sort

数据结构  

栈 Stack
队列 Queue
链表 Linked List
数组 Array
哈希表 Hash Table
二叉树 Binary Tree  
堆 Heap
并查集 Union Find
字典树 Trie

[2017-07-09 15:00:07]

[Learn you a Haskell for Great good](http://learnyouahaskell.com/chapters)
=

**中文版**

- [简体中文 zh-cn](https://learnyoua.haskell.sg/content/zh-cn/)
- [繁體中文 zh-tw](https://learnyoua.haskell.sg/content/zh-tw/)

# 01 [introduction](http://learnyouahaskell.com/introduction)

- Hakell 是一门 *纯粹函数式编程语言 (purely functional programming language)*
  无 *副作用 (side effect)*
- Haskell 是 *惰性 (lazy)* 的
- Haskell 是 *静态类型 (statically typed)* 的
  支持 *自动类型推导 (tyoe inference)*

## WinGHCi

在GHCi中在载入(`:load`/`:l`)文件后，若更改了源文件要记得重新加载源文件(`:reload`/`:r`)

# 02 [starting out](http://learnyouahaskell.com/starting-out)

## Ready, set, go!

GHCi的提示符默认是`Preload`可以通过`:set prompt "ghci>"`修改成你想要的形式

**简单的运算**

```
ghci> 1+1
2
ghci> 1/3
0.3333333333333333
ghci> div 3 1
3
ghci> div 9 5
1
ghci> 9 `div` 5
1
```

`/`默认结果为小数，`div`为整除

可以通过加上反引号(\`)，将函数写在中间

**负数**

```
ghci> -1
-1
ghci> -1 *9
-9
ghci> 9* -1

<interactive>:15:1: error:
    Precedence parsing error
        cannot mix ‘*’ [infixl 7] and prefix `-' [infixl 6] in the same infix expression
ghci> 9*(-1)
-9
```
haskell 里面的`-`为一个函数。所以负数一般都要加上括号(句首可以不用加)

**逻辑运算**

```
ghci> True || False
True
ghci> True && False
False
ghci> not True
False
ghci> ^ True

<interactive>:22:1: error: parse error on input ‘^’
ghci> True | False

<interactive>:23:14: error:
    parse error (possibly incorrect indentation or mismatched brackets)
ghci> True and False

<interactive>:24:1: error:
    ? Couldn't match expected type ‘([Bool] -> Bool) -> Bool -> t’
                  with actual type ‘Bool’
    ? The function ‘True’ is applied to two arguments,
      but its type ‘Bool’ has none
      In the expression: True and False
      In an equation for ‘it’: it = True and False
    ? Relevant bindings include it :: t (bound at <interactive>:24:1)
```

- 与 `||`
- 或 `&&`
- 非 `not`

**比较运算符**

```
ghci> 1 == 2
False
ghci> 1 ?= 9

<interactive>:26:3: error:
    ? Variable not in scope: (?=) :: Integer -> Integer -> t
    ? Perhaps you meant one of these:
        ‘>=’ (imported from Prelude), ‘==’ (imported from Prelude),
        ‘/=’ (imported from Prelude)
ghci> 1 >= 9
False
ghci> 1 /= 9
True
ghci> True == False
False
ghci> "a" == 'a'

<interactive>:30:8: error:
    ? Couldn't match expected type ‘[Char]’ with actual type ‘Char’
    ? In the second argument of ‘(==)’, namely ‘'a'’
      In the expression: "a" == 'a'
      In an equation for ‘it’: it = "a" == 'a'
ghci> 'a' == 'a'
True
ghci> 1 === 2

<interactive>:32:3: error:
    ? Variable not in scope: (===) :: Integer -> Integer -> t
    ? Perhaps you meant ‘==’ (imported from Prelude)
ghci> 1 == True

<interactive>:33:1: error:
    ? No instance for (Num Bool) arising from the literal ‘1’
    ? In the first argument of ‘(==)’, namely ‘1’
      In the expression: 1 == True
      In an equation for ‘it’: it = 1 == True
```

- 大于? `>=`
- 小于? `<=`
- 等于? `==`
- 不等? `/=`

不同类型之间不能判定是否相等，Bool值和0/1没有关系

**函数**

```
ghci> succ 9 + max 5 4 + 1
16
ghci> (succ 9) + (max 5 4) + 1
16
ghci> succ 9 * 10
100
ghci> succ (9 * 10)
91
```

函数的优先级最高(>9)

haskell 中的函数调用不需要括号

## Baby's first functions

此节至本章末尾的函数定义：

ref: [02-starting out.lhs](//)

- haskell 中的函数定义没有顺序
- haskell 中`if`语句的`else`不可省略
- 函数名中的单引号`'`没有特殊含义，只是用来区分不同的函数
- 首字母大写的函数是不允许的
- 常量(函数)不可修改

## An intro to lists

** lists, strings and list comprehensions**

>*Note*: 在 ghci 下，我们可以使用 ``let`` 关键字来定义一个常量。在 ghci 下运行 ``let a=1`` 与在脚本中编写 ``a=1`` 是等价的。

```
ghci> let lostNumbers = [4,8,15,16,23,48]  
ghci> lostNumbers
[4,8,15,16,23,48]
ghci> [4,8,15,16,23,48]  
[4,8,15,16,23,48]
ghci> [1,2,'a',3,'b','c',4]

<interactive>:39:2: error:
    ? No instance for (Num Char) arising from the literal ‘1’
    ? In the expression: 1
      In the expression: [1, 2, 'a', 3, ....]
      In an equation for ‘it’: it = [1, 2, 'a', ....]
ghci> ['h','e','l','l','o']
"hello"
```

- List里面元素的类型必须相同
- 字符串是字符list的语法糖

**`++`**

`++`是用来连接list的操作符

```
ghci> "hello" ++ " " ++ "world"  
"hello world"
ghci> [1,2,3,4] ++ [9,10,11,12]  
[1,2,3,4,9,10,11,12]
ghci> ['w','o'] ++ ['o','t']  
"woot"
ghci> ['w','o'] ++ "class"
"woclass"
```

- `++`在插入元素时会遍历整个list，效率很低
- 使用`:`在lsit前面添加元素效率更高

**`:`**

`:`用来在list头部插入 **一个** 元素
```
ghci> '!' : ['w','o']
"!wo"
ghci> "hi" : ['w','o']

<interactive>:48:9: error:
    ? Couldn't match expected type ‘[Char]’ with actual type ‘Char’
    ? In the expression: 'w'
      In the second argument of ‘(:)’, namely ‘['w', 'o']’
      In the expression: "hi" : ['w', 'o']

<interactive>:48:13: error:
    ? Couldn't match expected type ‘[Char]’ with actual type ‘Char’
    ? In the expression: 'o'
      In the second argument of ‘(:)’, namely ‘['w', 'o']’
      In the expression: "hi" : ['w', 'o']
ghci> 'A':" SMALL CAT"
"A SMALL CAT"
ghci> 5:[1,2,3,4,5]
[5,1,2,3,4,5]
```

>*Note*: ``[],[[]],[[],[],[]]`` 是不同的。第一个是一个空的 List，第二个是含有一个空 List 的 List，第三个是含有三个空 List 的 List。

```
ghci> []
[]
ghci> [[]]
[[]]
ghci> [] == [[]]
False
ghci> [] : [[]]
[[],[]]
ghci> [] : [] : []
[[],[]]
ghci> ([] : []) : []
[[[]]]
```

**`!!`**

`!!`用于按照顺序从list 里面取值，索引从0开始

```
ghci> "Steve Buscemi" !! 0
'S'
ghci> "Steve Buscemi" !! 3
'v'
ghci> [9.4,33.2,96.2,11.2,23.25] !! 1  
33.2
ghci> [9.4,33.2,96.2,11.2,23.25] !! 11
*** Exception: Prelude.!!: index too large
ghci> [9.4,33.2,96.2,11.2,23.25] !! (-1)
*** Exception: Prelude.!!: negative index
```

索引超出范围会报错

**List of list**

list可以装入list从而得到多维数组

```
ghci> let b = [[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3]]
ghci> b
[[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3]]
ghci> b ++ [[1,1,1,1]]
[[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3],[1,1,1,1]]
ghci> it !! 2
[1,2,2,3,4]
ghci> [6,6,6]:b
[[6,6,6],[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3]]
ghci> b !! 3
[1,2,3]
```

`it`代指上一次的运算结果(仅ghci中有效)

List 中的 List 可以是不同长度，但必须得是相同的类型。
```
ghci> ["adsf","123"]
["adsf","123"]
ghci> [["adsf"],["123"]]
[["adsf"],["123"]]
ghci> [["adsf"],["123"],[213]]

<interactive>:73:20: error:
    ? No instance for (Num [Char]) arising from the literal ‘213’
    ? In the expression: 213
      In the expression: [213]
      In the expression: [["adsf"], ["123"], [213]]
```

**比较list**

当 List 内装有可比较的元素时，使用 `>` 和 `>=` 可以比较 List 的大小。它会先比较第一个元素，若它们的值相等，则比较下一个，以此类推。

```
ghci> [3,2,1] > [2,1,0]  
True
ghci> ["abcd"] <= ["xyz"]
True
ghci> "abcd" <= ['a']
False
ghci> "ab" == ['a','b']
True
ghci> [['a']] == ['a']

<interactive>:78:13: error:
    ? Couldn't match expected type ‘[Char]’ with actual type ‘Char’
    ? In the expression: 'a'
      In the second argument of ‘(==)’, namely ‘['a']’
      In the expression: [['a']] == ['a']
      ghci> ["abcd"] <= ['a']

      <interactive>:76:14: error:
          ? Couldn't match expected type ‘[Char]’ with actual type ‘Char’
          ? In the expression: 'a'
            In the second argument of ‘(<=)’, namely ‘['a']’
            In the expression: ["abcd"] <= ['a']
```

**List 常用函数**

![](http://s3.amazonaws.com/lyah/listmonster.png)

```
ghci> head [5,4,3,2,1]
5
ghci> tail [5,4,3,2,1]  
[4,3,2,1]
ghci> last [5,4,3,2,1]  
1
ghci> init [5,4,3,2,1]
[5,4,3,2]
```

## Texas ranges


## I'm a list comprehension

## Tuples

----

[2017-07-08 13:06:01]
测试 haskell 高亮以及 `pandoc` `lhs`转`md`效果

```
# 写成这样会显示`lhs`中的`>`。 ↓↓↓↓↓
pandoc -f markdown+lhs -t html+lhs -o 1.html '.\10.2-Identity Monad.lhs'

pandoc -f markdown+lhs -t markdown -o 1.md '.\10.2-Identity Monad.lhs'
pandoc -f markdown -t html -o 2.html 1.md
```
## 10.2 Identity Monad

为避免与 `Prelude`及`GHC.Base`里面预定义的函数冲突，加上以下几行

不自动导入 `Prelude`

``` haskell
{-# LANGUAGE NoImplicitPrelude #-}
-- 避开冲突
import Prelude hiding ((>>=), Monad, Identity)
```

### 10.2.1 最基本的Monad定义

``` haskell
-- typeclass Monad
class Monad m where
  return :: a -> m a

  (>>=)  :: m a -> (a -> m b) -> m b
  (>>) :: m a -> m b -> m b
  m >> k = m >>= \_-> k

  fail :: String -> m a
  fail s = error s
```

要实现Monad类型类，需要实现`return`函数和`(>>=)`运算符。

-   `return`函数将一个值`a`映射为`Monad a`
-   `(>>=)`运算符将连续的、从左至右的运算串联起来

### 10.2.2 Monad.Identity

下面定义一个最简单的Monad——Identity Monad(单位元Monad)

``` haskell
-- Identity Monad
newtype Identity a = Identity { runIdentity :: a }

instance Monad Identity where
  -- return a = Identity a
  return = Identity
  (Identity m) >>= k = k m
```

### 10.2.3 (|&gt;)

在讨论高阶函数时，为了把参数写在函数名的前面，定义了一个中缀运算符`(|>)`

``` {.sourceCode .literate .haskell}
-- 中缀运算符
(|>) = flip ($)
```

---

目前看高亮效果一般，大概是主题配色的锅;

pandoc转化有点小问题，代码段头会多出一段，需要手工替换
```
{.sourceCode .literate .haskell}
```

另外建议使用`=`代替`#`标识标题，`#`会被转义为`\#`，需要手工替换


----

[2017-07-05 13:22:19]

暑假借了本书看

- [老码识途 (豆瓣)](https://book.douban.com/subject/19930393/)

## 1.1.1 机器码

``` c
int gi;

void main(int argc, char* argv[])
{
    gi = 12;
}
```

用vs2015 在赋值语句处下断点，反汇编可得 (关闭`显示符号名`，打开`显示字节码`)

``` asm
    gi = 12;
001B168E C7 05 44 81 1B 00 0C 00 00 00 mov         dword ptr ds:[001B8144h],0Ch  
}
```

观察机器码，猜测可分为三块

``` asm
C7 05 | 44 81 1B 00 | 0C 00 00 00
mov   | 0x001B8144  | 0x0000000C (12)
```

说明整数在计算机中按逆序储存。更改`gi`的值可进一步确认

``` asm
gi = 0x12345678;
013C168E C7 05 44 81 3C 01 78 56 34 12 mov         dword ptr ds:[013C8144h],12345678h  
}

C7 05 | 44 81 3C 01 | 78 56 34 12
mov   |  013C8144h  | 12345678h
```

>**大端序**：按书写顺序存放。
>  PowerPC, SUN' SPARC 等为大端序
>
>**小端序**：整数逻辑上的最低字节放在内存的最低地址，依次存放。
>  Intel x86 CPU 是小端序

----

[2017-07-02 09:54:43]

- Atom Haskell Tools

安装atom上的haskell套件时出错了

参照教程

- [打造令人愉悦的 Haskell 开发环境 - 简书](http://www.jianshu.com/p/605042ea7c16)

以前也没安装成功，这次先装依赖`cabal install ghc-mod`

``` log
Failed to install old-time-1.1.0.3
Build log ( C:\Users\inkyd\AppData\Roaming\cabal\logs\old-time-1.1.0.3.log ):
Configuring old-time-1.1.0.3...
configure: WARNING: unrecognized options: --with-compiler
checking for gcc... F:\env\HASKEL~1\8080A1~1.2-A\mingw\bin\gcc.exe
checking whether the C compiler works... no
configure: error: in `/cygdrive/c/Users/inkyd/AppData/Local/Temp/cabal-tmp-6820/old-time-1.1.0.3':
configure: error: C compiler cannot create executables
See `config.log' for more details
cabal: Leaving directory 'C:\Users\inkyd\AppData\Local\Temp\cabal-tmp-6820\old-time-1.1.0.3'

···

cabal: Error: some packages failed to install:
cpphs-1.20.8 depends on old-time-1.1.0.3 which failed to install.
ghc-mod-5.8.0.0 depends on old-time-1.1.0.3 which failed to install.
haskell-src-exts-1.19.1 depends on old-time-1.1.0.3 which failed to install.
hlint-2.0.9 depends on old-time-1.1.0.3 which failed to install.
old-time-1.1.0.3 failed during the configure step. The exception was:
ExitFailure 77
```

找到一个issue

- [old-time fails to detect the c compiler on Windows · Issue #5 · haskell/old-time](https://github.com/haskell/old-time/issues/5)

放弃

----

[2017-06-29 22:52:43]

- [How to Contribute to Open Source | Open Source Guides](https://opensource.guide/how-to-contribute/)
