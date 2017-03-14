module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (Error(..))
import Types exposing (..)
import Utils.Types exposing (ApiResponse(..))
import Translators exposing (alertTranslator, silenceTranslator)
import Silences.Views
import Silences.Types
import Alerts.Views
import NavBar.Views exposing (appHeader)


view : Model -> Html Msg
view model =
    div []
        [ appHeader model
        , div [ class "pt6 w-80 center pa3" ]
            [ appBody model ]
        ]

appBody : Model -> Html Msg
appBody model =
    case model.route of
        AlertsRoute route ->
            case model.alertGroups of
                Success alertGroups ->
                    Html.map alertTranslator (Alerts.Views.view route alertGroups model.filter (text ""))

                Loading ->
                    loading

                Failure msg ->
                    Html.map alertTranslator (Alerts.Views.view route [] model.filter (error msg))

        NewSilenceRoute ->
            case model.silence of
                Success silence ->
                    Html.map silenceTranslator (Silences.Views.silenceForm "New" silence)

                Loading ->
                    loading

                Failure msg ->
                    error msg

        EditSilenceRoute id ->
            case model.silence of
                Success silence ->
                    Html.map silenceTranslator (Silences.Views.silenceForm "Edit" silence)

                Loading ->
                    loading

                Failure msg ->
                    error msg

        SilencesRoute _ ->
            -- Add buttons at the top to filter Active/Pending/Expired
            case model.silences of
                Success silences ->
                    Html.map silenceTranslator (Silences.Views.silences silences model.filter)

                Loading ->
                    loading

                Failure msg ->
                    error msg

        SilenceRoute name ->
            case model.silence of
                Success silence ->
                    Html.map silenceTranslator (Silences.Views.silence silence)

                Loading ->
                    loading

                Failure msg ->
                    error msg

        _ ->
            notFoundView model


loading : Html msg
loading =
    div []
        [ i [ class "fa fa-cog fa-spin fa-3x fa-fw" ] []
        , span [ class "sr-only" ] [ text "Loading..." ]
        ]


notFoundView : a -> Html msg
notFoundView model =
    div []
        [ h1 [] [ text "not found" ]
        ]


error : Http.Error -> Html msg
error err =
    let
        msg =
            case err of
                Timeout ->
                    "timeout exceeded"

                NetworkError ->
                    "network error"

                BadStatus resp ->
                    resp.status.message ++ " " ++ resp.body

                BadPayload err resp ->
                    -- OK status, unexpected payload
                    "unexpected response from api"

                BadUrl url ->
                    "malformed url: " ++ url
    in
        div []
            [ p [] [ text <| "Error: " ++ msg ]
            ]
