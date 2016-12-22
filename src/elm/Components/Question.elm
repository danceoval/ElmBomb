module Components.Question exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias QuestionId =
    String


type alias Question =
    { id : QuestionId
    , name : String
    , answer : String
    , prize : Int
    }


