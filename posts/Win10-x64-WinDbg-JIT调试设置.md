---
title: Win10 x64 WinDbg JIT调试设置
date: 2016-12-10 15:09:38
tags: 
- WinDbg
---
《格蠹汇编》中第四章有关于如何把WinDbg设为Windows的JIT调试器方法。  
> 打开一个以管理员身份运行的控制台窗口，切换到WinDbg躲在的目录。然后执行`WinDbg -I`,将WinDbg注册成为JIT调试器，如果执行成功，那么WinDbg会弹出对话框。——《格蠹汇编》P28

<!-- truncate -->
按照书中的方法，用书中的例子初步试了一下，发现系统还是用MSVC作为默认的调试器。   
![MSVC调试器](vs.png)

在经过一番尝试后，终于找到了解决方案。

我的系统是Win10 x64,在注册表中有两个控制JIT的项。分别控制x86和x64程序的默认调制器。最开始我尝试时注册了x64的WinDbg为默认调试器，而我调试的程序是x86的，而我又安装了MSVC,所以还是以MSVC为x86程序的默认调试器。

【解决方案】先清理了一遍注册表，然后再分别注册x86和x64的WinDbg就可以用了。

1. **清理注册表**    
___x86部分___   
删除`HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\AeDebug`中的`Auto`和`Debugger`两项。  
___x64部分___   
![AeDebug](regedit_x86.png)     
删除`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug`中的`Auto`和`Debugger`两项。   
![AeDebug](regedit_x64.png)

2. **注册WinDbg为默认的JIT调试器**   
在管理员模式下的CMD中输入  
【注：下面的地址为WinDbg的根目录，请根据实际情况进行修改】
```
cd C:\Program Files (x86)\Windows Kits\10\Debuggers\x86
windbg -I
cd C:\Program Files (x86)\Windows Kits\10\Debuggers\x64
windbg -I
```
出现弹窗说明注册成功，这样x86和x64和JIT一时期就都注册为WinDbg了。    
![WinDbg注册成功](windbg_1.png)

3. **JIT参数微调**  
1.中注册表项`Auto`可取值`0` or `1`。    
取`0`，代表不自动启动调试器，会显示一个对话框，询问你是否启动调试器。    
取`1`，则自动打开默认的调试器。   
![程序崩溃](shut.png)
![选择是否调试](choose.png)

4. **调试符号设置**   
为了方便调试，在WinDbg中按`Ctrl+S`打开将符号路径设置   
输入`cache*c:\mysymbol;srv*https://msdl.microsoft.com/download/symbols`这样WinDbg就可以自动从微软的符号服务器下载符号文件并缓存在`c:\mysymbol`文件夹下。     
![符号设置](windbg_symbol.png WinDbg)
![C盘的符号缓存](c_symbol.png)    
设置好后，WinDbg会自动加载下载/加载符号文件       
![WinDbg成功加载符号文件](symbols.png)  
