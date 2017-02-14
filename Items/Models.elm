{- Note: this is almost entirely made based on the following brilliant tutorial:
https://www.elm-tutorial.org/en/07-routing/cover.html
-}

module Items.Models exposing (..)

type alias Id = Int
type alias Item = { id: Id, value: String }
type alias Items = List Item
type alias Model = { list: Items, edit: Maybe Item }

initialModel : Model
initialModel = { list = [], edit = Nothing }
