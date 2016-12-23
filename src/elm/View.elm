module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Messages exposing (Msg(..))
import Models exposing (Model)
import Components.Question exposing (Question, QuestionId)
import Dialog
import Array.Hamt as Array


-- UTILS
mapPrize : Int -> Html Msg
mapPrize int =
  img [src "static/img/gem.gif"] []

mapPrizes : Int -> Html Msg
mapPrizes int = 
  if (int /= 0 && int /= 99) then
    div [] (List.map mapPrize (List.range 1 int))
  else if int == 0 then 
    div [] [
      h4 [] [text ("Lose All Points!")],
      img [id "death" ,src "static/img/death.GIF"] []
    ]
  else
    h3 [class "warning"] [text ("Teams Switch points!")]
mapIcon : Question -> Html Msg
mapIcon question =
  div [class "col-md-3 question", onClick (SetQuestion question.id) ] [
    h1 [class "markerNo"] [text(toString question.id)],
    img [class "img-responsive", src "static/img/sphynxsprite.png"] []
  ]

mapIcons : List Question -> Html Msg
mapIcons questions = 
  div [] (List.map mapIcon questions)  

selectScene : Int -> Html Msg
selectScene int =
  let lines = Array.fromList ["Hello young adventurers.",
      "I am the legendary Sphinx, the terror of Thebes!",
      "If you wish to defeat me, you must answer my riddles and collect precious gems.",
      "The adventurer with the most gems will become the Hero of Thebes and will be remembered for ages to come!",
      "So, can you defeat me?"]
  in 
    h1 [class "title", style [("font-size", "4em")]] [text(Array.get int lines |> Maybe.withDefault "")]   


   
-- MODAL VIEW
dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    { 
      closeMessage = Just (CloseModal model.currentQuestion.id),
      containerClass = Nothing,
      header = Just ( h2 [] [text (model.currentQuestion.name)]),
      body = Just ( div [] [
                    if model.answerVisible then
                      p [] [ text (model.currentQuestion.answer)]
                    else if model.prizeVisible then
                      mapPrizes model.currentQuestion.prize
                    else
                      p [onClick ShowAnswer] [ text ("(Click to reveal Answer)")]
                  ]),
      footer = Just (div [] [
                      span [ id "prizeimage"] [],
                        if (model.answerVisible && not model.prizeVisible) then
                          div [] [
                            button [  class "btn btn-danger", id "returnButton", (onClick (CloseModal model.currentQuestion.id))] [ text ("Return")],
                            button [  class "btn btn-success", id "correctButton", (onClick (ShowPrize model.currentQuestion.prize))] [ text ("Correct!")]
                          ]
                        else if model.prizeVisible then
                          button [  class "btn btn-danger", id "returnButton", (onClick (CloseModal model.currentQuestion.id))] [ text ("Return")]
                        else   
                          div [] [] 
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
              div [class "col-md-6 ", onClick ResetGame] [
                div [class "orange", style [("width", "70%"), ("margin-left", "15%")]] [
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