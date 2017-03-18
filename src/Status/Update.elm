module Status.Update exposing (update)

import Types exposing (Msg)
import Status.Types exposing (StatusModel, StatusMsg(NewStatus), StatusResponse)
import Status.Api exposing (getStatus)


update : StatusMsg -> StatusModel -> ( StatusModel, Cmd Msg )
update msg model =
    case msg of
        NewStatus (Ok response) ->
            ( { model | response = Just response }, Cmd.none )

        NewStatus (Err err) ->
            ( model, Cmd.none )
