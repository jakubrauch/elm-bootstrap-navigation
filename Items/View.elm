module Items.View exposing (..)

import Html exposing (Html)
import Items.Routing exposing (..)
import Items.List
import Items.Edit
import Items.Models
import Items.Updates

-- VIEW
view : Items.Routing.Route -> Items.Models.Model -> Html Items.Updates.Msg
view route model = case route of
    ListRoute -> Items.List.view model
    NewItemRoute -> Items.Edit.view model
    EditItemRoute id -> Items.Edit.view model
