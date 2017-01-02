module Components.Question exposing (..)

type alias QuestionId =
    Int


type alias Question =
    { id : QuestionId
    , name : String
    , answer : String
    , choices : List String
    , prize : Int
    , order : Int
    }
