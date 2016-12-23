module Messages exposing (..)

import Components.Question exposing (Question, QuestionId)
import Components.QuestionSet exposing (Msg, fetchAll)
import Components.QuestionUpdate

type Msg 
  = IncrementSlide
  |CloseModal QuestionId
  | ShowAnswer
  | ShowPrize Int
  | SetQuestion QuestionId
  | QuestionsMsg Components.QuestionSet.Msg
  | ResetGame 
  | NoOp