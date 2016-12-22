module Components.QuestionModal exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

-- MODEL

-- MODEL
type alias Model =
  { showModal : Bool
  }


questionModal model =
  if model.showModal
    then div [class "modal", id "myModal"] [
          div [ class "modal-dialog" ] [
            div [ class "modal-content"] [
              div [ class "modal-header"] [
                h4 [class "modal-title", id "myModalLabel"] [
                  text ("Question")
                ],
                div [ class "modal-body", id "myModalBody"] [
                  p [] [ text ("(Click to reveal Answer)")]
                ],
                div [ class "modal-footer"] [
                  span [ id "prizeimage"] [],
                  div [ class "modal-footer"] [
                    button [  class "btn btn-danger", id "returnButton"] [ text ("Return")],
                    button [  class "btn btn-success", id "correctButton"] [ text ("Correct!")]
                  ]
                ] 
              ]
            ]
          ]
        ]
  else div [] []   