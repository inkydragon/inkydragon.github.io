# JuliaLowering.jl Dev

https://github.com/c42f/JuliaLowering.jl

## What is Lowing

1. **Macro expansion** - expanding user-defined syntactic constructs by running the user's macros. This pass also includes a small amount of other symbolic simplification.
2. **Syntax desugaring** - simplifying Julia's rich surface syntax down to a small number of syntactic forms.
3. **Scope analysis** - analyzing identifier names used in the code to discover local variables, closure captures, and associate global variables to the appropriate module.
4. **Closure conversion** - convert closures to types and deal with captured variables efficiently where possible.
5. **Flattening to linear IR** - convert code in hierarchical tree form to a flat array of statements; convert control flow into gotos.

```jl
function f(x)
sum = 0.0
while x > 0
    sum += x
    x -= 1
end
sum
end
```

## Lowing

```jl
code_lowered(f, (Int,))
Base.uncompressed_ir(Base.method_instances(f, (Int,), Base.get_world_counter())[1].def)

m = Base.method_instances(f, (Int,), Base.get_world_counter())[1].def
ccall(:jl_uncompress_ir, Any, (Any, Ptr{Cvoid}, Any), m, C_NULL, m.source)
# |> Base.remove_linenums!

# jl_code_info_t *jl_uncompress_ir(jl_method_t *m, jl_code_instance_t *metadata, jl_string_t *data)

```


## Macro expansion

```jl
macroexpand(m::Module, x; recursive=true)
```

```c
// rec
jl_value_t *jl_macroexpand(jl_value_t *expr, jl_module_t *inmodule)
jl_value_t *jl_macroexpand1(jl_value_t *expr, jl_module_t *inmodule)
```

## Syntax desugaring

## Scope analysis

## Closure conversion

## Flattening
