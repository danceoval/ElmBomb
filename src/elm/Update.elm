module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model, placeholder)
import Components.QuestionUpdate 
import Components.QuestionSet exposing (Msg, fetchAll)

-- UPDATE
update : Messages.Msg -> Model -> (Model, Cmd Messages.Msg)
update msg model =
  case msg of
    IncrementSlide ->
      if (model.slide + 1 > 4) then 
        ({model | openingMovie = False}, Cmd.none)
      else 
        ({model | slide = model.slide + 1}, Cmd.none)  
    CloseModal currentQuestion ->
      let 
        filteredQuestions = List.filter (\q -> q /= currentQuestion) model.questions
      in
        ({ model | showDialog = False, prizeVisible = False, questions = filteredQuestions, selectedChoice = ""  }, Cmd.none)
    SelectChoice str ->
      ({model | selectedChoice = str }, Cmd.none)
    Guess str ->
      let prize = model.currentQuestion.prize in 
        if str == model.currentQuestion.answer then
          if (prize /= 0 && prize /= 6) then
            --Red Scores
            if model.turnRed then
              ({model | prizeVisible = True, scoreRed = (model.scoreRed + model.currentQuestion.prize), turnRed = not model.turnRed}, Cmd.none)
            -- Blue Scores
            else 
              ({model | prizeVisible = True, scoreBlue = (model.scoreBlue + model.currentQuestion.prize), turnRed = not model.turnRed}, Cmd.none)  
          else if (prize == 0) then
            -- Red Bomb
            if model.turnRed then
              ({ model | prizeVisible = True, scoreRed = 0, turnRed = not model.turnRed }, Cmd.none) 
            -- Blue Bomb
            else
              ({ model | prizeVisible = True, scoreBlue = 0, turnRed = not model.turnRed }, Cmd.none)  
          else
            -- Switch points
            ({ model | prizeVisible = True, scoreRed = model.scoreBlue, scoreBlue = model.scoreRed, turnRed = not model.turnRed}, Cmd.none)
        else
          -- No Points, Change turn
          ({ model | turnRed = not model.turnRed }, Cmd.none)       
    SetQuestion q ->
        ({ model | currentQuestion = q, showDialog = True }, Cmd.none)
    QuestionsMsg subMsg ->
      let 
        ( updatedQuestions, cmd ) =
          Components.QuestionUpdate.update subMsg model.questions
      in
          ( { model | questions = updatedQuestions, cached = updatedQuestions}, Cmd.map QuestionsMsg cmd )
    ResetGame ->
      ({model | scoreRed = 0, scoreBlue = 0, questions = model.cached }, Cmd.map QuestionsMsg fetchAll)
    NoOp -> (model, Cmd.none)