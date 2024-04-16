module NoBrokenParserFunctions exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Expression as Expression exposing (Expression)
import Elm.Syntax.ModuleName exposing (ModuleName)
import Elm.Syntax.Node exposing (Node(..))
import Review.ModuleNameLookupTable as ModuleNameLookupTable exposing (ModuleNameLookupTable)
import Review.Rule as Rule exposing (Error, Rule)


type alias Context =
    { lookupTable : ModuleNameLookupTable }


{-| Check for usages of the broken parser functions.
-}
rule : Rule
rule =
    Rule.newModuleRuleSchemaUsingContextCreator "NoBrokenParserFunctions" initialContext
        |> Rule.withExpressionEnterVisitor expressionVisitor
        |> Rule.fromModuleRuleSchema


initialContext : Rule.ContextCreator () Context
initialContext =
    Rule.initContextCreator
        (\lookupTable () -> { lookupTable = lookupTable })
        |> Rule.withModuleNameLookupTable


expressionVisitor : Node Expression -> Context -> ( List (Error {}), Context )
expressionVisitor ((Node range expression) as node) context =
    case expression of
        Expression.FunctionOrValue _ name ->
            if List.member name brokenFunctions then
                let
                    moduleName : ModuleName
                    moduleName =
                        ModuleNameLookupTable.moduleNameFor context.lookupTable node
                            |> Maybe.withDefault []
                in
                if moduleName == [ "Parser" ] || moduleName == [ "Parser", "Advanced" ] then
                    ( [ Rule.error
                            { message = "Do not use " ++ String.join "." moduleName ++ "." ++ name
                            , details = [ "That function desyncs the parser's internal state. Use one of the functions from pithub/elm-parser-bug-workaround instead." ]
                            }
                            range
                      ]
                    , context
                    )

                else
                    ( [], context )

            else
                ( [], context )

        _ ->
            ( [], context )


brokenFunctions : List String
brokenFunctions =
    [ "lineComment", "multiComment", "chompUntil", "chompUntilEndOr" ]
