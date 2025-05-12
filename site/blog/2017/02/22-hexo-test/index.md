---
slug: hexo-test-page
title: Hexo 测试页
date: 2017-02-22 17:00:31
author: cyhan
tags:
  - debug
  - hexo
---

Hexo 测试页

<!-- truncate -->

# 超长 TOC 滚动
[2017-04-24]

# Install



# --------- Day 1 ---------

# Ruby'properties

# Note：

# summary

# Todo


## 1. "Hello, world."

## 2. 找下标

### `index` 方法
### `=~` 方法

## 3. 重复打印

### `each` 方法
### 更优雅的 `*`方法


## 4. 循环

## 5.&6. 猜数字.rb

----

# --------- Day 2 ---------

# Note
## 函数

## 数组

## 散列表

## 代码块和yield

## 类


# summary


# Todo

## 1. each与枚举

## 2. 树与方法

## 3. grep

----

# --------- Day 3 ---------
# Note
## 元编程


# summary


# Todo
## CSV程序



# ---- More about Ruby ----

## Ruby 的核心优势

## 不足之处



<!-- ============================================================ -->

# 连接符test

# - 1
# -- 2
# --- 3
# ---- 4
# ----- 5
# ------ 6
# ------- 7
# -------- 8
# --------- 9


# highlight-test

``` c 
#include <stdio.h>

int main() 
{
    printf("hello, world\n");
    return 0;
}
```

``` ruby 
# Guess_Number.rb https://gist.github.com/inkydragon/247dea86ec79d9d100faf930527fc515 test.md 
# Guess num between [0..9]
num = rand(10)
puts "Let's guess number !\nHave a guess!\n" 
loop do
    tmp = gets.to_i
    puts "Too High" if num < tmp
    puts "Too Low" if num > tmp
    break if num == gets.to_i 
end
puts "Yes! rand number is #{num}"
```

-------
# date & update test

```
date: 2017-02-07 17:00:31
updated: 1017-02-07 16:43:31
```

-----

# LaTeX Supposed-test

The **characteristic polynomial** $\chi(\lambda)$ of the $3 \times 3$ matrix
```tex
$$
\left( \begin{array}{ccc}
a & b & c \\
d & e & f \\
g & h & i
\end{array} \right)
$$


is given by the formula
$$
\chi(\lambda) = \left| \begin{array}{ccc}
\lambda - a & -b & -c \\
-d & \lambda - e & -f \\
-g & -h & \lambda - i
\end{array} \right|.
$$

$$
y'=ay
$$
$$
\Updownarrow 
$$

$$
y=Ce^{at}
$$
```
