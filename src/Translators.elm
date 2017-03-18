module Translators exposing (..)

import Silences.Types
import Silences.Translator
import Types exposing (Msg(Alerts, CreateSilenceFromAlert, Silences, UpdateFilter, NewUrl, UpdateCurrentTime, PreviewSilence, AlertGroupsPreview))



silenceTranslator : Silences.Types.Msg -> Msg
silenceTranslator =
    Silences.Translator.translator
        { onInternalMessage = Silences
        , onNewUrl = NewUrl
        , onUpdateFilter = UpdateFilter
        , onUpdateCurrentTime = UpdateCurrentTime
        , onPreviewSilence = PreviewSilence
        }
