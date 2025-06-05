---
slug: nvda-internals-7
title: NVDA 内幕故事7：API 和覆盖类
authors: [Joseph, cyhan]
tags: [nvda-internals, 译文]
---

本文为[《内幕故事》][1]系列英文译文的第七篇，也是关于 NVDA 对象的三部曲的最后一部分。

对于新读者：欢迎来到《NVDA 内幕故事》系列，
一位经验丰富的 NVDA 开发人员将带您揭秘 NVDA 屏幕阅读器的内部工作原理。
由于我们讨论的是软件内部原理，这些帖子很快就会变得非常复杂，所以请耐心阅读。

<!-- truncate -->

到目前为止，我们已经讨论了[对象名称与角色]和 [NVDA 对象的解剖]。
本文将讨论 API 和覆盖类，并对 NVDA 对象进行一些评论。
我可能会稍微扩展一下，并讨论一两个行为类，并且在未来的文章中可以详细介绍进度条输出和建议宣告
（关于各种 NVDA 行为类，如表格导航、对话框、进度条等的讨论将需要一篇完整的文章）。


## 回顾

NVDA 对象是单个 GUI 控件的抽象（理想化）表示。
NVDA 对象本身不会为您提供有用的信息，也不会提供帮助您与给定控件有效交互的方法。
因此，它依赖于更具体的实现，例如辅助功能 API 对象，来提供诸如对象导航、焦点和前台宣告等功能背后的实际机制。
在讨论 NVDA 对象的构造时，我展示了一个“抽象类”的示例 —— NVDA 如何通过各种方式获取对象位置
（展示了三种方式：基础 NVDA 对象、IAccessible 和 UIA），最后我展示了 NVDA 对象的类继承树。
如果您想了解更多关于我刚才讨论的内容，请点击上面的“NVDA 对象解剖”链接
（从某种程度上来说，您需要阅读过 NVDA 对象文章的前两部分，因为我接下来要描述的内容建立在它们之上）。

回想一下，程序员可以用类和对象来表示世界，而人们定义继承是为了让世界变得更有趣。
简而言之，继承是指自定义对象或类可以从基类（父类）继承功能，而自定义类可以出于各种原因编辑或替换父类的部分功能。
例如，基类可以定义一个 `name` 方法，继承自基类的类可以自定义该方法以提供更多详细信息。
有关快速示例，请参阅上一篇《内幕故事》文章中的对象位置示例。


## NVDA 对象派生类

如果只提供基础 NVDA 对象 (`NVDAObjects.NVDAObject`)，NVDA 将缺乏灵活性。
它无法为应用程序提供自定义命令，无法获取一两个自定义控件的标签和角色，
无法自动读取对话框文本，也无法提供浏览模式... 总之，NVDA 只提供一种方法。
但请记住，NVDA 对象是一个类，而 Python 以面向对象编程为范式，允许您自定义获取控件标签和角色的方式。
而这正是 API、行为和覆盖类发挥作用的地方
（我之所以在这里提到行为类，是因为一些插件确实带有从行为派生出来的覆盖类。例如进度条）。

API、行为和覆盖类可以被视为 NVDA 基础对象之上的层。

### 窗口和行为

第一层是窗口和行为。在 Microsoft Windows 中，控件具有所谓的“窗口句柄”，用于区分各个控件
（您可能会看到文档中用“`hwnd`”来指代窗口句柄）。
为了容纳窗口句柄和其他属性，在 NVDA 基础对象之上定义了一个窗口类 (`NVDAObjects.window.Window`)。
这是必要的，因为如果没有窗口句柄，NVDA 将会：

- 无法区分 GUI 控件
- 无法创建或与辅助功能 API 及其生成的 API 类进行交互（例如 IAccessible）

除了基础窗口对象之外，NVDA 还附带了一系列窗口对象，用于处理诸如 Excel 之类的操作。
这些对象不一定使用辅助功能 API 来完成各种任务——需要辅助功能 API 的对象被分组到相应的 API 目录中。
窗口对象主要依靠诸如窗口句柄和类名之类的属性来告知 NVDA 它正在处理的控件类型。

紧邻 NVDA 基础对象之上的另一个类（或一组类）是行为。
行为类包括表格单元格的表示（并因此提供表格导航命令）、进度条、对话框、可编辑文本等等。
这些类旨在使 NVDA 能够以特定方式运行 —— 例如播放进度条蜂鸣声。
我可以在以后的文章中详细讨论行为类；目前，我们将重点介绍以下其他类。

> 译者注：
> - 窗口类源代码 [`NVDAObjects.window` (release-2024.4.2)](https://github.com/nvaccess/nvda/tree/release-2024.4.2/source/NVDAObjects/window)
> - 行为类源代码 [`NVDAObjects.behaviors` (release-2024.4.2)](https://github.com/nvaccess/nvda/blob/release-2024.4.2/source/NVDAObjects/behaviors.py)

### API 类

现在介绍第二层：API 类。
这些类代表各种 API 及其支持的控件，包括 MSAA/IAccessible (`NvDAObjects.IAccessible.IAccessible`)、
Java Access Bridge (`NVDAObjects.JAB.JAB`) 和 UI Automation (`NVDAObjects.UIA.UIA`)。
如上所述，这些类需要窗口句柄才能正常运行，因此它们继承自基窗口类。
这些 API 类的作用是通过提供名称、角色、描述以及其他属性和方法的具体实现，来补充基 NVDA 对象，并参考实际的辅助功能 API 特性。
（请记住，由于基 NVDA 对象是抽象类，因此许多属性和方法会显示“未实现”）
定义后，API 类将为 NVDA 提供一种处理由该 API 支持的控件的方法，并提供供覆盖类（如下所述）使用的常用服务。
例如，NVDA 获取控件标签（名称）的方式在 IAccessible 和 UIA 之间有所不同，
并且任何 UIA 类都可以在需要时使用 UIA 方式查找控件标签，而无需定义自己的方式
（因为基本 UIA NVDA 对象完成了繁重的工作；您可以覆盖如何在覆盖类中“定义”标签）。
API 类在大多数情况下并不打算被直接使用 —— 在大多数情况下，人们会根据控件被视为的 NVDA 对象的类型从这些类中继承
（例如，如果处理 IAccessible 对象，则会创建一个从基本 IAccessible 类继承的类）；
使用这些 API 类的唯一时间是：如果您需要编辑 NVDA 源代码，以向这些类添加可由继承或覆盖类使用的功能。

### 覆盖类

下一层（也是最后一层）是覆盖类，它们既内置于 NVDA，也由许多 NVDA 插件定义，
其中许多插件源自具体的辅助功能 API 类。
顾名思义，覆盖类是一种“自定义覆盖”，旨在帮助 NVDA 应对特定情况。
例如，名为 `SysListView32` （派生自 IAccessible）的覆盖类在任务管理器等位置提供表格导航命令，
名为 `SuggestionsList` （来自 UIA）的类会在 Windows 10/11 设置等应用中公布建议计数。
NVDA 之所以非常灵活，是因为插件可以定义自己的覆盖类：
一个很好的例子就是在安装 Mozilla 应用增强插件后，NVDA 如何与各种 Mozilla 应用和控件协同工作。

从技术角度来说，覆盖类是一个自定义或扩展的 API 类，提供自定义的方法来执行某些操作。
NVDA 所关注的只是它能够完成其工作，例如播报标签、响应事件以及执行各种操作，
而无需了解底层发生了什么，而这正是 NVDA 对象的用户体验方面。
在代码层面，覆盖类可以扩展或替换基类提供的服务，
无论基类是 API 类、行为类，还是至少一个插件中的 NVDA 基类对象。
换句话说，覆盖类可以塑造 NVDA 呈现给用户的体验，如果插件定义了自己的覆盖类，则更是如此。

> 译者注：与覆盖类相关的开发文档是
> [Providing Custom NVDA Object Classes (release-2024.4.2)](https://github.com/nvaccess/nvda/blob/release-2024.4.2/projectDocs/dev/developerGuide/developerGuide.md?plain=1#L850)


## 示例：StationPlaylist 插件

为了展示覆盖类在塑造 NVDA 行为和用户体验方面的强大功能，
我们来看一下 StationPlaylist 插件，以及 NVDA 如何在曲目列表中提供表格导航命令。
作为此插件的一部分，定义了一个 StationPlaylist Studio (`splstudio`) 的应用模块，
该应用模块内部包含一个覆盖类，它提供了曲目项的抽象视图。
该曲目项类 (`appModules.splstudio.SPLTrackItem`) 派生自一长串 IAccessible 类：

- SysListView32 列表项（`NVDAObjects.IAccessible.syslistview32.ListItem`），
  为某些列表提供表格导航命令，由以下功能提供支持：
- 伪表格行和导航（`NVDAObjects.behaviors.RowWithFakeNavigation`），
  为不是真正表格的行定义表格导航命令（就 NVDA 第一眼能获取的的部分），但这还不是全部：
- 基本 IAccessible/MSAA 服务（`NVDAObjects.IAccessible.IAccessible`）
- 窗口（`NVDAObjects.window.Window`）
- 基本 NVDA 对象（`NVDAObjects.NVDAObject`）

最终，SPL 轨道列表中的表格导航命令来自 `sysListView32.ListItem`。
但是，SPL 应用模块中的轨道项类会覆盖某些用于获取列内容的方法，从而改变 NVDA 获取单元格内容的方式。
所有这些都由来自插件的单个覆盖类处理
（现在您看到了覆盖类的强大之处；给插件作者的忠告：您的代码会在一定程度上影响用户对 NVDA 的看法）。
或者，简单地说，覆盖类的作用是改变 NVDA 的行为以适应当前情况，而这一切都归功于抽象、继承和多态性。

> 译者注：
> - StationPlaylist 插件目前仍在维护。当前的维护者是 Joseph Lee，即本文作者。
> - [`SPLTrackItem` 类的定义代码](https://github.com/ChrisDuffley/stationPlaylist/blob/25.06/addon/appModules/splstudio/__init__.py#L124)


## 特殊情况

最后，NVDA 如何了解“特殊情况”？
这是在构建一个 NVDA 对象来表示您正在使用的控件时完成的。

首先，NVDA 将确定需要使用哪个 API 类。
然后，NVDA 将确定它是否是它所知道的对象（通过调用 `findOverlayClasses` 来查找所选 API 的内置覆盖类），
接着询问代表该控件所属应用程序的应用程序模块，然后遍历已加载的全局插件，看看它们是否知道该对象
（对于应用程序模块和全局插件，将调用 `chooseNVDAObjectOverlayClasses`）。
NVDA 还可以询问应用程序模块是否需要进一步自定义对象，例如使用不同的角色（`event_NVDAObject_init`）。
如果生成的对象是一个覆盖类（而不是 API 类），则可以将其视为“特殊情况”，
否则将直接使用辅助功能 API 提供的服务，因为生成的 NVDA 对象是一个纯 API 类（没有自定义）。


## 总结

NVDA 对象系列文章共分为三部分，涵盖了 NVDA 对象的概念、工作原理、内部结构以及如何自定义。
本系列文章的关键点在于，NVDA 竭尽全力在各种辅助功能 API 中提供通用的用户体验，并且始终考虑各种特殊情况。
从某种程度上来说，了解 NVDA 对象、其结构以及覆盖类的用途，是创建高效插件所需的最低知识要求，特别是在设计应用模块时。

希望这有所帮助。
欢迎提问和评论。

Cheers,
Joseph


## 评论与回复

- 评论中有人询问了是否还有类似的技术文章，作者回复了这是系列文章之一。
- 作者还提到之后可能会暂停更新，因为要忙于研究生学业。
  原文为:“我将暂停发布《内幕故事》文章一段时间，以便专注于研究生学习。再过一个学期我就会知道是否可以在我的名字后面加上 "M.A."。”


## 译注

译自 Joseph Lee - [The Inside Story of NVDA: API and overlay classes][2]
(2023-01-13)

- 代码与开发文档均使用指向特定 git 提交的版本，这样可以保证不会因版本更新而失效。

[1]: https://nvdacn.com/index.php/tag/NVDA-%E5%86%85%E5%B9%95%E6%95%85%E4%BA%8B/
[2]: https://nvda.groups.io/g/nvda/topic/96236605#102447
