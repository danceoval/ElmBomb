module Main exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model, placeholder, init)
import Update exposing (update)
import View exposing (view)
import Html exposing (..)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Messages.Msg
subscriptions model =
  Sub.none



-- APP
main : Program Never Model Messages.Msg
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions}


