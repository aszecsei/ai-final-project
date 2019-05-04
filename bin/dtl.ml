open Lib.Reader
open Lib.Types
open Lib.Creator
open Lib.Decision_tree_j
(*
 * first argument is the type of data (Balance | Mushrooms | TicTacToe | #$#$#$##$#$)
 * second argument is the file path for the file that contains the data in CSV format
 *)
let () =
        if Array.length Sys.argv <> 3 then 
                failwith "Wrong parameters"
        else (
                let kind       = getDataType Sys.argv.(1) in
                let cci        = getCCI kind in
                let classes    = getClassifications kind in 
                let examples   = read_gen Sys.argv.(2) cci in
                let attributes = getAttributes kind in
                let temp cls =(*this is for debug purposes*) 
                        let rec for_loop (i:int) =
                                if (i>=(Array.length cls)) then ()
                                else (Printf.printf "%s; " (Array.get cls i);
                                     (for_loop (i+1)));
                        in
                        for_loop 0;
                        Printf.printf "\n";
                in
                let tree = decision_tree_learning examples attributes [||] classes in
                print_example_array (Array.sub examples 0 10); (*FOR DEBUG PURPOSES*)
                print_attribute_array attributes; (*FOR DEBUG PURPOSES*)
                temp classes; (*FOR DEBUG PURPOSES*)
                Printf.printf "%s\n" (string_of_decision_tree tree) 
             )
;;
