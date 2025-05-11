---
title: Metapost btex etex problem
date: 2017-02-14 21:07:03
tags:
- bug or typo?
- Metapost
---

### ref
- [要被metapost的Unable to make mpx file 整崩溃了。 - ctex.org](http://bbs.ctex.org/forum.php?mod=viewthread&tid=152699)
- [以下为什么不能编绎？ - chinatex.org](http://bbs.chinatex.org/forum.php?mod=viewthread&action=printable&tid=7149)
- [[metapost] Metapost btex etex problem - tug.org](https://www.tug.org/pipermail/metapost/2013-July/002863.html)
- [[metapost] Unable to make mpx file. Btex and etex issue - tug.org](https://www.tug.org/pipermail/metapost/2010-September/002032.html)
- ["! Unable to make mpx file." - G+](https://groups.google.com/forum/#!msg/comp.text.tex/jnQDiYmqZfU/t06ah2bWOmIJ)
- tex.stackexchange 上搜 `Unable to read mpx file`啥都没有        
    搜`Unable to make mpx file`有三个问题....上面都是`make`       
    以下是**唯一一个**与`Unable to read mpx file`相关的,是源码   
- 巨坑的源码 [Diff of /trunk/source/texk/web2c/mplibdir/mp.w](https://foundry.supelec.fr/scm/viewvc.php/trunk/source/texk/web2c/mplibdir/mp.w?root=metapost&r1=2037&r2=2044)


## 问题简述
mpost 编译不加任何头的mp 文件可以正常生成mps 
但从上一级目录编译就不行

<!-- truncate -->
正常情况:
```
I:\Desktop\Translation\TeX-doc\Metapost\Metapost-doc-CHS\source-manual>cd mp

I:\Desktop\Translation\TeX-doc\Metapost\Metapost-doc-CHS\source-manual\mp>mpost mpgraph.mp
This is MetaPost, version 1.9991 (TeX Live 2016/W32TeX) (kpathsea version 6.2.2)
(f:/study/texlive/2016/texmf-dist/metapost/base/mpost.mp
(f:/study/texlive/2016/texmf-dist/metapost/base/plain.mp
Preloading the plain mem file, version 1.005) ) (./mpgraph.mp
(f:/study/texlive/2016/texmf-dist/metapost/base/graph.mp
(f:/study/texlive/2016/texmf-dist/metapost/base/marith.mp
(f:/study/texlive/2016/texmf-dist/metapost/base/string.mp))
(f:/study/texlive/2016/texmf-dist/metapost/base/format.mp
(f:/study/texlive/2016/texmf-dist/metapost/base/string.mp)
(f:/study/texlive/2016/texmf-dist/metapost/base/texnum.mp))) [1] [2] [3] [4]
[5] [6] (f:/study/texlive/2016/texmf-dist/metapost/base/sarith.mp) [7] [8]
[9] [10] [11] )
11 output files written: mpgraph-1.mps .. mpgraph-11.mps
Transcript written on mpgraph.log.
```

改为上一级目录：
```
I:\Desktop\Translation\TeX-doc\Metapost\Metapost-doc-CHS\source-manual\mp>mpost --debug ./mp/mpgraph.mp
This is MetaPost, version 1.9991 (TeX Live 2016/W32TeX) (kpathsea version 6.2.2)
(f:/study/texlive/2016/texmf-dist/metapost/base/mpost.mp
(f:/study/texlive/2016/texmf-dist/metapost/base/plain.mp
Preloading the plain mem file, version 1.005) ) (./mpgraph.mp
(f:/study/texlive/2016/texmf-dist/metapost/base/graph.mp
(f:/study/texlive/2016/texmf-dist/metapost/base/marith.mp
(f:/study/texlive/2016/texmf-dist/metapost/base/string.mp))
(f:/study/texlive/2016/texmf-dist/metapost/base/format.mp
(f:/study/texlive/2016/texmf-dist/metapost/base/string.mp)
(f:/study/texlive/2016/texmf-dist/metapost/base/texnum.mp
>> texnum.mp
>> texnum.mpx
! ! Unable to read mpx file.
l.17 init_numbers(btex
                      $-$etex, btex$1$etex, btex${\times}10$etex,
Transcript written on mpgraph.log.

I:\Desktop\Translation\TeX-doc\Metapost\Metapost-doc-CHS\source-manual\mp>
```
