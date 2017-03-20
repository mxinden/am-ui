module Views exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class)
import Types exposing (Msg, Model, Route(..))
import Utils.Types exposing (ApiResponse(..))
import Utils.Views exposing (error, loading)
import Views.SilenceList.Views
import Views.SilenceForm.Views
import Views.AlertList.Views
import Views.Silence.Views
import Views.NotFound.Views
import Views.Status.Views
import NavBar.Views exposing (appHeader)


view : Model -> Html Msg
view model =
    div []
        [ appHeader links
        , div [ class "pt6 w-80 center pa3" ]
            [ appBody model ]
        ]


links : List ( String, String )
links =
    [ ( "#", "AlertManager" )
    , ( "#/alerts", "Alerts" )
    , ( "#/silences", "Silences" )
    , ( "#/status", "Status" )
    ]


appBody : Model -> Html Msg
appBody model =
    case model.route of
        StatusRoute ->
            Views.Status.Views.view model

        SilenceRoute silenceId ->
            Views.Silence.Views.view model

        AlertsRoute route ->
            case model.alertGroups of
                Success alertGroups ->
                    Views.AlertList.Views.view route alertGroups model.filter (text "")

                Loading ->
                    loading

                Failure msg ->
                    Views.AlertList.Views.view route [] model.filter (error msg)

        SilenceListRoute route ->
            Views.SilenceList.Views.view model.silences model.silence model.currentTime model.filter

        SilenceFormNewRoute ->
            Views.SilenceForm.Views.newForm model

        SilenceFormEditRoute silenceId ->
            Views.SilenceForm.Views.editForm model

        TopLevelRoute ->
            Utils.Views.loading

        NotFoundRoute ->
            Views.NotFound.Views.view
