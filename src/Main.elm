module Main exposing (..)

-- External Imports

import Date
import Navigation
import Task
import Time
import ISO8601


-- Internal Imports

import Parsing
import Views
import Api
import Types exposing (..)
import Utils.List
import Utils.Date
import Silences.Api


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
    in
        update (urlUpdate location) (Model [] nullSilence [] route "" True)


nullSilence : Silence
nullSilence =
    Silence 0 "" "" nullTime nullTime nullTime [ nullMatcher ]


nullMatcher : Matcher
nullMatcher =
    Matcher "" "" False


nullTime : Types.Time
nullTime =
    let
        epochString =
            ISO8601.toString Utils.Date.unixEpochStart
    in
        Types.Time Utils.Date.unixEpochStart epochString True


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- HTTP Result messages
        SilencesFetch (Ok silences) ->
            ( { model | silences = silences, loading = False }, Cmd.none )

        SilencesFetch (Err _) ->
            ( { model | route = NotFound, loading = False }, Cmd.none )

        SilenceFetch (Ok silence) ->
            ( { model | silence = silence, loading = False }, Cmd.none )

        SilenceFetch (Err _) ->
            -- show the error somehow
            ( { model | route = NotFound }, Cmd.none )

        SilenceCreate (Ok id) ->
            ( { model | silence = nullSilence, route = SilenceRoute id }, Navigation.newUrl ("/#/silences/" ++ toString id) )

        SilenceCreate (Err err) ->
            ( { model | silence = nullSilence, route = SilencesRoute }, Navigation.newUrl "/#/silences" )

        SilenceDestroy (Ok id) ->
            -- TODO: "Deleted id: ID" growl
            -- TODO: Add DELETE to accepted CORS methods in alertmanager
            -- TODO: Check why POST isn't there but is accepted
            ( { model | route = SilencesRoute }, Navigation.newUrl "/#/silences" )

        SilenceDestroy (Err err) ->
            -- TODO: Add error to the message or something.
            ( { model | route = SilencesRoute, error = "Failed to destroy silence" }, Navigation.newUrl "/#/silences" )

        AlertGroupsFetch (Ok alertGroups) ->
            ( { model | alertGroups = alertGroups, loading = False }, Cmd.none )

        AlertGroupsFetch (Err err) ->
            ( { model | route = NotFound, loading = False }, Cmd.none )

        -- API interaction messages
        FetchSilences ->
            ( { model | silence = nullSilence, route = SilencesRoute, loading = True }, Silences.Api.getSilences )

        FetchSilence id ->
            ( { model | route = SilenceRoute id, loading = True }, Silences.Api.getSilence id )

        EditSilence id ->
            -- Look into setting the silence if we're moving from the list to
            -- edit view, so that there's no pause for users navigating around.
            ( { model | route = EditSilenceRoute id, loading = True }, Silences.Api.getSilence id )

        CreateSilence silence ->
            ( model, Silences.Api.create silence )

        FetchAlertGroups ->
            ( { model | silence = nullSilence, route = AlertGroupsRoute }, Api.getAlertGroups )

        NewSilence ->
            ( { model | route = NewSilenceRoute, loading = False }, (Task.perform NewDefaultTimeRange Time.now) )

        SilenceFromAlert matchers ->
            let
                s =
                    { nullSilence | matchers = List.sortBy .name matchers }
            in
                ( { model | silence = s }, (Task.perform NewDefaultTimeRange Time.now) )

        RedirectAlerts ->
            ( { model | route = AlertGroupsRoute }, Navigation.newUrl "/#/alerts" )

        -- New silence form messages
        UpdateStartsAt time ->
            -- TODO:
            -- Update silence to hold datetime as string, on each pass through
            -- here update an error message "this is invalid", but let them put
            -- it in anyway.
            let
                sil =
                    model.silence

                startsAt =
                    Utils.Date.toISO8601Time time
            in
                ( { model | silence = { sil | startsAt = startsAt } }, Cmd.none )

        UpdateEndsAt time ->
            let
                sil =
                    model.silence

                endsAt =
                    Utils.Date.toISO8601Time time
            in
                ( { model | silence = { sil | endsAt = endsAt } }, Cmd.none )

        UpdateCreatedBy by ->
            let
                sil =
                    model.silence
            in
                ( { model | silence = { sil | createdBy = by } }, Cmd.none )

        UpdateComment comment ->
            let
                sil =
                    model.silence
            in
                ( { model | silence = { sil | comment = comment } }, Cmd.none )

        AddMatcher ->
            -- TODO: If a user adds two blank matchers and attempts to update
            -- one, both are updated because they are identical. Maybe add a
            -- unique identifier on creation so this doesn't happen.
            let
                sil =
                    model.silence
            in
                ( { model | silence = { sil | matchers = sil.matchers ++ [ Matcher "" "" False ] } }, Cmd.none )

        UpdateForm msg matcher val ->
            let
                matchers = Silences.Api.update msg matcher val
                s =
                    model.silence
            in
                ( { model | silence = { s | matchers = matchers } }, Cmd.none )

        NewDefaultTimeRange time ->
            let
                endsIso =
                    Utils.Date.addTime time (2 * Time.hour)

                endsAt =
                    Types.Time endsIso (ISO8601.toString endsIso) True

                startsIso =
                    Utils.Date.toISO8601 time

                startsAt =
                    Types.Time endsIso (ISO8601.toString startsIso) True

                s =
                    model.silence
            in
                ( { model | silence = { s | startsAt = startsAt, endsAt = endsAt } }, Cmd.none )

        Noop _ ->
            ( model, Cmd.none )


urlUpdate : Navigation.Location -> Msg
urlUpdate location =
    let
        route =
            Parsing.urlParser location
    in
        case route of
            SilencesRoute ->
                FetchSilences

            NewSilenceRoute ->
                NewSilence

            SilenceRoute id ->
                FetchSilence id

            EditSilenceRoute id ->
                EditSilence id

            AlertGroupsRoute ->
                FetchAlertGroups

            _ ->
                -- TODO: 404 page
                RedirectAlerts



-- SUBSCRIPTIONS
-- TODO: Poll API for changes.


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
