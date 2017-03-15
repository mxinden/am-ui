module Types exposing (..)

-- External Imports

import Alerts.Types exposing (AlertGroup, AlertsMsg, Alert)
import Silences.Types exposing (SilencesMsg, Silence)
import ISO8601
import Time
import Utils.Types exposing (ApiData, Filter)
import Material


-- Internal Imports
-- Types


type alias Model =
    { silences : ApiData (List Silence)
    , silence : ApiData Silence
    , alertGroups : ApiData (List AlertGroup)
    , route : Route
    , filter : Filter
    , currentTime : ISO8601.Time
    , mdl : Material.Model
    }


type Msg
    = CreateSilenceFromAlert Alert
    | UpdateFilter Filter String
    | NavigateToAlerts Alerts.Types.Route
    | NavigateToSilences Silences.Types.Route
    | Alerts AlertsMsg
    | Silences SilencesMsg
    | RedirectAlerts
    | NewUrl String
    | Noop
    | UpdateCurrentTime Time.Time
    | Mdl (Material.Msg Msg)


type Route
    = SilencesRoute Silences.Types.Route
    | AlertsRoute Alerts.Types.Route
    | TopLevel
    | NotFound
