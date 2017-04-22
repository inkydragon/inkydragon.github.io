---
title: Hexo 测试页
date: 2017-02-22 17:00:31
updated: 2017-04-22 17:00:31
tags:
  - debug
  - hexo
mathjax: true
---
# highlight-test

{% codeblock c源码 lang:c 3.1.c %}
#include <stdio.h>

int main() 
{
    printf("hello, world\n");
    return 0;
}
{% endcodeblock %}

``` c 
#include <stdio.h>

int main() 
{
    printf("hello, world\n");
    return 0;
}
```

``` ruby Guess_Number.rb https://gist.github.com/inkydragon/247dea86ec79d9d100faf930527fc515 test.md 
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


```
date: 2017-02-07 17:00:31
updated: 1017-02-07 16:43:31
```

-----

# LaTeX-test

The **characteristic polynomial** $\chi(\lambda)$ of the $3 \times 3$ matrix
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
