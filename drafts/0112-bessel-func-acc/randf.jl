# SPDX-License-Identifier: MIT OR Apache-2.0
# Copy from:  inkydragon/PureLibm.jl:test/utils/ranges.jl
"""
Generate random float numbers using `rand(UInt)`.

# Arguments
- `lo::Unsigned`: lower bound
- `hi::Unsigned`: upper bound
- `n::Int`: number of random values

# Returns
- `Vector{T}`: Generator for random float values in the range `[lo, hi]`
"""
function rand_float(xu_lo::T, xu_hi::T, n::Int) where {T<:Unsigned}
    @assert xu_lo < xu_hi
    FloatType = Base.floattype(T)
    xu_range = xu_lo:xu_hi
    xu_rand = rand(xu_range, n)
    f_rand = Iterators.map(xu->reinterpret(FloatType, xu), xu_rand)
    f_rand
end

"""
Generate random float numbers using `rand(UInt)`.

# Arguments
- `lo::AbstractFloat`: lower bound
- `hi::AbstractFloat`: upper bound
- `n::Int`: number of random values

# Returns
- `Vector{T}`: Generator for random float values in the range `[lo, hi]`
"""
function rand_float(lo::T, hi::T, n::Int) where {T<:AbstractFloat}
    @assert abs(lo) < abs(hi)
    UIntBaseType = Base.uinttype(T)
    xu_lo = reinterpret(UIntBaseType, lo)
    xu_hi = reinterpret(UIntBaseType, hi)
    rand_float(xu_lo, xu_hi, n)
end

"""
Generate random float numbers around `x` with integer radius `r`.

# Arguments
- `x::AbstractFloat`: center value
- `r::Int`: radius in integer representation (ULPs)
- `n::Int`: number of random values

# Returns
- `Vector{T}`: Generator for random float values
"""
function rand_float_at(x::T; r::Int, n::Int) where {T<:AbstractFloat}
    UIntType = Base.uinttype(T)
    xu = reinterpret(UIntType, x)
    r_u = convert(UIntType, r)
    
    # Check for underflow
    xu_lo = (xu < r_u) ? zero(UIntType) : xu - r_u
    
    # Check for overflow
    xu_hi = (xu > typemax(UIntType) - r_u) ? typemax(UIntType) : xu + r_u
    
    rand_float(xu_lo, xu_hi, n)
end
