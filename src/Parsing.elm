module Parsing exposing (..)

import Views.AlertList.Parsing exposing (alertsParser)
import Views.SilenceList.Parsing exposing (silenceListParser)
import Views.Silence.Parsing exposing (silenceParser)
import Views.SilenceForm.Parsing exposing (silenceFormNewParser, silenceFormEditParser)
import Status.Parsing exposing (statusParser)
import Navigation
import UrlParser exposing ((</>), (<?>), Parser, int, map, oneOf, parseHash, s, string, stringParam, top)
import Regex
import Types exposing (Route(..))



urlParser : Navigation.Location -> Route
urlParser location =
    let
        -- Parse a query string occurring after the hash if it exists, and use
        -- it for routing.
        hashAndQuery =
            Regex.split (Regex.AtMost 1) (Regex.regex "\\?") (location.hash)

        hash =
            case List.head hashAndQuery of
                Just hash ->
                    hash

                Nothing ->
                    ""

        query =
            if List.length hashAndQuery == 2 then
                case List.head <| List.reverse hashAndQuery of
                    Just query ->
                        "?" ++ query

                    Nothing ->
                        ""
            else
                ""
    in
        case parseHash routeParser { location | search = query, hash = hash } of
            Just route ->
                route

            Nothing ->
                Debug.log "inside nothing!" NotFoundRoute



routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map SilenceListRoute silenceListParser
        , map StatusRoute statusParser
        , map SilenceRoute silenceParser
        , map SilenceFormEditRoute silenceFormEditParser
        , map SilenceFormNewRoute silenceFormNewParser
        , map AlertsRoute alertsParser
        , map TopLevelRoute top
        ]
