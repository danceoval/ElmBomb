module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Messages exposing (Msg(..))
import Models exposing (Model, placeholder)
import Dialog
import Utils exposing (mapPrizes, getLetter, mapIcons, selectScene, mapChoices)

   
-- MODAL VIEW
dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    { 
      closeMessage = Just (CloseModal model.currentQuestion),
      containerClass = Nothing,
      header = Just ( h2 [] [text (model.currentQuestion.name)]),
      body = Just ( 
        div [] [
          div [] [
            if not model.prizeVisible then
              if (model.turnRed ) then
                h3[class "red"] [text("Red Guesses")]
              else
                h3[class "blue"] [text("Blue Guesses")]  
            else
              div [] []    
          ],
          div [] [
            if model.prizeVisible then
              mapPrizes model.currentQuestion.prize
            else  
              mapChoices model.currentQuestion.choices 
          ]
        ]
      ),
      footer = Just (div [] [
                      span [ id "prizeimage"] [],
                      div [] [
                        if model.prizeVisible then
                          button [  class "btn btn-action", (onClick (CloseModal model.currentQuestion))] [ text ("Return")]
                        else  
                          button [  class "btn btn-warning", (onClick (Guess model.selectedChoice))] [ text ("Guess")]
                      ]
                    ])
    }


-- VIEW
view : Model -> Html Msg
view model =
  div [ class "container" ] [
    div [] [
      audio [src  "static/sfx/coinsound.mp3"] [],
      if (model.openingMovie /= True) then
        div [ class "board", style [("margin-top", "30px"), ( "text-align", "center" ), ("background-image", "url(static/img/pyramid.jpg)")] ][
          div [class "row"] [
            let
              titleTxt = 
                if (List.length model.questions == 0) then 
                    "Game Over!"
                else if model.turnRed then
                  "Red's Turn"
                else     
                 "Blue's Turn"
                in  
              h1 [ class "title"] [ text (titleTxt)],
            mapIcons model.questions,
            if (List.length model.questions == 0) then
              div [] [
                div [class "btn btn-warning", onClick ResetGame] [
                   h1 [class "white"] [ text ("RESET")] 
                ]
              ]
            else
              div [] []  
          ],
          div [ class "row"] [
            div [class "col-md-6 "] [
              div [class "red", style [("width", "70%"), ("margin-left", "15%")]] [
                 h1 [class "white"] [ text ("GEMS: " ++ toString model.scoreRed)] 
              ]
            ],
            div [class "col-md-6 "] [
              div [class "blue", style [("width", "70%"),("margin-left", "15%")]] [
                 h1 [class "white"] [ text ("GEMS: " ++ toString model.scoreBlue)] 
              ]
            ]
          ]
        ]
      else 
        div [class "board", style [("background-image", "url(static/img/sphinx.jpg)")], onClick IncrementSlide] [
          selectScene model.slide
        ]      
    ],
    Dialog.view
      (if model.showDialog then
        Just (dialogConfig model)
      else
        Nothing
      )
    ]