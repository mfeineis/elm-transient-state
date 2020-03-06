module App exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes as Attr
import Html.Events exposing (onClick, onInput)
import TransientState.Toggle as Toggle


type alias Model =
    { isOpen : Bool
    , searchText : String
    }

type Msg
    = SearchTextChanged String
    | LocalOpenStateChanged Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        LocalOpenStateChanged open ->
            { model | isOpen = open
            }

        SearchTextChanged t ->
            { model | searchText = t
            }


view : Model -> Html Msg
view { isOpen, searchText } =
    Toggle.initiallyClosedOnChange LocalOpenStateChanged
        [ button [ Toggle.onClick ] [ text "Accordion" ]
        , div [ Toggle.content, Attr.style "background-color" "#eee" ]
            [ div [] [ text "Some content to hide" ]
            , input [ onInput SearchTextChanged, Attr.type_ "text" ] []
            , button [ Toggle.onClick ] [ text "Close from within content" ]
            ]
        , div [] [ text searchText, text "|", text <| if isOpen then "open" else "closed" ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = { isOpen = False, searchText = "" }
        , view = view
        , update = update
        }