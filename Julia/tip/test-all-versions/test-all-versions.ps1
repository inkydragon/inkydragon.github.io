# 测试不同 julia 版本的输出
Set-PSDebug -Trace 1

julia +1.0      bugs.jl
julia +1.6      bugs.jl

julia +1.10.0   bugs.jl
julia +1.10     bugs.jl

julia +1.11.0   bugs.jl
julia +1.11     bugs.jl

julia +nightly  bugs.jl
