module NavBar.Views exposing (viewHeader)

import Html exposing (Html, header, text, a, nav, i)
import Html.Attributes exposing (class, href, title)
import Material.Layout
import Material.Tabs
import Material.Icon
import Material.Color
import Types exposing (Msg(Mdl), Model, Route(AlertsRoute, SilencesRoute, NotFound))
import Silences.Types
import Alerts.Types
import List.Extra exposing (findIndex)


viewHeader : Model -> Html Msg
viewHeader model =
    Material.Layout.row [ Material.Color.background Material.Color.white ]
        [ Material.Layout.title [ Material.Color.text Material.Color.black ] [ text "Alertmanager" ]
        , Material.Layout.spacer
        , Material.Layout.navigation [] [ tabs model ]
        ]


tabs : Model -> Html Msg
tabs model =
    Material.Tabs.render Mdl
        []
        model.mdl
        [ Material.Tabs.activeTab (getSelectedTab model.route) ]
        (List.map
            (\link -> tab link)
            links
        )
        []


tab : Link -> Material.Tabs.Label Msg
tab { url, name, route, icon } =
    Material.Tabs.label []
        [ a [ href url ]
            [ Material.Icon.i icon
            , text name
            ]
        ]


getSelectedTab : Route -> Int
getSelectedTab currentRoute =
    let
        index =
            findIndex (\{ url, name, route } -> route == (currentRoute)) links
    in
        case index of
            Just i ->
                i

            Nothing ->
                0


links : List Link
links =
    [ { url = "#/alerts", name = "Alerts", route = AlertsRoute (Alerts.Types.Receiver Nothing Nothing Nothing), icon = "alarm" }
    , { url = "#/silences", name = "Silences", route = SilencesRoute (Silences.Types.ShowSilences Nothing), icon = "volume_mute" }
    , { url = "#/status", name = "Status", route = NotFound, icon = "info" }
    ]


type alias Link =
    { url : String
    , name : String
    , route : Route
    , icon : String
    }
