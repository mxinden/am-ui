module Views.Shared.AlertListCompact exposing (view)

import Alerts.Types exposing (AlertGroup)
import Html exposing (Html, ul)
import Html.Attributes exposing (class)
import Views.Shared.AlertCompact

view : AlertGroup -> Html msg
view ag =
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
            (List.indexedMap Views.Shared.AlertCompact.view alerts)

