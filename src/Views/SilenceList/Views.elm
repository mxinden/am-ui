module Views.SilenceList.Views exposing (..)

-- External Imports

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Views.SilenceList.Types exposing (SilencesMsg(..), Route(..))
import Views.Shared.SilenceBase
import Views.Shared.SilencePreview
import Silences.Types exposing (Silence)
import Utils.Types exposing (Matcher, ApiResponse(..), Filter, ApiData)
import Utils.Views exposing (iconButtonMsg, checkbox, textField, formInput, formField, buttonLink, error, loading)
import Utils.Date
import Utils.List
import Time

import Views.AlertList.Views
import Types exposing (Msg(UpdateFilter, PreviewSilence, MsgForSilenceList, Noop))


view : Route -> ApiData (List Silence) -> ApiData Silence -> Time.Time -> Filter -> Html Msg
view route apiSilences apiSilence currentTime filter =
    case route of
        ShowSilences _ ->
            case apiSilences of
                Success sils ->
                    -- Add buttons at the top to filter Active/Pending/Expired
                    silences sils filter (text "")

                Loading ->
                    loading

                Failure msg ->
                    silences [] filter (error msg)

        ShowNewSilence ->
            case apiSilence of
                Success silence ->
                    silenceForm "New" silence

                Loading ->
                    loading

                Failure msg ->
                    error msg

        ShowEditSilence id ->
            case apiSilence of
                Success silence ->
                    silenceForm "Edit" silence

                Loading ->
                    loading

                Failure msg ->
                    error msg


silences : List Silence -> Filter -> Html Msg -> Html Msg
silences silences filter errorHtml =
    let
        filterText =
            Maybe.withDefault "" filter.text

        html =
            if List.isEmpty silences then
                div [ class "mt2" ] [ text "no silences found" ]
            else
                ul
                    [ classList
                        [ ( "list", True )
                        , ( "pa0", True )
                        ]
                    ]
                    (List.map silenceList silences)
    in
        div []
            [ textField "Filter" filterText (UpdateFilter filter)
            , a [ class "f6 link br2 ba ph3 pv2 mr2 dib blue", onClick (MsgForSilenceList FilterSilences) ] [ text "Filter Silences" ]
            , a [ class "f6 link br2 ba ph3 pv2 mr2 dib blue", href "#/silences/new" ] [ text "New Silence" ]
            , errorHtml
            , html
            ]


silenceList : Silence -> Html Msg
silenceList silence =
    li
        [ class "pa3 pa4-ns bb b--black-10" ]
        [ Views.Shared.SilenceBase.view silence
        ]








silenceForm : String -> Silence -> Html Msg
silenceForm kind silence =
    -- TODO: Add field validations.
    let
        base =
            "/#/silences/"

        boundMatcherForm =
            matcherForm silence

        url =
            case kind of
                "New" ->
                    base ++ "new"

                "Edit" ->
                    base ++ (toString silence.id) ++ "/edit"

                _ ->
                    "/#/silences"
    in
        div []
            [ div [ class "pa4 black-80" ]
                [ fieldset [ class "ba b--transparent ph0 mh0" ]
                    [ legend [ class "ph0 mh0 fw6" ] [ text <| kind ++ " Silence" ]
                    , (formField "Start" silence.startsAt.s (UpdateStartsAt silence))
                    , div [ class "dib mb2 mr2 w-40" ] [ formField "End" silence.endsAt.s (UpdateEndsAt silence) ]
                    , div [ class "dib mb2 mr2 w-40" ] [ formField "Duration" silence.duration.s (UpdateDuration silence) ]
                    , div [ class "mt3" ]
                        [ label [ class "f6 b db mb2" ]
                            [ text "Matchers "
                            , span [ class "normal black-60" ] [ text "Alerts affected by this silence. Format: name=value" ]
                            ]
                        , label [ class "f6 dib mb2 mr2 w-40" ] [ text "Name" ]
                        , label [ class "f6 dib mb2 mr2 w-40" ] [ text "Value" ]
                        ]
                    , div [] (List.map boundMatcherForm silence.matchers)
                    , iconButtonMsg "blue" "fa-plus" (AddMatcher silence)
                    , formField "Creator" silence.createdBy (UpdateCreatedBy silence)
                    , textField "Comment" silence.comment (UpdateComment silence)
                    , div [ class "mt3" ]
                        [ a [ class "f6 link br2 ba ph3 pv2 mr2 dib blue", onClick (CreateSilence silence) ] [ text "Create" ]
                          -- Reset isn't working for "New" -- just updates time.
                        , a [ class "f6 link br2 ba ph3 pv2 mr2 dib dark-red", href url ] [ text "Reset" ]
                        ]
                    ]
                    |> (Html.map MsgForSilenceList)
                , div [ class "mt3" ]
                    [ a [ class "f6 link br2 ba ph3 pv2 mr2 dib dark-green", onClick <| PreviewSilence silence ] [ text "Show Affected Alerts" ]
                    ]
                , Views.Shared.SilencePreview.view silence
                ]
            ]


matcherForm : Silence -> Matcher -> Html SilencesMsg
matcherForm silence matcher =
    div []
        [ formInput matcher.name (UpdateMatcherName silence matcher)
        , formInput matcher.value (UpdateMatcherValue silence matcher)
        , checkbox "Regex" matcher.isRegex (UpdateMatcherRegex silence matcher)
        , iconButtonMsg "dark-red" "fa-trash-o" (DeleteMatcher silence matcher)
        ]


