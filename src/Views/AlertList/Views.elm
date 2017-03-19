module Views.AlertList.Views exposing (view, compact)

import Alerts.Types exposing (Alert, AlertGroup, Block)
import Views.AlertList.Types exposing (Route(..), AlertListMsg(FilterAlerts))
import Views.AlertList.Filter exposing (silenced, receiver, matchers)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Utils.Date
import Utils.Types exposing (Filter)
import Utils.Views exposing (..)
import Types exposing (Msg(MsgForAlerts, Noop, CreateSilenceFromAlert))


view : Route -> List AlertGroup -> Filter -> Html Msg -> Html Msg
view route alertGroups filter errorHtml =
    let
        filteredGroups =
            case route of
                Receiver maybeReceiver maybeShowSilenced maybeFilter ->
                    receiver maybeReceiver alertGroups
                        |> silenced maybeShowSilenced

        filterText =
            Maybe.withDefault "" filter.text

        alertHtml =
            if List.isEmpty filteredGroups then
                div [ class "mt2" ] [ text "no alerts found found" ]
            else
                ul
                    [ classList
                        [ ( "list", True )
                        , ( "pa0", True )
                        ]
                    ]
                    (List.map alertGroupView filteredGroups)
    in
        div []
            [ textField "Filter" filterText (Types.UpdateFilter filter)
            , a [ class "f6 link br2 ba ph3 pv2 mr2 dib dark-red", onClick (MsgForAlerts FilterAlerts) ] [ text "Filter Alerts" ]
            , errorHtml
            , alertHtml
            ]


compact : AlertGroup -> Html msg
compact ag =
    let
        alerts =
            List.concatMap
                (\b ->
                    b.alerts
                )
                ag.blocks
    in
        ul
            [ class "list pa0"
            ]
            (List.indexedMap alertCompact alerts)


alertCompact : Int -> Alert -> Html msg
alertCompact idx alert =
    li [ class "mb2 w-80-l w-100-m" ]
        [ span [] [ text <| toString (idx + 1) ++ ". " ]
        , div [] (List.map labelButton alert.labels)
        ]


alertGroupView : AlertGroup -> Html Msg
alertGroupView alertGroup =
    li [ class "pa3 pa4-ns bb b--black-10" ]
        [ div [ class "mb3" ] (List.map alertHeader <| List.sort alertGroup.labels)
        , div [] (List.map blockView alertGroup.blocks)
        ]


blockView : Block -> Html Msg
blockView block =
    div [] (List.map alertView block.alerts)


alertView : Alert -> Html Msg
alertView alert =
    let
        id =
            case alert.silenceId of
                Just id ->
                    id

                Nothing ->
                    ""

        b =
            if alert.silenced then
                buttonLink "fa-deaf" ("#/silences/" ++ id) "blue" (Types.Noop)
            else
                buttonLink "fa-exclamation-triangle" "#/silences/new" "dark-red" (CreateSilenceFromAlert alert)
    in
        div [ class "f6 mb3" ]
            [ div [ class "mb1" ]
                [ b
                , buttonLink "fa-bar-chart" alert.generatorUrl "black" (Types.Noop)
                , p [ class "dib mr2" ] [ text <| Utils.Date.timeFormat alert.startsAt ]
                ]
            , div [ class "mb2 w-80-l w-100-m" ] (List.map labelButton <| List.filter (\( k, v ) -> k /= "alertname") alert.labels)
            ]


alertHeader : ( String, String ) -> Html Msg
alertHeader ( key, value ) =
    if key == "alertname" then
        b [ class "db f4 mr2 dark-red dib" ] [ text value ]
    else
        listButton "ph1 pv1" ( key, value )