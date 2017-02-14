{- Note: this is almost entirely made based on the following brilliant tutorial:
https://www.elm-tutorial.org/en/07-routing/cover.html
-}

module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Items.Routing exposing (..)

-- All available routes (pages) in our application
type alias ItemId = Int
type Route
    = ItemsRoute Items.Routing.Route -- represents items routes
    | NotFoundRoute -- represents a 404 page

-- This is how we structure our pages
matchers : Parser (Route -> a) a
matchers
    = oneOf
        [ map (ItemsRoute ListRoute) top -- ListRoute is top-level page
        , map (NewItemRoute |> ItemsRoute) (s "items" </> s "new")
        , map (\i -> EditItemRoute i |> ItemsRoute) (s "items" </> int) -- /items/{int} resolves to Items Edit (int) page
        , map (ItemsRoute ListRoute) (s "items") -- /items path resolves to ItemsListRoute as well
        ] -- note - order is important, not matched pages are handled by parseLocation specified below

-- This function converts current location (url string) to one of our available Routes (pages)
parseLocation : Location -> Route
parseLocation location
    = case (parseHash matchers location) of -- we could use parsePath instead to parse entire location, not just hash
        Just route ->
            route
        Nothing ->
            NotFoundRoute -- If no route matched - return NotFoundRoute
