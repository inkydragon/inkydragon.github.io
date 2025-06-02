---
slug: nvda-internals-6
title: NVDA 内幕故事6：解析 NVDA 对象 
authors: [Joseph, cyhan]
tags: [nvda-internals, 译文]
---

本文是是关于NVDA对象的三部曲之一：NVDA 对象的解析，深入构成 NVDA 对象组成部分。

<!-- truncate -->

希望大家这段时间都能保持安全和健康。

对于新加入NVDA用户列表的人：《NVDA的内幕故事》是一系列详细介绍NVDA操作和内部机制的帖子。由于某些部分可能会变得相当技术性，我会尽力简化一些，但不会削减关键细节。对于经验丰富的NVDA用户，我希望这些帖子能帮助他们理解NVDA的工作原理。

以下是关于NVDA对象的三部分系列之一

 1. 控件名称和角色的来源：关于NVDA如何宣布控件的名称和角色的详细概述。
 1. 一个NVDA对象的解剖（本帖）：涉及构成NVDA对象的部分。
 1. 叠加类（下一篇文章）：进入叠加类（非常接近附加组件开发领域），计划于2023年1月。

该帖子还应该对最近关于事件、任务切换、浏览模式的部分以及其他帖子进行解释。
再次提醒，下面的帖子可能会变得非常极客，请耐心等待：


Cheers,
Joseph


## 评论与回复


## 译注

译自 Joseph Lee - [The Inside Story of NVDA: the anatomy of an NVDA object][1]


[1]: https://nvda.groups.io/g/nvda/topic/95747818#101756
