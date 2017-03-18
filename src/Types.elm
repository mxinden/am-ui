module Types exposing (Model, Msg(..), Route(..))

import Alerts.Types exposing (AlertGroup, Alert)
import Views.AlertList.Types exposing (AlertListMsg)
import Silences.Types exposing (SilencesMsg, Silence)
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
    | NavigateToSilences Silences.Types.Route
    | NavigateToStatus
    | Alerts AlertListMsg
    | Silences SilencesMsg
    | RedirectAlerts
    | NewUrl String
    | Noop
    | UpdateCurrentTime Time.Time
    | MsgForStatus StatusMsg
    | MsgForAlerts AlertListMsg


type Route
    = SilencesRoute Silences.Types.Route
    | AlertsRoute Views.AlertList.Types.Route
    | StatusRoute
    | TopLevel
    | NotFound
