import Dialog
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Components.Question exposing (Question, QuestionId)
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
    questions : List Question,
    cached : List Question,
    scoreRed : Int,
    scoreBlue : Int,
    turnRed : Bool
  }

type Msg 
  = IncrementSlide
  |CloseModal QuestionId
  | ShowAnswer
  | ShowPrize Int
  | SetQuestion QuestionId
  | QuestionsMsg Components.QuestionSet.Msg
  | ResetGame 
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
        ({ model | turnRed = not model.turnRed, showDialog = False, answerVisible = False, prizeVisible = False, questions = filteredQuestions  }, Cmd.none)
    ShowAnswer -> 
      ({ model | answerVisible = True, prizeVisible = False  }, Cmd.none)
    ShowPrize int ->
      if int == 99 then 
        ({ model | answerVisible = False, prizeVisible = True, scoreRed = model.scoreBlue, scoreBlue = model.scoreRed }, Cmd.none)
      else   
        if model.turnRed then 
          if (int > 0) then
            ({ model | answerVisible = False, prizeVisible = True, scoreRed = model.scoreRed + int }, Cmd.none)
          else -- Lose all points
            ({ model | answerVisible = False, prizeVisible = True, scoreRed = 0 }, Cmd.none)
        else
          if (int > 0) then
            ({ model | answerVisible = False, prizeVisible = True, scoreBlue = model.scoreBlue + int }, Cmd.none)
          else -- Lose all points
            ({ model | answerVisible = False, prizeVisible = True, scoreBlue = 0 }, Cmd.none)     
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
          ( { model | questions = updatedQuestions, cached = updatedQuestions }, Cmd.map QuestionsMsg cmd )
    ResetGame ->
      ({model | scoreRed = 0, scoreBlue = 0, questions = model.cached }, Cmd.none)
    NoOp -> (model, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

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
                else
                  "SphynxQuest"    
            in  
              h1 [ class "title"] [ text (titleTxt)],
            mapIcons model.questions,
            if (List.length model.questions == 0) then
              button [class "btn btn-warning", onClick ResetGame] [text("Reset")]
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
    , scoreRed = 0
    , scoreBlue = 0
    , turnRed = True
    , showDialog = False
    , answerVisible = False
    , prizeVisible = False
    , currentQuestion = placeholder
    , questions = [placeholder] 
    , cached = [placeholder]
    }, Cmd.map QuestionsMsg fetchAll)

-- APP
main : Program Never Model Msg
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions}


