module Types exposing (..)

-- External Imports

import Http exposing (Error)
import Time
import ISO8601


-- Internal Imports

import Silences.Types exposing (Silence, Matcher)


-- Types


type alias Model =
    { silences : List Silence
    , silence : Silence
    , alertGroups : List AlertGroup
    , route : Route
    , error : String
    , loading : Bool
    }


type alias AlertGroup =
    { blocks : List Block
    , labels : List ( String, String )
    }


type alias Alert =
    { annotations : List ( String, String )
    , labels : List ( String, String )
    , inhibited : Bool
    , silenceId : Maybe Int
    , silenced : Bool
    , startsAt : ISO8601.Time
    , generatorUrl : String
    }


type alias Block =
    { alerts : List Alert
    , routeOpts : RouteOpts
    }


type alias RouteOpts =
    { receiver : String }


type Msg
    = AlertGroupsFetch (Result Http.Error (List AlertGroup))
    | FetchAlertGroups
    | RedirectAlerts
    | SilenceFromAlert (List Matcher)
    | NewDefaultTimeRange Time.Time
    | UpdateForm Silences.Types.Msg
    | Noop


type Route
    = SilencesRoute
    | NewSilenceRoute
    | SilenceRoute Int
    | EditSilenceRoute Int
    | AlertGroupsRoute
    | TopLevel
    | NotFound
