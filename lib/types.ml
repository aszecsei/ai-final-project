type example={attributes:string list; value:string}
type attribute = { name:string; possible_values:string array; index: int; }
type dataType = Balance | Mushrooms | TicTacToe | Unnamed
let getDataType (typ:string) : dataType =
        match (String.lowercase_ascii typ) with
        | "balance" -> Balance
        | "mushrooms" -> Mushrooms
        | "tictactoe" -> TicTacToe
        | _ -> failwith "not one of our data sets"
;;

let getCCI (kind:dataType) :int =
        match kind with
        | Balance   -> 0
        | Mushrooms -> 0
        | TicTacToe -> 9
        | _         -> failwith "not one of our data sets"
;;
