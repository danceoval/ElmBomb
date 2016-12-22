import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Dialog


-- MODEL
type alias Model =
  { showDialog : Bool,
    answerVisible : Bool
  }

type Msg 
  = OpenModal
  | CloseModal
  | ShowAnswer
  | NoOp


-- Initial State

init : (Model, Cmd Msg)
init = 
  ({showDialog = False, answerVisible = False}, Cmd.none)



-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OpenModal ->
      ({ model | showDialog = True, answerVisible = False }, Cmd.none)
    CloseModal ->
      ({ model | showDialog = False }, Cmd.none)
    ShowAnswer -> 
      ({ model | answerVisible = True }, Cmd.none)
    NoOp -> (model, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW
view : Model -> Html Msg
view model =
  div [ class "container" ] [
    div [ id "gameboard", style [("margin-top", "30px"), ( "text-align", "center" ), ("background-image", "url(static/img/pyramid.jpg)")] ][
      div [class "row"] [
        h1 [ id "title"] [ text ("SphynxQuest")],
        div [class "col-md-4 question", onClick OpenModal] [
          img [class "img-responsive", src "static/img/sphynxsprite.png", onClick OpenModal] []
        ]
      ]
    ],
    Dialog.view
      (if model.showDialog then
        Just { closeMessage = Just CloseModal
              ,containerClass = Nothing
              , body = Just (div [ class "modal-body", id "myModalBody"] [
                  ( if model.answerVisible then
                      p [] [ text ("The Answer is Youu")]
                    else
                      p [(onClick ShowAnswer)] [ text ("(Click to reveal Answer)")]
                  )
                ])
              , header = Just ( 
                h4 [class "modal-title", id "myModalLabel"] [
                  text ("Question")
                ])
              , footer = Just (
                div [ class "modal-footer"] [
                  span [ id "prizeimage"] [],
                  button [  class "btn btn-danger", id "returnButton", onClick CloseModal] [ text ("Return")],
                  button [  class "btn btn-success", id "correctButton"] [ text ("Correct!")]
                ])
              }  
      else
        Nothing
      )
    ]


-- APP
main : Program Never Model Msg
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions}


