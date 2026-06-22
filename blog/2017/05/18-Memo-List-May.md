---
slug: 2017-may-memo-list
title: Memo List May
date: 2017-05-18 19:08:45
authors: cyhan
tags:
- memo
---
少量尚不能单独成篇的笔记

<!-- truncate -->

## Week13
[2017-05-18 19:15:40]
```
## R-lang `data frame with 0 columns and 0 rows error`
```

-----

## Week14
[2017-05-27 12:38:29]
- [How do i convert String into list of integers in Haskell](https://stackoverflow.com/questions/8879391/how-do-i-convert-string-into-list-of-integers-in-haskell)

将字符串型数字转成[int]

**Integer -> [Int]**
``` haskell
toDigits :: Integer -> [Int]
toDigits = map (fromIntegral . digitToInt) . show
```

- [(译) Haskell 中随机数的使用](http://www.tuicool.com/articles/qayuuez)
- [How to generate random array in Haskell?](https://stackoverflow.com/questions/22423180/how-to-generate-random-array-in-haskell)

获取随机数/随机数的list
``` haskell
randint :: IO Int
randint = randomRIO (1,55) -- 生成int的范围

-- 获得一个长为 10 的list
rint <- sequence (replicate 10 randint)


randomList :: IO [Int] -- 返回一个 generater
randomList = getStdGen >>= return . randomRs (1,55)
```


### Ruby Random String
- [How to generate a random string in Ruby](https://stackoverflow.com/questions/88311/how-to-generate-a-random-string-in-ruby)
- [Generate Unique Random String With Letters And Numbers In Lower Case](https://stackoverflow.com/questions/5966910/generate-unique-random-string-with-letters-and-numbers-in-lower-case)
- [How do I populate an array with random numbers?](https://stackoverflow.com/questions/24944083/how-do-i-populate-an-array-with-random-numbers)
- [How do I pick randomly from an array?](https://stackoverflow.com/questions/3482149/how-do-i-pick-randomly-from-an-array)


以下的`shuffle`均可改成`shuffle(random: Random.new)`以提高随机性

生成`len`长度的大小写字母
``` ruby
([*('a'..'z'),*('A'..'Z')]*len).shuffle[0,len].join
```

生成`len`长度的小写字母+数字
``` ruby
(36**(len-1) + rand(36**len - 36**(len-1))).to_s(36)
```

生成`len ± 1`长度的小写字母+数字
``` ruby
rand(36**len).to_s(36)
```


生成 随机长度 随机内容的 `[[_RandomString], [_RandomString], ...]`
``` ruby

def gen_test_case # for "Sort array by string length" Ruby Translation —— codewars
  #prng = Random.new  # 使用新得随机数生成器
  arr = [*(1..10)].
    shuffle[0, rand(1..100)]. # arr.length
    sort.
    #map{|len| ([*('a'..'z'),*('A'..'Z')]*len).shuffle[0,len].join}
    map{|len| (36**(len-1) + rand(36**len - 36**(len-1))).to_s(36)}
  [arr.shuffle(random: Random.new), arr]
  # arr 为按长度排序的 数组
end
```


[2017-05-23 12:03:29]

- [[转]MIT牛人解说数学体系](http://sparkandshine.net/mit-mathematical-formalism/)



[2017-05-22 19:25:21]
### [Real World Haskell 中文版](http://cnhaskell.com/chp/1.html)

**修改提示符**

Note: 提示符并不需要引号包起来。[ghci ver 8.0.1]
``` haskell
Prelude> :set prompt "ghci>"
"ghci>" :set prompt ghci>
ghci>
```

#### 基本算术运算
```
ghci>2+2
4
ghci>2/2
1.0
ghci>7.0/2
3.5
ghci>331*2
662
ghci>123*0.5
61.5
ghci>123*1.0
123.0
```

**前缀表达式**
```
ghci>(+) 2 2
4
ghci>(/) 10 5
2.0
```

**幂**
```
ghci>2^3
8
ghci>2**3
8.0
```


**负数**

负数需要用括号括起来。单独出现时除外，此时`-`为一元运算符。
```
ghci>-1
-1
ghci>2* -1

<interactive>:18:1: error:
    Precedence parsing error
        cannot mix ‘*’ [infixl 7] and prefix `-' [infixl 6] in the same infix expression
ghci>2* (-1)
-2
```


------


## Week15

[2017-06-02 22:20:48]

### Haskell 可选参数(optional arguments)

1. [Is there a better way to have optional arguments in Haskell?](https://stackoverflow.com/questions/7781096/is-there-a-better-way-to-have-optional-arguments-in-haskell)
2. [optional arguments in haskell](https://stackoverflow.com/questions/2790860/optional-arguments-in-haskell)


1 中的第一个答案可以用，后面的跑不起来

``` haskell
{-# LANGUAGE FlexibleContexts #-}

multiProduct req1 opt1 opt2 opt3 = req1 * opt1' * opt2' * opt3'
  where opt1' = fromJust (fromMaybe 10 opt1)
        opt2' = fromJust (fromMaybe 20 opt2)
        opt3' = fromJust (fromMaybe 30 opt3)

multiProduct' req1 opt1 opt2 opt3 = req1 * opt1' * opt2' * opt3'
  where opt1' = if isJust opt1 then (fromJust opt1) else 10
        opt2' = if isJust opt2 then (fromJust opt2) else 20
        opt3' = if isJust opt3 then (fromJust opt3) else 30
```

**Error**
``` haskell
ghci> multiProduct 1

<interactive>:215:1: error:
    ? Non type-variable argument in the constraint: Num (Maybe a)
      (Use FlexibleContexts to permit this)
    ? When checking the inferred type
        it :: forall a.
              (Num (Maybe a), Num a) =>
              Maybe (Maybe a) -> Maybe (Maybe a) -> Maybe (Maybe a) -> a
ghci> multiProduct' 1

<interactive>:216:1: error:
    ? No instance for (Show (Maybe a0 -> Maybe a0 -> Maybe a0 -> a0))
        arising from a use of ‘print’
        (maybe you haven't applied a function to enough arguments?)
    ? In a stmt of an interactive GHCi command: print it
```


### Tips
- [Maybe a -> a](https://www.haskell.org/hoogle/?hoogle=Maybe+Int+-%3E+Int)


[2017-05-29 11:12:58]

- [Useful Haskell functions](http://www.cse.unsw.edu.au/~en1000/haskell/inbuilt.html)
