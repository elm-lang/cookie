module Cookie.LowLevel exposing (get, set)
{-| Low-level bindings to the JavaScript API for cookies. Generally you want
to use the `Cookie` module, not `Cookie.LowLevel`.

# Get and Set Cookies
@docs get, set
-}

import Native.Cookie


{-| Get the contents of `document.cookie` as a string.

Generally speaking, there is no major motivation for looking at this
information that is not better covered by [local-storage][local] and
[session-storage][session].

[local]: http://package.elm-lang.org/packages/elm-lang/local-storage/latest
[session]: http://package.elm-lang.org/packages/elm-lang/session-storage/latest
-}
get : Task x String
get =
  Native.Cookie.get


{-| Set a cookie using the low-level string API implemented by the browser.
Instead of setting options individually, you provide a string like this:

    set "sessionToken=abc123;path=/;max-age=30000;secure"

This gives you a safety valve in case you ever have to set a new option that
is not covered by the `Cookie` module.
-}
set : String -> Task x ()
set =
  Native.Cookie.set