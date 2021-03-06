module Types exposing (..)

import Array exposing (Array)
import BigInt exposing (BigInt)
import Browser
import Browser.Navigation
import Config
import Contracts.BucketSale.Generated.BucketSale exposing (currentBucket)
import Contracts.BucketSale.Wrappers as BucketSaleWrappers
import Css exposing (calc)
import Dict exposing (Dict)
import Eth.Sentry.Event as EventSentry exposing (EventSentry)
import Eth.Sentry.Tx as TxSentry exposing (TxSentry)
import Eth.Sentry.Wallet as WalletSentry exposing (WalletSentry)
import Eth.Types exposing (Address, Hex, Tx, TxHash, TxReceipt)
import Eth.Utils
import FormatFloat exposing (autoFormatFloat)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Helpers.Element as EH
import Helpers.Time as TimeHelpers
import Html.Attributes exposing (required)
import Http
import Json.Decode exposing (Decoder, field, float, int, map3)
import Json.Encode
import List.Extra
import Random exposing (Seed)
import Time
import TokenValue exposing (TokenValue)
import UniSwapGraph.Object exposing (..)
import UniSwapGraph.Object.Bundle as Bundle
import UniSwapGraph.Object.Token as Token
import UniSwapGraph.Query as Query
import UniSwapGraph.Scalar exposing (Id(..))
import UniSwapGraph.ScalarCodecs exposing (..)
import Url exposing (Url)


type alias Flags =
    { basePath : String
    , networkId : Int
    , width : Int
    , height : Int
    , nowInMillis : Int
    }


type alias Model =
    { currentTime : Int
    , currentBucketId : Int
    , currentBucketTotalEntered : TokenValue
    , currentEthPriceUsd : Float
    , currentDaiPriceEth : Float
    , currentFryPriceEth : Float
    , circSupply : Float
    , marketCap : Float
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | Tick Time.Posix
    | Resize Int Int
    | BucketValueEnteredFetched Int (Result Http.Error TokenValue)
    | FetchedEthPrice (Result (Graphql.Http.Error (Maybe Value)) (Maybe Value))
    | FetchedDaiPrice (Result (Graphql.Http.Error (Maybe Value)) (Maybe Value))
    | FetchedFryPrice (Result (Graphql.Http.Error (Maybe Value)) (Maybe Value))
    | NoOp


type alias Value =
    { ethPrice : Float
    }


resultBundle : SelectionSet Value UniSwapGraph.Object.Bundle
resultBundle =
    SelectionSet.map Value
        (Bundle.ethPrice
            |> SelectionSet.map
                (\(UniSwapGraph.Scalar.BigDecimal dec) ->
                    String.toFloat dec
                        |> Maybe.withDefault 0
                )
        )


resultToken : SelectionSet Value UniSwapGraph.Object.Token
resultToken =
    SelectionSet.map Value
        (Token.derivedETH
            |> SelectionSet.map
                (\(UniSwapGraph.Scalar.BigDecimal dec) ->
                    String.toFloat dec
                        |> Maybe.withDefault 0
                )
        )


fetchEthPrice : Cmd Msg
fetchEthPrice =
    Query.bundle identity { id = Id "1" } resultBundle
        |> Graphql.Http.queryRequest Config.uniswapGraphQL
        |> Graphql.Http.send FetchedEthPrice


fetchDaiPrice : Cmd Msg
fetchDaiPrice =
    Query.token identity
        { id =
            Id <|
                Eth.Utils.addressToString Config.daiContractAddress
        }
        resultToken
        |> Graphql.Http.queryRequest Config.uniswapGraphQL
        |> Graphql.Http.send FetchedDaiPrice


fetchFryPrice : Cmd Msg
fetchFryPrice =
    Query.token identity
        { id =
            Id <|
                Eth.Utils.addressToString Config.fryTokenAddress
        }
        resultToken
        |> Graphql.Http.queryRequest Config.uniswapGraphQL
        |> Graphql.Http.send FetchedFryPrice


getCurrentBucketId : Int -> Int
getCurrentBucketId now =
    (TimeHelpers.sub (Time.millisToPosix now) (Time.millisToPosix Config.saleStarted)
        |> TimeHelpers.posixToSeconds
    )
        // (Config.bucketSaleBucketInterval
                |> TimeHelpers.posixToSeconds
           )


getBucketRemainingTimeText : Int -> Int -> String
getBucketRemainingTimeText bucketId now =
    TimeHelpers.toHumanReadableString
        (TimeHelpers.sub
            (getBucketEndTime bucketId)
            (Time.millisToPosix now)
        )


getBucketStartTime : Int -> Time.Posix
getBucketStartTime bucketId =
    Time.millisToPosix
        (Config.saleStarted + (bucketId * Time.posixToMillis Config.bucketSaleBucketInterval))


getBucketEndTime : Int -> Time.Posix
getBucketEndTime bucketId =
    TimeHelpers.add
        (getBucketStartTime bucketId)
        Config.bucketSaleBucketInterval


calcEffectivePricePerToken : TokenValue -> Float -> TokenValue
calcEffectivePricePerToken totalValueEntered tokenValue =
    let
        ve =
            totalValueEntered
                |> TokenValue.toFloatWithWarning

        tpb =
            Config.bucketSaleTokensPerBucket
                |> TokenValue.toFloatWithWarning
    in
    (ve * tokenValue / tpb)
        |> TokenValue.fromFloatWithWarning


fetchTotalValueEnteredCmd : Int -> Cmd Msg
fetchTotalValueEnteredCmd id =
    BucketSaleWrappers.getTotalValueEnteredForBucket
        id
        (BucketValueEnteredFetched id)


calcCircSupply : Model -> Float
calcCircSupply model =
    (Config.bucketSaleTokensPerBucket
        |> TokenValue.toFloatWithWarning
    )
        * (model.currentBucketId
            |> toFloat
          )


calcMarketCap : Model -> Float
calcMarketCap model =
    calcCircSupply model
        * model.currentFryPriceEth
        * model.currentEthPriceUsd
