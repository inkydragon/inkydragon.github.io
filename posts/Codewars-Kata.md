---
title: Codewars' Kata
date: 2017-03-25 20:18:23
categories:
  - Programming
tags:
  - Python
  - Ruby
---
看到 [Codewars](www.codewars.com/r/S2zJGQ) oj类似物，不过可以看到详细的报错，并在AC一次后看到别人的答案

开坑记录一下有趣的题, 顺便采用新结构 [堆栈类似物]

<!-- truncate -->
[我的解题集](https://www.codewars.com/users/0u0/completed_solutions)

### 1ku
### 2ku
### 3ku
### 4ku
[Roman Numerals Decoder](https://www.codewars.com/kata/roman-numerals-decoder)

根据以前找的js，改写一下带验证的函数
``` ruby
def Roman_Num_Decoder(s)
  validator = /^M*(?:D?C{0,3}|C[MD])(?:L?X{0,3}|X[CL])(?:V?I{0,3}|I[XV])$/
  token = /[MDLV]|C[MD]?|X[CL]?|I[XV]?/
	key = { M:1000,
          CM:900, D:500, CD:400, C:100,
          XC:90,  L:50,  XL:40,  X:10,
          IX:9,   V:5,   IV:4,   I:1}

  
  s.upcase.split(' ').map do |rnum|
    if validator.match(rnum)
      rnum.scan(token).
      reduce(0) {|sum, rn| sum+=key[rn.to_sym]}
    else
      puts "Not valid Roman Numbers!\n"
      return nil
    end
  end
end

s = 'CI XCVII CXV CXXI XCIX CXVI CII CXXIII CXVI CIV CV CXV XCV CV CXV XCV CX CXI CXVI XCV CXVI CIV CI XCV CII CVIII XCVII CIII CXXV XXXII CV XXXII CVII CX CXI CXIX XXXII CXVI CIV CV CXV XXXII CII CVIII XCVII CIII XXXII CV CXV XXXII CXIX CI CV CXIV C XXXII CV XXXII CVI CXVII CXV CXVI XXXII XCIX XCVII CX XXXIX CXVI XXXII CXII CXVII CXVI XXXII CIX CXXI XXXII CII CV CX CIII CI CXIV XXXII CXI CX XXXII CXIX CIV CXXI'
p Roman_Num_Decoder(s)
```

题目要求的无检验
``` ruby
def Roman_Num_Decoder(s)
  token = /[MDLV]|C[MD]?|X[CL]?|I[XV]?/
	key = { M:1000,
          CM:900, D:500, CD:400, C:100,
          XC:90,  L:50,  XL:40,  X:10,
          IX:9,   V:5,   IV:4,   I:1}
  
  s.
    upcase.
    scan(token).
    reduce(0) {|sum, rn| sum+=key[rn.to_sym]}
end

s = 'CI XCVII CXV CXXI XCIX CXVI CII CXXIII CXVI CIV CV CXV XCV CV CXV XCV CX CXI CXVI XCV CXVI CIV CI XCV CII CVIII XCVII CIII CXXV XXXII CV XXXII CVII CX CXI CXIX XXXII CXVI CIV CV CXV XXXII CII CVIII XCVII CIII XXXII CV CXV XXXII CXIX CI CV CXIV C XXXII CV XXXII CVI CXVII CXV CXVI XXXII XCIX XCVII CX XXXIX CXVI XXXII CXII CXVII CXVI XXXII CIX CXXI XXXII CII CV CX CIII CI CXIV XXXII CXI CX XXXII CXIX CIV CXXI'

s.split(' ').each do |rn|
  print Roman_Num_Decoder(rn), ', '
end
print "\n"
```




### 5ku

["Simple Fun #299: Look And Say And Sum" Translation](https://www.codewars.com/kata/simple-fun-number-299-look-and-say-and-sum)

**Solution**

``` haskell
module Haskell.Codewars.LookAndSayAndSum where
import Data.List (group)
import Data.Char (digitToInt)

lookAndSay' :: Integer -> Integer
lookAndSay' n = read (concatMap count (group (show n)))
  where 
    count run = show (length run) ++ take 1 run

toDigits = map (fromIntegral . digitToInt) . show

lookAndSaySum :: Int -> Int
lookAndSaySum n = foldr (+) 0 (toDigits (iterate lookAndSay' 1 !! (n - 1)) )
```


**Test Case**

``` haskell
import Test.Hspec
import Haskell.Codewars.LookAndSayAndSum (lookAndSaySum)
import System.Random

sol :: Int -> Int
sol n = [0,1,2,3,5,8,10,13,16,23,32,44,56,76,102,132,174,227,296,383,505,679,892,1151,1516,1988,2602,3400,4410,5759,7519,9809,12810,16710,21758,28356,36955,48189,62805,81803,106647,139088,181301,236453,308150,401689,523719,682571,889807,1159977,1511915,1970964,2569494,3349648,4366359,5691884] !! n

randint :: IO Int
randint = randomRIO (1,55)

main :: IO ()
main = hspec $ do
  describe "Unit tests" $ do
    it "Basic tests" $ do
      lookAndSaySum 1 `shouldBe` 1
      lookAndSaySum 2 `shouldBe` 2
      lookAndSaySum 3 `shouldBe` 3
      lookAndSaySum 4 `shouldBe` 5
      lookAndSaySum 5 `shouldBe` 8
    it "Radnom tests" $ do
      rint <- sequence (replicate 5 randint) 
      map lookAndSaySum rint `shouldBe` map sol rint
```



[First Variation on Caesar Cipher](https://www.codewars.com/kata/first-variation-on-caesar-cipher)

5ku的题果然不是那么简单的
先写一个凯撒函数
``` ruby
def movingShift(s, shift)
  s.gsub!(/[A-Z]/) do |c| 
    tmp = c.ord.+(shift%27).%('Z'.ord+1)
    tmp += 'A'.ord unless tmp >= c.ord
    tmp.chr
  end
  s.gsub!(/[a-z]/) do |c| 
    tmp = c.ord.+(shift%27).%('z'.ord+1)
    tmp += 'a'.ord unless tmp >= c.ord
    tmp.chr
  end
end

def demovingShift(arr, shift)
  movingShift(arr.join, 26-shift)
end


p u = "I should have known that you would have a perfect answer for me!!!"
p v = movingShift(u, 1)
p demovingShift(v, 1)
```

**Simplify**
``` Ruby 
def movingShift(s, shift)
  t = s.chars.join    # deep clone 保证输入字符串s不变
  t.gsub!(/\w/) do |c| 
    isUC = c.ord < 91
    tmp = c.ord.+(shift%26).%((isUC ? 'Z' : 'z').ord+1)
    tmp += (isUC ? 'A' : 'a').ord unless tmp >= c.ord
    tmp.chr
  end
end
```

按题意修改程序，并格式化输出
``` ruby
def movingShift(s, shift)
  s.chars.map.with_index do |c, i|
    if c =~ /\w/
      isUC = c.ord < 91
      tmp = c.ord.+((i+shift)%26).%((isUC ? 'Z' : 'z').ord+1)
      tmp += (isUC ? 'A' : 'a').ord unless tmp >= c.ord
      tmp.chr
    else
      c
    end
  end.each_slice(s.length/5+1).to_a.map{|a| a.join}
end

def demovingShift(arr, shift)
  arr.join.chars.map.with_index do |c, i|
    if c =~ /\w/
      movingShift(c, 26-shift-i)
    else
      c
    end
  end.join
end
```

解决数字干扰问题，并添加奇怪的输出格式支持
``` ruby
def movingShift(s, shift)
  len = s.length
  @obj = nil
  s.chars.map.with_index do |c, i|
    if c =~ /[a-z]/i
      isUC = c.ord < 91
      tmp = c.ord.+((i+shift)%26).%((isUC ? 'Z' : 'z').ord+1)
      tmp += (isUC ? 'A' : 'a').ord unless tmp >= c.ord
      tmp.chr
    else
      c
    end
  end.
  each_slice(len%5 == 0 ? len/5: len/5+1).
  to_a.map{|a| a.join}.
  tap{|obj| @obj = obj}.            # 从链式调用中 ‘抽样’
  +(@obj.length == 5 ? [] : [''])   # 保证返回的数组有5个元素
end

def demovingShift(arr, shift)
  arr.join.chars.map.with_index do |c, i|
    if c =~ /[a-z]/i
      movingShift(c, 26-shift-i)
    else
      c
    end
  end.join
end
```


### 6ku

[Dubstep](https://www.codewars.com/kata/dubstep/ruby)

``` ruby
def song_decoder(song)
  song.gsub(/(WUB)+/, ' ').strip
end
```

GET 新函数`strip`,去除字符串前后空白字符.
```
strip → new_str click to toggle source
Returns a copy of str with leading and trailing whitespace removed.
```



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

a.map{|arr| arr.map{|a| avg = a.reduce(:+)./3; [avg, avg, avg] }}

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

