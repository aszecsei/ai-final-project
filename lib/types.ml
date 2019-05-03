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

let getClassifications (kind:dataType) :string array =
        (*balance classification*)
        let balance_classes = [|"L"; "B"; "R"|] in
        (*mushrooms classification*)
        let mushrooms_classes = [|"e";"p"|] in
        (*tictactoe classification*)
        let ttt_classification = [|"positive";"negative"|]
        match kind with
        | Balance   -> balance_classes
        | Mushrooms -> mushrooms_classes
        | _         -> failwith "not one of our data sets"

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
                                    possible_values = [|"k";"n";"b";"h";"g";"r";"o";"p";"u";"e";"w";"y"|]
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
                                    possible_values = [|"c";"e";"f";"l";"n";"p";"s";"z"|]
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
        let call1 = { name = "cell[1,1]"; possible_values = [|"x";"o";"b"|]; index = 0;} in
        let call2 = { name = "cell[2,1]"; possible_values = [|"x";"o";"b"|]; index = 1;} in
        let call1 = { name = "cell[3,1]"; possible_values = [|"x";"o";"b"|]; index = 2;} in
        match kind with
        | Balance   -> [| leftWeight; leftDist; rightWeight; rightDist;|]
        | Mushrooms -> [| capShape; capSurface; capColor; bruises; odor;
                          gillAttachment; gillSpacing; gillSize; gillColor;
                          stalkShape; stalkRoot; stalkSurfAboveRing;
                          stalkSurfBelowRing; stalkColorAboveRing;
                          stalkColorBelowRing; veilType; veildColor; ringNumber;
                          ringType; sporePrintColor; population; habitat;|]
        | _         -> failwith "not one of our data sets"



















