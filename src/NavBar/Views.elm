module NavBar.Views exposing (viewHeader)

import Html exposing (Html, header, text, a, nav)
import Html.Attributes exposing (class, href, title)
import Material.Layout


viewHeader : List ( String, String ) -> Html msg
viewHeader links =
    let
        headerLinks =
            List.map (\( link, text ) -> headerLink link text) links
    in
        Material.Layout.row []
            [ Material.Layout.title [] [ text "Alertmanager" ]
            , Material.Layout.spacer
            , Material.Layout.navigation []
                headerLinks
            ]


headerLink : String -> String -> Html msg
headerLink link linkText =
    a [ class "link dim white dib mr3", href link, title linkText ]
        [ text linkText ]
