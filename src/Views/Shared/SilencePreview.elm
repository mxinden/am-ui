module Views.Shared.SilencePreview exposing (view)

import Silences.Types exposing (Silence)
import Html exposing (Html, div)
import Utils.Types exposing (ApiResponse(Success, Loading, Failure))
import Views.Shared.AlertListCompact
import Utils.Views exposing (error, loading)

view : Silence -> Html msg
view s =
    case s.silencedAlertGroups of
        Success alertGroups ->
            div []
                (List.map Views.Shared.AlertListCompact.view alertGroups)

        Loading ->
            loading

        Failure e ->
            error e
