---
title: texlive2016 更新问题
date: 2017-04-23 15:23:20
categories:
tags:
  - texlive
description:
  texlive 2016 宏包更新后炸了。
---

<!--more-->

手贱，在图形界面更新了所有的可更新宏包。

然后编译文档就炸了。
![编译伪helloworld爆炸](tex1.jpg)

报错
``` latex
! Missing \endcsname inserted. <to be read again> 
\def  l.252 ...   \UnicodeEncodingName {}{"007E}
?
```
google之，找到 
[! Missing \endcsname inserted. <to be read again> \def l.252 … \UnicodeEncodingName {}{"007E}](https://tex.stackexchange.com/questions/357690/missing-endcsname-inserted-to-be-read-again-def-l-252-unicodeencodin)

内面要求在 `texlive\2016\texmf-dist\scripts\texlive`下执行 `fmtutil-sys -all` 试过了并不好使

报错
![fmtutil-sys爆炸](err1.jpg)
![fmtutil-sys爆炸](err2.png)

然后各种关键词搜来搜去，就是找不到有效的解决方法。

some ref:

- [fontspec error on BasicTeX (missing \endcsname inserted)](https://tex.stackexchange.com/questions/358404/fontspec-error-on-basictex-missing-endcsname-inserted)  
    |- 这一篇提到了版本问题。说latex2e的版本太老了。
    
我去翻了翻日志发现latex2e的版本确实是没更新，估计是缓存的锅。然后就准备删掉缓存。

查texlive手册，知：

>`TEXMFVAR` 这个目录是给 `texconfig、updmap 和 fmtutil` 存储 (缓存) 格式文件、生成 map 文件这类运行时个人数据的。 
> 
>`TEXMFSYSVAR` 给 `texconfig-sys、updmap-sys 和 fmtutil-sys 还有 tlmgr` 这几个命令存储、缓存运行时使用的格式文件和生成的 map 文件，对整个系统都有效。
> 
>`TEXMFCACHE` `ConTeXt MkIV 和 LuaLaTeX` 用来保存 (缓存的) 运行时数据的目录树；缺省为 `TEXMFSYSVAR`，如果该目录不可写，则使用 `TEXMFVAR`。

然后我就在 **备份** 之后删了`TEXMFVAR`目录

重新运行 `fmtutil-sys -all` 成功。
{% asset_img su.png %}

但编译文件是提示找不到字体缓存，尝试 `fc-cache`
报错，提示 找不到缓存
{% asset_img err4.png %}

遂恢复字体缓存及其配置文件
{% asset_img fc.png %}

然后在重建缓存 `fc-cache` 成功

最后生成map及Hash文件 【可选】
``` sh
updmap-sys

texhash
```

``` cmd
F:\study\texlive\2016\texmf-dist\scripts\texlive>updmap-sys
updmap will read the following updmap.cfg files (in precedence order):
  f:/study/texlive/2016/texmf-dist/web2c/updmap.cfg
updmap may write changes to the following updmap.cfg file:
  f:/study/texlive/2016/texmf-config/web2c/updmap.cfg
dvips output dir: "f:/study/texlive/2016/texmf-var/fonts/map/dvips/updmap"
pdftex output dir: "f:/study/texlive/2016/texmf-var/fonts/map/pdftex/updmap"
dvipdfmx output dir: "f:/study/texlive/2016/texmf-var/fonts/map/dvipdfmx/updmap"

updmap is creating new map files
using the following configuration:
  LW35 font names                  : URWkb (f:/study/texlive/2016/texmf-dist/web2c/updmap.cfg)
  prefer outlines                  : true (f:/study/texlive/2016/texmf-dist/web2c/updmap.cfg)
  texhash enabled                  : true
  download standard fonts (dvips)  : true (f:/study/texlive/2016/texmf-dist/web2c/updmap.cfg)
  download standard fonts (pdftex) : true (f:/study/texlive/2016/texmf-dist/web2c/updmap.cfg)
  jaEmbed replacement string       : ipaex (f:/study/texlive/2016/texmf-dist/web2c/updmap.cfg)
  jaVariant replacement string     : <empty> (default)
  scEmbed replacement string       : noEmbed (default)
  tcEmbed replacement string       : noEmbed (default)
  koEmbed replacement string       : noEmbed (default)
  create a mapfile for pxdvi       : false (default)

Scanning for LW35 support files  [  3 files]
Scanning for MixedMap entries    [ 44 files]
Scanning for KanjiMap entries    [ 11 files]
Scanning for Map entries         [265 files]

Generating output for dvipdfmx...
Generating output for ps2pk...
Generating output for dvips...
Generating output for pdftex...

Files generated:
  f:/study/texlive/2016/texmf-var/fonts/map/dvips/updmap:
       16049 2017-04-23 15:24:49 builtin35.map
       21523 2017-04-23 15:24:49 download35.map
     2113917 2017-04-23 15:24:51 psfonts_pk.map
     2379298 2017-04-23 15:24:50 psfonts_t1.map
     2373949 2017-04-23 15:24:49 ps2pk.map
     2379298 2017-04-23 15:24:50 psfonts.map = psfonts_t1.map
  f:/study/texlive/2016/texmf-var/fonts/map/pdftex/updmap:
     2373956 2017-04-23 15:24:53 pdftex_dl14.map
     2372291 2017-04-23 15:24:52 pdftex_ndl14.map
     2373956 2017-04-23 15:24:53 pdftex.map = pdftex_dl14.map
  f:/study/texlive/2016/texmf-var/fonts/map/dvipdfmx/updmap:
        8055 2017-04-23 15:24:48 kanjix.map

Transcript written on "f:/study/texlive/2016/texmf-var/web2c/updmap.log".
updmap: Updating ls-R files.

F:\study\texlive\2016\texmf-dist\scripts\texlive>texhash
texhash: Updating F:/study/texlive/2016/texmf-config/ls-R...
texhash: Updated F:/study/texlive/2016/texmf-config/ls-R.
texhash: Updating F:/study/texlive/2016/texmf-var/ls-R...
texhash: Updated F:/study/texlive/2016/texmf-var/ls-R.
texhash: Updating F:/study/texlive/texmf-local/ls-R...
texhash: Updated F:/study/texlive/texmf-local/ls-R.
texhash: Updating F:/study/texlive/2016/texmf-dist/ls-R...
texhash: Updated F:/study/texlive/2016/texmf-dist/ls-R.
texhash: Done.

```

至此，texlive修复完毕