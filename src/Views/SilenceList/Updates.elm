module Views.SilenceList.Updates exposing (..)

import Silences.Api as Api
import Views.SilenceList.Types exposing (SilencesMsg(..), Route(..))
import Silences.Types exposing (Silence, nullSilence, nullMatcher)
import Task
import Utils.Types exposing (ApiData, ApiResponse(..), Filter, Matchers)
import Utils.Types as Types exposing (ApiData, ApiResponse(Failure, Loading, Success), Time, Filter, Matchers)
import Time
import Types exposing (Msg(NewUrl, UpdateCurrentTime, PreviewSilence, MsgForSilenceList, Noop))
import Utils.Date
import Utils.List
import Utils.Filter exposing (generateQueryString)


update : SilencesMsg -> ApiData (List Silence) -> ApiData Silence -> Filter -> ( ApiData (List Silence), ApiData Silence, Cmd Types.Msg )
update msg silences silence filter =
    case msg of
        SilencesFetch sils ->
            ( sils, silence, Task.perform UpdateCurrentTime Time.now )


        FetchSilences ->
            ( silences, silence, Api.getSilences filter (SilencesFetch >> MsgForSilenceList) )

        DestroySilence silence ->
            ( silences, Loading, Api.destroy silence (SilenceDestroy >> MsgForSilenceList))

        SilenceDestroy silence ->
            -- TODO: "Deleted id: ID" growl
            -- TODO: Add DELETE to accepted CORS methods in alertmanager
            -- TODO: Check why POST isn't there but is accepted
                ( silences, Loading, Task.perform identity (Task.succeed <| NewUrl "/#/silences" ))


        FilterSilences ->
            let
                url =
                    "/#/silences" ++ generateQueryString filter

                cmds =
                    Task.perform identity (Task.succeed (NewUrl url))
            in
                ( silences, silence, Task.perform identity (Task.succeed <| NewUrl url ))




urlUpdate : Route -> ( SilencesMsg, Filter )
urlUpdate route =
    let
        msg =
            case route of
                ShowSilences _ ->
                    FetchSilences
    in
        ( msg, updateFilter route )


updateFilter : Route -> Filter
updateFilter route =
    case route of
        ShowSilences maybeFilter ->
            { receiver = Nothing
            , showSilenced = Nothing
            , text = maybeFilter
            }

