# This file contains code that was a part of Julia
# License is MIT: see LICENSE.md

size(cp::Chr) = ()
ndims(cp::Chr) = 0
ndims(::Type{<:Chr}) = 0
length(cp::Chr) = 1
lastindex(cp::Chr) = 1
getindex(cp::Chr) = cp
first(cp::Chr) = cp
last(cp::Chr) = cp
start(cp::Chr) = false
next(cp::Chr, state) = (cp, true)
done(cp::Chr, state) = state
isempty(cp::Chr) = false
in(x::AbsChar, y::Chr) = x == y
in(x::Chr, y::AbsChar) = x == y
in(x::Chr, y::Chr) = x == y
-(x::AbsChar, y::Chr) = Int(x) - Int(y)
-(x::Chr, y::AbsChar) = Int(x) - Int(y)
-(x::Chr, y::Chr) = Int(x) - Int(y)
-(x::Chr, y::Integer) = Chr((Int32(x) - Int32(y))%UInt32)
+(x::Chr, y::Integer) = Chr((Int32(x) + Int32(y))%UInt32)
+(x::Integer, y::Chr) = y + x
show(io::IO, cp::Chr)  = show(io, Char(cp))
print(io::IO, cp::Chr) = print(io, Char(cp))
