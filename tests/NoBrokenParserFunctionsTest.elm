module NoBrokenParserFunctionsTest exposing (all)

import NoBrokenParserFunctions exposing (rule)
import Review.Test
import Test exposing (Test, describe, test)


all : Test
all =
    describe "NoBrokenParserFunctions"
        [ test "should not report an error when using similarly named functions from a different module" <|
            \() ->
                """module A exposing (..)

import FixedParser exposing (lineComment)

a = lineComment
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        , test "should report an error when using the broken functions (Parser)" <|
            \() ->
                """module A exposing (..)

import Parser exposing (lineComment)

a = lineComment
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use Parser.lineComment"
                            , details = [ "That function desyncs the parser's internal state. Use one of the functions from pithub/elm-parser-bug-workaround instead." ]
                            , under = "lineComment"
                            }
                            |> Review.Test.atExactly
                                { start = { row = 5, column = 5 }
                                , end = { row = 5, column = 16 }
                                }
                        ]
        , test "should report an error when using the broken functions (Parser.Advanced)" <|
            \() ->
                """module A exposing (..)

import Parser.Advanced as Fuzzy

a = Fuzzy.int
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use Parser.Advanced.int"
                            , details =
                                [ "That function is based on one which parsing floats, which means that it has surprising behaviors around `e` and `.`."
                                , "Use `Fuzzy.chompWhile Char.isDigit` instead."
                                ]
                            , under = "Fuzzy.int"
                            }
                            |> Review.Test.atExactly
                                { start = { row = 5, column = 5 }
                                , end = { row = 5, column = 14 }
                                }
                        ]
        ]
