module Views.Silence.Updates exposing (update)

import Views.Silence.Types exposing (SilenceMsg(..))
import Types exposing (Model, Msg(MsgForSilence))
import Silences.Api exposing (getSilence)
import Utils.Types exposing (ApiResponse(Success))
import Task
import Types exposing (Msg(PreviewSilence))


update : SilenceMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchSilence id ->
            ( model, getSilence id (SilenceFetched >> MsgForSilence) )

        SilenceFetched s ->
            let
                cmd =
                    case s of
                        Success sil ->
                            Task.perform identity (Task.succeed (PreviewSilence sil))

                        _ ->
                            Cmd.none
            in
                ( { model | silence = s }, cmd )

        InitSilenceView silenceId ->
            ( model, getSilence silenceId (SilenceFetched >> MsgForSilence) )
