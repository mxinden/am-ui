module Views.SilenceList.Types exposing (..)

import Silences.Types exposing (Silence)
import Utils.Types exposing (Time, Duration, Matcher, Filter, ApiData, ApiResponse(..))

type Route

    = ShowSilences (Maybe String)




type SilencesMsg
    = SilenceDestroy (ApiData String)
    | DestroySilence Silence
    | FilterSilences
    | SilencesFetch (ApiData (List Silence))
    | FetchSilences


