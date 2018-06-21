__precompile__(true)
"""
ChrBase package

Copyright 2017-2018 Gandalf Software, Inc., Scott P. Jones, and contributors to julia
Licensed under MIT License, see LICENSE.md
In part based on code for Char in Julia
"""
module ChrBase

using ModuleInterfaceTools

@api extend! CharSetEncodings

@api public Chr

@api public! is_malformed, is_overlong

@api develop get_utf8_2, get_utf8_3, get_utf8_4, get_utf8_16, get_utf8_32, get_utf16, get_utf16_32,
             is_valid_continuation, is_surrogate_lead, is_surrogate_trail, is_surrogate_codeunit,
             LatinChars, ByteChars, WideChars, AbsChar, bytoff, chroff, chrdiff, utf_trail,
             codepoint_cse, codepoint_rng, codepoint_adj, utf8proc_error,
             write_utf8, write_utf16, _write_utf8_2, _write_utf8_3, _write_utf8_4, _write_ucs2,
             _lowercase_l, _uppercase_l, _lowercase_u, _uppercase_u, _titlecase_u,
             _islower_a, _islower_u, _isupper_a, _isupper_l, _isupper_al, _isupper_u,
             _can_upper_latin, _can_upper_only_latin, _can_upper_ch, _can_lower_ch,
             _can_upper, _can_upper_l

@api develop! _isvalid_chr

include("core.jl")
@static V6_COMPAT && include("compat.jl")
include("casefold.jl")
include("io.jl")
include("traits.jl")
include("unicode.jl")
include("utf8proc.jl")

@api freeze

end # module ChrBase
