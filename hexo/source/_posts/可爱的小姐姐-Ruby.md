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
Seven Languages in Seven Weeks: Ruby, Day 1-3 FULL

{% asset_img ruby.jpg Just For Fun ! —— Ruby %}

<!--more-->
> 有糖相伴好下药。 ——Mary Poppins

# Install

[下载 Ruby](https://www.ruby-lang.org/zh_cn/downloads/)

每个流行的平台都有多种工具可用于安装 Ruby：

- Linux/UNIX 平台，可以使用第三方工具（如 rbenv 或 RVM）或使用系统中的包管理系统。
- OS X 平台，可以使用第三方工具（如 rbenv 或 RVM）。
- Windows 平台，可以使用 [RubyInstaller](https://rubyinstaller.org/downloads/)。

# --------- Day 1 ---------

# Ruby'properties
- Ruby is object oriented
- Ruby is duck typed
- Ruby is productive


# Note：

- 除了nil和false之外，其他值都代表true。C和C++程序员可得小心了，**0也是true！**
- obj is first-class object
- and && or || [短路求值]
    - 整个表达式全部求值 & |


# summary
- Ruby是一门解释型语言。一切皆为对象，且易于获取对象的任何信息，如对象的各方法及所属类。
- 它是鸭子类型的，且行为通常和强类型语言毫无二致，尽管一些学者会争论其中差别。
- 它也是崇尚自由精神的语言，允许你做几乎一切事情，包括修改NilClass或String这样的核心类。


# Todo
**Find**：

- Ruby API文档。  
    |- [Help and documentation for the Ruby programming language.](http://ruby-doc.org/)  
    |- [documentation](https://www.ruby-lang.org/zh_cn/documentation/)
- Programming Ruby ：The Pragmatic Programmer’s Guide   
    |- [Programming Ruby](http://ruby-doc.com/docs/ProgrammingRuby/)
- 替换字符串某一部分的方法。  
    |- [String-sub](https://ruby-doc.org/core-1.9.3/String.html#method-i-sub)
- 有关Ruby正则表达式的资料。  
    |- [Regexp](https://ruby-doc.org/core-1.9.3/Regexp.html)
- 有关Ruby区间（range）的资料。  
    |- [Range](https://ruby-doc.org/core-1.9.3/Range.html)
    
**Do**:

1. 打印字符串"Hello, world."。  
2. 在字符串"Hello, Ruby."中，找出"Ruby."所在下标。
3. 打印你的名字十遍。
4. 打印字符串"This is sentence number 1."，其中的数字1会一直变化到10。
5. 从文件运行Ruby程序。
6. 加分题：如果你感觉意犹未尽，还可以写一个选随机数的程序。该程序让玩家猜随机数是多少，并告诉玩家是猜大了还是猜小了。
（提示：rand(10)可产生0～9的随机数，gets可读取键盘输入的字符串，你要把输入字符串转换成整数。）


## 1. "Hello, world."
``` ruby Hello, world.
irb(main):001:0> puts("Hello,  world.")
Hello,  world.
=> nil
```

直接输入字符串，看上去 `Ruby` 输出了字符串，其实那是返回值。
~~你大概写了一个假的 `Hello, world`~~
``` ruby 
irb(main):002:0> "Hello World"
=> "Hello World"
```


## 2. 找下标

### `index` 方法
>index(substring [, offset]) → fixnum or nil 
 index(regexp [, offset]) → fixnum or nil
 
``` ruby
irb(main):048:0> str = "Hello, Ruby."
=> "Hello, Ruby."
irb(main):049:0> str.index("Ruby.")
=> 7
```

### `=~` 方法
正则表达式匹配：
>str =~ obj → fixnum or nil

``` ruby
irb(main):052:0> str =~ /[Ruby.]/
=> 7
```


## 3. 重复打印

### `each` 方法

``` ruby
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
``` ruby
irb(main):021:0> (1..10).each do |i|
irb(main):022:1*   h()
irb(main):023:1> end
```

### 更优雅的 `*`方法

``` ruby
irb(main):026:0> "Hello, wo!" * 10
=> "Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!Hello, wo!"
irb(main):028:0> puts "Hello, wo!\n" * 10
Hello, wo!
Hello, wo!
...
```


## 4. 循环

``` ruby 
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
``` ruby Guess-Number.rb 
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

``` ruby result
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

[2017-04-22]

----

# --------- Day 2 ---------

# Note
## 函数
- Ruby 用命令行就可以定义函数
- 每个函数都会返回结果。如果你没有显式指定某个返回值，函数就将返回退出函数前最后处理的表达式的值。
- 像所有其他事物一样，函数也是个对象。

## 数组
- 如果访问任何未定义的数组元素，Ruby会直接返回nil
- 数组元素不必具有相同类型

## 散列表
- 键=>值
- 符号（symbol）  
    符号是前面带有冒号的标识符，类似于:symbol的形式
    尽管两个同值字符串在物理上不同，但相同的符号却是同一物理对象
    类似严格指针/ Alias

## 代码块和yield
- 代码块是没有名字的函数。它可以作为参数传递给函数或方法  
    可以采用{/}或do/end两种界定代码块的形式
- Ruby的一般惯例是：代码块只占一行时用大括号，代码块占多行时用do/end。
- 在Ruby中，参数名之前加一个“&”，表示将代码块作为闭包传递给函数。

## 类
**Ruby的命名一些惯例和规则**:

- 实例变量（一个对象有一个值）前必须加上@
- 而类变量（一个类有一个值） 前必须加上@@
- 实例变量和方法名以小写字母开头， 并采用下划线命名法， 如underscore_style。
- 常量采用全大写形式，如ALL_CAPS。
- 用于逻辑测试的函数和方法一般要加上问号，如if test?。

**attr 关键字可用来定义实例变量**:
- attr定义实例变量和访问变量的同名方法，  
    实际上，attr也可以定义设置方法，只需将true作为第二个参数传入即可，如attr_accessor :children, true。
- 而attr_accessor定义实例变量、访问方法和设置方法。


# summary

- 集合
    - 数组
    - 散列表
- Ruby关注的是程序员的效率，应用程序的效率是次要的。
- 枚举
- 单继承、面向对象

# Todo
**Find**:

- 分别找到用代码块和不用代码块读取文件的方法，用代码块有什么好处？
    |- 不用代码块
    ``` ruby
    file = File.new("testfile", "r")
    # ... do something
    file.close
    ```
    |- 用代码块
    ``` ruby
    File.open("testfile", "r") do |file|
        # ... do somrthing
    end
    ```
    参看[Programming Ruby - P128]，书上说：
    >用代码块，如果在处理文件中发生异常，open方法可以捕捉并处理这个异常。而不用代码块，可能无法关闭文件对象。
    
- 如何把散列表转换成数组？数组能转换成散列表吗？
    |- 散列转数组：
    ``` ruby
    {"a"=>"1", "b"=>"2", "c"=>"3"}.to_a
    #=> [["a", "1"], ["b", "2"], ["c", "3"]]
    
    # 默认生成二维数组，可以用 `flatten` 方法转换为一维数组
    {"a"=>"1", "b"=>"2", "c"=>"3"}.to_a.flatten
    #=> ["a", "1", "b", "2", "c", "3"]
    ```
    搜索后发现还可以用zip [Ruby 数组转 hash · Ruby China](https://ruby-china.org/topics/24622)
    ``` ruby
    irb(main):035:0> {"a"=>"1", "b"=>"2", "c"=>"3"}.zip
    => [[["a", "1"]], [["b", "2"]], [["c", "3"]]]
    irb(main):036:0> {"a"=>"1", "b"=>"2", "c"=>"3"}.zip.flatten
    => ["a", "1", "b", "2", "c", "3"]
    ```
    |- 数组转散列：
    ``` ruby
    arr = %w[a 1 b 2 c 3]
    hash_table = Hash[*arr]
    
    # at one line
    
    hash_table = Hash[*%w[a 1 b 2 c 3]]
    ```
- 你能循环遍历散列表吗？
    |- `{a: 1, b: 2, c: 3}.each {|k, v| puts "#{k}=>#{v}"}`
- Ruby的数组能当作栈来用，它还能用作哪些常用的数据结构？
    |- 栈/`Stack`、集合/`Set`、队列/`Queue`、双向队列/`Dequeue`、先进先出队列/`fifo`

**Do**

1. 有一个数组，包含16个数字。仅用each方法打印数组中的内容，一次打印4个数字。然后，用可枚举模块的each_slice方法重做一遍。
2. 我们前面实现了一个有趣的树类Tree，但它不具有简洁的用户接口，来设置一棵新树，为它写一个初始化方法，接受散列表和数组嵌套的结构。
    |- 写好之后，你可以这样设置新树：
    ``` ruby
    {
      'grandpa' => { 
        'dad' => {
          'child 1' => {}, 
          'child 2' => {} 
        },
        'uncle'=> {
          'child 3' => {}, 
          'child 4' => {} 
        } 
      } 
    }
    ```
3. 写一个简单的grep程序，把文件中出现某词组的行全都打印出来。这需要使用简单的正则表达式匹配，并从文件中读取各行。
    |- （这在Ruby中超乎想象地简单。）如果你愿意的话，还可以加上行号。   
    
[2017-04-23]

## 1. each与枚举
这破题太坑，查了下手册，发现 `each` 并不能指定步长， `setp()` 可以。

然后就有了以下解法：(<- 其实是投机取巧，`array` 并没有 `step` 方法)
``` ruby
(1..16).step(4).each{|i| print i, " ", i.next, " ", i.next.next, " ", i.next.next.next, "\n"}
```

之后又上网查了下，发现果然是大坑，一般的实现都用了判断语句：

ref：
- [如何仅用 each 实现 each_slice 的功能？ · Ruby China](https://ruby-china.org/topics/24514)
- [Ruby数组的each方法使用 - 开源中国社区](https://www.oschina.net/question/1156611_142414)

**较优雅的解法**
``` ruby
(1..16).to_a.each {|i| print i, " "; print "\n" unless i%4 !=0}
```

## 2. 树与方法
想到大概要用递归，但是还是图样，参考

[七周七语言：Ruby Day 2 - 冰激淋 - 博客园](http://www.cnblogs.com/iceCream/archive/2012/12/02/2855493.html)

``` ruby
class Tree
  attr_accessor :children, :node_name

  def initialize(hash)
    hash.each do |name, children|
      @node_name = name
      @children = children.map {|key, value| Tree.new(key => value)}
    end    
  end
  
  def visit_all(&block)
    visit &block
    children.each {|c| c.visit_all &block}
  end
  
  def visit(&block)
    block.call self
  end    
end

ruby_tree = Tree.new({'grandpa' => {'dad' => {'child 1' => {}, 'child 2' => {}}, 'uncle' => {'child 3' => {}, 'child 4' => {} }}})

puts "visiting a node"
ruby_tree.visit {|node| puts node.node_name}
puts

puts "Visiting entire tree"
ruby_tree.visit_all {|node| puts node.node_name}
```

``` ruby 输出
PS I:\Desktop\Programming\Ruby\7d7lang> .\tree.rb
visiting a node
Ruby

Visiting entire tree
Ruby
Reia
MacRuby
```

## 3. grep
用了文件块，实现了带行号输出，测试文件 [Ruby' license](https://www.ruby-lang.org/en/about/license.txt)

``` ruby
# grep-word.rb
# codeblock + gets
word = "give"

def grep(line, keyword="Ruby")
    line.gsub(keyword) {|match| %Q(!!#{match}!!)}
end


File.open("ruby-license.txt", "r") do |file|
  i = 0
  while line = file.gets
    i += 1
    if line != grep(line, word)
      print "Line ", i, ": ", grep(line, word) 
    end
  end
end
```

也可以用 `each_line`
``` ruby
# grep-word-ver2.rb
# code block +　`each_line` Method
key = "give"

def grep(line, keyword="Ruby")
  line.gsub(keyword,%Q(!!#{keyword}!!)) unless line !~ /#{keyword}/
end

File.open("ruby-license.txt", "r") do |file|
  i = 0
  file.each_line do |line| 
    i += 1
    print "Line ", i, ": ", grep(line, key) unless !grep(line, key)
  end
end
```


**IO.foreach**

迭代器 + `block` = `IO.foreach`

该方法以数据源的名字为参数，以只读模式打开它，并以文件中的每一行为参数调用迭代器。

用正则让匹配更精确，转义序列配上背景颜色。
``` ruby
# grep-word-ver3.rb
# code block +　IO.foreach + Regexp + colorize

def grep(filename="testfile", re=/Ruby/)
  i = 0
  IO.foreach(filename) do |line|
    i += 1
    if line =~ re
      puts %Q(Line #{i}: #{$`}\033[42m#{$&}\033[0m#{$'})
    else
      nil
    end
  end            
end


grep("ruby-license.txt", /[ ]{1}with[ ]{1}/)
```

{% asset_img color.png 彩色输出效果 %}

彩色转义序列参考 [ruby输出多背景、颜色、效果的字符串](http://starzhou.com/blogs/ruby_colorize_console)

[2017-04-29]

----

# --------- Day 3 ---------
# Note
## 元编程
**Ruby与元编程（metaprogramming）**

元编程，说白了就是“写能写程序的程序”

**几种可用在元编程当中的技术**:

- 开放类  
    它可以随时改变任何类的定义，常用于给类添加行为
- method_missing  
    这样做也要付出代价：我们写的类调试起来会比过去困难得多，因为Ruby再也不会告诉你找不到某个方法！
- 模块


# summary

- 用Ruby定义自己的语法
- 动态地改变类

# Todo
**Do**

1. 修改前面的CSV应用程序，使它可以用each方法返回CsvRow对象。然后，在CsvRow对象上，对某个给定标题，用method_missing方法返回标题所在列的值。
    - | 比如，对于包含以下内容的文件：
        ``` ruby
        one, two
        lions, tigers
        ```
    - | API可以向下面这样操作
        ``` ruby
        csv = RubyCsv.new
        csv.each {|row| puts row.one}
        ```
    - | 这会打印出"lions"

[2017-04-23]

## CSV程序
testfile

``` plain rubycsv.txt
one, two
lions, tigers
```

想了半天没思路，去官方论坛找了找，也没有人给答案。

找了两个ref：

- [7-languages-in-7-weeks/1-ruby/day-3/acts_as_csv.rb](https://github.com/kikito/7-languages-in-7-weeks/blob/master/1-ruby/day-3/acts_as_csv.rb)
- [Ruby, Day 3: Problems CSV application](http://www.ybrikman.com/writing/2012/01/31/seven-languages-in-seven-weeks-ruby-day_31/)  
    这个怀疑代码是抄的，`respond_to?`方法的参数与函数本体对不上。

大致看了一下，要新加入一个 `each` 方法和一个 `CscRow` 类。

最后参照第一个ref, 改写出了答案
``` ruby
module ActsAsCsv
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def acts_as_csv
      include InstanceMethods
    end
  end

  module InstanceMethods
    attr_accessor :headers, :csv_contents
    
    def initialize
      read
    end
    
    def read
      @csv_contents = []
      filename = self.class.to_s.downcase + '.txt'
      file = File.new(filename)
      @headers = file.gets.chomp.split(', ')
      
      file.each do |row|
        @csv_contents << row.chomp.split(', ')
      end
    end
    
    def each(&block)
      @csv_contents.each {|contents| block.call(CsvRow.new(headers, contents))}
    end
    
    class CsvRow
      
      def initialize(headers, row)
        @headers = headers
        @row = row
      end
      
=begin
      # 暂不清楚作用， 注释掉不影响程序
      def respond_to?(name)
        @headers.index(name.to_s)
      end
=end
      
      def method_missing name, *args
        index = @headers.index(name.to_s)   
        @row[index] if index
      end
      
    end # class CvsRow END
    
  end # module InstanceMethods END
  
end # module ActsAsCsv END

class RubyCsv
  include ActsAsCsv
  acts_as_csv
end

m = RubyCsv.new
puts m.headers.inspect
puts m.csv_contents.inspect
m.each {|row| puts row.one, row.two}
```

``` palin
["one", "two"]
[["lions", "tigers"]]
lions
tigers
```

[2017-04-29]

----

# -- More about Ruby --

# Ruby 的核心优势
>Ruby的纯面向对象可以让你用一致的方式来处理对象。  
>
鸭子类型根据对象可提供的方法，而不是对象的继承层次，实现了更切合实际的多态设计。  
>
Ruby的模块和开放类，使程序员能把行为紧密结合到语法上，这大大超越了类中定义的传统方法和实例变量。

1. 脚本  
    glue code
    数以千计的gem或预打包插件
2. Web开发
    Rails  

# 不足之处

1. 性能
2. 并发和面向对象编程  
    最好的情况下，Ruby会产生大量的资源竞争；
    最坏的情况下，面向对象语言几乎无法在并发环境下调试程序，也无法可靠地测试程序。
3. 类型安全





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
