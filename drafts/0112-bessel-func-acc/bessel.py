import time
import numpy as np
import mpmath
import matplotlib.pyplot as plt
from scipy import special as sc

# 设置高精度计算的精度 (binary bits)
# float64 尾数约 53 位
mpmath.mp.prec = 64

# 计算点数
NUM_POINTS = 5 * 10**5
X_START = np.spacing(np.spacing(1.0))
X_END = 16.0
ULP_LIMIT = 128.0
PLOT_ULP = False


def calculate_errors(n_points):
    # x_vals = np.linspace(X_START, X_END, n_points)
    x_vals = np.random.default_rng().uniform(X_START, X_END, size=n_points)
    
    # 向量化计算待测值
    y_approx_all = sc.y0(x_vals)
    
    # 循环计算高精度差值
    diffs_list = []
    y_exacts_list = []

    mp_func = lambda x: mpmath.bessely(0, x)
    mp_mpf = mpmath.mpf
    for x, y_approx in zip(x_vals, y_approx_all):
        x_mp = mp_mpf(x)
        y_exact = mp_func(x_mp)

        diff = mp_mpf(y_approx) - y_exact

        diffs_list.append(float(diff))
        y_exacts_list.append(float(y_exact))
        
    # 转为 numpy 数组
    diffs = np.array(diffs_list)
    y_exacts = np.array(y_exacts_list)
    
    # 3. 向量化计算误差指标
    # --- 相对误差 ---
    # 使用 numpy 处理除法，忽略除以 0 的警告（稍后修正）
    with np.errstate(divide='ignore', invalid='ignore'):
        rel_errors = diffs / y_exacts
    # 修正 y_exact 为 0 导致的 inf/nan，设为 0
    rel_errors[y_exacts == 0] = 0.0
    
    # --- ULP 误差 ---
    ulp_errors = np.array([])
    if PLOT_ULP:
        ulp_units = np.spacing(y_exacts)
        with np.errstate(divide='ignore', invalid='ignore'):
            ulp_errors = diffs / ulp_units
        # 修正 ulp_unit 为 0 (如下溢出) 的情况
        ulp_errors[ulp_units == 0] = 0.0
        
    return x_vals, rel_errors, ulp_errors

def plot_relative_error(x, rel):
    # 绘制相对误差
    plt.figure(figsize=(10, 5))
    
    plt.plot(x, rel, '.', markersize=1, alpha=0.6, label='Relative Error')
    
    # 使用 symlog (Symmetric Log) 坐标轴
    # 允许同时显示正负值，linthresh 设为极小值以保证绝大多数非零误差都在对数区
    plt.yscale('symlog', linthresh=1e-19)
    
    # 画最大误差线 (正负各画一条或只画绝对值最大处，这里画绝对值最大处的正负边界)
    # 过滤掉 0 和 nan
    abs_rel = np.abs(rel)
    valid_mask = (abs_rel > 0) & np.isfinite(abs_rel)
    
    if np.any(valid_mask):
        max_rel = np.max(abs_rel[valid_mask])
        plt.axhline(max_rel, color='r', linestyle='--', linewidth=1,
            label=f'max(|rel_err|)={max_rel:.2e}')
        plt.axhline(-max_rel, color='r', linestyle='--', linewidth=1)

    plt.title(f'Relative Error (N={len(x):.3g})')
    plt.ylabel('Relative Error (symlog scale)')
    plt.xlabel('x')
    plt.grid(True, which='both', linestyle='--', alpha=0.5)
    plt.legend(loc='center right')
    plt.tight_layout()
    plt.show()

def plot_ulp_error(x, ulp):
    # 绘制 ULP 误差
    plt.figure(figsize=(10, 5))
    plt.plot(x, ulp, '.', markersize=1, alpha=0.6, label='ULP Error')
    
    # 画最大误差线
    # max_ulp_abs = np.nanmax(np.abs(ulp))
    # plt.axhline(max_ulp_abs, color='m', linestyle='--', linewidth=1, label=f'Max Abs: {max_ulp_abs:.2f}')
    # plt.axhline(-max_ulp_abs, color='m', linestyle='--', linewidth=1)
    
    plt.title(f'ULP Error  (N={len(x):.3g})')
    plt.ylabel('Error (ULPs)')
    plt.xlabel('x')
    plt.ylim(-ULP_LIMIT, ULP_LIMIT)
    plt.grid(True, which='both', linestyle='--', alpha=0.5)
    plt.legend(loc='center right')
    plt.tight_layout()
    plt.show()


def rel_stats(rel):
    abs_rel = np.abs(rel)
    finite = np.isfinite(abs_rel)
    if not np.any(finite):
        return {"max": np.nan, "median": np.nan, "mean": np.nan, "p99": np.nan}
    vals = abs_rel[finite]
    return {
        "max": np.max(vals),
        "median": np.median(vals),
        "mean": np.mean(vals),
        "p99": np.percentile(vals, 99),
    }

if __name__ == "__main__":
    print(f"Start calculating errors for {NUM_POINTS:.2g} points...")
    start_time = time.time()
    x, rel, ulp = calculate_errors(NUM_POINTS)
    elapsed_time = time.time() - start_time
    print(f"Calc finished in {elapsed_time:.2f} seconds.")
    
    rstats = rel_stats(rel)
    print(f"Rel max   = {rstats['max']:.3g}")
    print(f"Rel p99   = {rstats['p99']:.3g}")
    print(f"Rel mean  = {rstats['mean']:.3g}")
    print(f"Rel median= {rstats['median']:.3g}")
    if PLOT_ULP:
        print(f"ULP max = {np.max(np.abs(ulp)):.3g} ULPs")
        plot_ulp_error(x, ulp)

    plot_relative_error(x, rel)
