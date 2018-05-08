# This file includes code that was formerly a part of Julia.
# Further modifications and additions: Scott P. Jones
# License is MIT: LICENSE.md

const V6_COMPAT = VERSION < v"0.7.0-DEV"

@static V6_COMPAT ? (using Base.Test) : (using Test)

using StrAPI, CharSetEncodings, Chars

@using_list StrAPI api_ext dev_ext api_def dev_def
@using_list CharSetEncodings api_ext api_def dev_def
@using_list Chars dev_ext api_def dev_def

for C in (ASCIIChr, LatinChr, UCS2Chr, UTF32Chr)

    maxch = typemax(C)%UInt

    V6_COMPAT || @testset "ranges: $C" begin
        # This caused JuliaLang/JSON.jl#82
        rng = C('\x00'):C('\x7f')
        @test first(rng) === C('\x00')
        @test last(rng) === C('\x7f')
    end

    @testset "isvalid edge conditions" begin
        for (val, pass) in (
            (0, true), (0xd7ff, true),
            (0xd800, false), (0xdfff, false),
            (0xe000, true), (0xffff, true),
            (0x10000, true), (0x10ffff, true),
            (0x110000, false))
            pass &= val <= maxch
            @test is_valid(C, val) == pass
        end
        V6_COMPAT || for (val, pass) in (
            (String(b"\x00"), true),
            (String(b"\x7f"), true),
            (String(b"\x80"), false),
            (String(b"\xbf"), false),
            (String(b"\xc0"), false),
            (String(b"\xff"), false),
            (String(b"\xc0\x80"), false),
            (String(b"\xc1\x80"), false),
            (String(b"\xc2\x80"), true),
            (String(b"\xc2\xc0"), false),
            (String(b"\xed\x9f\xbf"), true),
            (String(b"\xed\xa0\x80"), false),
            (String(b"\xed\xbf\xbf"), false),
            (String(b"\xee\x80\x80"), true),
            (String(b"\xef\xbf\xbf"), true),
            (String(b"\xf0\x80\x80\x80"), false),
            (String(b"\xf0\x90\x80\x80"), true),
            (String(b"\xf4\x8f\xbf\xbf"), true),
            (String(b"\xf4\x90\x80\x80"), false),
            (String(b"\xf5\x80\x80\x80"), false),
            (String(b"\ud800\udc00"), false),
            (String(b"\udbff\udfff"), false),
            (String(b"\ud800\u0100"), false),
            (String(b"\udc00\u0100"), false),
            (String(b"\udc00\ud800"), false))
            @test is_valid(C, val[1]) == pass
        end

        # invalid Chars
        @test  is_valid(C, 'a')    == ('a'    <= Char(maxch))
        @test  is_valid(C, '柒')   == ('柒'   <= Char(maxch))
        @test  is_valid(C, 0xd7ff) == (0xd7ff <= maxch)
        @test  is_valid(C, 0xe000) == (0xe000 <= maxch)
        @test !is_valid(C, Char(0xd800))
        @test !is_valid(C, Char(0xdfff))
    end
end
