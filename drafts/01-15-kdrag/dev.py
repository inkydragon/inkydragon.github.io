"""
Docstring for drafts.01-15-kdrag.dev

安装 https://github.com/philzook58/knuckledragger

```
python3 -m pip install git+https://github.com/philzook58/knuckledragger.git
# 3a6a962
```
"""
from kdrag.all import *
from kdrag.all import smt, kd

n, m, k = smt.Ints("n m k")

integer_properties = {
    'add_comm': smt.ForAll([n, m], n + m == m + n),
    'add_assoc': smt.ForAll([n, m, k], n + (m + k) == (n + m) + k),
    'add_zero': smt.ForAll([n], n + 0 == n),
    'add_inv': smt.ForAll([n], n + -n == 0),
    'add_monotone': kd.QForAll([n, m, k], n <= m, n + k <= m + k),

    'mul_comm': smt.ForAll([n, m], n * m == m * n),
    'mul_assoc': smt.ForAll([n, m, k], n * (m * k) == (n * m) * k),
    'mul_one': smt.ForAll([n], n * 1 == n),
    'mul_zero': smt.ForAll([n], n * 0 == 0),
    'mul_monotone': kd.QForAll([n, m, k], n <= m, k >= 0, n * k <= m * k),

    'le_refl': smt.ForAll([n], n <= n),
    'le_trans': kd.QForAll([n, m, k], n <= m, m <= k, n <= k),

    'lt_trans': kd.QForAll([n, m, k], n < m, m < k, n < k),
    'lt_total': kd.QForAll([n, m], smt.Or(n < m, n == m, m < n)),

    'distrib_left': kd.QForAll([n, m, k], n * (m + k) == n * m + n * k),
    'distrib_right': kd.QForAll([n, m, k], (m + k) * n == m * n + k * n),
} # integer_properties


for (name, formula) in integer_properties.items():
    res = kd.prove(formula)
    print(f"[{name:<16}]:\t{res}")
