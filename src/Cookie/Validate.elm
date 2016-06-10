module Cookie.Validate exposing (key, value)

import Regex exposing (Regex)
import String


{-| Identifies characters that would make a cookie value illegal. Built for
speed, not for error messages! Other regexes can be used to find specific errors
in the event that this fails.

    [;,\\s]            // Semicolons, commas, and whitespace are banned.
    [^\\x20-\\x7E]     // Control characters, or characters that are not
                       // standard ASCII, are banned.
                       // (\x00 to \x7F are standard ASCII, but
                       // \x00 to \x1F plus \x7F are banned. This reduces to
                       // everything outside \x20 to \x7E being banned.)

Detailed breakdown:
http://stackoverflow.com/questions/1969232/allowed-characters-in-cookies/1969339#1969339
-}
illegalValueChar : Regex
illegalValueChar =
    Regex.regex "[^a-zA-Z0-9#!$%&'()*+-./:<=>?@\\[\\]^_`{|}~]"


{-| Identifies characters that would make a cookie key illegal. Built for
speed, not for error messages! Other regexes can be used to find specific errors
in the event that this fails.
-}
illegalKeyChar : Regex
illegalKeyChar =
    Regex.regex "[^a-zA-Z0-9!#$%&'*+-.^_`|~]"


{-| I started out by reading http://stackoverflow.com/questions/1969232/allowed-characters-in-cookies/1969339#1969339
which says "in practice you cannot use non-ASCII characters in cookies at all."

I did some experiments with this to see what different browsers would send.
Here's what they sent when I tried to use the thorn ('Þ') character in a cookie:

    document.cookie = "thorn=ThisIsAÞThorn"

    // Safari 9.1 sends this to the server:
    thorn=ThisIsA;

    // Chrome 50 sends this to the server:
    thorn=ThisIsAÃThorn;

    // Firefox 47 sends this to the server:
    thorn=ThisIsAÃThorn;

I saw the same behavior with the Unicode horse (♞) character. It seems that
allowing even Extended ASCII characters results in inconsistent behavior
cross-browser, so we should not allow it.

-@rtfeldman
-}
valueError : String -> String
valueError str =
    let
        matches =
            str
                |> Regex.find Regex.All illegalValueChar
                |> List.map .match
    in
        String.concat
            [ "For reliable cross-browser cookie setting, "
            , "cookie values may only contain Standard ASCII letters, numbers, "
            , "and the following special characters:\n\n"
            , "!#$%&'()*+-./:<=>?@[]^_`{|}~"
            , "Using encodeURIComponent may help here!\n\n"
            , "See http://stackoverflow.com/a/1969339 for further explanation.\n"
            , "Unsupported character sequences: "
            , toString matches
            , "\n\nOriginal value: "
            , str
            ]


keyError : String -> String
keyError str =
    let
        matches =
            str
                |> Regex.find Regex.All illegalKeyChar
                |> List.map .match
    in
        String.concat
            [ "For reliable cross-browser cookie setting, "
            , "cookie keys may only contain Standard ASCII letters, numbers, "
            , "and the following special characters:\n\n"
            , "!#$%&'*+-.^_`|~"
            , "Using encodeURIComponent may help here!\n\n"
            , "See http://stackoverflow.com/a/1969339 for further explanation.\n"
            , "Unsupported character sequences: "
            , toString matches
            , "\n\nOriginal value: "
            , str
            ]


emptyKeyError : String
emptyKeyError =
    String.join " "
        [ "Cookies with empty keys are not supported."
        , "Different browsers handle them differently,"
        , "which can lead to nasty bugs on the server."
        , "Provide a key now to avoid crazy problems later!"
        ]


key : String -> Maybe String
key str =
    if String.isEmpty str then
        Just emptyKeyError
    else if (Regex.contains illegalKeyChar str) then
        Just (keyError str)
    else
        Nothing


value : String -> Maybe String
value str =
    if (Regex.contains illegalValueChar str) then
        Just (valueError str)
    else
        Nothing
