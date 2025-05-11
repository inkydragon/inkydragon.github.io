---
title: 密码与 Esoteric programming languages
date: 2017-02-08 23:08:56
tags:
- Cipher & Code
---
在密码吧看到[两张图](http://tieba.baidu.com/p/4963843005)，目测是[Esoteric programming language](https://en.wikipedia.org/wiki/Esoteric_programming_language)(天马dalao也提示了，就想着试一试
![第一张](Piet.jpg)
![第二张](Malbolge.jpg)

以前也在知乎上看见过[相关的介绍](https://www.zhihu.com/question/23115824/answer/45138393)，找了一下，第一张是Piet-lang，第二张是 Malbolge-lang

开工！

<!-- truncate -->

# Piet-lang
Google 之，找到编译器 [Piet Interpreters and Assemblers](http://www.dangermouse.net/esoteric/piet/tools.html)

## Piet-lang 编译环境构建
### # 0 try: [web Piet IDE](http://zobier.net/piet/)
格子太少，需要手工输入，虽然有[源码](http://www.rapapaing.com/blog/?page_id=6)，但目测改起来麻烦，遂放弃

### # 1st try: .py 脚本
另存为.py运行，需要 Python Imaging Library 库

在[官网](http://www.pythonware.com/products/pil/)下载的安装包不能用，`easy_install PIL`无果

遂手动编译 PIL

下载源码 ，cd到源代码根目录`python setup.py install`

报错
```
...
running build_ext
building '_imaging' extension
error: Unable to find vcvarsall.bat

I:\Desktop\Imaging-1.1.7>
```
google 得知是少Python的C++编译器
{% blockquote Ross Rogers http://stackoverflow.com/a/10558328 hexo error: Unable to find vcvarsall.bat %}
Update: Comments point out that the instructions here may be dangerous. Consider using the Visual C++ 2008 Express edition or the purpose-built [Microsoft Visual C++ Compiler for Python](http://www.microsoft.com/en-us/download/details.aspx?id=44266) [(details)](http://stackoverflow.com/a/26127562/2778484) and NOT using the original answer below. Original error message means the required version of Visual C++ is not installed.
{% endblockquote %}

安装以上提到的.msi包，发现已经装过了

DEAD

### # 2nd try: [C 编译器](https://github.com/ducin/piet)
需要`cmake`，下载cmake(网速感人，安装完，编译

报错：
```
CMake Error at C:/Program Files/CMake/share/cmake-3.8/Modules/FindQt4.cmake:1318 (message):
  Found unsuitable Qt version "" from NOTFOUND, this code requires Qt 4.x
Call Stack (most recent call first):
  CMakeLists.txt:5 (FIND_PACKAGE)


-- Configuring incomplete, errors occurred!
See also "I:/Desktop/piet-master/build/CMakeFiles/CMakeOutput.log".

I:\Desktop\piet-master\build>
```

DEAD

### # 3rd try: 成品编译器 npiet-1.3a
[npiet-1.3a-win32 ](http://www.bertnase.de/npiet/)
只支持 .gif .png .ppm
自带的例子可以正常运行，

{% codeblock npiet-help %}
I:\Downloads\npiet-1.3a-win32>npiet.exe -h
npiet v1.3  (with GD support, with GIF support, with PNG support)

use: npiet [<options>] <filename>
options:
        -v         - be verbose (default: off)
        -q         - be quiet (default: off)
        -e <n>     - execution steps (default: unlimited)
        -t         - trace (default: off)
        -ub        - unknown colors are black (default: white)
        -uu        - unknown colors give error (default: white)
        -cs <n>    - codelsize of the input (default: guess)
        -tpic      - create trace picture  (default: do not)
        -tpf <n>   - trace pixelzoom  (default: 48 or so)
        -tps       - simple trace pic w/o dp/cc info  (default: sho dp/cc info)
        -ts <n>    - graphic trace start (default: 0)
        -te <n>    - graphic trace end (default: unlimited)
        -n-str <s> - nase stuff: string-to-command
        -d         - debug (default: off)
        -dpbug     - model the perl piet interpreter (default: off)
        -v11       - model the npiet v1.1 interpreter (default: off)
{% endcodeblock %}


不带参数运行题目，听见风扇声，CPU占用率升高，怀疑死循环，加上参数`-t`确认是死循环

怀疑是图片非原图质量不高且经过放大所致.
```
I:\Downloads\npiet-1.3a-win32>npiet.exe -t Piet.png
trace: special case: we at a white codel - continuing
trace: entering white block at 471,0 (like the perl interpreter would)...

trace: step 0  (0,0/r,l WW -> 471,0/r,l WW):
trace: special case: we at a white codel - continuing
trace: entering white block at 471,2 (like the perl interpreter would)...

trace: step 1  (471,0/r,l WW -> 471,2/d,r WW):
trace: special case: we at a white codel - continuing
trace: entering white block at 464,2 (like the perl interpreter would)...

trace: step 2  (471,2/d,r WW -> 464,2/l,l WW):
trace: special case: we at a white codel - continuing
trace: entering white block at 464,0 (like the perl interpreter would)...

trace: step 3  (464,2/l,l WW -> 464,0/u,r WW):
trace: special case: we at a white codel - continuing
trace: entering white block at 471,0 (like the perl interpreter would)...

trace: step 4  (464,0/u,r WW -> 471,0/r,l WW):
trace: special case: we at a white codel - continuing
trace: entering white block at 471,2 (like the perl interpreter would)...

trace: step 5  (471,0/r,l WW -> 471,2/d,r WW):
trace: special case: we at a white codel - continuing
trace: entering white block at 464,2 (like the perl interpreter would)...

.....
```
带参数`-ub`无果
```
I:\Downloads\npiet-1.3a-win32>npiet.exe -ub -t Piet.png
trace: special case: we started at a black cell - exiting...

I:\Downloads\npiet-1.3a-win32>
```
用老版的解释器进一步确认是死循环：
```
I:\Downloads\npiet-1.3a-win32>npiet.exe -v11 -t Piet.png
trace: special case: we at a white codel - continuing
trace: hitting black block when sliding at 471,0 l r
trace: hitting black block when sliding at 471,2 r d
trace: hitting black block when sliding at 464,2 l l
trace: hitting black block when sliding at 464,0 r u
trace: hitting black block when sliding at 471,0 l r

I:\Downloads\npiet-1.3a-win32>
```
遂放弃

DEAD

--------

# Malbolge-lang
找到疑似[官网](http://www.lscheffer.com/malbolge.shtml)

## 编译环境
[编译器源码](http://www.lscheffer.com/malbolge_interp.html)
***记得把第一句话删掉！！***

Hello World测试代码
{% codeblock Malbolge-lang Hello World.mal %}
('&%:9]!~}|z2Vxwv-,POqponl$Hjig%eB@@>}=<M:9wv6WsU2T|nm-,jcL(I&%$#"
 `CB]V?Tx<uVtT`Rpo3NlF.Jh++FdbCBA@?]!~|4XzyTT43Qsqq(Lnmkj"Fhg${z@>
{% endcodeblock %}
一般都能正常运行

然后手工识别源码：
{% codeblock Malbolge-lang Job.mal %}
('&$:^"!}54Xzyw5.Rtrrp('Kml)j!Eg
f{"cx>_u::[q7554E~10A.-+M*uK'_^]
\"ZY}j/zxw;;:Ur7q44
{% endcodeblock %}

结果：
```
I:\Desktop\malbolge_interp>malbolge.exe Hello_World.mal
Hello World!
I:\Desktop\malbolge_interp>malbolge.exe job.mal
g@v-io.co
I:\Desktop\malbolge_interp>
```

FIN
