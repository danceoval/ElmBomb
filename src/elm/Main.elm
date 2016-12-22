import Dialog
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )



-- MODELS
type alias Model =
  { showDialog : Bool,
    answerVisible: Bool
  }

type Msg 
  = OpenModal
  | CloseModal
  | ShowAnswer
  | NoOp

--type alias QuestionModal msg =
--    { closeMessage : Maybe msg
--    , containerClass : Maybe String
--    , header : Maybe (Html msg)
--    , body : Maybe (Html msg)
--    , footer : Maybe (Html msg)
--    , answerVisible : Bool
--    }


-- Initial State

init : (Model, Cmd Msg)
init = 
  ({showDialog = False, answerVisible = False}, Cmd.none)



-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OpenModal ->
      ({ model | showDialog = True}, Cmd.none)
    CloseModal ->
      ({ model | showDialog = False, answerVisible = False }, Cmd.none)
    ShowAnswer -> 
      ({ model | answerVisible = True }, Cmd.none)
    --ShowPrize ->
    --  ({ model | answerVisible = True }, Cmd.none)
    NoOp -> (model, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- Modal
dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    { 
      closeMessage = Just CloseModal,
      containerClass = Nothing,
      header = Just ( h4 [class "modal-title", id "myModalLabel"] [text ("Question")]),
      body = Just ( div [ class "modal-body", id "myModalBody"] [
                    if model.answerVisible then
                      p [] [ text ("(The answer is youuu)")]
                    else
                      p [onClick ShowAnswer] [ text ("(Click to reveal Answer)")]
                  ]),
      footer = Just (div [ class "modal-footer"] [
                      span [ id "prizeimage"] [],
                      div [ class "modal-footer"] [
                        button [  class "btn btn-danger", id "returnButton", (onClick CloseModal)] [ text ("Return")],
                        button [  class "btn btn-success", id "correctButton"] [ text ("Correct!")]
                      ]
                    ])
    }


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
        Just (dialogConfig model)
      else
        Nothing
      )
    ]


-- APP
main : Program Never Model Msg
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions}


