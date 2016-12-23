module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model, placeholder)
import Components.Question exposing (Question, QuestionId)
import Components.QuestionSet exposing (Msg, fetchAll)
import Components.QuestionUpdate 


-- UPDATE
update : Messages.Msg -> Model -> (Model, Cmd Messages.Msg)
update msg model =
  case msg of
    IncrementSlide ->
      if (model.slide + 1 > 4) then 
        ({model | openingMovie = False}, Cmd.none)
      else 
        ({model | slide = model.slide + 1}, Cmd.none)  
    CloseModal questionId ->
      let 
        filteredQuestions = List.filter (\q -> q.id /= questionId) model.questions
      in
        ({ model | turnRed = not model.turnRed, showDialog = False, answerVisible = False, prizeVisible = False, questions = filteredQuestions  }, Cmd.none)
    ShowAnswer -> 
      ({ model | answerVisible = True, prizeVisible = False  }, Cmd.none)
    ShowPrize int ->
      if int == 99 then 
        ({ model | answerVisible = False, prizeVisible = True, scoreRed = model.scoreBlue, scoreBlue = model.scoreRed }, Cmd.none)
      else   
        if model.turnRed then 
          if (int > 0) then
            ({ model | answerVisible = False, prizeVisible = True, scoreRed = model.scoreRed + int }, Cmd.none)
          else -- Lose all points
            ({ model | answerVisible = False, prizeVisible = True, scoreRed = 0 }, Cmd.none)
        else
          if (int > 0) then
            ({ model | answerVisible = False, prizeVisible = True, scoreBlue = model.scoreBlue + int }, Cmd.none)
          else -- Lose all points
            ({ model | answerVisible = False, prizeVisible = True, scoreBlue = 0 }, Cmd.none)     
    SetQuestion questionId ->
      let setQ =
        List.head (List.filter (\q -> q.id == questionId) model.questions)
          |> Maybe.withDefault placeholder
      in
        ({ model | currentQuestion = setQ, showDialog = True }, Cmd.none)
    QuestionsMsg subMsg ->
      let
          ( updatedQuestions, cmd ) =
              Components.QuestionUpdate.update subMsg model.questions
      in
          ( { model | questions = updatedQuestions, cached = updatedQuestions }, Cmd.map QuestionsMsg cmd )
    ResetGame ->
      ({model | scoreRed = 0, scoreBlue = 0, questions = model.cached }, Cmd.none)
    NoOp -> (model, Cmd.none)