---
title: GCC 中的main 与 __main
date: 2017-04-08 21:48:55
categories:
tags:
 - gcc
---
看RE4B, C3 中间有提到用gcc编译简单函数，试了下hello world，发现生成的汇编代码很奇怪，看上去想出现了死循环。

<!--more-->

{% codeblock c源码 lang:c 3.1.c %}
#include <stdio.h>

int main() 
{
    printf("hello, world\n");
    return 0;
}
{% endcodeblock %}

``` lang:nsam 得到的汇编代码 3.1.s
.file	"3.1.c"
.def	__main;	.scl	2;	.type	32;	.endef
.section .rdata,"dr"
.LC0:
.ascii "hello, world\0"
.text
.globl	main
.def	main;	.scl	2;	.type	32;	.endef
main:
pushq	%rbp
movq	%rsp, %rbp
subq	$32, %rsp
call	__main
leaq	.LC0(%rip), %rcx
call	puts
movl	$0, %eax
leave
ret
.ident	"GCC: (Rev3, Built by MSYS2 project) 5.2.0"
.def	puts;	.scl	2;	.type	32;	.endef
```

main 函数中间有一句 `call	__main` 看上去很像死循环，到群里问，把左懒大大也给坑了一下

不过实际上通过`.def`宏可以看出，他们是两个不同的函数，置于为什么这样用还有待深究。

ref:

- [GNU Compiler Collection (GCC) Internals](http://www.delorie.com/gnu/docs/gcc/gccint_149.html)
- [20 collect2](https://gcc.gnu.org/onlinedocs/gccint/Collect2.html#Collect2)
- [gcc on windows generating garbage? windows vs linux](http://stackoverflow.com/questions/19552816/gcc-on-windows-generating-garbage-windows-vs-linux/19553974#19553974)
[2017-04-08]
- [GCC Assembly Optimizations - Why are these equivalent?](http://stackoverflow.com/questions/31166773/gcc-assembly-optimizations-why-are-these-equivalent)
- [GCC's assembly output of an empty program on x86, win32](http://stackoverflow.com/questions/1317081/gccs-assembly-output-of-an-empty-program-on-x86-win32/1317202#1317202)



<div style="display: none;">
{% raw %}


{% blockquote [author[, source]] [link] [source_link_title] %}
content
{% endblockquote %}


{% codeblock [title] [lang:language] [url] [link text] %}
code snippet
{% endcodeblock %}

``` [language] [title] [url] [link text] 
code snippet 
```


{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}

{% asset_img slug [title] %}


{% endraw %}
</div>
