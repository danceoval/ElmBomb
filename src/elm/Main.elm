import Dialog
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Components.Question exposing (Question)



-- MODELS
type alias Model =
  { showDialog : Bool,
    answerVisible: Bool,
    prizeVisible : Bool,
    currentQuestion : Question
  }

type Msg 
  = OpenModal
  | CloseModal
  | ShowAnswer
  | ShowPrize
  | NoOp


-- Initial State

init : (Model, Cmd Msg)
init = ({  
    showDialog = False
    , answerVisible = False
    , prizeVisible = False
    , currentQuestion = {
         id = "0"
        , name = "How many licks to the center of a tootsie pop?"
        , answer = "50000"
        , prize = 1
      }
    }, Cmd.none)



-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OpenModal ->
      ({ model | showDialog = True}, Cmd.none)
    CloseModal ->
      ({ model | showDialog = False, answerVisible = False, prizeVisible = False  }, Cmd.none)
    ShowAnswer -> 
      ({ model | answerVisible = True, prizeVisible = False  }, Cmd.none)
    ShowPrize ->
      ({ model | answerVisible = False, prizeVisible = True }, Cmd.none)
    NoOp -> (model, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- UTILS
mapPrize : Int -> Html Msg
mapPrize int =
  img [class "img-responsive", src "static/img/gem.gif"] []

mapPrizes : Int -> Html Msg
mapPrizes int = 
  div [] (List.map mapPrize (List.range 1 int))
  
  


-- Modal
dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    { 
      closeMessage = Just CloseModal,
      containerClass = Nothing,
      header = Just ( h4 [class "modal-title", id "myModalLabel"] [text (model.currentQuestion.name)]),
      body = Just ( div [ class "modal-body", id "myModalBody"] [
                    if model.answerVisible then
                      p [] [ text (model.currentQuestion.answer)]
                    else if model.prizeVisible then
                      --p [] [ text ("Prize!!")]
                      mapPrizes model.currentQuestion.prize
                    else
                      p [onClick ShowAnswer] [ text ("(Click to reveal Answer)")]
                  ]),
      footer = Just (div [ class "modal-footer"] [
                      span [ id "prizeimage"] [],
                      div [ class "modal-footer"] [
                        button [  class "btn btn-danger", id "returnButton", (onClick CloseModal)] [ text ("Return")],
                        button [  class "btn btn-success", id "correctButton", (onClick ShowPrize)] [ text ("Correct!")]
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


