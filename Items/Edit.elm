{- Note: this is almost entirely made based on the following brilliant tutorial:
https://www.elm-tutorial.org/en/07-routing/cover.html
-}

module Items.Edit exposing (..)

import Html exposing (Html, div, h1, button, span, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Navigation
import Items.Models exposing (Model)
import Items.Updates exposing (Msg(..))

-- View
view : Model -> Html Items.Updates.Msg
view model
    = case model.edit of
        Nothing ->
            div [] [ h1 [] [ text "No item being edited." ] ] -- TODO: Do we want to handle this?
        Just edit ->
            div [ class "row" ]
                [ div [ class "col-sm-offset-3 col-sm-6" ]
                    [ div [ class "input-group input-group-lg" ]
                        [ input [ value edit.value, onInput ItemValueChange, type_ "text", class "form-control", placeholder "item" ] []
                        , span [ class "input-group-btn" ]
                            [ button [ class "btn btn-primary", type_ "button", onClick (Save edit) ]
                                [ text "Save" ]
                            ]
                        ]
                    ]
                ]
