#=
Case folding for Unicode Chr types

Copyright 2017-2018 Gandalf Software, Inc., Scott P. Jones
Licensed under MIT License, see LICENSE.md
=#

_wide_upper(ch) =
    ifelse(ch == 0xb5, 0x39c,
           ifelse(ch == 0xff, 0x178, ifelse(!V6_COMPAT && ch == 0xdf, 0x1e9e, ch%UInt16)))

_lowercase_l(ch) = _isupper_al(ch) ? ch + 0x20 : ch
_uppercase_l(ch) = _can_upper(ch)  ? ch - 0x20 : _wide_upper(ch)

_lowercase(ch) = is_latin(ch) ? _lowercase_l(ch) : _lowercase_u(ch)
_uppercase(ch) = is_latin(ch) ? _uppercase_l(ch) : _uppercase_u(ch)
_titlecase(ch) = is_latin(ch) ? _uppercase_l(ch) : _titlecase_u(ch)

lowercase(ch::T) where {T<:Chr} = T(_lowercase(codepoint(ch)))
uppercase(ch::T) where {T<:Chr} = T(_uppercase(codepoint(ch)))
titlecase(ch::T) where {T<:Chr} = T(_titlecase(codepoint(ch)))

lowercase(ch::ASCIIChr) = _isupper_a(ch) ? ASCIIChr(ch + 0x20) : ch
uppercase(ch::ASCIIChr) = _islower_a(ch) ? ASCIIChr(ch - 0x20) : ch
titlecase(ch::ASCIIChr) = uppercase(ch)

lowercase(ch::T) where {T<:LatinChars} = T(_lowercase_l(codepoint(ch)))

_uppercase_latin(ch) = _can_upper(ch) ? ch - 0x20 : ch
uppercase(ch::LatinChr) = LatinChr(_uppercase_latin(codepoint(ch)))

# Special handling for case where this is just an optimization of the first 256 bytes of Unicode,
# and not the 8-bit ISO 8859-1 character set
function uppercase(ch::_LatinChr)
    cb = codepoint(ch)
    _can_upper(cb) && return _LatinChr(cb - 0x20)
    # We didn't used to uppercase 0xdf, the ß character, now we do
    !V6_COMPAT && cb == 0xdf && return UCS2Chr(0x1e9e)
    cb == 0xb5 ? UCS2Chr(0x39c) : cb == 0xff ? UCS2Chr(0x178) : ch
end
titlecase(ch::LatinChars) = uppercase(ch)
