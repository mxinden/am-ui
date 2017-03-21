module Views exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class)
import Types exposing (Msg, Model, Route(..))
import Utils.Types exposing (ApiResponse(..))
import Utils.Views exposing (error, loading)
import Views.SilenceList.Views as SilenceList
import Views.SilenceForm.Views as SilenceForm
import Views.AlertList.Views as AlertList
import Views.Silence.Views as Silence
import Views.NotFound.Views as NotFound
import Views.Status.Views as Status
import Views.NavBar.Views exposing (appHeader)


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
            Status.view model

        SilenceRoute silenceId ->
            Silence.view model

        AlertsRoute route ->
            case model.alertGroups of
                Success alertGroups ->
                   AlertList.view route alertGroups model.filter (text "")

                Loading ->
                    loading

                Failure msg ->
                    AlertList.view route [] model.filter (error msg)

        SilenceListRoute route ->
            SilenceList.view model.silences model.silence model.currentTime model.filter

        SilenceFormNewRoute ->
            SilenceForm.newForm model

        SilenceFormEditRoute silenceId ->
            SilenceForm.editForm model

        TopLevelRoute ->
            Utils.Views.loading

        NotFoundRoute ->
            NotFound.view
