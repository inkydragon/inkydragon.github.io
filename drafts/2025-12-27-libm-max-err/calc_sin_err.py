import time
import numpy as np
import mpmath
import matplotlib.pyplot as plt

# 设置高精度计算的精度 (binary bits)
# float64 尾数约 53 位
mpmath.mp.prec = 64

# 计算点数
NUM_POINTS = 5*10**5


def calculate_errors(n_points):
    x_vals = np.linspace(0, 2 * np.pi, n_points)
    
    # 向量化计算待测值
    y_approx_all = np.sin(x_vals)
    
    # 循环计算高精度差值
    diffs_list = []
    y_exacts_list = []

    mp_sin = mpmath.sin
    mp_mpf = mpmath.mpf
    for x, y_approx in zip(x_vals, y_approx_all):
        x_mp = mp_mpf(x)
        y_exact = mp_sin(x_mp)

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
    ulp_units = np.spacing(y_exacts)
    with np.errstate(divide='ignore', invalid='ignore'):
        ulp_errors = diffs / ulp_units
    # 修正 ulp_unit 为 0 (如下溢出) 的情况
    ulp_errors[ulp_units == 0] = 0.0
        
    return x_vals, rel_errors, ulp_errors

def get_pi_ticks():
    ticks = np.arange(0, 2 * np.pi + 0.001, np.pi / 6)
    labels = []
    for t in ticks:
        k = int(round(t / (np.pi / 6)))
        if k == 0:
            labels.append("0")
        else:
            numerator = k
            denominator = 6
            gcd = np.gcd(numerator, denominator)
            num = int(numerator // gcd)
            den = int(denominator // gcd)
            
            label = "π"
            if num != 1:
                label = f"{num}π"
            
            if den != 1:
                label = f"{label}/{den}"
            
            labels.append(label)
    return ticks, labels

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
        plt.axhline(max_rel, color='r', linestyle='--', linewidth=1, label=f'Max Abs: {max_rel:.2e}')
        plt.axhline(-max_rel, color='r', linestyle='--', linewidth=1)

    plt.title(f'sin(x) Relative Error (N={len(x):.3g})')
    plt.ylabel('Relative Error (symlog scale)')
    plt.xlabel('x (radians)')
    plt.xticks(*get_pi_ticks())
    plt.grid(True, which='both', linestyle='--', alpha=0.5)
    plt.legend(loc='lower right')
    plt.tight_layout()
    plt.show()

def plot_ulp_error(x, ulp):
    # 绘制 ULP 误差
    plt.figure(figsize=(10, 5))
    plt.plot(x, ulp, '.', markersize=1, alpha=0.6, label='ULP Error')
    
    # 画最大误差线
    max_ulp_abs = np.nanmax(np.abs(ulp))
    plt.axhline(max_ulp_abs, color='m', linestyle='--', linewidth=1, label=f'Max Abs: {max_ulp_abs:.2f}')
    plt.axhline(-max_ulp_abs, color='m', linestyle='--', linewidth=1)
    
    plt.title(f'sin(x) ULP Error  (N={len(x):.3g})')
    plt.ylabel('Error (ULPs)')
    plt.xlabel('x (radians)')
    plt.xticks(*get_pi_ticks())
    plt.grid(True, which='both', linestyle='--', alpha=0.5)

    plt.legend(loc='center right')
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    print(f"Start calculating sin(x) errors for {NUM_POINTS} points...")
    start_time = time.time()
    x, rel, ulp = calculate_errors(NUM_POINTS)
    elapsed_time = time.time() - start_time
    print(f"Calculation finished in {elapsed_time:.4f} seconds.")
    
    max_rel = np.max(np.abs(rel))
    max_ulp = np.max(np.abs(ulp))
    
    print(f"Max Relative Error: {max_rel:.4e}")
    print(f"Max ULP Error:      {max_ulp:.4f} ULPs")
    
    plot_relative_error(x, rel)
    plot_ulp_error(x, ulp)
