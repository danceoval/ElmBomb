module Messages exposing (..)

import Components.Question exposing (Question, QuestionId)
import Components.QuestionSet exposing (Msg, fetchAll)

type Msg 
  = IncrementSlide
  | CloseModal Question
  | SelectChoice String
  | Guess String
  | SetQuestion Question
  | QuestionsMsg Components.QuestionSet.Msg
  | ResetGame 
  | NoOp