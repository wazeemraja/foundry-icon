-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module UniSwapGraph.Object.Token exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import UniSwapGraph.Enum.OrderDirection
import UniSwapGraph.Enum.PairDayData_orderBy
import UniSwapGraph.InputObject
import UniSwapGraph.Interface
import UniSwapGraph.Object
import UniSwapGraph.Scalar
import UniSwapGraph.ScalarCodecs
import UniSwapGraph.Union


id : SelectionSet UniSwapGraph.ScalarCodecs.Id UniSwapGraph.Object.Token
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (UniSwapGraph.ScalarCodecs.codecs |> UniSwapGraph.Scalar.unwrapCodecs |> .codecId |> .decoder)


symbol : SelectionSet String UniSwapGraph.Object.Token
symbol =
    Object.selectionForField "String" "symbol" [] Decode.string


name : SelectionSet String UniSwapGraph.Object.Token
name =
    Object.selectionForField "String" "name" [] Decode.string


decimals : SelectionSet UniSwapGraph.ScalarCodecs.BigInt UniSwapGraph.Object.Token
decimals =
    Object.selectionForField "ScalarCodecs.BigInt" "decimals" [] (UniSwapGraph.ScalarCodecs.codecs |> UniSwapGraph.Scalar.unwrapCodecs |> .codecBigInt |> .decoder)


totalSupply : SelectionSet UniSwapGraph.ScalarCodecs.BigInt UniSwapGraph.Object.Token
totalSupply =
    Object.selectionForField "ScalarCodecs.BigInt" "totalSupply" [] (UniSwapGraph.ScalarCodecs.codecs |> UniSwapGraph.Scalar.unwrapCodecs |> .codecBigInt |> .decoder)


tradeVolume : SelectionSet UniSwapGraph.ScalarCodecs.BigDecimal UniSwapGraph.Object.Token
tradeVolume =
    Object.selectionForField "ScalarCodecs.BigDecimal" "tradeVolume" [] (UniSwapGraph.ScalarCodecs.codecs |> UniSwapGraph.Scalar.unwrapCodecs |> .codecBigDecimal |> .decoder)


tradeVolumeUSD : SelectionSet UniSwapGraph.ScalarCodecs.BigDecimal UniSwapGraph.Object.Token
tradeVolumeUSD =
    Object.selectionForField "ScalarCodecs.BigDecimal" "tradeVolumeUSD" [] (UniSwapGraph.ScalarCodecs.codecs |> UniSwapGraph.Scalar.unwrapCodecs |> .codecBigDecimal |> .decoder)


untrackedVolumeUSD : SelectionSet UniSwapGraph.ScalarCodecs.BigDecimal UniSwapGraph.Object.Token
untrackedVolumeUSD =
    Object.selectionForField "ScalarCodecs.BigDecimal" "untrackedVolumeUSD" [] (UniSwapGraph.ScalarCodecs.codecs |> UniSwapGraph.Scalar.unwrapCodecs |> .codecBigDecimal |> .decoder)


txCount : SelectionSet UniSwapGraph.ScalarCodecs.BigInt UniSwapGraph.Object.Token
txCount =
    Object.selectionForField "ScalarCodecs.BigInt" "txCount" [] (UniSwapGraph.ScalarCodecs.codecs |> UniSwapGraph.Scalar.unwrapCodecs |> .codecBigInt |> .decoder)


totalLiquidity : SelectionSet UniSwapGraph.ScalarCodecs.BigDecimal UniSwapGraph.Object.Token
totalLiquidity =
    Object.selectionForField "ScalarCodecs.BigDecimal" "totalLiquidity" [] (UniSwapGraph.ScalarCodecs.codecs |> UniSwapGraph.Scalar.unwrapCodecs |> .codecBigDecimal |> .decoder)


derivedETH : SelectionSet (Maybe UniSwapGraph.ScalarCodecs.BigDecimal) UniSwapGraph.Object.Token
derivedETH =
    Object.selectionForField "(Maybe ScalarCodecs.BigDecimal)" "derivedETH" [] (UniSwapGraph.ScalarCodecs.codecs |> UniSwapGraph.Scalar.unwrapCodecs |> .codecBigDecimal |> .decoder |> Decode.nullable)


type alias MostLiquidPairsOptionalArguments =
    { skip : OptionalArgument Int
    , first : OptionalArgument Int
    , orderBy : OptionalArgument UniSwapGraph.Enum.PairDayData_orderBy.PairDayData_orderBy
    , orderDirection : OptionalArgument UniSwapGraph.Enum.OrderDirection.OrderDirection
    , where_ : OptionalArgument UniSwapGraph.InputObject.PairDayData_filter
    }


mostLiquidPairs :
    (MostLiquidPairsOptionalArguments -> MostLiquidPairsOptionalArguments)
    -> SelectionSet decodesTo UniSwapGraph.Object.PairDayData
    -> SelectionSet (List (Maybe decodesTo)) UniSwapGraph.Object.Token
mostLiquidPairs fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { skip = Absent, first = Absent, orderBy = Absent, orderDirection = Absent, where_ = Absent }

        optionalArgs =
            [ Argument.optional "skip" filledInOptionals.skip Encode.int, Argument.optional "first" filledInOptionals.first Encode.int, Argument.optional "orderBy" filledInOptionals.orderBy (Encode.enum UniSwapGraph.Enum.PairDayData_orderBy.toString), Argument.optional "orderDirection" filledInOptionals.orderDirection (Encode.enum UniSwapGraph.Enum.OrderDirection.toString), Argument.optional "where" filledInOptionals.where_ UniSwapGraph.InputObject.encodePairDayData_filter ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "mostLiquidPairs" optionalArgs object_ (identity >> Decode.nullable >> Decode.list)
