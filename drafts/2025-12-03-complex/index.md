# 复数运算

浮点复数运算没有一个同一个规定。
主要问题出在乘法、除法的具体运算定义，和 Inf, NaN 等特殊值的处理上。

## 现有的规范

## 当前实现

### C23: Annex G

ISO/IEC 60559-compatible complex arithmetic

- [ISO/IEC 9899:2024](https://open-std.org/JTC1/SC22/WG14/www/docs/n3220.pdf)

类型上：区分实数、纯虚数、复数。
- 因此实数和纯虚数直接提升为复数，运算结果不一定相同。
