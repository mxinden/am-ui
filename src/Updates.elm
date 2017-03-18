module Updates exposing (update)

import Alerts.Api
import Alerts.Update
import Navigation
import Silences.Types exposing (nullSilence)
import Silences.Update
import Status.Api exposing (getStatus)
import Status.Update
import Task
import Translators exposing ( silenceTranslator)
import Types
    exposing
        ( Msg
            ( AlertGroupsPreview
            , Alerts
            , CreateSilenceFromAlert
            , MsgForAlerts
            , MsgForStatus
            , NavigateToAlerts
            , NavigateToSilences
            , NavigateToStatus
            , NewUrl
            , Noop
            , PreviewSilence
            , RedirectAlerts
            , Silences
            , UpdateCurrentTime
            , UpdateFilter
            )
        , Model
        , Route(AlertsRoute, SilencesRoute, StatusRoute)
        )
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
                    (Alerts.Update.urlUpdate alertsRoute)

                ( alertGroups, cmd) =
                    Alerts.Update.update alertsMsg model.alertGroups filter
            in
                ( { model | alertGroups = alertGroups, route = AlertsRoute alertsRoute, filter = filter }, cmd)

        Alerts alertsMsg ->
            let
                ( alertGroups, cmd) =
                    Alerts.Update.update alertsMsg model.alertGroups model.filter
            in
                ( { model | alertGroups = alertGroups }, cmd)

        NavigateToSilences silencesRoute ->
            let
                ( silencesMsg, filter ) =
                    (Silences.Update.urlUpdate silencesRoute)

                ( silences, silence, silencesCmd ) =
                    Silences.Update.update silencesMsg model.silences model.silence filter
            in
                ( { model | silence = silence, silences = silences, route = SilencesRoute silencesRoute, filter = filter }
                , Cmd.map silenceTranslator silencesCmd
                )

        NavigateToStatus ->
            ( { model | route = StatusRoute }, getStatus )

        Silences silencesMsg ->
            let
                ( silences, silence, silencesCmd ) =
                    Silences.Update.update silencesMsg model.silences model.silence model.filter
            in
                ( { model | silences = silences, silence = silence }
                , Cmd.map silenceTranslator silencesCmd
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
        MsgForAlerts msg ->
            let
                (alertGroups, cmd) =
                    Alerts.Update.update msg model.alertGroups model.filter
            in
                ({model | alertGroups = alertGroups}, cmd)
