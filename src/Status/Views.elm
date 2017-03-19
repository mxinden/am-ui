module Status.Views exposing (view)

import Html exposing (Html, text, button, div, li, ul, b)
import Status.Types exposing  (StatusResponse)
import Types exposing (Msg(MsgForStatus), Model)


view : Model -> Html Types.Msg
view model =
    ul []
        [ li []
            [ b [] [ text "Status: " ], text (getStatus model.status.response) ]
        , li []
            [ b [] [ text "Uptime: " ], text (getUptime model.status.response) ]
        ]


getStatus : Maybe StatusResponse -> String
getStatus maybeResponse =
    case maybeResponse of
        Nothing ->
            "No status information available"

        Just response ->
            response.status


getUptime : Maybe StatusResponse -> String
getUptime maybeResponse =
    case maybeResponse of
        Nothing ->
            "No version information available"

        Just response ->
            response.uptime
