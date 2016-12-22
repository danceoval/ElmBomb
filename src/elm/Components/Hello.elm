module Components.Hello exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Signal


-- hello component
hello : Int -> Html a
hello model =
  div
    [ class "h1" ]
    [ text ( "Hello, Elm" ++ ( "!" |> String.repeat model ) ) ]
