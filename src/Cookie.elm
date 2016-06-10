module Cookie exposing
  ( get
  , set, setWith, Options
  , Error
  )

{-|
-}


import Native.Cookie


type Error
  = InvalidPath String
  | NotFound


{-|
-}
get : String -> Task Error String
get =
  Native.Cookie.get


{-| Set a key-value pair. So if you perform the following task on a page with
no cookies:

    set "sessionToken" "abc123"

The following header would be added to every request to your servers:

    Cookie: sessionToken=abc123

As you `set` more cookies, that `Cookie` header would get more and more stuff
in it.
-}
set : String -> String -> Task Error ()
set key value =
  setWith defaultOptions key value


{-| Set a cookie with custom options. The `set` function uses
`defaultOptions` which may not be what you want.
-}
setWith : Options -> String -> String -> Task Error ()
setWith =
  Native.Cookie.set


{-| When setting cookies, there are a few options you can tweak:

The **`path`** field lets you restrict which pages can see your cookie.

If you set this to `"/"`, the cookie will be visible on `/index.html` and
`/cats/search` and any other page that starts with `/`. Similarly, if you
set this to `"/cats"`, the cookie will be visible on `/cats/search` and
anything else under `/cats`.

If you do not set the `path`, it defaults to `"/"` allowing every page to
see the cookie. If you do set the `path`, it must be an absolute path starting
with `/`.

The **`domain`** field lets you restrict which domains can see your
cookie.

If it is not set, it defaults to the broadest domain. So if you are on
`downloads.example.org` it would be set to `example.org`. This means the
cookie would be available on *any* subdomain.

The **`maxAge`** field specifies when the cookie should expire.

If this is not specified, the cookie expires at the end of the session.

When the **`secure`** field is true, the cookie will only be sent over secure
protocols, like HTTPS.

-}
type alias Options =
  { path : Maybe String
  , domain : Maybe String
  , maxAge : Maybe Date
  , secure : Bool
  }


{-| The default options kind of suck.

    { path = Nothing
    , domain = Nothing
    , maxAge = Nothing
    , secure = False
    }

This means all pages can see your cookies, all subdomains can see your
cookies, and your cookies are sent over HTTP. The only redeeming quality
here is that the cookies expire at the end of the session.
-}
defaultOptions : Options
defaultOptions =
  { path = Nothing
  , domain = Nothing
  , maxAge = Nothing
  , secure = False
  }