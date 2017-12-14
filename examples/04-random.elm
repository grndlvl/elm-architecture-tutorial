import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { die1Face : Int
  , die2Face : Int
  }


init : (Model, Cmd Msg)
init =
  (Model 1 1, Cmd.none)



-- UPDATE


type Msg
  = Roll
  | NewFace Int Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.pair (Random.int 1 6) (Random.int 1 6)) )

    NewFace new1Face new2Face ->
      (Model new1Face new2Face, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  let
      (x1Offset, y1Offset) = getOffset model.die1Face
  in
    div []
      [ h1 [] [ text (toString model.die1Face) ]
      , div [ style [("background", "url(./dice.png) " ++ x1Offset ++ " " ++ y1Offset), ("width", "112px"), ("height", "122px")] ] []
      --, div [ style [("background", "url(./dice.png) " ++ xOffset ++ " " ++ yOffset), ("width", "112px"), ("height", "122px")] ] []
      , button [ onClick Roll ] [ text "Roll" ]
      ]

getOffset : Int -> (String, String)
getOffset x =
  if x == 2 then
    ("-114.5px", "0")
  else if x == 3 then
    ("-224px", "0")
  else if x == 4 then
    ("0", "-122px")
  else if x == 5 then
    ("-115px", "-122px")
  else if x == 6 then
    ("-224px", "-122px")
  else
    ("0", "0")
