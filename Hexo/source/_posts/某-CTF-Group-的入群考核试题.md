---
title: 某 CTF Group 的入群考核试题
date: 2017-03-13 20:27:23
tags:
- CTF
---
## 题目由来
看知乎CTF入门相关问题看到 [sunnyelf](https://www.zhihu.com/people/sunnyelf/answers) dalao的答案 [针对CTF，大家都是怎么训练的？](http://zhihu.com/question/30505597/answer/72163029)

他的签名里有个群号

>CTF Group:473831530

加群需要先解出Flag
{% asset_img 0-flag.png 加群Flag %}

> http://t.cn/RJgPBh4 -> https://pan.baidu.com/s/1nv4UsyP

<!--more-->

## CTF
{% asset_img 1-7zip.png 压缩包内容 %}

### RFC4042
google 一下发现是 [UTF-9 and UTF-18](https://www.ietf.org/rfc/rfc4042.txt)

在 GitHub 上找到一个解码脚本 [utf9](https://github.com/enricobacis/utf9)
装完了写一个解码脚本

``` lang:python Utf-9_Decode.py 
#coding=utf-8
#Utf-9.py
import codecs
import utf9

def main():
    with codecs.open("rfc4042") as file:
        data = file.read()
        #data = data.replace("\n", "")
        #print utf9.utf9decode(data)
        file.close()
        return utf9.utf9decode(data)

with codecs.open("_DecodeFile.txt", "w") as temp:
    temp.write(main())
    temp.close()
```
{% asset_img 2-key.png UTF-9解码得key %}

key 看起来能运算的样子，先放一放。

考虑到本题有`.py`文件，又看到`** //`等Python的运算符，怀疑是Python的代码


### marshal
再看flag.py
{% asset_img 3-flag.png %}

执行一下
{% asset_img 4-try1.png %}

尝试依次`base64 zlib`解码无果

搜索`marshal`发现是序列化，
在 stackoverflow 上看到有人说这是序列化过的Python代码，有软件可以还原 —— [uncompyle2](https://github.com/Mysterie/uncompyle2)

下载安装之，写个脚本解码
``` lang:python FlagCodeDecrypted.py 
#!/usr/bin/env python
#coding=utf-8
#flag.py

import marshal, zlib, base64
import uncompyle2

#exec(marshal.loads(
co = marshal.loads(zlib.decompress(base64.b64decode('eJxtVP9r21YQvyd/ieWm66Cd03QM1B8C3pggUuzYCSWstHSFQijyoJBhhGq9OXJl2ZFeqAMOK6Q/94f9Ofvn1s+d7Lgtk/3O997du/vc584a0eqpYP2GVfwDEeOrKCU6g2LRRyiK4oooFsVVUSqkqxTX6J1F+SfSNYrrdKPorC76luhbpOEGCZNFZw2KG3Rmk26QtuXi3xTb7ND6/aVu0g2RuvhEcZNut5lAGbTvAFbyH57TkYLKy8J6xpDvQxiiiaIlcdqJxVcHbXY6bXNlZgviPCrO0+StqfKd88gzNh/qRZyMdWHE29TZZvIkG7eZFRGGRcBmsXJaUoKCQ9fWKHwSqNeKFnsM5PnwJ7q2aKk4AFhcWtQCh+ChB5+Lu/RmyYUxmtOEYxas7i/2iuR7Ti14OEOSmU0RADd4+dQzbM1FJhukAUeQ+kZROuLyioagrau76kc1slY1NNaY/y3LAxDQBrAICJisV2hMdF2lxQcyFuMoqcX3+TCl6xotqzSpkqmxYVmjXVjAXiwBsEfBrd1VvTvLCj2EXRnhoryAKdpxcIgJcowUB68yAx/tlCAuPHqDuZo0CN3CUGHwkPhGMA7aXMfphjbmQLhLhJcHa0a+mpgB191c1U1lnHJQbgkHx+WGxeJbejnpkzSavo2jkxZ7i725npGAaTc8FXmUjbUETHUmkxXN5zqL5WiWxwE7Bc11yyYzNJpN02jerq+DzNNodfxOX8kE4FcmYKscDdYD1oPGGucXYNmgs1F+NTf3GOt3Mg7b+NTVruqoQyX1hOEUacKw+AGbP38ZOq9THRXaSbL5pXGQ8bho/Z/lrzQaHxdoCrlev+t6nZ7re57r+57rHXag93Deh37k+vuw9zorO/Qj/B50cAf2oyOsvut3D+ADWxdxfN/1Drqu39mHzvcRswv/Hvz7sHeg9w8Qzy99DzuFwxhPhs6zWTbOI3OZRiaZZcVj5wVwOklx7OwVxR47PR46r/SVM8ulBJic9zku/eqY/MqJxiDj+Gd55wS3f35pbLCzHoEwzKKpDkN5i+TR+1AYCWTo5IV0Z0P9H3phDDd6lMzPdS5bbo9eJGbTsW9nbDqLL1N9Iq+rRxDbll2x67a9Lf27hw5uK1s1rZr6DOPF+FI=')))
#)

f=open('./_DecryptedCode.py','w')
uncompyle2.uncompyle('2.7.3',co,f)
```
{% asset_img 5-py.png 解码得到的Python代码 %}

#### flag.py 分析

``` lang:python Flag.py 
#coding=utf-8

import hashlib

# 调用 hashlib 库, 计算sha1，然后转化为16进制输出
def sha1(string):
    return hashlib.sha1(string).hexdigest()

# 将 sha1 序列逐位按16进制求校验和
def calc(strSHA1):
    r = 0 # 校验和置0

    for i in strSHA1: # 循环读取 sha1 字符串的每一位
        r += int('0x%s' % i, 16) # 将读入的字符 按16进制转化为证书求和

    return r # 返回校验和

# 注加密函数，通过 key&flag 计算出 encryptText
def encrypt(plain, key):
    # 计算 key的sha1，及相应的校验和
    keySHA1 = sha1(key)
    intSHA1 = calc(keySHA1)

    r = [] # encryptText 数组置空

    # 主加密循环
    for i in range(len(plain)): # 循环读取 flag 的每一位
        # 将计算结果添加到数组 r 内
        r.append(ord(plain[i]) # 将 flag[i] 转化为整数(ASCII码)
                 + int('0x%s' % keySHA1[i % 40], 16) # 加上 10进制的 sha1的第 [i % 40] 位，(16 -> 10)
                 - intSHA1 #减去 sha1 的校验和
                 )
        # 计算新的校验和
        intSHA1 = calc(sha1(plain[:i + 1])[:20] # 【flag 前i位的 sha1】的 前20位
                       + sha1(str(intSHA1))[:20] # 加上 【上一次校验和的字符串】的 前20位
                       )
        # 继续循环

    # 将 r 转化为字符串并返回
    return ''.join( # 将字符串拼接在一起
        map( # 枚举r中元素
        lambda x: str(x), r ) # 此 lambda 表达式，将元素转化为字符串
    )

# 主函数
if __name__ == '__main__':
    # 输入 key&flag
    key = raw_input('[*] Please input key:')
    plain = raw_input('[*] Please input flag:')

    # 调用 encrypt 函数计算 encryptText
    encryptText = encrypt(plain, key)

    # 作为对比的 cipherText 字符串， 可用于逆推 flag
    cipherText = '-185-147-211-221-164-217-188-169-205-174-211-225-191-234-148-199-198-253-175-157-222-135-240-229-201-154-178-187-244-183-212-222-164'

    # 判断 flag 是否正确， 正确则输出 **你输入的** flag
    if encryptText == cipherText:
        print '[>] Congratulations! Flag is: %s' % plain
        exit()
    else:
        print '[!] Key or flag is wrong, try again:)'
        exit()
```


pycharm里单步调试一下，发现加密部分可以逐字逆推出flag

写个脚本

``` lang:python ReDecryptedCode.py 
#coding=utf-8
#ReDecryptedCode.py

import hashlib

def sha1(string):
    return hashlib.sha1(string).hexdigest()


def calc(strSHA1):
    r = 0
    for i in strSHA1:
        r += int('0x%s' % i, 16)
    return r


def encrypt(flag, key, cipherText):
    keySHA1 = sha1(key)
    intSHA1 = calc(keySHA1)
    
    cipherTextLength=len(cipherText)/4
    FlagASCII=[]
    r = []
    cipherNum=[]

    for i in range(cipherTextLength):
        # 将 cipherText 转化为数字 list
        cipherNum.append(int(cipherText[4*i : 4*i+4]))

        # 计算 plainText
        #         FlagASCII[i] = r[i] - int('0x%s' % keySHA1[i % 40], 16) + intSHA1
        FlagASCII.append(cipherNum[i] - int('0x%s' % keySHA1[i % 40], 16) + intSHA1)
        flag += chr(FlagASCII[i])

        #         r[i] = FlagASCII[i] + int('0x%s' % keySHA1[i % 40], 16) - intSHA1
        r.append(        ord(flag[i]) + int('0x%s' % keySHA1[i % 40], 16) - intSHA1)
        intSHA1 = calc(sha1(flag[:i + 1])[:20] + sha1(str(intSHA1))[:20])

    print FlagASCII
    return ''.join(map(lambda x: str(x), r)), flag


if __name__ == '__main__':
    f_key = open('_DecodeFile.txt', 'r')
    key = f_key.read().decode('utf8').encode('ascii','ignore')
    f_key.close()
    #key = raw_input('[*] Please input key:')
    #plain = raw_input('[*] Please input flag:')
    flag = ''
    cipherText = '-185-147-211-221-164-217-188-169-205-174-211-225-191-234-148-199-198-253-175-157-222-135-240-229-201-154-178-187-244-183-212-222-164'
    (encryptText, flag) = encrypt(flag, key, cipherText)
    if encryptText == cipherText:
        print '[>] Congratulations! Flag is: %s' % flag

        #with codecs.open("_Flag_res", "w", "utf-8-sig") as temp:
        #    temp.write(utf9.utf9decode(plain))
        #    temp.close()

        exit()
    else:
        print '[!] Key or flag is wrong, try again:)'
        exit()
```


### Capture the Flag
key 有了(or 部分解出)，flag 验证程序源码也有了，开始逆推Flag

#### 1-try
用上面的`.py`脚本+之前解出的key(那一堆下划线)，尝试尝试生成Flag
{% asset_img 6-try2.png %}
生成的flag乱码，看ASCII码(上面的数字)发现有部分字符无法打印，怀疑key有问题
[2017-03-01]

#### 2-try
将key中的下划线`_`按数量一次用数字替代，刚好可以用1~9替代完全
``` lang:python _DecodeFile2Num.txt 
5*((2//2+3+6-4%4)**((3%(3-1))+8+(3%3+5+7%2+6-(6//(5%3)))))+2*(((8/2)+3%2+7-(8//4))**(1*(5+5)+7+9%3))+8*(((9//2+8%2)+(7-1))**((3+7)+9-(6//2)))+7*((3+9-(6//3-7%2%1))**(5+5+5))+2*(2+9-(3//3-9%5%2))**(9-4+7)+(3+7)**(8%3%2+5+6)+(5-2)*((4//4-5%4%1)+9)**(5-(7//7+9%3)+6)+(5+(9%7)*2+1)**9+7*(((9%7)*2+7-(8//8))**7)+(8/2)*(((4-1+7)*(6+4))**3)+3*((2+9-1)**5)+3*(((3+7-6/3+2-9%5%2)*(3-1+8/2+9%5))**2)+(1//1)*(((8%3%2+5+5)%6)+7-1)**3+5*((6/(5%3))+7)*((9%7)*2+5+1)+3//3+9+9/3
```
Python 命令行下执行得 
{% codeblock %}
5287002131074331513L
{% endcodeblock %}

再次运行解密脚本(要手动输入key，可去掉注释，见下图)
{% asset_img 7-zhushi.png %}
纯数字key
{% asset_img 8-try3.png %}
带L的key
{% asset_img 9-try4.png %}

结果依旧乱码，无果
[2017-03-09]

#### final-try
还是Google好用 `CTF Python utf9`直接搜到了精灵[sunnyelf]大佬的writeup
[人生苦短，你需要用Python来做CTF](https://www.hackfun.org/CTF/you_need_python_write_up.html)

看了一眼key的部分

>得到一堆符号串，但是经常仔细观察，除了“”符号外，其他符号都是Python中的算数运算符，“(”，“)”括号表示优先级，然后开脑洞“”为数字“1”，“\__”为数字“2”，依次类推“_________”为数字“9”，在熟悉了utf9模块的使用后尝试编写转换代码，代码执行后得到数字：5287002131074331513，尝试转换为16进制然后转换为ASCII字符

```
>>>import binascii
>>>print binascii.a2b_hex(hex(5287002131074331513)[2:-1])
I_4m-k3y
```

这样才解出了真正的key：`I_4m-k3y`

输入脚本解出Flag：
`flag{Lif3_i5_5h0r7_U_n33d_Py7h0n}`

断断续续解了一个月....
[2017-03-31]




 