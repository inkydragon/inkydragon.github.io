---
slug: wsl-windows-subsystem-for-linux-notes
title: WSL (Windows Subsystem for Linux) 小记
date: 2017-04-12 21:44:45
authors: cyhan
tags:
- WSL
---

又看见 dalao star 了新的项目[alwsl](https://github.com/alwsl/alwsl)，看了一眼，是在WSL(Windows Subsystem for Linux) 中装ArchLinux的脚本，然后我就开始折腾WSL了。

<!-- truncate -->

ref:
- [进入 WSL（或者说 Bash on Ubuntu on Windows ）环境的多种方法比较](http://www.jianshu.com/p/a8989c23f766)

本来看到了alwsl我还考虑了一下装Ubuntu还是Arch，然后看到他的issue里说libc都炸了，估计还是有bug，遂按照正常的套路装Ubuntu。

## 步骤
cmd/powershell 下输入 `bash`，然后按`y`，自动从应用商店开始下载，国内有点慢。
