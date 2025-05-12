---
slug: programming-ruby-ver-2
title: Programming Ruby ver.2
date: 2017-04-24 18:15:37
authors: cyhan
tags:
- Books
- 编程
- Programming Ruby
- Ruby
---
七周七语言里推荐的书，随便看看，记点笔记

幕布版 [Programming Ruby —— The Pragmatic Programmer's Guide​](http://mubu.io/doc/SswLzGgZ0)

<!-- truncate -->

## ----- 2. Ruby.new ------
### Object-Oriented

Ruby是一门面向对象的语言。
你所操作的每件东西都是对象，操作结果本身也是对象。

#### 类

**类**/`class` 用来表示实体，类是 **状态**/`state` 和使用这些状态的 **方法**/`method` 的组合

#### 实例
建立了类，需要为每个类创建若干实例。
**实例/`instance` == 类的实体/`class instance` == 对象/`object`**

#### 构造函数
ruby通过调用 **构造函数**/`constructor` 来创建对象,标准的构造函数被称为 `new`.
``` ruby
song1 = Song.new("Ruby Tuesday")
song2 = Song.new("Enveloped in Python")
## and so on
```
以上的实例都是从相同的类派生出来的，他们具有各异的特征：  

- 每个对象有 **唯一的对象标识符**/`object identifier/Obj ID`
- 可定义 **实例变量**/`instance variable`  
    - 变量的值对每个实例来说是唯一的
    - 每个实例都持有对象的 **状态**/`state`

#### 实例方法
可以为每个类定义 **实例方法**/`instance method`.
每个方法都是一组功能，他们可能在类的内部or外部被调用,实例方法用来访问对象的实例变量及其状态。

#### 消息
方法用过向对象发送 **消息**/`message` 来唤起调用。
消息包含方法名称以及方法可能需要的参数。当对象接收到一条消息是，他会在自己的类中查找相应的方法：

- 找到了方法会被执行
- 没找到....

#### 接收器
``` ruby
irb(main):001:0> "gin joint".length
=> 9
irb(main):002:0> "Rick".index("c")
=> 2
irb(main):003:0> -1942.abs
=> 1942
```
以上代码中`.` 之前的东西称为 **接收者**/`receiver`，之后是被调用的方法。
在其他语言中 Ex: Java 你需要另一个函数来处理绝对值，并回传结果。而Ruby中 绝对值方法內建在number类中，只需发送一个abs消息给 number 就能得到绝对值。

所以我们说——Ruby是一门真正的面向对象的语言。

----

### Some Basic
Ruby 的语法很干净：

- 不需要语句结束的分号
- 注释由`#`开始,行尾结束
- 缩进排版不重要
- 不必声明变量

#### 方法
**方法**/`method` 由`def`关键字定义，后接方法名和括号中的参数，用end结束方法。
(实际上,定义中的括号是可选的)
``` ruby
def say_goodnight(name)
  result = "Good night, " + name
  return result
end
## time for bed...
puts say_goodnight("John-Boy")
puts say_goodnight("Marry-Ellen")

=> Good night, John-Boy
=> Good night, Marry-Ellen
```
`puts` 方法输出一行+回车

#### 字面量

**字面量/literals**，及一组单引号或双引号之间的字符序列:

- Ruby对单引号处理的较少
- 对双引号处理的较多
    - 处理转义序列 ：`\n`
    - 处理 **内插表达式**/`expression interpolation`：`#{表达式}`
    - 如果表达式是一个 全局实例or类变量，则不需要大括号

#### 内插表达式
``` ruby
def say_goodnight(name)
  result = "Good night, #{name}"
  return result
end
puts say_goodnight("Pa")

=> Good night, Pa
```

可以把任意的复杂表达式放在`#{...}`结构中。
一下代码调用了字符串的capitalize方法，把首字母转为大写
``` ruby 
def say_goodnight(name)
  result = "Good night, #{name.capitalize}"
  return result
end
puts say_goodnight("uncle")

=> Good night, Uncle
```

----

## --- 5. Stand Types -----
>Ruby 中的基本类型：
**数字**/`number`、**字符串**/`string`、**区间**/`range`和 **正则表达式**/`regular expression`

### Numbers
Ruby 支持整数和浮点数。

>整数可以是任何的长度，其最大值取决于系统的最大可用内存。

一定范围内的整数 [$-20^30$ ~ $20^30-1$ or $-20^62$ ~ $2^62-1$] 是 `Fixnum` 类的对象，而这个范围之外的整数储存在 `Bignum` 类中。

**进制的表示**

一些可选的 **前导符**：

-  `0` 表示八进制
- `0d` 表示十进制[默认]
- `0x` 表示十六进制
- `0b` 表示二进制 

**一些字符的整数值**

- 控制字符 `?\C-x`  
    即 `Ctrl+x`
- 元字符   `?\M-x`  
    即 `Alt+x`
- 元字符和控制字符的组合 `?\M-\C-x`  
    即 `Ctrl+Alt+x`
- 反斜杠   `?\\`

**小数与幂**

>带小数点的数字和幂的字面量被转换为浮点对象。
Ex: 1.0e3 
    `not ~~1.e3~~` `<-` Ruby会调用 `Fixnum` 类的 `e3`方法

所有数字都是对象，并且可以相应各种消息。

**整数的迭代器**

``` ruby
3.times {print "x "}                #=>x x x => 3
1.upto(5) {|i| print i, " "}        #=>1 2 3 4 5 => 1
99.downto(95) {|i| print i, " "}    #=>99 98 97 96 95 => 99
50.step(80, 5){|i| print i, " "}    #=>50 55 60 65 70 75 80 => 50
```

>包含数字的字符串不能隐式转换为数字。

Ex: A+B Program
``` plain Input
3 4
5 6
7 8
```

直接相加不行
``` ruby
ARGF.each do |line|
  v1, v2 = line.split # split line on space
  print v1 + v2, " "
end

##=>34 56 78
```

要将字符转化为整数。可用 `str.to_i` 或 `Integer(str)` 方法
``` ruby
ARGF.each do |line|
  v1, v2 = line.split # split line on space
  print v1.to_i + v2.to_i, " "
end

##=>7 11 15
```


### String



----

## --- 15. Ruby shell -----
### Tab Completion
ref:

- [Module: IRB (Ruby 2.0.0)](http://ruby-doc.org/stdlib-2.0.0/libdoc/irb/rdoc/IRB.html)
- [marioaquino/.irbrc](https://gist.github.com/marioaquino/738897/3dfea80e81cc86fc82a386b3d0162f0c8df4c9bb)
- [加强版irb](http://cookoo.iteye.com/blog/28781)

### ri in irb

在 `~/.irbrc`中添加
``` ruby
def ri(*names)  
  system(%{ri.bat #{names.map{ |name| name.to_s}.join(" ")}})  
end  
```
可以实现在`irb`中直接调用`ri`

#### ri & rdoc
为了愉快的使用`ri`首先要生成`rdoc`
``` ruby
gem rdoc --all --ri --no-rdoc
```

然而只生成了部分文档，还得再找找方法 

[Getting Ruby documentation from command line? [duplicate]](http://stackoverflow.com/questions/15697209/getting-ruby-documentation-from-command-line)

看来需要更新/下载`rdoc`,执行`gem install rdoc-data`和`rdoc-data --install`

```
I:\Ruby>gem install rdoc-data
Fetching: rdoc-data-4.1.0.gem (100%)
rdoc-data is only required for C ruby 1.8.7 or 1.9.1.

rdoc-data is required for JRuby.

To install ri data for RDoc 4.0+ run:

  rdoc-data --install

Successfully installed rdoc-data-4.1.0
Parsing documentation for rdoc-data-4.1.0
Installing ri documentation for rdoc-data-4.1.0
Done installing documentation for rdoc-data after 0 seconds
```

测试 `ri String` 和 `ri Proc`
```
I:\Ruby>ri String
String < Object

------------------------------------------------------------------------------
Includes:
Comparable (from ruby core)

(from ruby core)


.... many lines ....


I:\Ruby>ri Proc
Proc < Object

(from ruby core)
------------------------------------------------------------------------------
Proc objects are blocks of code that have been bound to a set of local
variables. Once bound, the code may be called in different contexts and still
access those variables.
```

### gen server' bug
在检查文档状态时发现了个小bug

``` 
I:\Ruby>gem server
Server started at http://[::]:8808
Server started at http://0.0.0.0:8808
```

事实上应该是 `http://localhost:8808`

搜了一下是已存在的bug
[`gem server` seems to not REALLY be doing what it says the defaults are](https://github.com/rubygems/rubygems/issues/1303)
