---
title: Memo List @Aug
date: 2017-08-08 17:00:44
categories:
tags:
  - Memo List
description:
  备忘&开坑记录
---

<!--more-->






[2017-08-28 12:17:54]

- [美国文化大革命样板戏之四 《沙里亚浜》 - 知乎专栏](https://zhuanlan.zhihu.com/p/28683644)



- [中国真的能在未来抗衡美国么？ - 知乎](https://www.zhihu.com/question/20241087/answer/130160119)


超零界

【存疑？】
>脉冲星就是高速自转的中子星，具有极其稳定的周期性，其稳定度比目前最稳定的氢原子钟还要高1万倍以上，被誉为自然界中最稳定的天文时钟，使之成为人类在宇宙中航行的灯塔。

# QQ协议分析
[Achieved]

- [ScienJus/qqbot: 基于SmartQQ（WebQQ）的QQ机器人 / a qq robot based on smartqq(webqq) api](https://github.com/ScienJus/qqbot)
- [ScienJus/smartqq: SmartQQ（WebQQ）的Api ，你可以用它实现自己的QQ 机器人 a qq robot based on smartqq (webqq) api](https://github.com/ScienJus/smartqq)



- [Web QQ协议分析（一）：前言 | ScienJus's Blog](http://www.scienjus.com/webqq-analysis-1/)
- [Web QQ协议分析（二）：登录 | ScienJus's Blog](http://www.scienjus.com/webqq-analysis-2/)
- [Web QQ协议分析（三）：收发消息 | ScienJus's Blog](http://www.scienjus.com/webqq-analysis-3/)
- [Web QQ协议分析（四）：好友相关 | ScienJus's Blog](http://www.scienjus.com/webqq-analysis-4/)
- [Web QQ协议分析（五）：群和讨论组相关 | ScienJus's Blog](http://www.scienjus.com/webqq-analysis-5/)
- [Web QQ协议分析（六）：其他 | ScienJus's Blog](http://www.scienjus.com/webqq-analysis-6/)



[2017-08-23 18:11:43]

# 如何正确的看待国际形势

- [【局座时评24】8.1 八一特别节目|中国军队：过去的你很不容易，今后等你到世界最强_星海_科技_bilibili_哔哩哔哩](https://www.bilibili.com/video/av5601953/)


[2017-08-21 00:37:36]

monad

- [What I Wish I Knew When Learning Haskell 2.3 ( Stephen Diehl )](http://dev.stephendiehl.com/hask/#monads)


- [你会创造还是破坏？记一场成了社会学实验的大型在线游戏](http://mp.weixin.qq.com/s/4iDA68HS4RbTNjK6s8rdMA)



[2017-08-20 12:21:17]

- [化学工程专业毕业后直接工作赚钱，还是攻读研究生后再工作赚钱？ - 知乎](https://www.zhihu.com/question/22976221)


# 杂文 历史
- [有哪些影响力被严重低估的历史事件？ - 知乎](https://www.zhihu.com/question/35266109/answer/194982719)


# Heroes in my heart

- 【HTML】[Heros in My Heart](http://www.brunel.ac.uk/~csstzzw/story.html)
- [Heroes in My Heart - 知乎专栏](https://zhuanlan.zhihu.com/scienceandscientists)




[2017-08-17 13:53:06]

# radare2

- [radare/radare2: unix-like reverse engineering framework and commandline tools](https://github.com/radare/radare2)


## Qus
- [Memory Manipulation · Radare2 Explorations](https://monosource.gitbooks.io/radare2-explorations/content/tut2/tut2_-_mem_manip.html)

## tutorial
- [Introduction · Radare2 Book](https://radare.gitbooks.io/radare2book/content/introduction/intro.html)
- [Reverse Engineering With Radare2, Part 1 | Sam Symons](https://samsymons.com/blog/reverse-engineering-with-radare2-part-1/)
- [Radare 2 in 0x1E minutes – Techorganic – Musings from the brainpan](https://blog.techorganic.com/2016/03/08/radare-2-in-0x1e-minutes/)
- [A journey into Radare 2 – Part 1: Simple crackme – Megabeets](https://www.megabeets.net/a-journey-into-radare-2-part-1/)

- [An Introduction to radare2 – sushant94](http://sushant94.me/2015/05/31/Introduction_to_radare2/)


# Functional square root

- [(1 条消息)已知f(f(x))，在怎样的条件下，可求f(x)？ - 知乎](https://www.zhihu.com/question/63745657)

- [Functional square root - Wikipedia](https://en.wikipedia.org/wiki/Functional_square_root)
- [Iterated function - Wikipedia](https://en.wikipedia.org/wiki/Iterated_function)



- [磁悬浮盆栽一定要电力驱动吗，为什么做不到一块磁石稳定悬浮在另一块或一组磁石上空？ - 知乎](https://www.zhihu.com/question/40489312/answer/215702643)




# FCC

**Override Styles in Subsequent CSS**

``` html
<style>
  .pink-text {
    color: pink;
  }
  .blue-text {
    color: blue;
  }
</style>
<h1 class="pink-text blue-text">Hello World!</h1>
```

通过用空格分隔多个 `class` 属性，可对 `HTML` 元素应用多个 `class` 属性：

```
class="class1 class2"
```

注意：在 `HTML` 中这些 `class` 如何排序是无所谓的。

然而，在 `<style>` 部分中 `class` 声明的顺序却非常重要，第二个声明总是比第一个具有优先权。因为 `.blue-text` 是第二个声明，它覆盖了 `.pink-text` 属性。


**Override Class Declarations by Styling ID Attributes**

我们刚刚证明了浏览器读取 CSS 的顺序是从上到下，这意味着，在发生冲突时，浏览器会使用最后的 CSS 声明。

但是并非只有这些，还有其他覆盖 CSS 的方法。你还记得 id 属性吗？

让我们来覆盖你的 pink-text 和 blue-text 两个 class，通过为 h1 元素添加 id 并设置 id 的样式，使你的 h1 元素变成 orange（橙色）。

给你的 h1 元素添加名为 orange-text 的 id 属性。记住，id 样式看起来是这样的：

<h1 id="orange-text">

在你的 h1 元素中保留 blue-text 和 pink-text 两个 class。

在你的 style 元素中为你的 orange-text id 创建一个 CSS 声明，就像下面例子中的样子：

``` CSS
#brown-text {
  color: brown;
}
```

注意：你声明的这个 CSS 在 pink-text类选择器的上面还是下面是无所谓的，因为 id 属性总是具有更高的优先级。



- [教你如何使用分组密码对shellcode中的windows api字符串进行加密 - 知乎专栏](https://zhuanlan.zhihu.com/p/28569786)



# 生化-代谢途径

- [biochemical-pathways.com/#/map/1](http://biochemical-pathways.com/#/map/1)
- [Human_Metabolism_-_Pathways.jpg (2054×1792)](https://upload.wikimedia.org/wikipedia/commons/a/a8/Human_Metabolism_-_Pathways.jpg)
- [Metabolic Pathways Poster](http://www.sigmaaldrich.com/content/dam/sigma-aldrich/docs/Sigma/General_Information/metabolic_pathways_poster.pdf)

----

[2017-08-14 22:27:57]

**板绘**

自从有了板子之后就更想画画了

于是收集一些教程

- [How to start out drawing digital art with no drawing expierence - Quora](https://www.quora.com/How-do-I-start-out-drawing-digital-art-with-no-drawing-expierence)

- [Digital Painting 101 (1 of 5) intro — Ctrl+Paint - Digital Painting Simplified](https://www.ctrlpaint.com/dp101-1/)
- [Are You a Drawing Beginner? Start Here. | The Drawing Website](http://www.thedrawingwebsite.com/beginners-drawing/#)
- [Digital Drawing for Beginners: Before You Start Drawing](https://design.tutsplus.com/tutorials/digital-drawing-for-beginners-before-you-start-drawing--cms-27284)
- [【二次元向】零基础绘画入门引导_绘画_生活_bilibili_哔哩哔哩](https://www.bilibili.com/video/av4710062/)


[2017-08-08 16:58:52]

## Atom Haskell lint err

在ghci中可以import的模块,写在文件里就报err

```

I:\Desktop\Programming\Haskell\Write-Yourself-a-Scheme-in-48h\Setup.hs: 2, 1
Failed to load interface for ‘Text.Parsec’
Use -v to see a list of the files searched for.
I:\Desktop\Programming\Haskell\Write-Yourself-a-Scheme-in-48h\Setup.hs: 3, 1
Failed to load interface for ‘Text.ParserCombinators.Parsec’
Perhaps you meant
  Text.ParserCombinators.ReadPrec (from base-4.9.1.0)
  Text.ParserCombinators.ReadP (from base-4.9.1.0)
Use -v to see a list of the files searched for.
```

找了半天

ref：

- [simonmichael/haskell-atom-setup: How to set up and use the Atom IDE for Haskell development](https://github.com/simonmichael/haskell-atom-setup#more-on-atoms-haskell-support)


## Check 1
- [Home · DanielG/ghc-mod Wiki](https://github.com/DanielG/ghc-mod/wiki#most-common-stack-related-issue)

```
PS I:\Desktop\Programming\Haskell\WYaSi48> ghc-mod --version
ghc-mod version 5.7.0.0 compiled by GHC 8.0.2

PS I:\Desktop\Programming\Haskell\WYaSi48> stack ghc -- --version
The Glorious Glasgow Haskell Compilation System, version 8.0.2
```
pass


Open atom use: `stack exec -- atom ./`

```

I:\Desktop\Programming\Haskell\WYaSi48\hello.hs: 5, 1
Failed to load interface for ‘Text.ParserCombinators.Parsec’
Perhaps you meant
  Text.ParserCombinators.ReadPrec (from base-4.9.1.0)
  Text.ParserCombinators.ReadP (from base-4.9.1.0)
Use -v to see a list of the files searched for.
```


```
PS I:\Desktop\Programming\Haskell\WYaSi48> ghc-mod debug
Version:              ghc-mod-5.7.0.0
Library GHC Version:  8.0.2
System GHC Version:   8.0.2
Root directory:       I:\Desktop\Programming\Haskell\WYaSi48
Current directory:    I:\Desktop\Programming\Haskell\WYaSi48
GHC Package flags:
    -iI:\Desktop\Programming\Haskell\WYaSi48
    -iI:\Desktop\Programming\Haskell\WYaSi48 -global-package-db
    -user-package-db -Wall
GHC System libraries: C:\Users\inkyd\AppData\Local\Programs\stack\x86_64-windows\ghc-8.0.2\lib
```

顺手开了 `C:\Users\inkyd\AppData\Local\Programs\stack\x86_64-windows\ghc-8.0.2\lib`看了下





[2017-08-07 16:38:12]

# Atom haskell 开发环境配置

- [打造令人愉悦的 Haskell 开发环境 - 简书](http://www.jianshu.com/p/605042ea7c16)

安装二进制插件时使用 `stack`

```
stack install ghc-mod
stack install hasktags
```

{% asset_img haskell-atom-stack.png %}

**FIN**

新开一个 stack项目，然后在yaml中添加`extra-deps: [parsec-3.1.11]`
`.cabal`中添加
```
build-depends:       base >= 4.7 && < 5
                   , parsec
```

报错消失

另： 清除了atom ghc-mod的配置(不做配置，路径留空)



[2017-08-04 08:52:56]
- [泰晓科技 - Linux 下通过 Qemu 学习 X86 AT T 汇编语言](http://www.tinylab.org/learn-x86-language-courses-on-the-ubuntu-qemu-cs630/)
- [泰晓科技 - 五分钟内搭建 Linux 0.11 的实验环境](http://www.tinylab.org/take-5-minutes-to-build-linux-0-11-experiment-envrionment/)


## KVM

- [kvm - 韋任的維基百科](http://people.cs.nctu.edu.tw/~chenwj/dokuwiki/doku.php?id=kvm)
- [KVM虚拟化原理与实践（连载） – 笑遍世界](http://smilejay.com/kvm_theory_practice/)

## Kotlin

- [Kotlin 作为 Android 开发语言相比传统 Java 有什么优势？ - 知乎](https://www.zhihu.com/question/37288009/answer/172132665)


## BIOS 终端向量表

- [BIOS 和DOS 中断大全](http://staff.ustc.edu.cn/~hufy/ComputerSystem/%B8%BD%C2%BC/BIOS_DOS%D6%D0%B6%CF%B9%A6%C4%DC%B5%F7%D3%C3%B4%F3%C8%AB.pdf)
- [Embedded BIOS User's Manual](ftp://ftp.embeddedarm.com/old/saved-downloads-manuals/EBIOS-UM.PDF)
- [深入理解 x86/x64 的中断体系](http://www.mouseos.com/arch/interrupt.html)
- [Ralf Brown's Interrupt List - HTML Version](http://www.ctyme.com/rbrown.htm)
- [BIOS_UserManual.book](http://www.cypress.com/file/43311/download)
- [ClipX - Assembly Language - Norton Guide](http://www.ousob.com/ng/asm/index.php)
- [int table](http://stanislavs.org/helppc/int_table.html)




- [Phil Storrs PC Hardware book--Opening menu page](http://philipstorr.id.au/pcbook/index.htm)



[2017-08-02 20:58:02]

# Arch x64 的安装
某up打包的Arch有点问题，遂重装一遍

ref：

- [以官方Wiki的方式安装ArchLinux | viseator's blog](http://www.viseator.com/2017/05/17/arch_install/)
  虚拟机中按照教程来，非常流畅，没有任何问题
- [ArchLinux安装后的必须配置与图形界面安装教程 | viseator's blog](http://www.viseator.com/2017/05/19/arch_setup/)
- [ArchLinux你可能需要知道的操作与软件包推荐「持续更新」 | viseator's blog](http://www.viseator.com/2017/07/02/arch_more/)
  `noto-fonts-cjk`安装时建议用无图形的tty

**acpi**

`acpid`

使用的是 oh-my-zsh 的 gnzh 主题， 加了一些插件(git zsh-syntax-highlighting)，并修改了一下 ~/.oh-my-zsh/themes/gnzh.zsh-theme 文件内 PR_PROMPT 的内容（加了颜文字，然后使用的是 tmux + tmux-powerline

- [优雅地使用命令行：Tmux 终端复用 | Harttle Land](http://harttle.com/2015/11/06/tmux-startup.html)

输入法装 `ibus` + googlepinyin

```
yaourt -S ibus
yaourt -S ibus-qt
yaourt -S ibus-googlepinyin
ibus-setup
```

GCC 套装 `gcc binutils gdb make patch`


### 网络配置

配置前先`ifconfig`看看网卡是否启用，若启用
则用`ip link set <ethx/enp0sx> down`关闭

然后编辑配置文件
```
sudo cp /etc/netctl/examples/ethernet-static /etc/netctl
vim /etc/netctl
```

编辑好后，改名`<eth-static-enp0sx>`
然后启用配置文件`netctl start <eth-static-enp0sx>`

无输出则配置成功，可`ifconfig`查看效果，
`netctl enable <eth-static-enp0sx>`重启再次确认配置生效


## Vim 配置

- [yangyangwithgnu/use_vim_as_ide: use vim as IDE](https://github.com/yangyangwithgnu/use_vim_as_ide)

vim 皮肤

- [Bytefluent | Vivify](http://bytefluent.com/vivify/)
- [Newest - Vim Colors](http://vimcolors.com/)


### ssh vim 皮肤 err

ides#capture_highlight 时发生错误:
第 2 行:
E411: 找不到 highlight group: Normal
