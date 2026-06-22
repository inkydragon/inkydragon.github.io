---
slug: slsw-scala
title: 七周七语言：Scala
date: 2017-12-25 19:06:50
authors: cyhan
tags:
- 七周七语言
---

Scala

<!-- truncate -->

## Day 0

*`Scala` 与 `java` 的不同之处*

- 类型推断
- 函数式编程理念
- 不(可)变量
- 高级程序构造

## Day 1

### 类型
``` java
scala> println("Hello, surreal world")
Hello, surreal world

scala> println('Hello, world')
<console>:1: error: unclosed character literal
       println('Hello, world')
                            ^

scala> println('!')
!

scala> 1 + 1
res2: Int = 2

scala> (1) .+ (1)
res3: Int = 2

scala> 5 + 4 * 3
res4: Int = 17

scala> 5 .+ (4 .* (3))
res5: Int = 17

scala> (5) .+ ((4) .* (3))
res6: Int = 17

scala> "abc".size
res7: Int = 3

scala> "abc" + 4
res8: String = abc4

scala> 4 + "abc"
res9: String = 4abc

scala> 4 + "1.0"
res10: String = 41.0

scala> 4 * "abc"
<console>:12: error: overloaded method value * with alternatives:
  (x: Double)Double <and>
  (x: Float)Float <and>
  (x: Long)Long <and>
  (x: Int)Int <and>
  (x: Char)Int <and>
  (x: Short)Int <and>
  (x: Byte)Int
 cannot be applied to (String)
       4 * "abc"
         ^
```

#### 表达式与条件

``` java
scala> 5 < 6
res0: Boolean = true

scala> 5 <= 6
res1: Boolean = true

scala> 5 >= 2
res2: Boolean = true

scala> 5 == 2
res3: Boolean = false

scala> 5 != 2
res4: Boolean = true
```

*自动类型推断*
``` java
scala> val a = 1
a: Int = 1

scala> val b = 2
b: Int = 2

scala> if (b < a) {
     | println("true")
     | } else {
     | println("false")
     | }
false
```

Note:
- Scala 可以自动推断类型
- `var` 变量
- `val` 声明不变量

*`0``nil`与`false`*
``` java

scala> Nil
res6: scala.collection.immutable.Nil.type = List()

scala> if (false) {println("true")}

scala> if (0) {println("true")}
<console>:12: error: type mismatch;
 found   : Int(0)
 required: Boolean
       if (0) {println("true")}
           ^

scala> if (Nil) {println("true")}
<console>:12: error: type mismatch;
 found   : scala.collection.immutable.Nil.type
 required: Boolean
       if (Nil) {println("true")}
           ^

scala> if ('') {println("true")}
<console>:1: error: empty character literal
       if ('') {println("true")}
           ^

scala> if ("") {println("true")}
<console>:12: error: type mismatch;
 found   : String("")
 required: Boolean
       if ("") {println("true")}
           ^

scala> if (true) {println("true")}
true

scala> if (1) {println("true")}
<console>:12: error: type mismatch;
 found   : Int(1)
 required: Boolean
       if (1) {println("true")}
           ^
```

#### 循环

#### Range 与 元组

**Range**
``` java
scala> val rang = 0 until 10
rang: scala.collection.immutable.Range = Range 0 until 10

scala> val range = 0 until 10
range: scala.collection.immutable.Range = Range 0 until 10

scala> range.start
res1: Int = 0

scala> range.end
res2: Int = 10

scala> range.step
res3: Int = 1

scala> (0 to 10) by 5
res4: scala.collection.immutable.Range = Range 0 to 10 by 5

scala> (0 to 10) by 6
res5: scala.collection.immutable.Range = inexact Range 0 to 10 by 6

scala> (0 until 10 by 5)
res6: scala.collection.immutable.Range = Range 0 until 10 by 5

scala> val range = (10 until 0) by -1
range: scala.collection.immutable.Range = Range 10 until 0 by -1

scala> val range = (10 until 0)
range: scala.collection.immutable.Range = empty Range 10 until 0

scala> val range = (0 to 10)
range: scala.collection.immutable.Range.Inclusive = Range 0 to 10

scala> val range = 'a' to 'e'
range: scala.collection.immutable.NumericRange.Inclusive[Char] = NumericRange a to e
```

**元组**
``` java
scala> val person = ("Elvis", "Presley")
person: (String, String) = (Elvis,Presley)

scala> person._1
res7: String = Elvis

scala> person._2
res8: String = Presley

scala> person._3
<console>:13: error: value _3 is not a member of (String, String)
       person._3
              ^
```

``` java

scala> val (x, y) = (1, 2)
x: Int = 1
y: Int = 2

scala> val (x, y) = (1, 2, 3)
<console>:13: error: constructor cannot be instantiated to expected type;
 found   : (T1, T2)
 required: (Int, Int, Int)
       val (x, y) = (1, 2, 3)
           ^

scala> val (x, y, z) = (1, 2, 3)
x: Int = 1
y: Int = 2
z: Int = 3

scala> val (x, y, z) = (1, 2)
<console>:14: error: constructor cannot be instantiated to expected type;
 found   : (T1, T2, T3)
 required: (Int, Int)
       val (x, y, z) = (1, 2)
           ^
```

#### 类

定义类
`class Person(firstName: String, lastName: String)`

``` java
scala> class Person(firstName: String, lastName: String)
defined class Person

scala> val gump = new Person("Forrest", "Gump")
gump: Person = Person@5e9257b3
```

#### 扩展类


## Day 2

``` java
scala> def double(x:Int):Int = x * 2
double: (x: Int)Int

scala> double(4)
res0: Int = 8

scala> def double(x:Int):Int = {
     |   x * 2
     | }
double: (x: Int)Int

scala> double(2)
res1: Int = 4
```


### var and val

``` java
scala> var mutable = "I am mutable"
mutable: String = I am mutable

scala> mutable = "Touch me, change me..."
mutable: String = Touch me, change me...

scala> val immutable = "I am not mutable"
immutable: String = I am not mutable

scala> immutable = "Can't tounch this"
<console>:12: error: reassignment to val
       immutable = "Can't tounch this"
                 ^
```

- `var` 可变
- `val` 不可变
- 可变状态限制并发

### 集合

**List - 列表**

``` java
scala> List(1,2,3)
res2: List[Int] = List(1, 2, 3)

scala> List("one", "two", "three")
res3: List[String] = List(one, two, three)

scala> List(1, 2, "three")
res4: List[Any] = List(1, 2, three)

scala> List(1, 2, "three")(2)
res5: Any = three

scala> List(1, 2, "three")(3)
java.lang.IndexOutOfBoundsException: 3
  at scala.collection.LinearSeqOptimized.apply(LinearSeqOptimized.scala:63)
  at scala.collection.LinearSeqOptimized.apply$(LinearSeqOptimized.scala:61)
  at scala.collection.immutable.List.apply(List.scala:86)
  ... 28 elided

scala> List(1, 2, "three")(-1)
java.lang.IndexOutOfBoundsException: -1
  at scala.collection.LinearSeqOptimized.apply(LinearSeqOptimized.scala:63)
  at scala.collection.LinearSeqOptimized.apply$(LinearSeqOptimized.scala:61)
  at scala.collection.immutable.List.apply(List.scala:86)
  ... 28 elided

scala> Nil
res8: scala.collection.immutable.Nil.type = List()

scala> List()
res9: List[Nothing] = List()
```

**set - 集合**

``` java
scala> val animals = Set("lions", "tigers", "bears")
animals: scala.collection.immutable.Set[String] = Set(lions, tigers, bears)

scala> animals + "armadillos"
res10: scala.collection.immutable.Set[String] = Set(lions, tigers, bears, armadillos)

scala> animals - "tigers"
res11: scala.collection.immutable.Set[String] = Set(lions, bears)

scala> animals + Set("raccoons")
<console>:13: error: type mismatch;
 found   : scala.collection.immutable.Set[String]
 required: String
       animals + Set("raccoons")
                    ^

scala> animals ++ Set("raccoons")
res13: scala.collection.immutable.Set[String] = Set(lions, tigers, bears, raccoons)

scala> animals -- Set("lions", "bears")
res14: scala.collection.immutable.Set[String] = Set(tigers)

scala> animals & Set("lions", "bears")
res15: scala.collection.immutable.Set[String] = Set(lions, bears)

scala> Set(1,2,3) == Set(3,2,1)
res16: Boolean = true

scala> List(1,2,3) == List(3,2,1)
res17: Boolean = false
```

**map - 映射**

``` java
scala> import scala.collection.mutable.HashMap
import scala.collection.mutable.HashMap

scala> val map = new HashMap[Int, String]
map: scala.collection.mutable.HashMap[Int,String] = Map()

scala> map += 4 -> "four"
res19: map.type = Map(4 -> four)

scala> map += 8 -> "eight"
res20: map.type = Map(8 -> eight, 4 -> four)

scala> map
res21: scala.collection.mutable.HashMap[Int,String] = Map(8 -> eight, 4 -> four)

scala> map += "zero" -> 0
<console>:14: error: type mismatch;
 found   : (String, Int)
 required: (Int, String)
       map += "zero" -> 0
```

### `Any` and `Nothing`
