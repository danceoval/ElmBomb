module Models exposing (..)

import Messages exposing (Msg(..))
import Components.Question exposing (Question, QuestionId)
import Components.QuestionSet exposing (Msg, fetchAll)
import Components.QuestionUpdate 


-- MODELS
type alias Model =
  { 
    openingMovie : Bool,
    slide : Int,
    showDialog : Bool,
    answerVisible: Bool,
    prizeVisible : Bool,
    currentQuestion : Question,
    questions : List Question,
    cached : List Question,
    scoreRed : Int,
    scoreBlue : Int,
    turnRed : Bool
  }


-- Initial State
placeholder : Question
placeholder =
  {
    id = 0
    , name = "How many licks to the center of a tootsie pop?"
    , answer = "50000"
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
    , answerVisible = False
    , prizeVisible = False
    , currentQuestion = placeholder
    , questions = [placeholder] 
    , cached = [placeholder]
    }, Cmd.map QuestionsMsg fetchAll)  