open Lib.Reader
open Lib.Types
open Lib.Creator
open Lib.Decision_tree_j
open Yojson.Safe
(*
 * first argument is the type of data (Balance | Mushrooms | TicTacToe | Car) case insensitive
 * second argument is the file path for the file that contains the data in CSV format
 * third argument is the file path for where to spit the json output
 *)
let () =
        let len = Array.length Sys.argv in
        if len < 3 then 
                failwith "Wrong parameters"
        else (
                let doPretty   = (len>3)&&(String.contains Sys.argv.(3) 'p') in
                let doWrite    = (len>3)&&(String.contains Sys.argv.(3) 'w') in
                let kind       = getDataType Sys.argv.(1) in
                let cci        = getCCI kind in
                let classes    = getClassifications kind in 
                let examples   = read_gen Sys.argv.(2) cci in
                let attributes = getAttributes kind in
                (*let temp cls =(*this is for debug purposes*) 
                        let rec for_loop (i:int) =
                                if (i>=(Array.length cls)) then ()
                                else (Printf.printf "%s; " (Array.get cls i);
                                     (for_loop (i+1)));
                        in
                        for_loop 0;
                        Printf.printf "\n";
                in*)
                let tree = decision_tree_learning examples attributes [||] classes in
                let tree_str = 
                        if doPretty then (pretty_to_string (from_string (string_of_decision_tree tree))) 
                        else (string_of_decision_tree tree)
                in
                let writeOut str =
                        if (len<5) then failwith "need to provide the file path for out put with write option"
                        else (
                                let outf = open_out Sys.argv.(4) in
                                Printf.fprintf outf "%s" str;
                                close_out outf;
                             )
                in
                (*print_example_array (Array.sub examples 0 10); (*FOR DEBUG PURPOSES*)
                print_attribute_array attributes; (*FOR DEBUG PURPOSES*)
                temp classes; (*FOR DEBUG PURPOSES*)*)
                Printf.printf "%s\n" tree_str;
                if doWrite then writeOut tree_str else ();
            )
;;
