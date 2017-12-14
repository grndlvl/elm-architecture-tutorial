import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String exposing (..)
import Char exposing (..)
import Result exposing (withDefault)
import Debug exposing (..)


main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL


type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , age : String
  , error : String
  , color : String
  }


model : Model
model =
  Model "" "" "" "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Validate


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Age age ->
      { model | age = age }

    Validate ->
      let
          (color, error) = validate model
      in
        { model | color = color, error = error }

-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [ type_ "text", placeholder "Name", onInput Name ] []
    , input [ type_ "password", placeholder "Password", onInput Password ] []
    , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , input [ type_ "text", placeholder "Age", onInput Age ] []
    , div [ style [("color", model.color)] ] [ text model.error ]
    , button [ onClick Validate ] [ text "Submit" ]
    ]

validate : Model -> (String, String)
validate model =
  if length model.age > 0 && not (isNumber model.age) then
    ("red", "Age must be a valid number.")
  else if length model.password > 0 then
    if length model.password < 8 then
      ("red", "Password must be greater than 8 characters!")
    else if not (any isDigit model.password) then
      ("red", "Password must contain a numeric caracter.")
    else if not (any isLower model.password) then
      ("red", "Password must contain a lowercase character.")
    else if not (any isUpper model.password) then
      ("red", "Password must contain a uppercase character.")
    else if not (model.password == model.passwordAgain) then
      ("red", "Passwords do not match!")
    else
      ("green", "OK")
  else
    ("green", "OK")


isNumber : String -> Bool
isNumber s =
  let
      n = toInt s
  in
    case n of
      (Ok num) -> True
      _ -> False
