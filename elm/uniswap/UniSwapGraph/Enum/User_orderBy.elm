-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module UniSwapGraph.Enum.User_orderBy exposing (..)

import Json.Decode as Decode exposing (Decoder)


type User_orderBy
    = Id
    | LiquidityPositions
    | UsdSwapped


list : List User_orderBy
list =
    [ Id, LiquidityPositions, UsdSwapped ]


decoder : Decoder User_orderBy
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "id" ->
                        Decode.succeed Id

                    "liquidityPositions" ->
                        Decode.succeed LiquidityPositions

                    "usdSwapped" ->
                        Decode.succeed UsdSwapped

                    _ ->
                        Decode.fail ("Invalid User_orderBy type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : User_orderBy -> String
toString enum =
    case enum of
        Id ->
            "id"

        LiquidityPositions ->
            "liquidityPositions"

        UsdSwapped ->
            "usdSwapped"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe User_orderBy
fromString enumString =
    case enumString of
        "id" ->
            Just Id

        "liquidityPositions" ->
            Just LiquidityPositions

        "usdSwapped" ->
            Just UsdSwapped

        _ ->
            Nothing
