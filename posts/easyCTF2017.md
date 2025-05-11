---
title: easyCTF2017
date: 2017-03-14 13:47:47
tags:
- CTF
---

### IRC
\#easyctf2017: EasyCTF 2017 - Flag is easyctf{irc_d0esn7_apist0rm_:)}

>easyctf{irc_d0esn7_apist0rm_:)}

<!--more-->
### Flip My Letters
看提示是按字母表逆序替换
![](Flip_My_Letters.png)

>easyctf{i_dont_even_need_an_ascii_table}

###　Clear and Concise Commentary on Caesar Cipher
都说了是Caesar Cipher

>easyctf{yougotit}

### Hexable
notepad++直接打开
![](Hexable.png)

>easyctf{T00rtUMhk0eTOp}

### Phunky Python I

``` python
x = 672676048626705557 # REDACTED
digs = [672676048626705658, 672676048626705654, 672676048626705672, 672676048626705678, 672676048626705656, 672676048626705673, 672676048626705659]
out = ""
bar=[]

for foo in reversed('easyctf'):
    bar.append(ord(foo))

for letter in reversed(digs):
    #x = letter - bar[0]
    out = chr(letter - x) + out
print out
```

>672676048626705557

### Cookie Blog
![](Cookie_Blog.png)

>easyctf{yum_c00kies!!!}

### Mane Event
看见 `new camera`果断去看 EXIF 果然有flag
![](Mane_Event.png)

>easyctf{pride_in_african_engin33ring}


###　Petty Difference
直接diff出来一堆东西，没法看

还是cmp好用

``` 
$ cmp -cl file1.txt file2.txt
  482 175 }    154 l
 1638  64 4    146 f
 1796 137 _    142 b
 2240 147 g    172 z
 3157 156 n     71 9
 3303  61 1     65 5
 3568 153 k    145 e
 3892  60 0    157 o
 3911  60 0    142 b
 4501 154 l    143 c
 5204 137 _    162 r
 5582  63 3    164 t
 6107 162 r    161 q
 6563  63 3    141 a
 7043 167 w    144 d
 7196 137 _    164 t
 8269 165 u     67 7
 8866  60 0    153 k
 9164 171 y    144 d
 9965 137 _    170 x
10771  63 3    172 z
11220 143 c     60 0
11283 156 n    144 d
11285  63 3    143 c
11666 162 r    151 i
13337  63 3    163 s
14816 146 f    167 w
15168 146 f    173 {
15180  61 1    170 x
15366 144 d     65 5
15656 137 _    153 k
16168  63 3    151 i
17651 150 h    153 k
17761 164 t     64 4
18186 137 _    160 p
18261  63 3    165 u
18592 142 b    145 e
18739 137 _    162 r
19676 171 y    151 i
20033  64 4    151 i
20228 155 m    145 e
20246 137 _    142 b
23511 163 s    155 m
24001  61 1    141 a
24487 150 h    166 v
24845 164 t    167 w
25291 173 {    156 n
25411 146 f    170 x
25491 164 t    144 d
25502 143 c    166 v
25673 171 y    167 w
26410 163 s    145 e
27127 141 a    170 x
27132 145 e     71 9
```

用正则搞了半天，才把flag提出来

>easyctf{th1s_m4y_b3_th3_d1ff3r3nc3_y0u_w3r3_l00k1ng_4}


### RSA 1

### Bizarro
图片题上神器 Stegsolve
![](Bizarro-1.png) 

```
CI XCVII CXV CXXI XCIX CXVI CII CXXIII CXVI CIV CV CXV XCV CV CXV XCV CX CXI CXVI XCV CXVI CIV CI XCV CII CVIII XCVII CIII CXXV XXXII CV XXXII CVII CX CXI CXIX XXXII CXVI CIV CV CXV XXXII CII CVIII XCVII CIII XXXII CV CXV XXXII CXIX CI CV CXIV C XXXII CV XXXII CVI CXVII CXV CXVI XXXII XCIX XCVII CX XXXIX CXVI XXXII CXII CXVII CXVI XXXII CIX CXXI XXXII CII CV CX CIII CI CXIV XXXII CXI CX XXXII CXIX CIV CXXI
```

目测罗马数字 [Advanced Roman Numerals Converter](http://www.onlineconversion.com/roman_numerals_advanced.htm)

半手工替换
```
101 97 115 121 99 116 102 123 116 104 105 115 95 105 115 95 110 111 116 95 116 104 101 95 102 108 97 103 125 32 105 32 107 110 111 119 32 116 104 105 115 32 102 108 97 103 32 105 115 32 119 101 105 114 100 32 105 32 106 117 115 116 32 99 97 110 39 116 32 112 117 116 32 109 121 32 102 105 110 103 101 114 32 111 110 32 119 104 121
```

这个有对齐要求 -> [ASCII to text converter](http://www.unit-conversion.info/texttools/ascii/)

```
101 097 115 121 099 116 102 123 116 104 105 115 095 105 115 095 110 111 116 095 116 104 101 095 102 108 097 103 125 032 105 032 107 110 111 119 032 116 104 105 115 032 102 108 097 103 032 105 115 032 119 101 105 114 100 032 105 032 106 117 115 116 032 099 097 110 039 116 032 112 117 116 032 109 121 032 102 105 110 103 101 114 032 111 110 032 119 104 121
```

```
easyctf{this_is_not_the_flag} 
i know this flag is weird i just can't put my finger on why
```

nope ?什么鬼

#### JavaScript Roman Numeral Converter
用现成的 [JavaScript Roman Numeral Converter](http://blog.stevenlevithan.com/archives/javascript-roman-numeral-converter)避免出错

``` js romanize https://repl.it/CLmf/27 deromanize.js
function deromanize (str) {
	var	str = str.toUpperCase(),
		validator = /^M*(?:D?C{0,3}|C[MD])(?:L?X{0,3}|X[CL])(?:V?I{0,3}|I[XV])$/,
		token = /[MDLV]|C[MD]?|X[CL]?|I[XV]?/g,
		key = {M:1000,CM:900,D:500,CD:400,C:100,XC:90,L:50,XL:40,X:10,IX:9,V:5,IV:4,I:1},
		num = 0, m;
	if (!(str && validator.test(str)))
		return false;
	while (m = token.exec(str))
		num += key[m[0]];
	return num;
}


function deroman( roman ) {
  var roman = roman.toUpperCase().split(' '),
      num = [];
  roman.forEach(function(e){
    num += deromanize(e);
    num += ' ';
    })
  return num;
}

deroman('CI XCVII CXV CXXI XCIX CXVI CII CXXIII CXVI CIV CV CXV XCV CV CXV XCV CX CXI CXVI XCV CXVI CIV CI XCV CII CVIII XCVII CIII CXXV XXXII CV XXXII CVII CX CXI CXIX XXXII CXVI CIV CV CXV XXXII CII CVIII XCVII CIII XXXII CV CXV XXXII CXIX CI CV CXIV C XXXII CV XXXII CVI CXVII CXV CXVI XXXII XCIX XCVII CX XXXIX CXVI XXXII CXII CXVII CXVI XXXII CIX CXXI XXXII CII CV CX CIII CI CXIV XXXII CXI CX XXXII CXIX CIV CXXI')
```

解出来和我手工解得一样



### Let Me Be Frank
先尝试单表，发现有重复替换，怀疑维吉尼亚，半手工破解成功

![尝试单表](Let_Me_Be_Frank-db) 
![维吉尼亚](Let_Me_Be_Frank-wm)

>easyctf{better_thank_the_french_for_this_one}

### Hash On Hash
目测MD5
查了一下第一行是`MD5(I)`

```
Im far too lazy to put anything meaningful here. Instead, here's some information about what you just solved.The MD5 algorithm is a widely used hash function producing a 128-bit hash value. Although MD5 was initially designed to be used as a cryptographic hash function, it has been found to suffer from extensive vulnerabilities. It can still be used as a checksum to verify data integrity, but only against unintentional corruption.Like most hash functions, MD5 is neither encryption nor encoding. It can be cracked by brute-force attack and suffers from extensive vulnerabilities as detailed in the security section below.MD5 was designed by Ronald Rivest in 1991 to replace an earlier hash function MD4.[3] The source code in RFC 1321 contains a "by attribution" RSA license. The abbreviation "MD" stands for "Message Digest."The security of the MD5 has been severely compromised, with its weaknesses having been exploited in the field, most infamously by the Flame malware in 2012. The CMU Software Engineering Institute considers MD5 essentially "cryptographically broken and unsuitable for further use".[4]easyctf{1_h0p3_y0u_d1dn7_d0_7h47_by_h4nd}
```

>easyctf{1_h0p3_y0u_d1dn7_d0_7h47_by_h4nd}

### Decode Me
base64 (手工)循环解码+去空格换行

>easyctf{what_1s_l0v3_bby_don7_hurt_m3}