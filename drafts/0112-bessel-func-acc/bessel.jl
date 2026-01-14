# SPDX-License-Identifier: MIT
using Bessels
using ArbNumerics
using Plots
using Statistics
using Random
using Printf

setprecision(ArbFloat, 128)

include("randf.jl")
const NUM_POINTS = 500_000
const X_START = eps(eps(1.0))
const X_END = 30.0

function generate_test_points(n_points::Int, func_name::String)
    Xoshiro(42)
    x_vals = Vector{Float64}(undef, 0)
    sizehint!(x_vals, n_points)

    # --- function related test cases
    # if func_name == "Bessels.bessely0"  # Rel max   = 7.405e+00
    #     # Zeros:  Table[N[BesselYZero[0, k], 18], {k, 1, 15}]
    #     y0 = [
    #         0.893576966279167522,3.95767841931485787,7.08605106030177270,10.2223450434964170,
    #         13.3610974738727635,16.5009224415280908,19.6413097008879398,
    #         22.7820280472915593,25.9229576531809227,29.0640302527283981,
    #         # 32.2052041164932807,35.3464523052143205,38.4877566530815372,41.6291044662138080,44.7704866072219932
    #     ]
    #     for y in y0
    #         push!(x_vals, y)
    #         append!(x_vals, rand_float_at(y; r=100, n=1000))
    #     end
    # end
    
    # [X_START, 1.0]
    n_small = n_points ÷ 10
    append!(x_vals, rand_float(X_START, 1.0, n_small))
    # [1.0, X_END]
    n_large = n_points - n_small
    append!(x_vals, rand_float(1.0, X_END, n_large))
    
    return sort!(x_vals)
end

function calculate_errors(x_vals::Vector{Float64}, test_fn::Function, mp_ref_fn::Function)
    n_points = length(x_vals)

    y_approx_all = test_fn.(x_vals)
    
    diffs = Vector{Float64}(undef, n_points)
    y_exacts = Vector{Float64}(undef, n_points)
    for i in 1:n_points
        x_mp = ArbFloat(x_vals[i])

        y_exact_mp = mp_ref_fn(x_mp)
        y_exact_f64 = Float64(y_exact_mp)
        diff_mp = ArbFloat(y_approx_all[i]) - y_exact_mp
        
        diffs[i] = Float64(diff_mp)
        y_exacts[i] = y_exact_f64
    end
    
    # rel_errors
    rel_errors = Vector{Float64}(undef, n_points)
    for i in 1:n_points
        if y_exacts[i] == 0.0
            rel_errors[i] = 0.0
        else
            rel_errors[i] = diffs[i] / y_exacts[i]
        end
    end

    return x_vals, rel_errors
end

function rel_stats(rel::Vector{Float64})
    abs_rel = abs.(rel)
    valid_mask = isfinite.(abs_rel)
    
    if !any(valid_mask)
        return (max=NaN, median=NaN, mean=NaN, p99=NaN)
    end
    
    vals = abs_rel[valid_mask]
    return (
        max = maximum(vals),
        median = median(vals),
        mean = mean(vals),
        p99 = quantile(vals, 0.99)
    )
end

function plot_relative_error(x, rel, func_name)
    # Max abs rel error
    abs_rel = abs.(rel)
    valid_mask = (abs_rel .> 0) .& isfinite.(abs_rel)
    max_rel = any(valid_mask) ? maximum(abs_rel[valid_mask]) : 1e-16

    pos_mask = (rel .> 0) .& isfinite.(rel)
    neg_mask = (rel .< 0) .& isfinite.(rel)

    # 显式设置 x 轴范围
    x_limit_min = floor(X_START) - 0.5
    x_limit_max = ceil(X_END) + 0.5

    title = @sprintf("%s(x) Relative Error (N=%g)", func_name, NUM_POINTS)
    p = plot(
        title=title,
        xlabel="x",
        ylabel="log10(|Relative Error|)",
        yscale=:log10,
        legend=:bottomright,
        grid=:true,
        gridalpha=0.5,
        minorgrid=:true,
        xlims=(x_limit_min, x_limit_max)
    )

    # Plot positive errors
    scatter!(p, x[pos_mask], rel[pos_mask],
        label="Pos Error",
        markersize=1.2,
        markerstrokewidth=0,
        color=:dodgerblue,
        alpha=0.6
    )

    # Plot negative errors as absolute values
    scatter!(p, x[neg_mask], abs.(rel[neg_mask]),
        label="Neg Error (abs)",
        markersize=1.2,
        markerstrokewidth=0,
        color=:darkorange,
        alpha=0.6
    )
    
    # Add horizontal line for max_rel
    hline!(p, [max_rel], linestyle=:dash, color=:red, label=@sprintf("max(|rel|) = %.2e", max_rel))

    savefig(p, "$(func_name)_rel_err.png")
    # Show plot
    display(p)
end

function run_benchmark(test_fn, mp_ref_fn, func_name::String)
    @printf("Start calculating %s(x) errors for %g points...\n", func_name, NUM_POINTS)
    x_vals = generate_test_points(NUM_POINTS, func_name)
    t_start = time()
    x, rel = calculate_errors(x_vals, test_fn, mp_ref_fn)
    t_elapsed = time() - t_start
    @printf("Calc finished in %.2f seconds.\n", t_elapsed)
    
    # Print stats
    stats = rel_stats(rel)
    @printf("Rel max   = %.3e\n", stats.max)
    @printf("Rel p99   = %.3e\n", stats.p99)
    @printf("Rel mean  = %.3e\n", stats.mean)
    @printf("Rel median= %.3e\n", stats.median)
    
    # Plot relative error
    plot_relative_error(x, rel, func_name)
end

# --- Main Execution ---

run_benchmark(
    Bessels.bessely0, 
    x -> ArbNumerics.bessely0(ArbReal(x)), 
    "Bessels.bessely0"
)
