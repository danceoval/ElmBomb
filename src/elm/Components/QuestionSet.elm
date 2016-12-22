module Components.QuestionSet exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Components.Question exposing (QuestionId, Question)

type Msg
    = OnFetchAll (Result Http.Error (List Question))

fetchAll : Cmd Msg
fetchAll =
    Http.get fetchAllUrl collectionDecoder
        |> Http.send OnFetchAll


fetchAllUrl : String
fetchAllUrl =
    "http://localhost:4000/questions"


collectionDecoder : Decode.Decoder (List Question)
collectionDecoder =
    Decode.list memberDecoder


memberDecoder : Decode.Decoder Question
memberDecoder =
    Decode.map4 Question
        (field "id" Decode.string)
        (field "name" Decode.string)
        (field "answer" Decode.string)
        (field "prize" Decode.int)    