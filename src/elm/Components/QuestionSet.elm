module Components.QuestionSet exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Components.Question exposing (QuestionId, Question)

type Msg
    = OnFetchAll (Result Http.Error (List Question))


-- switch to 'https://localhost:4000' when running locally
fetchAll : Cmd Msg
fetchAll =
    Http.get "https://radiant-sierra-95673.herokuapp.com" collectionDecoder
        |> Http.send OnFetchAll


collectionDecoder : Decode.Decoder (List Question)
collectionDecoder =
    Decode.list memberDecoder


memberDecoder : Decode.Decoder Question
memberDecoder =
    Decode.map6 Question
        (field "id" Decode.int)
        (field "name" Decode.string)
        (field "answer" Decode.string)
        (field "choices" (Decode.list Decode.string))
        (field "prize" Decode.int)   
        (field "order" Decode.int)    