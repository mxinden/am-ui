module Updates exposing (update)

import Alerts.Api
import Views.AlertList.Updates
import Navigation
import Silences.Types exposing (nullSilence)
import Silences.Api exposing (getSilence)
import Views.SilenceList.Updates
import Views.Silence.Types exposing (SilenceMsg(SilenceFetched))
import Views.SilenceForm.Types exposing (SilenceFormMsg(NewSilence, FetchSilence))
import Views.SilenceForm.Updates
import Views.Silence.Updates
import Status.Api exposing (getStatus)
import Status.Update
import Task
import Types exposing ( Msg(..), Model, Route(AlertsRoute, SilenceListRoute, StatusRoute, SilenceRoute, SilenceFormEditRoute, SilenceFormNewRoute))
import Utils.List
import Utils.Types
    exposing
        ( ApiResponse(Loading, Failure, Success)
        , Matcher
        , nullFilter
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CreateSilenceFromAlert alert ->
            let
                silence =
                    { nullSilence | matchers = (List.map (\( k, v ) -> Matcher k v False) alert.labels) }
            in
                ( { model | silence = Success silence }, Cmd.none )

        PreviewSilence silence ->
            let
                s =
                    { silence | silencedAlertGroups = Loading }

                filter =
                    { nullFilter | text = Just <| Utils.List.mjoin s.matchers }
            in
                ( { model | silence = Success silence }, Alerts.Api.alertPreview filter )

        AlertGroupsPreview alertGroups ->
            let
                silence =
                    case model.silence of
                        Success sil ->
                            Success { sil | silencedAlertGroups = alertGroups }

                        Failure e ->
                            Failure e

                        Loading ->
                            Loading
            in
                ( { model | silence = silence }, Cmd.none )

        NavigateToAlerts alertsRoute ->
            let
                ( alertsMsg, filter ) =
                    (Views.AlertList.Updates.urlUpdate alertsRoute)

                ( alertGroups, cmd) =
                    Views.AlertList.Updates.update alertsMsg model.alertGroups filter
            in
                ( { model | alertGroups = alertGroups, route = AlertsRoute alertsRoute, filter = filter }, cmd)

        Alerts alertsMsg ->
            let
                ( alertGroups, cmd) =
                    Views.AlertList.Updates.update alertsMsg model.alertGroups model.filter
            in
                ( { model | alertGroups = alertGroups }, cmd)

        NavigateToSilenceList maybeFilter ->
            let
                ( silencesMsg, filter ) =
                    (Views.SilenceList.Updates.urlUpdate maybeFilter)

                ( silences, silence, cmd) =
                    Views.SilenceList.Updates.update silencesMsg model.silences model.silence filter
            in
                ( { model | silence = silence, silences = silences, route = SilenceListRoute maybeFilter, filter = filter }
                , cmd
                )

        NavigateToStatus ->
            ( { model | route = StatusRoute }, getStatus )

        NavigateToSilence silenceId->
            ( { model | route = (SilenceRoute silenceId)}, getSilence silenceId (SilenceFetched >> MsgForSilence) )

        NavigateToSilenceFormNew ->
            ({model | route = SilenceFormNewRoute}, Task.perform identity (Task.succeed <| ( MsgForSilenceForm NewSilence)))

        NavigateToSilenceFormEdit uuid ->
            ( {model | route = SilenceFormEditRoute uuid }, Task.perform identity (Task.succeed <| (FetchSilence uuid |> MsgForSilenceForm)))

        Silences silencesMsg ->
            let
                ( silences, silence, cmd) =
                    Views.SilenceList.Updates.update silencesMsg model.silences model.silence model.filter
            in
                ( { model | silences = silences, silence = silence }
                , cmd
                )

        RedirectAlerts ->
            ( model, Task.perform NewUrl (Task.succeed "/#/alerts") )

        UpdateFilter filter text ->
            let
                t =
                    if text == "" then
                        Nothing
                    else
                        Just text
            in
                ( { model | filter = { filter | text = t } }, Cmd.none )

        NewUrl url ->
            ( model, Navigation.newUrl url )

        Noop ->
            ( model, Cmd.none )

        UpdateCurrentTime time ->
            ( { model | currentTime = time }, Cmd.none )

        MsgForStatus msg ->
            let
                ( status, cmd ) =
                    Status.Update.update msg model.status
            in
                ( { model | status = status }, cmd )
        MsgForAlertList msg ->
            let
                (alertGroups, cmd) =
                    Views.AlertList.Updates.update msg model.alertGroups model.filter
            in
                ({model | alertGroups = alertGroups}, cmd)
        MsgForSilenceList msg ->
            let
                (silences, silence, cmd) =
                    Views.SilenceList.Updates.update msg model.silences model.silence model.filter
            in
                ({model | silences = silences, silence = silence }, cmd)
        MsgForSilence msg ->
            Views.Silence.Updates.update msg model

        MsgForSilenceForm msg ->
            Views.SilenceForm.Updates.update msg model
