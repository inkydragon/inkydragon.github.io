---
slug: nvda-internals-5
title: NVDA 内幕故事5：控件名称和角色的来源是什么？
authors: [Joseph, cyhan]
tags: [nvda-internals, 译文]
---

这是第五篇 NVDA 内幕故事，将会介绍 NVDA 的核心部分：NVDA 对象。

对于我们的新朋友、新读者们：
如果你是一个新的 NVDA 用户，或者刚开始使用屏幕阅读器，
我要介绍的部分可能令人难以理解，因为它会涉及屏幕阅读器的内部工作原理。
作为一个即将踏上人生新阶段的开发者，我觉得这是一个好机会，
我可以传授我对屏幕阅读器的了解，以帮助下一批用户和有意成为开发者的人。
我会尽我所能让这些信息易于理解。

<!-- truncate -->

这篇内幕故事是系列文章的一部分，这些文章会深入探索 NVDA 对象。
一直关注 NVDA 邮件组的人都知道，我可以为一件事滔滔不绝地讲几个小时，NVDA 对象就是其中之一。
但是由于 NVDA 对象的故事将涉及到计算机编程中的一个关键概念，面向对象编程，需要用多个帖子来详细解释，
所以我将整个 NVDA 对象的讨论分成多个部分。
此外，我希望我写的大部分内容都是实用的，特别是在回应邮件组和其他地方的帖子时。


## 系列文章

NVDA 对象系列文章包括：

1. （本帖）控件名称和角色是从哪里来的：
   我将讨论 NVDA 如何准确地了解您正在处理的控件。
   这源自最近关于应用程序中控件标签的讨论。
2. “实际”解剖 NVDA 对象：
   这将变得非常极客（涉及很多技术细节），因为我将讨论类、获取函数（getters）和设置函数（setters）、
   属性（attributes）、继承（inheritance）和抽象（abstraction），以及讨论组成 NVDA 对象的内容。
   希望可以用一种易于理解的方式展开。
3. 叠加类（Overlay classes）（非常接近插件开发领域）：
   这是许多插件的核心，提供对控件和应用程序的支持与使用优化。
   只有在理解了 NVDA 对象的组织方式之后，这部分才会有意义。


## 获取控件名称与角色

第一步，让我们看看 NVDA 如何在不进行屏幕截图的情况下，获取控件标签（名称）和角色。
（提示：无障碍 API（Accessibility API））

几天前，在[这个帖子][2]中有一个关于 NVDA 在 Web 浏览器中遇到齿轮图标时会说什么的问题。
答案是：“取决于应用程序开发者如何描述”。
不久之后，在谈论[获取系统信息][3]时，Brian V 问我们是否可以通过查看角色来确定子对象是否存在，
我回答说：“也许可以将角色视为一种启发式方法”。

但是这些与 NVDA 对象有什么关系呢？
通过无障碍 API 和指针（是的，对于学过经典编程语言的人来说，还记得指针的概念吗？）。
并且，NVDA 不会通过扫描屏幕来确定控件的角色，也不会分析图标来找出标签（名称）是什么...
嗯，大部分情况下是这样的
（有时 NVDA 确实依赖屏幕信息，通过“显示模型（display model）”来确定控件是什么，但这是在某些特殊情况下）。
所以，为了给你提供关于链接讨论的“真实”答案：NVDA 向无障碍 API 请求诸如控件名称（标签）、角色以及其他属性的信息。
NVDA （在内部）如何做到这一点是本文其后续的重点。

大多数情况下，屏幕上的控件具有各种属性：名称、角色、状态、位置等等。
但是屏幕阅读器是如何获取这些信息的呢？是通过请求无障碍 API 来按需获取信息。
我们可以把无障碍 API，例如 Microsoft Active Accessibility 和 UI Automation，
视为屏幕阅读器和应用程序之间的“中间人”，它们保持着信息的交互。
如果你仔细思考这个描述，你可能会得出这样的结论：
控件属性最终是由应用程序开发人员设置的，告诉应用程序和无障碍 API 以特定的方式公开属性，
供屏幕阅读器使用，并最终以特定的方式向用户宣告属性。
但这只是其中的一部分。

你可能会问，既然 NVDA 似乎知道各种无障碍 API，
那么屏幕阅读器如何识别哪个无障碍 API 可以用来询问控件的名称和角色呢？
不同 API 的选择，发生在创建 NVDA 对象以表示你正在处理的屏幕控件时。一个例子是处理焦点变化事件时。
NVDA 会执行一系列测试，来确定与给定控件交互时要使用哪个无障碍 API
（一个例子是：通过 Windows API 公开的窗口类名），
并根据测试结果构建一个适当的 NVDA 对象，表示一个 API 类
（API 类是给定无障碍 API 的一组 NVDA 对象的集合；我将在以后的内幕故事帖子中继续介绍这个概念）。
但这还不是完整的故事。

因此，NVDA 构建了一个表示焦点控件的 NVDA 对象，那么 NVDA 如何获取其名称和角色呢？
这需要两个部分：对象属性和无障碍 API 代表（representative）。
每个 NVDA 对象都派生自一个名为 “`NVDAObject`”（`NVDAObjects.NVDAObject`）的抽象类，
该抽象类定义了一种获取名称和角色等属性的基本实现。
这些被定义为 “`_get_property`”（一种属性获取方法）。例如 `_get_name` 用于获取控件名称，`_get_role` 用于获取角色。
这样做可以使 NVDA 通过属性访问来查询属性（`object.something`，例如 `object.name` 用于控件标签，`object.role` 用于角色）。
但由于基本 NVDA 对象只是一个蓝图框架（在技术上称为“抽象基类”），
当获取属性时，它要么提供默认实现，要么什么都不做，因此不能单独用于宣告控件标签和角色。
这就是为什么几乎所有的 NVDA 对象，都派生自 NVDA 基类对象。例如：`IAccessible/IAccessible2/JAB/UIA` 对象，
这是另一篇内幕故事文章的主题，它将介绍一些面向对象编程的概念。

> 译者注：
> 技术上的细节：这里 NVDA 的代码中通过运行时反射等技术实现了：在类中定义具有特定前缀名的函数，就能定义特定属性的效果。
> 更多说明和具体的实现可以参照 `AutoPropertyObject` 类（位于 `baseObject.py` 文件中）。

那么，是什么让 NVDA 能够与不同的 API 协同工作以获取控件属性呢？
是通过无障碍 API 代表（representative），技术上称作无障碍对象/元素；本质上这些都是指针
（指针是将程序定向到特定内存位置/地址的东西；它的重要性超出了本论坛的讨论范围，因为它涉及编程和计算机科学的各个方面）。
几乎所有的 NVDA 对象都必须有一个指向无障碍 API 对象或元素的指针作为属性，以便进行“魔术般”的控件属性宣告
（当然也有例外，包括窗口对象和基本的 NVDA 对象）。
例如，`IAccessible` 对象包括 `IAccessibleObject`，它是指向表示当前控件的 MSAA 对象的指针；
在 UIA 世界中，这就是 UIA 元素。
尽管无障碍 API 对象的操作方式不同，可能以不同的方式公开相同的属性，
但 NVDA 可以跨 API 工作，因为我们以不同的方式获取了相同的属性。

> 译者注：
> 这里的要点在于: NVDA 封装了不同的无障碍接口，以一种统一的方式，对外提供信息。
> 只要从指定的属性，获取信息，这样编写的程序就可以自动跨 API 运行，而无需关心底层的实现细节。
>
> 技术上的细节：不同的无障碍接口对应的 NVDA 对象实际上持有了底层的指针。
> 有需要时可以通过接口独有的方式获取更多的信息。

### 示例：获取桌面图标的名称

举个例子，假设你将系统焦点移动到桌面（`Windows+D`），NVDA 会宣告所聚焦的桌面图标的名称。
但是，NVDA 是如何在不分析图标的情况下做到这一点的呢？

具体方法如下：

1. 桌面图标会触发（引发）系统焦点事件。
2. NVDA 识别焦点事件，并确定它正在处理的控件类型。
3. 经过一些测试，NVDA 发现它正在与 MSAA 控件配合使用。
   因此它构建了一个 `IAccessible` NVDA 对象（`NVDAObjects.IAccessible.IAccessible`）。
   对于 MSAA 对象来说，一个关键属性是 `IAccessibleObject`，因此 NVDA 也会获取到它的指针。
4. 即使它是一个 MSAA 对象，NVDA 也仅知道它是一个自定义的 MSAA 对象，还不知道他能做些什么。
   所以它调用 `NVDAObjects.IAccessible.IAccessible.findOverlayClasses` 方法来确定该做什么，
   最终得知它是一个 `Dynamic_SysListView32EmittingDuplicateFocusEventsListItemIAccessible` 对象
   （不用在意这个冗长的名称）。
5. 现在已经创建了一个合适的 MSAA NVDA 对象。
   NVDA 现在要求 `IAccessibleObject` 返回诸如名称和角色之类的属性。
   在 MSAA 中，`IAccessibleObject` 的 `accName` 属性保存控件名称属性，`accRole` 记录对象角色。
   现在，我们可以分别从 IAccessible NVDA 对象类中定义的：`_get_name` 和 `_get_role` 属性获取方法中查询这些属性。
6. 对于控制角色，需要执行额外的步骤，以便 NVDA 以友好的方式呈现角色。
   NVDA 的 MSAA API 处理程序（`IAccessibleHandler`）具有 MSAA 角色到 NVDA 角色的映射表，
   会查询该映射以返回“NVDA 角色”。
7. 获取名称和角色后，得到的信息进一步用于检索其他属性（例如状态），然后将所有这些属性呈现给用户。

### 示例：搜索框

作为另一个例子，假设您打开 Windows 10/11 的开始菜单，并且让搜索框获得焦点。
与上面的例子不同的是，此时 NVDA 正在处理一个 UIA 对象。
这需要创建一个 UIA NVDA 对象，其中包含指向 UIA 元素（`UIAElement`）的指针。
然后，调用 UIA 元素分别从名称和控件类型属性中获取名称和角色。
与 MSAA 控件角色一样，UIA API 处理程序 (`UIAHandler`) 包含 UIA 控件类型到 NVDA 角色的映射表。

无论使用哪种无障碍 API，有两个事情始终保持不变：
首先，控件属性（如名称和角色）由应用程序开发人员确定；其次，同一份源代码可以处理各种无障碍 API。
例如，无论最终调用哪个无障碍 API 指针和属性，从 NVDA Python 控制台调用 `focus.name` 都将返回控件标签。
（如 `IAccessibleObject` 的 `accName` 属性，和 `UIAElement` 的 `name` 属性），
标签文本就是应用程序开发人员定义的控件信息，开发人员的工作是将此信息提供给无障碍 API，以便屏幕阅读器和用户可以确定控件是什么。
这就是为什么在一些文档中，应用程序被称为“服务器”，而屏幕阅读器被称为“客户端”的原因。
还记得我用来描述无障碍 API 的“中间人”类比吗？这就是为什么。


## 小结

最后，我想谈两点：回答应用程序无障碍责任的问题，以及跟上不断变化的无障碍解决方案格局。

论坛上不时有人会问：“我应该向谁寻求帮助，才能让应用程序可以无障碍访问？”
是应用程序开发者、屏幕阅读器供应商，还是两者都是？
虽然双方都有责任，但我更倾向于认为应用程序无障碍是应用程序开发者的责任。
严格从无障碍信息检索的角度来看，屏幕阅读器是消费者。
人们可能会认为屏幕阅读器是生产者，但当我们思考应用程序及其来源时，应用程序的无障碍性和可用性正是最初编写应用程序代码的人的责任。
这就是为什么我一直并将继续建议，关于应用程序无障碍的问题，第一个联系的人应该是应用程序供应商，而不是 NV Access 等屏幕阅读器供应商，
因为应用程序供应商对应用程序无障碍的投入会使更多的 NVDA 用户受益。
我希望上面关于无障碍控件标签和角色的内幕故事，能让您明白我这么说的理由。

最后，无障碍的解决方案（是的，我说的是解决方案）在 1990 年代和今天是不同的。
当 MSAA 处于起步阶段（1990 年代末和 2000 年代初）时，屏幕抓取是一种获取屏幕上控件信息的有效方法。
在 2000 年代使用 JAWS 的人可能还记得 Vispero（前身为 Freedom Scientific）关于最佳屏幕分辨率设置的说明。
如今，使用无障碍 API（如 UIA）来检索控件属性已经成为常态，这要归功于残障社区的持续倡导以及
WCAG（Web Content Accessibility Guidelines，网络内容无障碍指南）和
WAI-ARIA（Web Accessibility Initiative - Accessible Rich Internet Applications，
网络无障碍倡议 - 可访问富互联网应用）等组织的持续对话和标准化努力。
这就是为什么屏幕分辨率和屏幕阅读器的最佳屏幕设置等说明不再适用的原因，至少对于 NVDA 用户来说
（在大部分情况下；正如我上面提到的，NVDA 在特定情况下仍然可以抓取屏幕以获取信息）。

这个内幕故事的关键要点是：无障碍 API 不能取代应用程序开发者的思维方式。

希望这篇帖子一并回答并澄清了许多事情。

Cheers,
Joseph


## 评论与回复

> 译注：无评论


## 译注

译自 Joseph Lee - [The Inside Story of NVDA: where do control names and roles come from][1]
 (2022-10-28)

- 译文原载于：[NVDA 内幕故事5：控件名称和角色的来源是什么？ - NVDA 中文站](https://nvdacn.com/index.php/archives/1310/)

[1]: https://nvda.groups.io/g/nvda/topic/94623740
[2]: https://nvda.groups.io/g/nvda/topic/94515025#100474
[3]: https://nvda.groups.io/g/nvda/topic/94565203#msg100526
