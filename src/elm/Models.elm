module Models exposing (..)

import Messages exposing (Msg(..))
import Components.Question exposing (Question, QuestionId)
import Components.QuestionSet exposing (Msg, fetchAll)


-- MODELS
type alias Model =
  { 
    openingMovie : Bool,
    slide : Int,
    showDialog : Bool,
    prizeVisible : Bool,
    currentQuestion : Question,
    questions : List Question,
    cached : List Question,
    scoreRed : Int,
    scoreBlue : Int,
    turnRed : Bool,
    selectedChoice : String
  }


-- Initial State
placeholder : Question
placeholder =
  {
    id = 0
    , name = "How many licks to the center of a tootsie pop?"
    , answer = "IDK"
    , choices = ["Over 9000", "1", "IDK", "666"]
    , prize = 1

  }


init : (Model, Cmd Messages.Msg)
init = ({  
    openingMovie = True
    , slide = 1
    , scoreRed = 0
    , scoreBlue = 0
    , turnRed = True
    , showDialog = False
    , prizeVisible = False
    , currentQuestion = placeholder
    , questions = [placeholder] 
    , cached = [placeholder]
    , selectedChoice = ""
    }, Cmd.map QuestionsMsg fetchAll)  