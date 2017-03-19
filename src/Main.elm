module Main exposing (..)

import Navigation
import Task
import Time
import Parsing
import Views
import Views.AlertList.Updates exposing (updateFilter)
import Types exposing (..)
import Utils.Types exposing (..)
import Views.SilenceList.Updates
import Status.Types exposing (StatusModel)
import Updates exposing (update)


main : Program Never Model Msg
main =
    Navigation.program urlUpdate
        { init = init
        , update = update
        , view = Views.view
        , subscriptions = subscriptions
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            Parsing.urlParser location

        filter =
            case route of
                AlertsRoute alertsRoute ->
                    updateFilter alertsRoute

                SilencesRoute silencesRoute ->
                    Views.SilenceList.Updates.updateFilter silencesRoute

                _ ->
                    nullFilter

        ( model, msg ) =
            update (urlUpdate location) (Model Loading Loading Loading route filter 0 (StatusModel Nothing))
    in
        model ! [ msg, Task.perform UpdateCurrentTime Time.now ]


urlUpdate : Navigation.Location -> Msg
urlUpdate location =
    let
        route =
            Parsing.urlParser location
    in
        case route of
            SilencesRoute silencesRoute ->
                NavigateToSilences silencesRoute

            AlertsRoute alertsRoute ->
                NavigateToAlerts alertsRoute

            StatusRoute ->
                NavigateToStatus

            _ ->
                -- TODO: 404 page
                RedirectAlerts



-- SUBSCRIPTIONS
-- TODO: Poll API for changes.


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
