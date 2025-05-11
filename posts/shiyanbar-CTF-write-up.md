---
title: shiyanbar CTF write up
date: 2017-03-15 13:15:04
tags:
  - CTF
categories:
---


<!--more-->
## 2002-[Spamcarver-实验吧](http://www.shiyanbar.com/ctf/2002)

Stegsolve 看了一下，没发现什么。

binwalk 看一下
```
% binwalk spamcarver.jpg

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, JFIF standard 1.01
64001         0xFA01          End of Zip archive
```

改成`.zip`解压 (最好在linux下进行)

> Win上删不掉解压出的文件，可以试试 [PC Hunter V1.52发布，支持Win10(15063)](http://www.xuetr.com/?p=191)
> 如果Win10 PChunter驱动加载失败，可以换 [GMER - Rootkit Detector and Remover](http://www.gmer.net/)

```
======================================================================
===== ***** 删除之前保存好其他工作，做好_蓝屏_重启的准备 ******** ========  ======================================================================
```

解压出的文件用binwalk看一下，发现是jpeg，改名打开(win上打开)，得到flag

{% asset_img 2002-Spamcarver-flag.jpg Flag %}

[2017-11-09 14:24:26]
> flag{7adf6f07e0810003c585a7be97868a90}

Other writeup:
- [write-ups-2013/pico-ctf-2013/spamcarver at master · ctfs/write-ups-2013](https://github.com/ctfs/write-ups-2013/tree/master/pico-ctf-2013/spamcarver)

---

## 2001-[NAVSAT-实验吧](http://www.shiyanbar.com/ctf/2001)

ref:
- [【CTF 攻略】CTF比赛中关于zip的总结 - 安全客 - 有思想的安全新媒体](http://bobao.360.cn/ctf/detail/203.html)
- [Zip 格式 — CTF Wiki 文档](https://ctf-wiki.github.io/ctf-wiki/misc/archive/zip.html)
- [zip伪加密 - CSDN博客](http://blog.csdn.net/ETF6996/article/details/51946250)

尝试 `unzip`
```
> unzip recovery.zip
Archive:  recovery.zip
file #1:  bad zipfile offset (local header sig):  0
inflating: Mag7-BW/Chart-15.pdf    
```
报错说zip头的签名没了，只解压出一个pdf。
看一下pdf也没有有价值的信息。

`zipinfo`看一下，发现key.txt预计flag就在里面
```
> zipinfo recovery.zip
Archive:  recovery.zip
Zip file size: 283883 bytes, number of entries: 3
-rw-rw-r--  3.0 unx       27 tx stor 13-Apr-15 03:09 Mag7-BW/key.txt
-rw-r--r--  3.0 unx   341644 bx defN 05-Feb-08 11:49 Mag7-BW/Chart-15.pdf
drwxr-xr-x  3.0 unx        0 bx stor 13-Apr-15 03:13 Mag7-BW/
3 files, 341671 bytes uncompressed, 283391 bytes compressed:  17.1%
```

看一下文件头
{% asset_img 2001-NAVSAT-hex1.png File header %}

确认是文件头有问题，把文件头改成 `50 4B 03 04`
> zip文件格式参考： [Zip 格式 — CTF Wiki 文档](https://ctf-wiki.github.io/ctf-wiki/misc/archive/zip.html)
> 工具推荐：在线HexEditor [HexEd.it](https://hexed.it/)

解压得到flag
```
> unzip recovery.zip
Archive:  recovery.zip
extracting: Mag7-BW/key.txt         
replace Mag7-BW/Chart-15.pdf? [y]es, [n]o, [A]ll, [N]one, [r]ename: A
inflating: Mag7-BW/Chart-15.pdf    

...

> cat key.txt
Key: Next stop Tau Eridani
```

[2017-11-09 10:20:32]
> flag{Next stop Tau Eridani}

Other writeup:
- [write-ups-2013/pico-ctf-2013/navsat at master · ctfs/write-ups-2013](https://github.com/ctfs/write-ups-2013/tree/master/pico-ctf-2013/navsat)

## 2000- [In Hex, No One Can Hear You Complain-实验吧](http://www.shiyanbar.com/ctf/2000)


binwalk 一下
```
~/Desktop❯ binwalk kane.docx

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             Zip archive data, at least v2.0 to extract, compressed size: 287, uncompressed size: 987, name: [Content_Types].xml
336           0x150           Zip archive data, at least v2.0 to extract, compressed size: 217, uncompressed size: 573, name: _rels/.rels
594           0x252           Zip archive data, at least v2.0 to extract, compressed size: 218, uncompressed size: 358, name: docProps/app.xml
858           0x35A           Zip archive data, at least v2.0 to extract, compressed size: 282, uncompressed size: 507, name: docProps/core.xml
1187          0x4A3           Zip archive data, at least v2.0 to extract, compressed size: 432, uncompressed size: 3240, name: word/_rels/document.xml.rels
1677          0x68D           Zip archive data, at least v2.0 to extract, compressed size: 1490, uncompressed size: 12277, name: word/document.xml
3214          0xC8E           Zip archive data, at least v2.0 to extract, compressed size: 223, uncompressed size: 595, name: word/fontTable.xml
3485          0xD9D           Zip archive data, at least v2.0 to extract, compressed size: 23084, uncompressed size: 26718, name: word/media/key.png
26617         0x67F9          Zip archive data, at least v2.0 to extract, compressed size: 586, uncompressed size: 2055, name: word/styles.xml
27821         0x6CAD          End of Zip archive
```

看见 key.png 直接解压

{% asset_img 2000-docz.png %}

[2017-11-09 14:29:49]
> flag{docx_why_not_docz}

---

## 1999- [stegas 300-实验吧](http://www.shiyanbar.com/ctf/1999)

AU看一下波形
{% asset_img 1999-stegas-wav.png %}

---

## 1998- [CFG to C-实验吧](http://www.shiyanbar.com/ctf/1998)

直接看代码可借。

OR gcc 编译一下，然后IDA看：

``` c
#include<stdio.h>

int modulo(int a, int b)
{
    return b % a;
}

int loop(int a)
{
    while (a >= 0) {
        a--;
    }
    return a;
}

int control(int a, int b)
{
    if (a > b)
        return b;
    else
        return a;
}

int for_loop(int a, int b, int c)
{
    int i;

    for(i = 0; i < b; i++)
         a = c + i;
    return a;
}

int main(int argc, char const *argv[]) {
  modulo(1, 2);
  loop(5);
  control(1, 2);
  for_loop(1, 2, 1);

  return 0;
}
```

{% asset_img 1998-CFG2C-f-modulo.png  Func modulo %}
{% asset_img 1998-CFG2C-f-loop.png Func loop %}
{% asset_img 1998-CFG2C-f-control.png Func control %}
{% asset_img 1998-CFG2C-f-for_loop.png Func for_loop %}

[2017-11-09 14:58:13]
> BCDA

---

## 1997- [Byte Code-实验吧](http://www.shiyanbar.com/ctf/1997)

> You need to authenticate with the guard to gain access to the loading bay! Enter the root password from the vault application to retrieve the **passkey**! This class file is the executable for the vault application.

JAD 反编译一下

``` java
// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3)
// Source File Name:   Authenticator.java

import java.io.Console;
import java.io.PrintStream;

class Authenticator
{

    public Authenticator()
    {
    }

    public static void main(String args[])
    {
        key = new char[10];
        key[0] = 'A';
        key[1] = 'o';
        key[2] = 'J';
        key[3] = 'k';
        key[4] = 'V';
        key[5] = 'h';
        key[6] = 'L';
        key[7] = 'w';
        key[8] = 'U';
        key[9] = 'R';
        // key = "AoJkVhLwUR"
        Console console = System.console();
        for(String s = "";
            !s.equals("ThisIsth3mag1calString4458");
            s = console.readLine("Enter password:", new Object[0]));

        for(int i = 0; i < key.length; i++)
            System.out.print(key[i]);

        System.out.println("");
    }

    public static char key[];
}
```

[2017-11-09 15:22:52]
> AoJkVhLwUR

## 1822 凯撒和某某加密

[2017-03-15 13:15:04]
>flag{_Just_4_fun_0.0_}

---

## 1788- [Guess Next Session-实验吧](http://www.shiyanbar.com/ctf/1788)

```

<?php
session_start();
if (isset ($_GET['password'])) {
    if ($_GET['password'] == $_SESSION['password'])
        die ('Flag: '.$flag);
    else
        print '<p>Wrong guess.</p>';
}

mt_srand((microtime() ^ rand(1, 10000)) % rand(1, 10000) + rand(1, 10000));
?>
```
> CTF{Cl3ar_th3_S3ss1on}

## 1787- [FALSE-实验吧](http://www.shiyanbar.com/ctf/1787)

``` php
<?php
if (isset($_GET['name']) and isset($_GET['password'])) {
    if ($_GET['name'] == $_GET['password'])
        echo '<p>Your password can not be your name!</p>';
    else if (sha1($_GET['name']) === sha1($_GET['password']))
        die('Flag: '.$flag);
    else
        echo '<p>Invalid password.</p>';
}
else{
	echo '<p>Login first!</p>';
?>
```

输入数组sha1函数会报错

Payload = false.php?name[]=0&password[]=

[2017-11-09 16:43:35]
> CTF{t3st_th3_Sha1}
---
## 34- [一段奇怪的代码-实验吧](http://www.shiyanbar.com/ctf/34)

VBscript.Encode

[2017-11-09 16:38:43]
> VbSciptEncodE
---


## 7- [这里没有key-实验吧](http://www.shiyanbar.com/ctf/7)

```
<!-- #@~^TgAAAA=='[6*liLa6++p'aXvfiLaa6i[[avWi[[a*p[[6*!I'[6cp'aXvXILa6fp[:6+Wp[:XvWi[[6+XivRIAAA==^#~@ -->
```

Tool:- [VBscript.Encode 解码器 - 楼教主 - 博客园](http://www.cnblogs.com/52cik/p/vbs-encode-decode.html)

[2017-11-09 16:37:10]
> Encode@decode

---

## 4- [考考你的程序功底-实验吧](http://www.shiyanbar.com/ctf/4)

``` python
arr=[
  [ 8, 2,22,97,38,15, 0,40, 0,75, 4, 5, 7,78,52,12,50,77,91, 8],
  [49,49,99,40,17,81,18,57,60,87,17,40,98,43,69,48, 4,56,62, 0],
  [81,49,31,73,55,79,14,29,93,71,40,67,53,88,30, 3,49,13,36,65],
  [52,70,95,23, 4,60,11,42,69,24,68,56, 1,32,56,71,37, 2,36,91],
  [22,31,16,71,51,67,63,89,41,92,36,54,22,40,40,28,66,33,13,80],
  [24,47,32,60,99, 3,45, 2,44,75,33,53,78,36,84,20,35,17,12,50],
  [32,98,81,28,64,23,67,10,26,38,40,67,59,54,70,66,18,38,64,70],
  [67,26,20,68, 2,62,12,20,95,63,94,39,63, 8,40,91,66,49,94,21],
  [24,55,58, 5,66,73,99,26,97,17,78,78,96,83,14,88,34,89,63,72],
  [21,36,23, 9,75, 0,76,44,20,45,35,14, 0,61,33,97,34,31,33,95],
  [78,17,53,28,22,75,31,67,15,94, 3,80, 4,62,16,14, 9,53,56,92],
  [16,39, 5,42,96,35,31,47,55,58,88,24, 0,17,54,24,36,29,85,57],
  [86,56, 0,48,35,71,89, 7, 5,44,44,37,44,60,21,58,51,54,17,58],
  [19,80,81,68, 5,94,47,69,28,73,92,13,86,52,17,77, 4,89,55,40],
  [04,52, 8,83,97,35,99,16, 7,97,57,32,16,26,26,79,33,27,98,66],
  [88,36,68,87,57,62,20,72, 3,46,33,67,46,55,12,32,63,93,53,69],
  [04,42,16,73,38,25,39,11,24,94,72,18, 8,46,29,32,40,62,76,36],
  [20,69,36,41,72,30,23,88,34,62,99,69,82,67,59,85,74, 4,36,16],
  [20,73,35,29,78,31,90, 1,74,31,49,71,48,86,81,16,23,57, 5,54],
  [01,70,54,71,83,51,54,69,16,92,33,48,61,43,52, 1,89,19,67,48]
]
```
70600674

[2017-11-09 15:55:29]
> IL0V3Pr0Gr4m@#!!
