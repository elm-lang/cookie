module Cookie
    exposing
        ( set
        , Options
        , Error
        )

{-| Be sure to read the README first. There is some important background
material there.

# Example

If you need to set a `userToken` cookie, you will end up writing something
like this:

    import Cookie
    import Time

    setUserToken : String -> Task Cookie.Error ()
    setUserToken token =
      Cookie.set options "userToken" token

    options : Cookie.Options
    options =
      { domain = Nothing
      , path = Nothing
      , maxAge = Just (7 * 24 * Time.hour)
      , secure = True
      }

The important part is the `options` record. It is saying:

  - all subdomains of your website can see this cookie
  - all paths on any of those subdomains can see this cookie
  - the cookie will live for seven days
  - the cookie will only be set over HTTPS

You may want to make other choices to further restrict things.

# The Documentation
@docs set, Options, Error

-}

import Date exposing (Date)
import Task exposing (Task)
import String


-- Local modules.

import Cookie.LowLevel as LL


{-| Setting cookies may fail for reasons including:

    - Some browsers only accept ASCII characters.
    - There is an equals sign in your key.
    - There are spaces or semicolons in your key or value.
    - You did not provide an absolute path.

The `Error` type will tell you generally what kind of problem you have with
a more specific error message to really pin things down.
-}
type Error
    = BadKey String
    | BadValue String
    | InvalidPath String


{-| Set a key-value pair. So if you perform the following task on a page with
no cookies:

    set "sessionToken" "abc123"

The following header would be added to every request to your servers:

    Cookie: sessionToken=abc123

As you `set` more cookies, that `Cookie` header would get more and more stuff
in it.
-}
set : Options -> String -> String -> Task Error ()
set options key value =
    let
        chunks =
            [ key ++ "=" ++ value
            , format "domain" identity options.domain
            , format "path" identity options.path
            , format "max-age" toString options.maxAge
            , if options.secure then
                ";secure"
              else
                ""
            ]
    in
        LL.set (String.concat chunks)


format : String -> (a -> String) -> Maybe a -> String
format prefix styler option =
    case option of
        Nothing ->
            ""

        Just value ->
            ";" ++ prefix ++ "=" ++ styler value


{-| When setting cookies, there are a few options you can tweak:

The **`maxAge`** field specifies when the cookie should expire.

If this is not specified, the cookie expires at the end of the session.

When the **`secure`** field is true, the cookie will only be sent over secure
protocols, like HTTPS.

The **`domain`** field lets you restrict which domains can see your
cookie.

If it is not set, it defaults to the broadest domain. So if you are on
`downloads.example.org` it would be set to `example.org`. This means the
cookie would be available on *any* subdomain.

The **`path`** field lets you restrict which pages can see your cookie.

If you set this to `"/"`, the cookie will be visible on `/index.html` and
`/cats/search` and any other page that starts with `/`. Similarly, if you
set this to `"/cats"`, the cookie will be visible on `/cats/search` and
anything else under `/cats`.

If you do not set the `path`, it defaults to `"/"` allowing every page to
see the cookie. If you do set the `path`, it must be an absolute path starting
with `/`.

-}
type alias Options =
    { maxAge : Maybe Date
    , secure : Bool
    , domain : Maybe String
    , path : Maybe String
    }
