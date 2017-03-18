module Views exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class)
import Types exposing (Msg, Model, Route(SilencesRoute, AlertsRoute, StatusRoute))
import Utils.Types exposing (ApiResponse(..))
import Utils.Views exposing (error, loading, notFoundView)
import Silences.Views
import Views.AlertList.Views
import Status.Views
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
            Status.Views.view model

        AlertsRoute route ->
            case model.alertGroups of
                Success alertGroups ->
                    Views.AlertList.Views.view route alertGroups model.filter (text "")

                Loading ->
                    loading

                Failure msg ->
                    Views.AlertList.Views.view route [] model.filter (error msg)

        SilencesRoute route ->
            Silences.Views.view route model.silences model.silence model.currentTime model.filter

        _ ->
            notFoundView model
