---
title: 'Memo List @Week15'
date: 2017-05-29 11:11:46
categories:
tags:
  - Memo List
description:
  备忘&开坑记录
---


<!--more-->
[2017-06-02 22:20:48]

# Haskell 可选参数(optional arguments)

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


## Tips
- [Maybe a -> a](https://www.haskell.org/hoogle/?hoogle=Maybe+Int+-%3E+Int)


[2017-05-29 11:12:58]

- [Useful Haskell functions](http://www.cse.unsw.edu.au/~en1000/haskell/inbuilt.html)
