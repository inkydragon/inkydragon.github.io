---
slug: 0ops-0ctf-2017
title: 0ops 0CTF 2017
date: 2017-03-09 16:06:16
authors: cyhan
tags:
- CTF
---

探索 http://www.0ops.net/cli.html

<!-- truncate -->

可用命令
``` sh
help
ls
co
cat
whoami
clear
whosyourdaddy
sudo
wget
curl
hint
konami.
```

## 第一次 大力出奇迹
比较懒，直接审查元素，找到了相关的js 
[0ops_cli_all.js](http://www.0ops.net/0ops_cli_all.js)

美化了一下js http://tool.lu/js/ 

然后大致看了一下，发现了这个
``` js
window["\x65\x76\x61\x6c"](Terminal["\x72\x75\x6e\x43\x6f\x6d\x6d\x61\x6e\x64"](unescape("%63%75\x72%6c%20%66%6c\x61%67%5f\u0069%73%5f%6e\x6f%74\u005f\u0068%65%72%65")))
```
即
``` js
window["eval"](Terminal["runCommand"](unescape("%63%75r%6c%20%66%6ca%67%5f\u0069%73%5f%6eo%74\u005f\u0068%65%72%65")))
```
``` js
> unescape("%63%75r%6c%20%66%6ca%67%5f\u0069%73%5f%6eo%74\u005f\u0068%65%72%65")
< "curl flag_is_not_here"
```

运行 以上命令得
![](curl.png)
```
emxpYi5kZWNvbXByZXNzKCd4nLPTpgrQsyFdi50uBtDDpg63ndiMwAVwGoPFYEzNNrp6dpjOwVQIVU6WC3CZBtcPAIrcScYnKQ==
```

用Python解得
``` python
>>> import base64
>>> base64.b64decode("emxpYi5kZWNvbXByZXNzKCd4nLPTpgrQsyFdi50uBtDDpg63ndiMwAVwGoPFYEzNNrp6dpjOwVQIVU6WC3CZBtcPAIrcScYnKQ==")
"zlib.decompress('x\x9c\xb3\xd3\xa6\n\xd0\xb3!]\x8b\x9d.\x06\xd0\xc3\xa6\x0e\xb7\x9d\xd8\x8c\xc0\x05p\x1a\x83\xc5`L\xcd6\xbazv\x98\xce\xc1T\x08UN\x96\x0bp\x99\x06\xd7\x0f\x00\x8a\xdcI\xc6')"
>>> import zlib
>>> zlib.decompress('x\x9c\xb3\xd3\xa6\n\xd0\xb3!]\x8b\x9d.\x06\xd0\xc3\xa6\x0e\xb7\x9d\xd8\x8c\xc0\x05p\x1a\x83\xc5`L\xcd6\xbazv\x98\xce\xc1T\x08UN\x96\x0bp\x99\x06\xd7\x0f\x00\x8a\xdcI\xc6')
'>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.<+++++++++++++++++++++++++++++++++++++++++++++++++.>------------------.+++++++++++++++++++.++++++++++++++++++++++++.<.>------------------------------------------.++++++++++++++++++++++++++++++++++++++++++.-----------------.<-.>++++++.+++++++++++.-----------------------.---------------------.+++++++++++++++++++++++++++++++.-------------------------------.'
```

目测某fuck语言 [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck)

web解释器[El Brainfuck](https://copy.sh/brainfuck/)

得到真正的Flag
```
F14G_15_N0T_H3R3
```

## 第二次 常规方法
Hint：
```
guest@0ops:/$ hint
      ________________________________________________
     < Do you know konami, konami, konami and konami? >
      ------------------------------------------------
             \   ^__^
              \  (xx)\_______
                 (__)\       )\/\
                  U  ||----w |
                     ||     ||


guest@0ops:/$   
```
在找到 hint 后，搜索一下就可知: `konami`指的是一组热键 `↑↑↓↓←→←→BA` —— [Konami Code - Wikipedia](https://en.wikipedia.org/wiki/Konami_Code)

尝试一下
ori
![初始界面](1-ori.png)
1st
![](1-konami.png)
2nd
![](2-KONAMI.png)
3rd
![发光了](3-KONAMI.png)
4th
![文字开始抖动--4-konami.gif](https://cdn.sa.net/2025/05/12/io5Cj87YTEBgcsI.gif)
result
![得到base64-code--5-konami.png](https://cdn.sa.net/2025/05/12/WPOujx8EQKqwboG.png)

接下来的解密同上


