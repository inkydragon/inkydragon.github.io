---
title: 解 Codewars' Python Kata 有感
date: 2017-03-25 20:18:23
categories:
  - Programming
  - Python
tags:
  - Python
---
看到 [Codewars](www.codewars.com/r/S2zJGQ) oj类似物，不过可以看到详细的报错，并在AC一次后看到别人的答案

开坑记录一下有趣的题, 顺便采用新结构 [堆栈类似物]

<!--more-->
[我的解题集](https://www.codewars.com/users/0u0/completed_solutions)

### 1ku
### 2ku
### 3ku
### 4ku
### 5ku
### 6ku
[Take a Number And Sum Its Digits Raised To The Consecutive Powers And ....¡Eureka!!](https://www.codewars.com/kata/5626b561280a42ecc50000d1)

GET：
- 知道了`enumerate` <- 不记得枚举，最后写了个循环

My Solution - Reduce ver
``` python
def sum_dig_pow(a, b): 
    return filter(
        lambda g:
            reduce(
                lambda y,x: y+int(str(g)[x])**(x+1), range(0, len(str(g))), 0
            ) == g
        , range(a, b+1))
```

enumerate ver
``` python
def sum_dig_pow(a, b): 
    return filter(
        lambda g:
            sum(
                int(d) ** (i+1) 
                for i, d in enumerate(str(a))
            ) == a
        , range(a, b+1))
```


### 7ku
[Ones and Zeros](https://www.codewars.com/kata/578553c3a1b8d5c40300037c)

GET:
- `join`的玩法

Reduce ver
``` python
from functools import reduce
def binary_array_to_number(arr):
    return int(reduce(lambda y,x:y+str(x), arr, ''), 2)
```

join ver
``` python
def binary_array_to_number(arr):
    return int("".join(map(str, arr)), 2)
```


[Regex validate PIN code](https://www.codewars.com/kata/55f8a9c06c018a0d6e000132)

GET:
- 正则表达式姿势
`^[0-9]{4}$`+`^[0-9]{6}$`==`^(\d{4}|\d{6})$`

[Get the Middle Character](https://www.codewars.com/kata/56747fd5cb988479af000028)

GET:
- 复习了Python 的整除

[Sum of two lowest positive integers](https://www.codewars.com/kata/558fc85d8fd1938afb000014)

GET：
- sort&sorted 的用法

>a = [5,2,1,9,6]        
> 
>\>>> sorted(a)                  #将a从小到大排序,不影响a本身结构     
>[1, 2, 5, 6, 9] 
> 
>\>>> sorted(a,reverse = True)   #将a从大到小排序,不影响a本身结构     
>[9, 6, 5, 2, 1] 
> 
>\>>> a.sort()                   #将a从小到大排序,影响a本身结构  
>\>>> a     
>[1, 2, 5, 6, 9] 
> 
>\>>> a.sort(reverse = True)     #将a从大到小排序,影响a本身结构      
>\>>> a     
>[9, 6, 5, 2, 1] 


### 8ku
[Basic Mathematical Operations](https://www.codewars.com/kata/57356c55867b9b7a60000bd7)

Get:
- `switch-case`替代方案

``` python
def basic_op(operator, value1, value2):
    ops = {'+': lambda a, b: a + b, 
           '-': lambda a, b: a - b,
           '*': lambda a, b: a * b,
           '/': lambda a, b: a / b}
    return ops[operator](value1, value2)
```

[Grasshopper - Summation](https://www.codewars.com/kata/55d24f55d7dd296eb9000030)

GET:
- `reduce&lambda表达式` 初体验

[Remove First and Last Character](https://www.codewars.com/kata/56bc28ad5bdaeb48760009b0)

GET:
- 切片技巧

