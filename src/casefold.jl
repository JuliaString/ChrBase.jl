#=
Case folding for Unicode Chr types

Copyright 2017-2018 Gandalf Software, Inc., Scott P. Jones
Licensed under MIT License, see LICENSE.md
=#

_lowercase_l(ch) = ifelse(_isupper_al(ch), ch + 0x20, ch)
_uppercase_l(ch) = ifelse(_can_upper(ch),  ch - 0x20, ch)

_lowercase(ch) = is_latin(ch) ? _lowercase_l(ch) : _lowercase_u(ch)
_uppercase(ch) = is_latin(ch) ? _uppercase_l(ch) : _uppercase_u(ch)
_titlecase(ch) = is_latin(ch) ? _uppercase_l(ch) : _titlecase_u(ch)

lowercase(ch::T) where {T<:Chr} = T(_lowercase(codepoint(ch)))
uppercase(ch::T) where {T<:Chr} = T(_uppercase(codepoint(ch)))
titlecase(ch::T) where {T<:Chr} = T(_titlecase(codepoint(ch)))

lowercase(ch::ASCIIChr) = ifelse(_isupper_a(ch), ASCIIChr(ch + 0x20), ch)
uppercase(ch::ASCIIChr) = ifelse(_islower_a(ch), ASCIIChr(ch - 0x20), ch)
titlecase(ch::ASCIIChr) = uppercase(ch)

lowercase(ch::T) where {T<:LatinChars} = T(_lowercase_l(codepoint(ch)))
uppercase(ch::LatinChr) = LatinChr(_uppercase_l(codepoint(ch)))

# Special handling for case where this is just an optimization of the first 256 bytes of Unicode,
# and not the 8-bit ISO 8859-1 character set
function uppercase(ch::_LatinChr)
    cb = codepoint(ch)
    _can_upper(cb) && return _LatinChr(cb - 0x20)
    # We don't uppercase 0xdf, the ß character
    cb == 0xb5 ? UCS2Chr(0x39c) : (cb == 0xff ? UCS2Chr(0x178) : ch)
end
titlecase(ch::LatinChars) = uppercase(ch)

_can_upper_latin(ch)      = _can_upper(ch) | (ch == 0xb5) | (ch == 0xff)
_can_upper_only_latin(ch) = _can_upper_l(ch) | (ch == 0xb5) | (ch == 0xff)

@inline _can_upper_ch(ch) =
    ch <= 0x7f ? _islower_a(ch) : (ch <= 0xff ? _can_upper_only_latin(ch) : _islower_u(ch))
@inline _can_lower_ch(ch) =
    ch <= 0x7f ? _isupper_a(ch) : (ch <= 0xff ? _isupper_l(ch) : _isupper_u(ch))
