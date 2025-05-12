---
slug: reverse-engineering-intro
title: Reverse Engineering 简介 (安利向)
date: 2017-03-30 22:55:04
authors: cyhan
tags:
- Reverse Engineering
---

## 0x1 什么是逆向工程
根据[维基百科](https://en.wikipedia.org/)上的定义
>[逆向工程(Reverse engineering)](https://zh.wikipedia.org/wiki/%E9%80%86%E5%90%91%E5%B7%A5%E7%A8%8B)
>是一种技术过程，即对一项目标产品进行逆向分析及研究，从而演绎并得出该产品的处理流程、组织结构、功能性能规格等设计要素。
>逆向工程源于商业及军事领域中的硬件分析。其主要目的是，在不能轻易获得必要的生产信息下，直接从成品的分析，推导出产品的设计原理。

<!-- truncate -->

### 逆向工程的分类
一般按逆向工程的对象分类：

- 机械设备 (machines)
- 软件 (software)
    - 源代码 (Source code) 
    - 二进制软件 (Binary software)
    - 协议 (protocols)
    - ...
- 硬件及智能卡 (integrated circuits/smart cards)
- 军事 (military applications)
- ...

**我们关注的逆向工程**
我们常用的，并且有能力进行分析的对象一般只有软件，对于软件逆向工程一般缩写为RCE(Reverse Code Engineering)

*下文均使用RCE代指软件逆向工程，而不是RE，避免混淆*

### 逆向工程的动力
*这里只针对RCE*

- 学术／学习目的
- 获得无许可／未授权的副本 [破解]
- 软件升级或更新 [二次开发]
- ...

对我们而言主要的动力就是这三条。我们日常中接触的比较多的是第二条，也就是各种破解补丁，但这次我们不谈这个，原因有二：1.违法 2.水平不够
。我们主要谈谈第一点，在学习逆向工程的过程中，你会学到大量的【计算机科学】相关的知识，从硬件到软件，从机器码到高级语言，从数学到物理[注1]。若果你有兴趣，还可以参加网络安全相关的竞赛即CTF(Capture The Flag)

[注1]：[云计算中跨虚拟机的Row Hammer攻击和权限提升](http://www.inforsec.org/wp/?p=1316) 属pwn，严格来说和逆向工程关系不大，但是他们找到了物理内存块的排布顺序，也算是一种逆向工程。

