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
    Regex.regex "(?:[^\\x00-\\x7F]|[;,\\s])"


{-| Identifies characters that would make a cookie value illegal. Built for
speed, not for error messages! Other regexes can be used to find specific errors
in the event that this fails.

This is the same as illegalValueChar, but with = characters banned as well.
-}
illegalKeyChar : Regex
illegalKeyChar =
    Regex.regex "(?:[^\\x00-\\x7F]|[;,=\\s])"


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
nonStandardAscii : Regex
nonStandardAscii =
    Regex.regex "[^\\x00-\\x7F]"


allStandardAscii : Regex
allStandardAscii =
    Regex.regex ("^[\\x00-\\x7F]*$")


detailedError : String -> String
detailedError str =
    let
        matches =
            str
                |> Regex.find Regex.All nonStandardAscii
                |> List.map .match
    in
        String.concat
            [ "Cookie keys and values may only contain Standard ASCII characters. "
            , "They also may not contain control characters. "
            , "Several browsers mangle or silently refuse to send Unicode and "
            , "Extended ASCII characters, so they are not supported.\n\n"
            , "Using encodeURIComponent may help here!\n\n"
            , "Unsupported character sequences: "
            , toString matches
            , "\n\nComplete Value: "
            , str
            ]


key : String -> Maybe String
key str =
    if String.isEmpty str then
        Just "Cookies with empty keys are not supported. Different browsers handle them differently, which can lead to nasty bugs on the server. Provide a key now to avoid crazy problems later!"
    else if (Regex.contains illegalKeyChar str) then
        Just (detailedError str)
    else
        Nothing


value : String -> Maybe String
value str =
    if (Regex.contains illegalValueChar str) then
        Just (detailedError str)
    else
        Nothing
