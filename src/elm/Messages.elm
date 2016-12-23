module Messages exposing (..)

import Components.Question exposing (Question, QuestionId)
import Components.QuestionSet exposing (Msg, fetchAll)

type Msg 
  = IncrementSlide
  | CloseModal QuestionId
  | SelectChoice String
  | Guess String
  | ShowAnswer
  | SetQuestion QuestionId
  | QuestionsMsg Components.QuestionSet.Msg
  | ResetGame 
  | NoOp