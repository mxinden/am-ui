module Views exposing (..)

import Html exposing (Html, text, div)
import Types exposing (Msg(Mdl), Model, Route(SilencesRoute, AlertsRoute))
import Utils.Types exposing (ApiResponse(..))
import Utils.Views exposing (error, loading, notFoundView)
import Translators exposing (alertTranslator, silenceTranslator)
import Silences.Views
import Alerts.Views
import NavBar.Views exposing (viewHeader)
import Material.Scheme
import Material.Layout
import Material.Options


view : Model -> Html Msg
view model =
    Material.Scheme.top <|
        Material.Layout.render Mdl
            model.mdl
            [ Material.Layout.fixedHeader
            , Material.Layout.fixedDrawer
            , Material.Options.css "display" "flex !important"
            , Material.Options.css "flex-direction" "row"
            , Material.Options.css "align-items" "center"
            ]
            { header = [ viewHeader model ]
            , drawer = []
            , tabs = ( [], [] )
            , main = [ viewBody model ]
            }


viewBody : Model -> Html Msg
viewBody model =
    case model.route of
        AlertsRoute route ->
            case model.alertGroups of
                Success alertGroups ->
                    Html.map alertTranslator (Alerts.Views.view route alertGroups model.filter (text ""))

                Loading ->
                    loading

                Failure msg ->
                    Html.map alertTranslator (Alerts.Views.view route [] model.filter (error msg))

        SilencesRoute route ->
            Html.map silenceTranslator (Silences.Views.view route model.silences model.silence model.currentTime model.filter)

        _ ->
            notFoundView model
