---
slug: 2017-memo-list-jun
title: Memo List Jun
date: 2017-06-05 16:23:52
authors: cyhan
tags:
- Memo List
---
备忘&开坑记录

<!-- truncate -->

## Week16
[2017-06-05 16:23:29]

某群的问题：

>Haskell prelude 库中带有 `a->a` 类型签名的函数？

ref:
- [Introduction | Hackage](http://hackage.haskell.org/)
- [A Tour of the Haskell Prelude](http://teaching.csse.uwa.edu.au/units/CITS3211/lectureNotes/tourofprelude.html)

(伪)标答：

`id :: a -> a`

完整答案：
``` haskell
-- 无限定
id :: a -> a

-- class Num
abs :: Num a => a -> a
negate :: Num a => a -> a
signum :: Num a => a -> a

recip :: Fractional a => a -> a

-- class Fractional
exp, log, sqrt :: Floating a => a -> a
--- 一些三角函数
sin, cos, tan :: Floating a => a -> a
asin, acos, atan :: Floating a => a -> a
sinh, cosh, tanh :: Floating a => a -> a
asinh, acosh, atanh :: Floating a => a -> a

-- class (RealFrac a, Floating a) => RealFloat a where
significand ::　RealFloat　a => a -> a

-- class Enum
pred :: Enum a => a -> a
succ :: Enum a => a -> a

```
