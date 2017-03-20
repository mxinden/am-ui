module Views.SilenceList.Parsing exposing (silencesParser)

import Views.SilenceList.Types exposing (..)
import UrlParser exposing ((</>), (<?>), Parser, int, map, oneOf, parseHash, s, string, stringParam)


silencesParser : Parser (Route -> a) a
silencesParser =
    oneOf
        [ map ShowSilences list
        ]


list : Parser (Maybe String -> a) a
list =
    s "silences" <?> stringParam "filter"


