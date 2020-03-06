module TransientState.Toggle
    exposing
        ( content
        , initiallyClosed
        , initiallyClosedOnChange
        , initiallyOpen
        , initiallyOpenOnChange
        , onClick
        )

import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode as Decode


initiallyOpen : List (Html msg) -> Html msg
initiallyOpen =
    containerWithDefault True Nothing


initiallyOpenOnChange : (Bool -> msg) -> List (Html msg) -> Html msg
initiallyOpenOnChange toMsg =
    containerWithDefault True (Just toMsg)


initiallyClosed : List (Html msg) -> Html msg
initiallyClosed =
    containerWithDefault False Nothing


initiallyClosedOnChange : (Bool -> msg) -> List (Html msg) -> Html msg
initiallyClosedOnChange toMsg =
    containerWithDefault False (Just toMsg)


content : Attribute msg
content =
    Attr.attribute "ui-toggle-content" "open"


onClick : Attribute msg
onClick =
    Attr.attribute "ui-toggle" "open"


containerWithDefault : Bool -> Maybe (Bool -> msg) -> List (Html msg) -> Html msg
containerWithDefault isOpen maybeToMsg =
    Html.node "ui-toggle"
        [ Attr.attribute "open" (if isOpen then "true" else "false")
        , case maybeToMsg of
            Just toMsg ->
                Events.on "change" (Decode.map toMsg (Decode.at ["detail", "open"] Decode.bool))

            Nothing ->
                Attr.class ""
        --, Attr.property "key" (Encode.string "accordion1")
        ]