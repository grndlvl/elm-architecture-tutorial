import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Guards exposing (..)



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
  | NewFaces (Int, Int)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFaces (Random.pair dieNumber dieNumber) )

    NewFaces (new1Face, new2Face) ->
      (Model new1Face new2Face, Cmd.none)


dieNumber : Random.Generator Int
dieNumber =
  Random.int 1 6

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  let
      (x1Offset, y1Offset) = getOffset model.die1Face
      (x2Offset, y2Offset) = getOffset model.die2Face
  in
    div []
      [ div [ style [("background", "url(./dice.png) " ++ x1Offset ++ " " ++ y1Offset), ("width", "112px"), ("height", "122px")] ] []
      , div [ style [("background", "url(./dice.png) " ++ x2Offset ++ " " ++ y2Offset), ("width", "112px"), ("height", "122px")] ] []
      , button [ onClick Roll ] [ text "Roll" ]
      ]

getOffset : Int -> (String, String)
getOffset x = x == 2 => ("-114.5px", "0")
  |= x == 3 => ("-224px", "0")
  |= x == 4 => ("0", "-122px")
  |= x == 5 => ("-115px", "-122px")
  |= x == 6 => ("-224px", "-122px")
  |= ("0", "0")
