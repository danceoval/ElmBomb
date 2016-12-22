module Components.QuestionModal exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )


questionModal model =
  { closeMessage = Just CloseModal,
  containerClass = "modal",
  header = Just ( 
            h4 [class "modal-title", id "myModalLabel"] [
              text ("Question")
            ]),
  body = Just (
          div [ class "modal-body", id "myModalBody"] [
            p [] [ text ("(Click to reveal Answer)")]
          ]),
  footer = Just (
            div [ class "modal-footer"] [
              span [ id "prizeimage"] [],
              div [ class "modal-footer"] [
                button [  class "btn btn-danger", id "returnButton"] [ text ("Return")],
                button [  class "btn btn-success", id "correctButton"] [ text ("Correct!")]
              ]
            ])
 
  }
  