import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode



main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { topic : String
  , gifUrl : String
  , errorMessage : String
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "waiting.gif" ""
  , getRandomGif topic
  )



-- UPDATE


type Msg
  = MorePlease
  | NewTopic String
  | NewGif (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      ({ model | gifUrl = "waiting.gif" }, getRandomGif model.topic)

    NewGif (Ok newUrl) ->
      (Model model.topic newUrl "", Cmd.none)

    NewGif (Err _) ->
      ({ model | errorMessage = "Unable to change image because we could not fetch a new one from giphy.", gifUrl = "waiting.gif" }, Cmd.none)

    NewTopic topic ->
      ({ model | topic = topic }, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , img [ src model.gifUrl ] []
    , div [ style [("color", "red")] ] [ text model.errorMessage ]
    , br [] []
    , input [ onInput NewTopic, placeholder "Topic" ] []
    , br [] []
    , button [ onClick MorePlease ] [ text "More Please!" ]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Http.send NewGif (Http.get url decodeGifUrl)


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
  Decode.at ["data", "image_url"] Decode.string
