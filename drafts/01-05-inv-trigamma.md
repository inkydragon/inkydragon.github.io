# 计算 Trigamma 的逆函数

- 审阅 [Implementation of inverse trigamma by nignatiadis · Pull Request #415 · JuliaMath/SpecialFunctions.jl](https://github.com/JuliaMath/SpecialFunctions.jl/pull/415)

搜索可知目前2025年，仅有 R 的 limma 包实现了 Trigamma 的逆函数 `trigammaInverse`。
该函数使用牛顿法进行数值求解。
https://github.com/cran/limma/blob/1b51b3a5295f9feedb72a0df97e9c3e236592464/R/ebayes.R#L205-L221

具体的求解算法在
Smyth, G. K. (2004). Linear models and empirical bayes methods for assessing differential expression in microarray experiments. Statistical applications in genetics and molecular biology, 3(1).
的附录中 Appendix: Inversion of Trigamma Function


# Appendix: Inversion of Trigamma Function

This appendix describes how to solve the equation

```latex
\psi(y) = x, \qquad x > 0
```

where \(\psi(y)\) is the **trigamma function**. A Newton iteration with guaranteed monotone convergence is derived, along with numerically stable initialization rules.

---

## Reformulation

Define

```latex
f(y) = \frac{1}{\psi(y)}.
```

For \(y > 0\), the function \(f(y)\) has the following properties:

- It is nearly linear and convex.
- It satisfies  
  ```latex
  f(0) = 0, \qquad f(y) \sim y - 0.5 \quad \text{as } y \to \infty.
  ```
- Its derivative is  
  ```latex
  f'(y) = -\frac{\psi'(y)}{\psi(y)^2},
  ```  
  which is strictly increasing from \(0\) to \(1\).

Because \(f'(y)\) is increasing and bounded above by 1, the Newton iteration for solving  
```latex
f(y) = z
```  
is **monotonically convergent** provided the starting value \(y_0\) satisfies \(f(y_0) \ge z\).

A suitable initial value is

```latex
y_0 = 0.5 + z.
```

---

## Newton Iteration for Solving \(\psi(y) = x\)

We want to solve

```latex
\psi(y) = x.
```

Let

```latex
z = \frac{1}{x}.
```

### Initialization

```latex
y_0 = 0.5 + \frac{1}{x}.
```

### Iteration

For \(i = 0, 1, 2, \ldots\), update

```latex
y_{i+1} = y_i + \delta_i,
```

where

```latex
\delta_i = \frac{\psi(y_i)\left(1 - \frac{\psi(y_i)}{x}\right)}{\psi'(y_i)}.
```

Notes:

- \(\delta_i < 0\) unless \(\psi(y_i) = x\).
- Stop when  
  ```latex
  -\frac{\delta_i}{y_i} < \varepsilon,
  ```  
  with \(\varepsilon\) typically \(10^{-8}\) for double‑precision accuracy.

---

## Numerical Stability

To avoid floating‑point overflow or underflow, use the following approximations in extreme cases:

- If  
  ```latex
  x > 10^7,
  ```  
  then  
  ```latex
  y \approx \frac{1}{\sqrt{x}}.
  ```

- If  
  ```latex
  x < 10^{-6},
  ```  
  then  
  ```latex
  y \approx \frac{1}{x}.
  ```

These approximations are sufficiently accurate for 64‑bit floating‑point arithmetic.
