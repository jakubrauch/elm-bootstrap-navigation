{- Note: this is almost entirely made based on the following brilliant tutorial:
https://www.elm-tutorial.org/en/07-routing/cover.html
-}

module Items.Updates exposing (..)
import Items.Models exposing (..)
import Items.Routing exposing (..)
import Navigation

-- MESSAGES
-- Operations that can be done on item(s)
type Msg
    = NewItem -- List page action - create new item
    | RemoveItem Id -- List page action - remove item with given id
    | StartEditingItem Id -- List page action - show edit page for given item
    | ItemValueChange String -- Edit page action - modify temporary item's value to given string
    | Save Item -- Edit page action - update items list with the passed item

-- UPDATES
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model
    = case msg of
        NewItem -> (model, Navigation.newUrl ("#items/new")) -- C
        RemoveItem id -> ({ model | list = List.filter (\t -> t.id /= id) model.list }, Cmd.none ) -- D
        StartEditingItem id -> (model, Navigation.newUrl ("#items/" ++ toString (id))) -- RU
        ItemValueChange newValue -> let modelEdit = model.edit in
            ({ model | edit = Maybe.map (\m ->  { m | value = newValue }) modelEdit }, Cmd.none)
        Save item -> ({ model | list = (updateList item model.list), edit = Nothing }, Navigation.newUrl ("#items"))

updateRoute : Route -> Model -> ( Model, Cmd Msg )
updateRoute route model
    = case route of
        ListRoute -> model ! []
        NewItemRoute -> { model | edit = Just ({ id = -1, value = "" }) } ! []
        EditItemRoute id -> { model | edit = findItem id model } ! []



newId : List Item -> Id
newId items =
    List.map (.id) items |> List.foldl Basics.max 0 |> (+) 1

updateList : Item -> List Item -> List Item
updateList item list -- if item existed then update it, create otherwise
    = if item.id == -1 then
        { item | id = newId list } :: list
    else case List.filter (\i -> i.id == item.id) list of
        h :: t -> List.map (\i -> if i.id == item.id then item else i) list
        [] -> item :: list

findItem : Id -> Model -> Maybe Item
findItem id model
    = List.filter (\i -> i.id == id) model.list
    |> List.head