```
a = tuple(collect(1:32)...)
b = tuple(collect(1:33)...)

function map1(f, t::Base.Any32{M}, s::Base.Any32{N}) where {M, N}
    n = min(M, N) + 32
    A = Vector{Any}(undef, n)
    for i = 1:n
        A[i] = f(t[i], s[i])
    end
    (A...,)
end

function Base.map(f, t::Base.Any32{M}, s::Base.Any32{N}) where {M, N}
    n = min(length(s), length(t))
    A = Vector{Any}(undef, n)
    for i = 1:n
        A[i] = f(t[i], s[i])
    end
    (A...,)
end

function Base.map(f, t1::Base.Any32, t2::Base.Any32, ts::Base.Any32...)
    n = min(length(t1), length(t2), minimum(length.(ts)))
	@show n ts
    A = Vector{Any}(undef, n)
    for i = 1:n
        A[i] = f(t1[i], t2[i], map(t -> t[i], ts)...)
    end
    (A...,)
end


Base.map(f, t1::Tuple{}, t2::Tuple, ts::Tuple...) = ()
Base.map(f, t1::Tuple, t2::Tuple{}, ts::Tuple...) = ()
Base.map(f, t1::Tuple, t2::Tuple, ts::Tuple{}...) = ()
Base.map(f, t1::Tuple, t2::Tuple{}, ts::Tuple{}...) = ()
Base.map(f, t1::Tuple{}, t2::Tuple, ts::Tuple{}...) = ()
Base.map(f, t1::Tuple{}, t2::Tuple{}, ts::Tuple...) = ()

```
