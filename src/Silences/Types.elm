module Silences.Types exposing (..)


import ISO8601
import Http


type alias Time =
    { t : ISO8601.Time
    , s : String
    , valid : Bool
    }


type alias Silence =
    { id : Int
    , createdBy : String
    , comment : String
    , startsAt : Time
    , endsAt : Time
    , createdAt : Time
    , matchers : List Matcher
    }


type alias Matcher =
    { name : String
    , value : String
    , isRegex : Bool
    }


type Msg
    = UpdateMatcherName Silence Matcher String
    | UpdateMatcherValue Silence Matcher String
    | UpdateMatcherRegex Silence Matcher Bool
    | DeleteMatcher Silence Matcher
    | AddMatcher Silence
    | UpdateEndsAt Silence String
    | UpdateStartsAt Silence String
    | UpdateCreatedBy Silence String
    | UpdateComment Silence String
    | CreateSilence Silence
    | SilenceFetch (Result Http.Error Silence)
    | SilencesFetch (Result Http.Error (List Silence))
    | SilenceCreate (Result Http.Error Int)
    | SilenceDestroy (Result Http.Error Int)
    | FetchSilences
    | FetchSilence Int
    | NewSilence
    | EditSilence Int
    | DestroySilence Silence
    | Noop (List Matcher)
