---
title: Lecture 1 - Introduction to Computation
date: 2017-01-29 14:10:28
categories: 
- Study
- MOOC
- edX
- MIT-6.00.1sp
---
# *Lecture 1 Introduction*
Lecture 1将介绍：计算方法和计算思维的一些基本原则：     
1.  计算机到底干了什么？
- 计算机最基本的操作(元指令)是什么？
- 这些元指令怎样构成我们所说的程序性知识(imperative knowledge)或操作方法？
- 算法中，让计算机能够完成计算的最基本的元素、原则是什么？
- 我们应该怎样用一门编程语言来描述上述的方法、原则？

<!--more-->
## Section1 Introduction to Computer Science and Programming
- Goal
    - Become skillful at making a computer do what you want it to do
    - Learn computational modes of thinking
    - Master the art of computational problem solving

## Section2 Basics Of Computation
### 计算机能干什么?
- 计算机的基本功能:
    - 计算 (Performs calculations)
    - 存储 (Remembers the results)
- 计算机能够做什么计算什么?
    - 内置的基本运算
    - 我们自己所创造的计算方法

### 计算机的运算速度

计算机速度很快
- 在光走完 1feet 所用的时间内，可以完成2次元指令
- 在小球自由落体 下落 1m 所用的时间内，可以完成 1,000,000,000 次元指令

### 计算机的存储空间

计算机的存储空间很大：假设 1 byte=1 ounce, 通常一个计算机有 100G 的存储空间，则等同于 300,,000,000 tons

### 计算机(现有的)计算能力足够了么？

其实并不是,在以下方面都不够好
- 搜索万维网(World Wild Web)
- 下国际象棋
- 算法设计

### 计算机的限制

- 虽然计算机已经足够快了，但仍有限制
    - 有些过于复杂的问题难于计算
        - 天气预测
        - 破解现代密码
    - 另有一些基本的问题无法计算
        - 停机问题

## Section3 Types of Knowledge
### 解决计算问题
- 什么是计算
    - 什么是知识
    - 陈述性知识 (Declarative knowledge)
        - 事实的陈述
        - y是x的平方根 --> y*y=x
    - 方法性知识 (Imperative knowledge)
        - 做事的方法、工序 (方法学)
        - 迭代求平方根
        ```
        while(g*g - x > erf):
            g = g + x/g
        return g
        ```

算法是方法学的一种

## Section4 Basic Machine Architecture
### 我们怎样才能在机械的(运算)过程中找到一个通用的方法
- 固定程序的计算机(Fixed Program Computers)
    - 计算器
    - 1941年，Atanasoff and Berry’s (1941) computer for systems of linear equations
    - 1940年，图灵'炸弹'(Alan Turing’s bombe) —— 解密德军的Enigma密码
- 使用一个储存了可变指令的计算机
    - 存储程序计算机(Stored Program Computer)

### Stored program computer
储存程序计算机的组成：
- 储存在计算机内部的一系列指令(程序)
    - 由预定义的元指令组成
        - 算法和逻辑
        - 简单的测试(条件判断)
        - 移动数据
- 能够以一定顺序执行语句的特殊程序(解释器)
    - 用测试(判断条件)去改变语句流，或者在必要的时候停下来

### 什么是元指令？
- 图灵证明了用6个元指令就能计算一切
    - 图灵完备性 (Turing complete)
- 幸运的是，现代编程语言有一系列方便的元指令
- 可以通过一些特殊的方法来构建元指令
- 在任何一中编程语言中能够计算的东西，在另一种编程语言中都同样能够计算

## Section5 Programming Language Characteristics
### 创造“方法”
每一种编程语言都提供了：
- 一系列的元操作
- 一种将元操作组合起来形成更复杂但是合法的表达式的方法
- 一种能够推导或计算表达式的值或含义的方法

### 语言的几个方面
- 基本结构 (Primitive constructs)
    - 编程语言：数字，字符串，简单操作符
    - 英语：单词
- 句法 (Syntax) —— 规定了字母和符号怎样组合才是符合文法的
    - 编程语言：在Python中 `3 + 3` 是合法的
    - 英语：“cat dog boy” 是不合法的
- 静态语义 (Static semantics) —— 判断哪些符合句法的字符串有意义
    - 英语：“I are big” 符合 ``<noun> <intransitive verb> <noun>`` 的句法形式，他是符合句法的。但是在英语中 i 应该和 am 组合，所以这句话违反了自然语言的静态语义。
    - 编程语言：``<literal> <operator> <literal>`` 是一种有效的句法，但是 `2.3/'abc'` 不符合Python的静态语义。
- 语义 (Semantics) —— 判断符合句法并且没有静态语义错误的字符串的意义
    - 英语：可能有歧义
    “I cannot praise this student too highly”
    - 编程语言：只有一种确定的意义

### 字符串可能有哪些错误？
- 语义错误
    - 常见，但很容易必被编译器发现
- 静态语义错误
    - 一些语言能在编译时发现这些错误；
    另一些会在运行时检查这些错误
    - 如果没有检查出错误，程序的行为可能无法预测
- 程序没有静态语义错误，但其意义可能不是我们想要的
    - 程序崩溃
    - 死循环
    - 程序给出意料之外的结果

### 我们的目标
- 学习一种编程语言的句法和语义
- 学习怎样用编程语言将“方法”(算法)表述成，计算机能够执行的代码
- 学会将问题分解为一步步的计算的思维模式
