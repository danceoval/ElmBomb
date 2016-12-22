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


new : Question
new =
    { id = "0"
    , name = "How many licks to the center of a tootsie pop?"
    , answer = "50000"
    , prize = 1
    }
