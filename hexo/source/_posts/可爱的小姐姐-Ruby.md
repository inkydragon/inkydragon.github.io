---
title: 可爱的小姐姐~ Ruby!
date: 2017-04-22 16:30:54
categories:
  - Books
  - 编程
  - 编程七周谈
tags:
  - Ruby
---
{% asset_img ruby.jpg Just For Fun ! —— Ruby %}

<!--more-->
> 有糖相伴好下药。 ——Mary Poppins

# Install
[下载 Ruby](https://www.ruby-lang.org/zh_cn/downloads/)

每个流行的平台都有多种工具可用于安装 Ruby：

- Linux/UNIX 平台，可以使用第三方工具（如 rbenv 或 RVM）或使用系统中的包管理系统。
- OS X 平台，可以使用第三方工具（如 rbenv 或 RVM）。
- Windows 平台，可以使用 [RubyInstaller](https://rubyinstaller.org/downloads/)。

# Ruby' properties
- Ruby is object oriented
- Ruby is duck typed
- Ruby is productive

Note：

- 除了nil和false之外，其他值都代表true。C和C++程序员可得小心了，**0也是true！**
- obj is first-class object
- and && or || [短路求值]
    - 整个表达式全部求值 & |

# night 1
- Ruby是一门解释型语言。一切皆为对象，且易于获取对象的任何信息，如对象的各方法及所属类。
- 它是鸭子类型的，且行为通常和强类型语言毫无二致，尽管一些学者会争论其中差别。
- 它也是崇尚自由精神的语言，允许你做几乎一切事情，包括修改NilClass或String这样的核心类。

# Todo
Find：

- Ruby API文档。  
    |-[Help and documentation for the Ruby programming language.](http://ruby-doc.org/)  
    |-[documentation](https://www.ruby-lang.org/zh_cn/documentation/)
- Programming Ruby ：The Pragmatic Programmer’s Guide   
    |-[Programming Ruby](http://ruby-doc.com/docs/ProgrammingRuby/)
- 替换字符串某一部分的方法。  
    |-[String-sub](https://ruby-doc.org/core-1.9.3/String.html#method-i-sub)
- 有关Ruby正则表达式的资料。  
    |-[Regexp](https://ruby-doc.org/core-1.9.3/Regexp.html)
- 有关Ruby区间（range）的资料。  
    |-[Range](https://ruby-doc.org/core-1.9.3/Range.html)
    
Do:

1. 打印字符串"Hello, world."。  
2. 在字符串"Hello, Ruby."中，找出"Ruby."所在下标。
3. 打印你的名字十遍。
4. 打印字符串"This is sentence number 1."，其中的数字1会一直变化到10。
5. 从文件运行Ruby程序。
6. 加分题：如果你感觉意犹未尽，还可以写一个选随机数的程序。该程序让玩家猜随机数是多少，并告诉玩家是猜大了还是猜小了。
（提示：rand(10)可产生0～9的随机数，gets可读取键盘输入的字符串，你要把输入字符串转换成整数。）


## 1. 打印"Hello, world."
``` lang:ruby   Hello, world.
irb(main):001:0> puts("Hello,  world.")
Hello,  world.
=> nil
```

直接输入字符串，看上去 `Ruby` 输出了字符串，其实那是返回值。
~~你大概写了一个假的 `Hello, world`~~
``` lang:ruby 
irb(main):002:0> "Hello World"
=> "Hello World"
```


## 2. 找下标

### `index` 方法
>index(substring [, offset]) → fixnum or nil 
 index(regexp [, offset]) → fixnum or nil
 
``` lang:ruby
irb(main):048:0> str = "Hello, Ruby."
=> "Hello, Ruby."
irb(main):049:0> str.index("Ruby.")
=> 7
```

### `=~` 方法
正则表达式匹配：
>str =~ obj → fixnum or nil

``` lang:ruby
irb(main):052:0> str =~ /[Ruby.]/
=> 7
```

## 3. 打印十遍名字

### `each` 方法

``` lang:ruby
irb(main):003:0> def h
irb(main):004:1> puts "Hello, wo!"
irb(main):005:1> end
=> :h
...
irb(main):013:0> (1..10).each do h end
Hello, wo!
Hello, wo!
Hello, wo!
Hello, wo!
Hello, wo!
Hello, wo!
Hello, wo!
Hello, wo!
Hello, wo!
Hello, wo!
=> 1..10
```

循环也可以换行
``` lang:ruby
irb(main):021:0> (1..10).each do |i|
irb(main):022:1*   h()
irb(main):023:1> end
```

### 更优雅的写法 `*`方法

``` lang:ruby
irb(main):026:0> "Hello, wo!" * 10
=> "Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!"
irb(main):028:0> puts "Hello, wo!\n" * 10
Hello, wo!
Hello, wo!
...
```


## 4. 循环

``` lang:ruby
irb(main):030:0> (1..10).each do |i|
irb(main):031:1*   puts "This is sentence number #{i}."
irb(main):032:1> end
This is sentence number 1.
This is sentence number 2.
This is sentence number 3.
This is sentence number 4.
This is sentence number 5.
This is sentence number 6.
This is sentence number 7.
This is sentence number 8.
This is sentence number 9.
This is sentence number 10.
=> 1..10
```

## 5.&6. 猜数字.rb
``` lang:ruby Guess Number.rb
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
``` lang:ruby result
I:\Desktop\Programming\Ruby>ruby "Guess Number.rb"
Let's guess number !
Have a guess!
5
Too High
4
Yes! rand number is 4

I:\Desktop\Programming\Ruby>ruby "Guess Number.rb"
Let's guess number !
Have a guess!
5
Too Low
9
Yes! rand number is 9
```

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
