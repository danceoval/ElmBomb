import Dialog
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Components.Question exposing (Question, QuestionId, FilterQuestion)
import Components.QuestionSet exposing (Msg, fetchAll)
import Components.QuestionUpdate 
import Array.Hamt as Array

-- MODELS
type alias Model =
  { 
    openingMovie : Bool,
    slide : Int,
    showDialog : Bool,
    answerVisible: Bool,
    prizeVisible : Bool,
    currentQuestion : Question,
    questions : List Question
  }

type Msg 
  = IncrementSlide
  |CloseModal QuestionId
  | ShowAnswer
  | ShowPrize
  | SetQuestion QuestionId
  | QuestionsMsg Components.QuestionSet.Msg
  | NoOp



-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
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
        ({ model | showDialog = False, answerVisible = False, prizeVisible = False, questions = filteredQuestions  }, Cmd.none)
    ShowAnswer -> 
      ({ model | answerVisible = True, prizeVisible = False  }, Cmd.none)
    ShowPrize ->
      ({ model | answerVisible = False, prizeVisible = True }, Cmd.none)
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
          ( { model | questions = updatedQuestions }, Cmd.map QuestionsMsg cmd )
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
  if (int /= 0) then
    div [] (List.map mapPrize (List.range 1 int))
  else   
    div [] [
      img [id "death" ,src "static/img/death.GIF"] []
    ]
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
    h1 [] [text(Array.get int lines |> Maybe.withDefault "")]    
   
-- MODAL VIEW
dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    { 
      closeMessage = Just (CloseModal model.currentQuestion.id),
      containerClass = Nothing,
      header = Just ( h4 [class "modal-title", id "myModalLabel"] [text (model.currentQuestion.name)]),
      body = Just ( div [ class "modal-body", id "myModalBody"] [
                    if model.answerVisible then
                      p [] [ text (model.currentQuestion.answer)]
                    else if model.prizeVisible then
                      mapPrizes model.currentQuestion.prize
                    else
                      p [onClick ShowAnswer] [ text ("(Click to reveal Answer)")]
                  ]),
      footer = Just (div [ class "modal-footer"] [
                      span [ id "prizeimage"] [],
                      div [ class "modal-footer"] [
                        button [  class "btn btn-danger", id "returnButton", (onClick (CloseModal model.currentQuestion.id))] [ text ("Return")],
                        button [  class "btn btn-success", id "correctButton", (onClick ShowPrize)] [ text ("Correct!")]
                      ]
                    ])
    }


-- VIEW
view : Model -> Html Msg
view model =
  div [ class "container" ] [
    div [] [
      if (model.openingMovie /= True) then
        div [ id "gameboard", style [("margin-top", "30px"), ( "text-align", "center" ), ("background-image", "url(static/img/pyramid.jpg)")] ][
          div [class "row"] [
            let
              titleTxt = 
                if (List.length model.questions == 0)
                  then 
                    "Game Over!"
                else
                  "SphynxQuest"    
            in  
              h1 [ class "title"] [ text (titleTxt)],
            mapIcons model.questions
          ]
        ]
      else 
        div [onClick IncrementSlide] [
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


-- Initial State
placeholder : Question
placeholder =
  {
    id = 0
    , name = "How many licks to the center of a tootsie pop?"
    , answer = "50000"
    , prize = 1
  }


init : (Model, Cmd Msg)
init = ({  
    openingMovie = True
    , slide = 1
    , showDialog = False
    , answerVisible = False
    , prizeVisible = False
    , currentQuestion = placeholder
    , questions = [placeholder]  
    }, Cmd.map QuestionsMsg fetchAll)

-- APP
main : Program Never Model Msg
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions}


