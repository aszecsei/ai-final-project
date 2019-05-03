open Lib.Reader
open Lib.Types
(*
 * first argument is the type of data (Balance | Mushrooms | TicTacToe | #$#$#$##$#$)
 * second argument is the file path for the file that contains the data in CSV format
 *)
let () =
        if Array.length Sys.argv <> 3 then 
                failwith "Wrong parameters"
        else (
                let kind = getDataType Sys.argv.(1) in
                let cci = getCCI kind in
                let examples = read_gen Sys.argv.(2) cci in
                print_example_array examples
             )
;;
