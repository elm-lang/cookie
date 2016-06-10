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


get : String -> Task Error String
get =
  Native.Cookie.get


set : String -> String -> Task Error ()
set key value =
  setWith defaultOptions key value


setWith : Options -> String -> String -> Task Error ()
setWith =
  Native.Cookie.set


type alias Options =
  { path : Maybe String
  , domain : Maybe String
  , expires : Maybe String
  , secure : Bool
  }


defaultOptions : Options
defaultOptions =
  { path = Just "/"
  , domain = Nothing
  , expires = Nothing
  , secure = False
  }