module Views.SilenceList.Types exposing (..)

import Silences.Types exposing (Silence)
import Utils.Types exposing (Time, Duration, Matcher, Filter, ApiData, ApiResponse(..))
import Time

type Route

    = ShowSilences (Maybe String)
    | ShowNewSilence
    | ShowSilence String
    | ShowEditSilence String


type OutMsg
    = UpdateFilter Filter String
    | UpdateCurrentTime Time.Time
    | PreviewSilence Silence


type SilencesMsg
    = DeleteMatcher Silence Matcher
    | AddMatcher Silence
    | UpdateMatcherName Silence Matcher String
    | UpdateMatcherValue Silence Matcher String
    | UpdateMatcherRegex Silence Matcher Bool
    | UpdateEndsAt Silence String
    | UpdateDuration Silence String
    | UpdateStartsAt Silence String
    | UpdateCreatedBy Silence String
    | UpdateComment Silence String
    | NewDefaultTimeRange Time.Time
    | SilenceCreate (ApiData String)
    | SilenceDestroy (ApiData String)
    | CreateSilence Silence
    | DestroySilence Silence
    | FilterSilences
    | SilenceFetch (ApiData Silence)
    | SilencesFetch (ApiData (List Silence))
    | FetchSilences
    | FetchSilence String
    | NewSilence


