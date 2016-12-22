import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Components.QuestionModal exposing ( questionModal )


-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Model =
  { showModal : Bool
  }


model : Model
model =  
  { showModal = True
  }


-- UPDATE
type Msg 
  = OpenModal
  | CloseModal
  | NoOp

update : Msg -> Model -> Model
update msg model =
  case msg of
    OpenModal ->
      { model | showModal = True }
    CloseModal ->
      { model | showModal = False }
    NoOp -> model


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container" ] [
    div [ id "gameboard", style [("margin-top", "30px"), ( "text-align", "center" ), ("background-image", "url(static/img/pyramid.jpg)")] ][
      div [class "row"] [
        h1 [ id "title"] [ text ("SphynxQuest")],
        div [class "col-md-4 question"] [
          img [class "img-responsive", src "static/img/sphynxsprite.png", onClick OpenModal] []
        ]
      ]
    ],
    questionModal model
  ]
  



