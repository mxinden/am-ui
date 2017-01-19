module Silences.Update exposing (update)

import Types exposing (..)

update : Msg ->  Silence -> Matcher -> a -> (Silence, Cmd Msg)
update msg matcher a =
    case msg of
        UpdateMatcherName silence matcher name ->
            let
                matchers =
                    Utils.List.replaceIf (\x -> x == matcher) { matcher | name = name } silence.matchers

            in
                ( { silence | matchers = matchers  }, Cmd.none )

        UpdateMatcherValue silence matcher value ->
            let
                matchers =
                    Utils.List.replaceIf (\x -> x == matcher) { matcher | value = value } model.silence.matchers

            in
                ( { silence | matchers = matchers  }, Cmd.none )

        UpdateMatcherRegex silence matcher bool ->
            let
                matchers =
                    Utils.List.replaceIf (\x -> x == matcher) { matcher | isRegex = bool } model.silence.matchers
            in
                ( { silence | matchers = matchers  }, Cmd.none )

        DeleteMatcher silence matcher ->
            ( { silence | matchers = (List.filter (\x -> x /= matcher) s.matchers) }, Cmd.none )

        DestroySilence silence ->
            ( model, Silences.Api.destroy silence )

