module Status.Api exposing (getStatus)

import Utils.Api exposing (baseUrl, send, get)
import Utils.Types exposing (ApiData)
import Status.Types exposing (StatusResponse)
import Json.Decode exposing (Decoder, map2, string, field, at)
import Types exposing (Msg(MsgForStatus))


getStatus : (ApiData StatusResponse -> Msg) -> Cmd Msg
getStatus msg =
    let
        url =
            String.join "/" [ baseUrl, "status" ]

        request =
            get url decodeStatusResponse
    in
        Cmd.map msg <| send request


decodeStatusResponse : Decoder StatusResponse
decodeStatusResponse =
    map2 StatusResponse
        (field "status" string)
        (at [ "data", "uptime" ] string)
