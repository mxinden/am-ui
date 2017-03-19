module Views.Silence.Types exposing (SilenceMsg(..))

import Silences.Types exposing (Silence)
import Utils.Types exposing (ApiData)

type SilenceMsg
    = FetchSilence String
    | SilenceFetched (ApiData Silence)
