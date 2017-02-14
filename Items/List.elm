{- Note: this is almost entirely made based on the following brilliant tutorial:
https://www.elm-tutorial.org/en/07-routing/cover.html
-}

module Items.List exposing (..)

import Html exposing (program, Html, div, button, span, node, text, h1, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Routing exposing (Route)
import Navigation exposing (Location)
import Items.Models exposing (..)
import Items.Updates exposing (..)

-- View
view : Model -> Html Items.Updates.Msg
view model
    = div []
        ( div [ class "row" ] -- new item row
            [ div [ class "col-xs-12 col-sm-offset-3 col-sm-6 text-right" ]
                [ button [class "btn btn-primary", onClick NewItem ] [ span [ class "glyphicon glyphicon-plus" ] [] ]
                ]
            ]
        ::
        List.map -- list of existing items
            ( \item -> div [ class "row" ]
                [ div [ class "col-xs-12 col-sm-offset-3 col-sm-6" ]
                    [ div [ class "item text-right" ]
                        [ span [] [ text item.value ]
                        , button [ class "btn btn-danger", onClick (RemoveItem item.id) ]
                            [ span [ class "glyphicon glyphicon-remove" ] [] ]
                        , button [class "btn btn-primary", onClick (StartEditingItem item.id) ]
                            [ span [ class "glyphicon glyphicon-pencil" ] [] ]
                        ]
                    ]
                ]
            )
            model.list
        )
