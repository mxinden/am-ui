module Types exposing (Model, Msg(..), Route(..))

import Alerts.Types exposing (AlertGroup, Alert)
import Views.AlertList.Types exposing (AlertListMsg)
import Views.SilenceList.Types exposing (SilenceListMsg)
import Views.Silence.Types exposing (SilenceMsg)
import Views.SilenceForm.Types exposing (SilenceFormMsg)
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
    | NavigateToSilenceList (Maybe String)
    | NavigateToStatus
    | NavigateToSilence String
    | NavigateToSilenceFormNew
    | NavigateToSilenceFormEdit String
    | NavigateToNotFound
    | Alerts AlertListMsg
    | Silences SilenceListMsg
    | RedirectAlerts
    | NewUrl String
    | Noop
    | UpdateCurrentTime Time.Time
    | MsgForStatus StatusMsg
    | MsgForAlertList AlertListMsg
    | MsgForSilenceList SilenceListMsg
    | MsgForSilence SilenceMsg
    | MsgForSilenceForm SilenceFormMsg


type Route
    = SilenceListRoute (Maybe String)
    | AlertsRoute Views.AlertList.Types.Route
    | SilenceRoute String
    | SilenceFormNewRoute
    | SilenceFormEditRoute String
    | StatusRoute
    | TopLevelRoute
    | NotFoundRoute
