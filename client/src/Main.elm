module Main exposing (..)

import Html exposing (..)
import Http
import Json.Decode as Decode
import Json.Encode as Encode


-- MESSAGES


type Msg
    = OnResponse (Result Http.Error String)



-- MODELS


type alias Model =
    { result : Result Http.Error String
    }


type alias Client =
    { name : String
    }


type alias Field =
    { name : String
    , params : Params
    , fields : Fields
    }


type Param
    = ParamId Int


type Fields
    = Fields (List Field)


type Params
    = Params (List Param)


field : String -> List Param -> List Field -> Field
field name params fields =
    Field name (Params params) (Fields fields)


typedQuery : Fields
typedQuery =
    Fields
        [ field "client"
            [ ParamId 1 ]
            [ field "name" [] []
            ]
        ]


fieldToString : Field -> String
fieldToString { name, params, fields } =
    name ++ paramsToString params ++ " " ++ fieldsToString fields


paramsToString : Params -> String
paramsToString (Params params) =
    if List.isEmpty params then
        ""
    else
        List.map paramToString params
            |> String.join ","
            |> wrapString "(" ")"


paramToString : Param -> String
paramToString param =
    case param of
        ParamId id ->
            "id: " ++ toString id


fieldsToString : Fields -> String
fieldsToString (Fields fields) =
    if List.isEmpty fields then
        ""
    else
        let
            str =
                List.map fieldToString fields
                    |> List.foldr (++) ""
        in
            "{ " ++ str ++ " }"


wrapString : String -> String -> String -> String
wrapString pre suf target =
    pre ++ target ++ suf


initialModel : Model
initialModel =
    { result = Ok "Waiting"
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnResponse result ->
            ( { model | result = result }, Cmd.none )


query =
    """query {
        client(id: 1) {
            name
        }
    }
"""



-- COMMANDS


sendQueryRequest =
    let
        -- jsonBody =
        --     Encode.object [ ( "query", query |> Encode.string ) ]
        body =
            Http.stringBody "application/graphql" query

        url =
            "http://localhost:3000/graphql"
    in
        Http.request
            { method = "POST"
            , headers = []
            , url = url
            , body = body
            , expect = Http.expectString
            , timeout = Nothing
            , withCredentials = False
            }


sendQueryCommand =
    Http.send OnResponse sendQueryRequest



-- VIEWS


view : Model -> Html Msg
view model =
    div []
        [ text (toString model.result)
        ]



-- PROGRAM


init : ( Model, Cmd Msg )
init =
    ( initialModel, sendQueryCommand )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
