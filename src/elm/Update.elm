module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model, placeholder)
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
        ({ model | showDialog = False, answerVisible = False, prizeVisible = False, questions = filteredQuestions, selectedChoice = ""  }, Cmd.none)
    SelectChoice str ->
      ({model | selectedChoice = str }, Cmd.none)
    ShowAnswer -> 
      ({ model | answerVisible = True, prizeVisible = False  }, Cmd.none)
    Guess str ->
      if str == model.currentQuestion.answer then
        if (model.currentQuestion.prize /= 0 && model.currentQuestion.prize /= 99) then
          --Red Scores
          if model.turnRed then
            ({model | prizeVisible = True, scoreRed = (model.scoreRed + model.currentQuestion.prize), turnRed = not model.turnRed}, Cmd.none)
          -- Blue Scores
          else 
            ({model | prizeVisible = True, scoreBlue = (model.scoreBlue + model.currentQuestion.prize), turnRed = not model.turnRed}, Cmd.none)  
        else if (model.currentQuestion.prize == 0) then
          -- Red Bomb
          if model.turnRed then
            ({ model | answerVisible = False, prizeVisible = True, scoreRed = 0, turnRed = not model.turnRed }, Cmd.none) 
          -- Blue Bomb
          else
            ({ model | answerVisible = False, prizeVisible = True, scoreBlue = 0, turnRed = not model.turnRed }, Cmd.none)  
        else
          -- Switch points
          ({ model | answerVisible = False, prizeVisible = True, scoreRed = model.scoreBlue, scoreBlue = model.scoreRed, turnRed = not model.turnRed}, Cmd.none)
      else
        -- No Points, Change turn
        ({ model | turnRed = not model.turnRed }, Cmd.none)       
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