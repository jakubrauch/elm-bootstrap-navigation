module Items.Routing exposing (..)

-- All available routes for Items.
type alias ItemId = Int
type Route
    = ListRoute -- represents my items list page
    | NewItemRoute -- represents new item page
    | EditItemRoute ItemId -- represents detailed view of an item