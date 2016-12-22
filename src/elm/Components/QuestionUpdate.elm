module Components.QuestionUpdate exposing (..)

import Components.QuestionSet exposing (Msg(..))
import Components.Question exposing (Question)


update : Msg -> List Question -> ( List Question, Cmd Msg )
update message questions =
    case message of
        OnFetchAll (Ok newQuestions) ->
            ( newQuestions, Cmd.none )
        OnFetchAll (Err error) ->
            ( questions, Cmd.none )