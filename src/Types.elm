module Types exposing (Model, Msg(..), Route(..))

import Alerts.Types exposing (AlertGroup, Alert)
import Views.AlertList.Types exposing (AlertListMsg)
import Views.SilenceList.Types exposing (SilencesMsg)
import Views.Silence.Types exposing (SilenceMsg)
import Silences.Types exposing (Silence)
import Status.Types exposing (StatusModel, StatusMsg)
import Utils.Types exposing (ApiData, Filter)
import Time


type alias Model =
    { silences : ApiData (List Silence)
    , silence : ApiData Silence
    , alertGroups : ApiData (List AlertGroup)
    , route : Route
    , filter : Filter
    , currentTime : Time.Time
    , status : StatusModel
    }


type Msg
    = CreateSilenceFromAlert Alert
    | PreviewSilence Silence
    | AlertGroupsPreview (ApiData (List AlertGroup))
    | UpdateFilter Filter String
    | NavigateToAlerts Views.AlertList.Types.Route
    | NavigateToSilences Views.SilenceList.Types.Route
    | NavigateToStatus
    | NavigateToSilence String
    | Alerts AlertListMsg
    | Silences SilencesMsg
    | RedirectAlerts
    | NewUrl String
    | Noop
    | UpdateCurrentTime Time.Time
    | MsgForStatus StatusMsg
    | MsgForAlertList AlertListMsg
    | MsgForSilenceList SilencesMsg
    | MsgForSilence SilenceMsg


type Route
    = SilencesRoute Views.SilenceList.Types.Route
    | AlertsRoute Views.AlertList.Types.Route
    | SilenceRoute String
    | StatusRoute
    | TopLevel
    | NotFound
