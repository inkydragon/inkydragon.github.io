---
slug: nvda-internals-4
title: NVDA 内幕故事4：在按下 NVDA+Shift+S/Z 后，NVDA 睡眠了么？不一定
authors: [Joseph, cyhan]
tags: [nvda-internals, 译文]
---

下面的故事源于[此讨论贴][1]中提出的问题：NVDA 如何在睡眠状态下接收到传递给自己的键盘命令？
更深层次的问题是：按下 NVDA+Shift+S/Z 切换睡眠模式时，NVDA 是否处于“睡眠”状态？

<!-- truncate -->

标题已经给出了答案，希望下面的故事能进一步澄清原因：

当您阅读用户指南时，您会遇到的命令之一是 NVDA+Shift+S（笔记本电脑是：NVDA+Shift+Z）。
此命令切换睡眠模式，NVDA 不会从焦点应用程序播报任何内容，或者将键盘命令传递给应用程序。
这里发生了什么？如果你还记得一些关于 NVDA 组件的内幕：NVDA 由多个部分组成，包括输入、输出、事件处理以及介于两者之间的东西。当 NVDA 处于“睡眠”状态时，这些组件的一部分被关闭。从技术上讲，没有输入。注意“睡眠”二字带有引号，稍后会做解释。

当 NVDA 未休眠、处于正常工作状态时。NVDA 将自行处理命令或将其传递给应用程序。
首先，在收到一段键盘输入后，NVDA 将键盘驱动程序（由 Windows 看到的）中的所谓“扫描代码”转换为 NVDA 可以理解的形式，通常为字符串。
稍后，NVDA 将其转换为手势，并将其传递给输入管理器（`inputCore.InputManager`），然后通过 `executeGesture` 方法运行与手势关联的命令。
“执行手势”方法的工作是找出输入的键盘命令是否有脚本（绑定）。如果有，它会执行您希望 NVDA 执行的任何操作; 如果没有，它会将键盘输入传递给焦点应用程序，除非 NVDA 正在“休息”（或者更确切地说，您告诉 NVDA 休息一下，也就是在焦点应用程序中睡眠）。

除了键盘命令外，NVDA 还可以对来自程序的事件做出反应。这是通过“执行事件”（`eventHandler.executeEvent`）程序来处理的，它会检查各种条件以确保能够对当前处理的任何事件做出反应。如果可以处理传入的事件，NVDA 会依次要求全局插件、应用程序模块、树拦截器和 NVDA 对象处理当前事件的任何形式.如果上述任何一层要求屏幕阅读器执行操作，你将会听到 NVDA 说出一些内容。

## 启用睡眠模式

但是，当启用睡眠模式时会发生什么？如果启用，它是否会使 NVDA “睡眠”？答案是否定的。
请记住，每当屏幕阅读器接收到键盘输入时，它都想知道是否有与之关联的命令（脚本）。我确实说过，除非它休息一下，否则它会做一些事情，而这恰好是检查一个标志。
下面看看如果焦点控件和应用程序说“现在休眠”，NVDA 是否应该什么都不做。这个属性或标志是一个布尔变量，称为 `sleepMode`，在两个位置定义：

 1. NVDA 对象：一个名为 `NVDAObjects.NVDAObject.sleepMode` 的标志告诉 NVDA 在控件处于焦点状态时进入睡眠状态。
   该标志最终由以下控制：
 1. 应用程序模块：应用程序模块可以在使用时，通知 NVDA 进入睡眠状态（`appModuleHandler.AppModule.sleepMode`，这个标志对你们中的一些人来说是否很熟悉？）

最终，NVDA 中的睡眠模式取决于应用程序模块中的睡眠模式标志。
睡眠模式切换命令大致如下：

 1. 按下 NVDA+Shift+S/Z
 1. 输入管理器意识到与其关联的脚本，在全局命令集中定义为：
    `globalCommands.GlobalCommands.script_toggleCurrentAppSleepMode`
 1. 在脚本级别，NVDA 需要知道你所处的位置，以便获取焦点控制和你正在使用的应用程序：
    `curFocus=api.getFocusObject()`; `curApp=curFocus.appModule`
 1. 检查睡眠模式标志：`if curApp.sleepMode`。
    如果为真，则关闭睡眠模式：`curApp.sleepMode=False`；
    输出“睡眠模式关闭”；
    并执行增益焦点事件： `eventHandler.executeEvent("gainFocus",curFocus)`
 1. 如果睡眠模式一开始就处于关闭状态：`else` 分支。
    NVDA 首先执行失焦事件: `eventHandler.executeEvent("loseFocus",curFocus)`。
    然后为当前应用程序启用睡眠模式标志：`curApp.sleepMode=True`，并输出“睡眠模式开启”

> 译注：以上逻辑对应的函数为：[`script_toggleCurrentAppSleepMode`][2]

## 在睡眠模式中

NVDA 睡眠时会发生什么？

从输入的角度来看：

 1. NVDA 首先检查自己是否以某种方式被冻结：`if watchdog.isAttemptingRecovery`.
    如果为真，则忽略关联的脚本：`raise NoInputGestureAction`，允许 NVDA 将您输入的任何键盘命令传递给焦点应用程序。
 1. 如果脚本与手势相关联（在此上下文中为键盘命令; `script = gesture.script`）。
    它会检查您所在的位置：`focus = api.getFocusObject()`。
 1. 它检查睡眠模式是否打开，如果焦点对象已开启睡眠: `if focus.sleepMode is focus.SLEEP_FULL`
    或者对象和应用程序已开启睡眠，并且脚本不允许在睡眠模式中执行：`focus.sleepMode and not getattr(script, 'allowInSleepMode', False)`
    最后一部分判断条件有点复杂，因为输入手势可以通知 NVDA 可以在睡眠模式下执行与之相关的命令（到目前为止，睡眠模式切换命令是人们最熟悉的命令）。
 1. 如果睡眠模式确实处于开启状态，NVDA 将简单地将手势从自身中移除，并允许焦点应用程序处理它：`raise NoInputGestureAction`。

> 译注：以上逻辑对应的函数片段为：[`InputManager.executeGesture()`][3] 的前两个分支判断


在事件处理方面（某种程度上与输出相关）：

 1. `eventHandler.executeEvent` 被调用，并接收要处理的事件（名称）及其来源（对象）。
 1. NVDA 在 Windows 锁屏界面中保持静音（`if objectBelowLockScreenAndWindowsIsLocked`，则采用多个参数）。
 1. 否则，NVDA 将确定事件是否来自焦点控件，并引发增益聚焦事件（`isGainFocus = eventName == "gainFocus"`）;
    如果是，它将检查睡眠模式标志（`sleepMode=obj.sleepMode`）并执行其他准备工作。
 1. 如果睡眠模式为已关闭，则将调用事件执行器（一个 Python 生成器）。允许各种 NVDA 组件处理它收到的任何事件；
    否则，NVDA 将在焦点应用程序中保持静默。

> 译注：以上逻辑对应的函数为：[`eventHandler.executeEvent()`][4]


我不会展开讨论输出方面（语音和盲文），因为它将触及 NVDA 控制器客户端（NVDA Controller client），一个由第三方应用程序调用的，用于给 NVDA 发送需要输出的语音和盲文文本的 DLL。
但以上涉及的逻辑足以说明，如果为焦点应用程序打开睡眠模式，语音和盲文宣告将被 NVDA 否决。

你可能已经注意到，应用程序模块中的睡眠模式标志是真正使 NVDA 做事或保持沉默的原因。在处理事件时更是如此。当您在睡眠模式处于活动状态，听到来自非焦点应用的应用的通知时（例如 Toast 通知），这一点很明显。
这应该回答了我以后可能会再次提到的一个问题：“NVDA如何在后台说话？”。这与前台和后台控件的事件处理有关，当您考虑后台进度条宣告时更是如此。

就目前而言，这个内幕故事的关键要点是：只要你不退出 NVDA，即使你认为它正在睡觉，NVDA 也会保持活跃。

希望这能澄清很多事情。

Cheers,
Joseph

P.S. 代码片段来自最新的 NVDA alpha 快照（NVDA 源代码中的主分支，截至本文撰写时，为 2022.4）

> 译注：对应的源代码版本为 [release-2022.4][5]

## 评论与回复

> 译注：无评论

## 译注

译自 Joseph Lee - [The Inside Story of NVDA: does NVDA sleep after pressing NVDA+Shift+S/Z? Not really][6]
 (2022-09-28)

- 本篇内容涉及特定版本的函数逻辑，可以不用太深究具体的逻辑分支。而是更关注模块间的交互。
  具体的逻辑后续版本可能会修改，而模块或类的名称则会更长时间保持不变。
- 原载于：[NVDA 内幕故事4：在按下 NVDA+Shift+S/Z 后，NVDA 睡眠了么？不一定 - NVDA 中文站](https://nvdacn.com/index.php/archives/1307/)

[1]: https://nvda.groups.io/g/nvda/topic/93962018#99790
[2]: https://github.com/nvaccess/nvda/blob/0ae0e1ebf84d0f423e1b015a251ea989b216caa9/source/globalCommands.py#L143-L161
[3]: https://github.com/nvaccess/nvda/blob/0ae0e1ebf84d0f423e1b015a251ea989b216caa9/source/inputCore.py#L452-L467
[4]: https://github.com/nvaccess/nvda/blob/0ae0e1ebf84d0f423e1b015a251ea989b216caa9/source/eventHandler.py#L274-L300
[5]: https://github.com/nvaccess/nvda/tree/release-2022.4
[6]: https://nvda.groups.io/g/nvda/message/99812
