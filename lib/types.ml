type example={attributes:string list; value:string}
let example_to_str (ex:example) :string=
        let rec mk_attrs_str attrs first=
                match attrs,first with
                | _, true -> "["^(mk_attrs_str attrs false)
                | [], _   -> "]"
                | h::t, _ -> h^";"^(mk_attrs_str t false)
        in
        "{value: "^ex.value^"; attributes: "^(mk_attrs_str ex.attributes true)^"}"
;;

let print_example (ex:example) =
        Printf.printf "%s\n" (example_to_str ex)
;;

let print_example_array (exs:example array) =
        let len = (Array.length exs); in
        for i=0 to len-1 do
                print_example (Array.get exs i);
        done
;;

type attribute = { name:string; possible_values:string array; index: int; }
let attribute_to_str (att:attribute) :string =
        let rec pv_to_str (i:int) =
                let first = if (i = 0) then "[|" else "" in
                if (i >= Array.length att.possible_values) then "|]"
                else first^(Array.get att.possible_values i)^"; "^(pv_to_str (i+1));
        in
        "{ name: "^att.name^"; possible_values: "^(pv_to_str 0)^"; value: "^(string_of_int att.index)^";}"
;;

let print_attribute (att:attribute) =
        Printf.printf "%s\n" (attribute_to_str att)
;;

let print_attribute_array (atts:attribute array) =
        let rec for_loop (i:int) =
                if (i>=(Array.length atts)) then ()
                else (print_attribute (Array.get atts i);
                     (for_loop (i+1)));
        in
        for_loop 0
;;

type dataType = Balance | Mushrooms | TicTacToe | Car

let str = Printf.sprintf
let kind_str = function Balance -> "balance" | Mushrooms -> "mushrooms" | TicTacToe -> "tictactoe" | Car -> "car"

let getDataType (typ:string) : dataType =
        match (String.lowercase_ascii typ) with
        | "balance"   -> Balance
        | "mushrooms" -> Mushrooms
        | "tictactoe" -> TicTacToe
        | "car"       -> Car
        | _           -> failwith "not one of the types we have."
;;

let getCCI (kind:dataType) :int =
        match kind with
        | Balance   -> 0
        | Mushrooms -> 0
        | TicTacToe -> 9
        | Car       -> 6
;;

let getClassifications (kind:dataType) :string array =
        (*balance classification*)
        let balance_classes   = [|"L"; "B"; "R"|] in
        (*mushrooms classification*)
        let mushrooms_classes = [|"e";"p"|] in
        (*tictactoe classification*)
        let ttt_classes       = [|"positive";"negative"|] in
        (*cars classification*)
        let car_classes       = [|"unacc";"acc";"good";"vgood"|] in
        match kind with
        | Balance   -> balance_classes
        | Mushrooms -> mushrooms_classes
        | TicTacToe -> ttt_classes
        | Car       -> car_classes

let getAttributes (kind:dataType) =
        (*balance attributes *)
        let leftWeight  = { name = "Left-Weight";    possible_values = [|"1";"2";"3";"4";"5"|]; index = 0;} in
        let leftDist    = { name = "Left-Distance";  possible_values = [|"1";"2";"3";"4";"5"|]; index = 1;} in
        let rightWeight = { name = "Right-Weight";   possible_values = [|"1";"2";"3";"4";"5"|]; index = 2;} in
        let rightDist   = { name = "Right-Distance"; possible_values = [|"1";"2";"3";"4";"5"|]; index = 3;} in
        (*mushrooms attributes*)
        let capShape            = { name = "cap-shape";   
                                    possible_values = [|"b";"c";"x";"f";"k";"s"|];
                                    index = 0;
                                  } in
        let capSurface          = { name = "cap-surface";
                                    possible_values = [|"f";"g";"y";"s"|];
                                    index = 1;
                                  } in
        let capColor            = { name = "cap-color";
                                    possible_values = [|"n";"b";"c";"g";"r";"p";"u";"e";"w";"y";|];
                                    index = 2;
                                  } in
        let bruises             = { name = "bruises";
                                    possible_values = [|"t";"f"|];
                                    index = 3;
                                  } in
        let odor                = { name = "oder";
                                    possible_values = [|"a";"l";"c";"y";"f";"m";"n";"p";"s";|];
                                    index = 4;
                                  } in
        let gillAttachment      = { name = "gill-attachment";
                                    possible_values = [|"a";"d";"f";"n"|];
                                    index = 5;
                                  } in
        let gillSpacing         = { name = "gill-spacing";
                                    possible_values = [|"c";"w";"d"|];
                                    index = 6;
                                  } in
        let gillSize            = { name = "gill-size";
                                    possible_values = [|"b";"n"|];
                                    index = 7;
                                  } in
        let gillColor           = { name = "gill-color";
                                    possible_values = [|"k";"n";"b";"h";"g";"r";"o";"p";"u";"e";"w";"y"|];
                                    index = 8;
                                  } in
        let stalkShape          = { name = "stalk-shape";
                                    possible_values = [|"e";"t"|];
                                    index = 9;
                                  } in
        let stalkRoot           = { name = "stalk-root";
                                    possible_values = [|"b";"c";"u";"e";"z";"r";"?"|];
                                    index = 10;
                                  } in
        let stalkSurfAboveRing  = { name = "stalk-surface-above-ring";
                                    possible_values = [|"f";"y";"k";"s"|];
                                    index = 11;
                                  } in
        let stalkSurfBelowRing  = { name = "stalk-surface-above-ring";
                                    possible_values = [|"f";"y";"k";"s"|];
                                    index = 12;
                                  } in
        let stalkColorAboveRing = { name = "stalk-color-above-ring";
                                    possible_values = [|"n";"b";"c";"g";"o";"p";"e";"w";"y"|];
                                    index = 13;
                                  } in
        let stalkColorBelowRing = { name = "stalk-color-below-ring";
                                    possible_values = [|"n";"b";"c";"g";"o";"p";"e";"w";"y"|];
                                    index = 14;
                                  } in
        let veilType            = { name = "veil-type";
                                    possible_values = [|"p";"u"|];
                                    index = 15;
                                  } in
        let veildColor          = { name = "veil-color";
                                    possible_values = [|"n";"o";"w";"y"|];
                                    index = 16;
                                  } in 
        let ringNumber          = { name = "ring-number";
                                    possible_values = [|"n";"o";"t"|];
                                    index = 17;
                                  } in
        let ringType            = { name = "ring-type";
                                    possible_values = [|"c";"e";"f";"l";"n";"p";"s";"z"|];
                                    index = 18;
                                  } in
        let sporePrintColor     = { name = "spore-print-color";
                                    possible_values = [|"k";"n";"b";"h";"r";"o";"u";"w";"y"|];
                                    index = 19;
                                  } in
        let population          = { name = "population";
                                    possible_values = [|"a";"c";"n";"s";"v";"y"|];
                                    index = 20;
                                  } in
        let habitat             = { name = "habitat";
                                    possible_values = [|"g";"l";"m";"p";"u";"w";"d"|];
                                    index = 21
                                  } in
        (*tictactoe attributes*)
        let cell1 = { name = "cell[1,1]"; possible_values = [|"x";"o";"b"|]; index = 0;} in
        let cell2 = { name = "cell[2,1]"; possible_values = [|"x";"o";"b"|]; index = 1;} in
        let cell3 = { name = "cell[3,1]"; possible_values = [|"x";"o";"b"|]; index = 2;} in
        let cell4 = { name = "cell[1,2]"; possible_values = [|"x";"o";"b"|]; index = 3;} in
        let cell5 = { name = "cell[2,2]"; possible_values = [|"x";"o";"b"|]; index = 4;} in
        let cell6 = { name = "cell[3,2]"; possible_values = [|"x";"o";"b"|]; index = 5;} in
        let cell7 = { name = "cell[1,3]"; possible_values = [|"x";"o";"b"|]; index = 6;} in
        let cell8 = { name = "cell[2,3]"; possible_values = [|"x";"o";"b"|]; index = 7;} in
        let cell9 = { name = "cell[3,3]"; possible_values = [|"x";"o";"b"|]; index = 8;} in
        (*car attributes*)
        let buying   = { name = "buying";   possible_values = [|"vhigh";"high";"med";"low"|]; index = 0} in
        let maint    = { name = "maint";    possible_values = [|"vhigh";"high";"med";"low"|]; index = 1} in
        let doors    = { name = "doors";    possible_values = [|"2";"3";"4";"5more"|];        index = 2} in
        let persons  = { name = "persons";  possible_values = [|"2";"4";"more"|];             index = 3} in
        let lug_boot = { name = "lug_boot"; possible_values = [|"small";"med";"big"|];        index = 4} in
        let safety   = { name = "safety";   possible_values = [|"low";"med";"high"|];         index = 5} in

        match kind with
        | Balance   -> [| leftWeight; leftDist; rightWeight; rightDist;|]
        | Mushrooms -> [| capShape; capSurface; capColor; bruises; odor;
                          gillAttachment; gillSpacing; gillSize; gillColor;
                          stalkShape; stalkRoot; stalkSurfAboveRing;
                          stalkSurfBelowRing; stalkColorAboveRing;
                          stalkColorBelowRing; veilType; veildColor; ringNumber;
                          ringType; sporePrintColor; population; habitat;|]
        | TicTacToe -> [| cell1; cell2; cell3; cell4; cell5; cell6; cell7; cell8; cell9|]
        | Car       -> [| buying; maint; doors; persons; lug_boot; safety|]
