{- Note: this is almost entirely made based on the following brilliant tutorial:
https://www.elm-tutorial.org/en/07-routing/cover.html
-}

-- Orchestration of all modules - wires up their views, models, messages, updates and navigation.
module Main exposing (..)

import Html exposing (Html, div, h1, text, node, a, span)
import Html.Attributes exposing (href, rel, type_, class)
import Navigation exposing (Location)
import Routing exposing (Route, parseLocation)
import Items.View
import Items.Models
import Items.Updates

-- MODEL
type alias Model = { items : Items.Models.Model, route : Route }
initialModel : Routing.Route -> Model
initialModel route = { items = Items.Models.initialModel, route = route }
init : Location -> (Model, Cmd Msg)
init location = (initialModel (parseLocation location), Cmd.none)

-- UPDATE
type Msg
    = ItemsMsg Items.Updates.Msg
    | OnLocationChange Location

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model
    = case msg of
        ItemsMsg itemsMsg ->
            let ( updatedItemsModel, itemsCmd ) = Items.Updates.update itemsMsg model.items
            in ({ model | items = updatedItemsModel }, Cmd.map ItemsMsg itemsCmd )
        OnLocationChange location -> -- Application navigated to another page or user pasted custom url
            let parsedRoute = parseLocation location in
                case parsedRoute of
                    Routing.ItemsRoute itemsRoute ->
                        let ( updatedItemsModel, itemsCmd ) = Items.Updates.updateRoute itemsRoute model.items
                        in ({ model | route = parsedRoute, items = updatedItemsModel }, Cmd.none )
                    Routing.NotFoundRoute -> ({ model | route = parsedRoute }, Cmd.none )

-- VIEW
view : Model -> Html Msg
view model
    = div [] -- our SPA root, contents are delegated to page selector
        [ stylesheet "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
        , stylesheet "style.css"
        , stylesheet "https://fonts.googleapis.com/css?family=Open+Sans|Roboto"
        , div [ class "container-fluid banner" ] [ h1 [] [ text "Elm Bootstrap Navigation" ] ]
        , div [ class "container contents" ] [ page model ]
        , div [ class "footer color-invert" ]
            [ div []
                [ a [ href "https://www.github.com/jakubrauch/elm-bootstrap-navigation" ]
                    [ span [] [ text "https://github.com/jakubrauch/elm-bootstrap-navigation" ] ]
                ]
            ]
        ]
stylesheet : String -> Html Msg
stylesheet link = node "link" [ (href link), (rel "stylesheet"), (type_ "text/css") ] []

page : Model -> Html Msg -- select view to show, depending on the selected route
page model
    = case model.route of
        Routing.ItemsRoute itemsRoute -> Html.map ItemsMsg (Items.View.view itemsRoute model.items)
        Routing.NotFoundRoute -> pageNotFound
pageNotFound : Html Msg
pageNotFound = div [] [ h1 [] [ text "Route 404" ] ]


-- Main (Navigation)
main : Program Never Model Msg
main
    = Navigation.program OnLocationChange
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }