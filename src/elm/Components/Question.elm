module Components.Question exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias QuestionId =
    Int


type alias Question =
    { id : QuestionId
    , name : String
    , answer : String
    , prize : Int
    }


type alias FilterQuestion =
  { id : Maybe QuestionId
    , name : Maybe String
    , answer : Maybe String
    , prize : Maybe Int
    }
