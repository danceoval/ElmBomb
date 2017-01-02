module Utils exposing (mapPrizes, getLetter, mapIcons, selectScene, mapChoices)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Models exposing (Model, placeholder)
import Messages exposing (Msg(..))
import Components.Question exposing (Question, QuestionId)
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


getLetter : Int -> String
getLetter n =
  String.slice n (n + 1) "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

mapIcon : Int -> Question -> Html Msg
mapIcon acc question = 
  div [class "col-md-3 question", onClick (SetQuestion question) ] [
    h1 [class "markerNo"] [text(getLetter question.order)],
    img [class "img-responsive", src "static/img/sphynxsprite.png"] []
  ]

mapIcons : List Question -> Html Msg
mapIcons questions = 
  div [] (List.indexedMap mapIcon questions)

selectScene : Int -> Html Msg
selectScene int =
  let lines = Array.fromList ["Hello young adventurers.",
      "I am the legendary Sphinx, the terror of Thebes!",
      "If you wish to defeat me, you must answer my riddles and collect precious gems.",
      "The adventurer with the most gems will become the Hero of Thebes and will be remembered for ages to come!",
      "So, can you defeat me?"]
  in 
    h1 [class "title", style [("font-size", "4em")]] [text(Array.get int lines |> Maybe.withDefault "")]   

mapChoices : List String -> Html Msg
mapChoices list =
    fieldset [] (List.map (\str -> label [ style [("padding", "15px"),("margin-right", "2em")]] [ 
        input [  style [("margin", ".75em")], type_ "radio", name "choice", value str, (onClick( SelectChoice str))] [], text(str)
      ]) list)
    
