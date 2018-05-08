__precompile__(true)
"""
Chars package

Copyright 2017-2018 Gandalf Software, Inc., Scott P. Jones, and contributors to julia
Licensed under MIT License, see LICENSE.md
In part based on code for Char in Julia
"""
module Chars

using StrAPI, CharSetEncodings

@import_list StrAPI base_api_ext base_dev_ext
@using_list  StrAPI api_def dev_def
@import_list StrAPI api_ext dev_ext
@using_list  CharSetEncodings api_def dev_def
@import_list CharSetEncodings api_ext

const api_ext = Symbol[]
const api_def = Symbol[]
const dev_ext = Symbol[]
const dev_def = Symbol[]

push!(api_def, :Chr)

push!(dev_def,
      :get_utf8_2, :get_utf8_3, :get_utf8_4, :utf_trail, :is_valid_continuation,
      :get_utf16, :is_surrogate_lead, :is_surrogate_trail, :is_surrogate_codeunit,
      :LatinChars, :ByteChars, :WideChars, :AbsChar, :bytoff, :chroff, :chrdiff,
      :codepoint_rng, :codepoint_adj, :write_utf8, :write_utf16,
      :_write_utf8_2, :_write_utf8_3, :_write_utf8_4, :_write_ucs2,
      :_lowercase_l, :_uppercase_l, :_lowercase_u, :_uppercase_u, :_titlecase_u,
      :_can_upper_latin, :_can_upper_only_latin, :_can_upper_ch, :_can_lower_ch)

push!(dev_ext, :_write, :_print, :_isvalid, :_isvalid_chr, :_lowercase, :_uppercase, :_titlecase)

include("core.jl")
include("compat.jl")
include("casefold.jl")
include("io.jl")
include("traits.jl")
include("unicode.jl")
include("utf8proc.jl")

end # module Chars
