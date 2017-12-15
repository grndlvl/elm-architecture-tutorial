import Html exposing (Html)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { time : Time
  , isStopped : Bool
  }


init : (Model, Cmd Msg)
init =
  (Model 0 False, Cmd.none)



-- UPDATE


type Msg
  = Tick Time
  | StopClock
  | RestartClock


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({ model | time = newTime }, Cmd.none)


    StopClock ->
      ({ model | isStopped = True }, Cmd.none)


    RestartClock ->
      ({ model | isStopped = False }, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  if model.isStopped then
    Sub.none
  else
    Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
  let
    (secondHandX, secondHandY) =
      getSecondHandCoords model.time

    (minuteHandX, minuteHandY) =
      getMinuteHandCoords model.time

    (buttonEvent, buttonText) =
      if model.isStopped then
        (RestartClock, "Start")
      else
        (StopClock, "Stop")

  in
    Html.div [] [ svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 secondHandX, y2 secondHandY, stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 minuteHandX, y2 minuteHandY, stroke "#023963" ] []
      ]
    , Html.button [ Html.Events.onClick buttonEvent ] [ Html.text buttonText ]
    ]

getSecondHandCoords : Time -> (String, String)
getSecondHandCoords time =
  let
    angle =
      turns (Time.inMinutes time)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
      (handX, handY)

getMinuteHandCoords : Time -> (String, String)
getMinuteHandCoords time =
  let
    angle =
      turns (Time.inHours time)

    handX =
      toString (50 + 30 * cos angle)

    handY =
      toString (50 + 30 * sin angle)
  in
      (handX, handY)
