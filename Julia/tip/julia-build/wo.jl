
# AST dump macro
"""
julia> ast"f(x)"
(:call, :f, :x)
"""
macro ast_str(ex)
    ex |> Meta.parse |> Meta.show_sexpr
end

"""
julia> @sexpr f(x)
(:call, :f, :x)
"""
macro sexpr(ex)
    ex |> Meta.show_sexpr
end
