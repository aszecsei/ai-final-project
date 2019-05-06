open Lib.Decision_tree_j
open Lib.Types
open Lib.Reader

let () = if Array.length Sys.argv <> 3 
    then failwith "Wrong parameters"

let file = Sys.argv.(1) (* path to decision tree *)
let dataset = Sys.argv.(2) (* path to dataset *)

let file_contents = 
  let ic = open_in file in
  try
    match input_line ic with
    | contents -> 
      close_in ic;
      contents

  with e ->
    close_in_noerr ic;
    raise e
;;

(* Used to grab the attribute being considered at a node in dt *)
let rec get_nth l n = 
  if n < 0 then failwith "invalid index"
  else match l with 
  | [] -> "index out of bounds"
  | h::_ when n = 0 -> h
  | _::t -> get_nth t (n-1)

let decisionTree = decision_tree_of_string file_contents ;;

(* get parsed dataset using reader/parser *)
let examples = read_gen dataset 1000

let rec classify dt (ex: example) = 
  match dt with 
  | `Leaf v -> v.result
  | `Node n -> 
    let attr_val = get_nth (ex.attributes) n.category_index in
    let rec findChild nc opt = 
      match nc with 
      | [] -> failwith "No children with option"
      | h::_ when h.option = opt -> h.child
      | _::t -> findChild t opt in
      let subtree = findChild n.children attr_val in 
      classify subtree ex

(* print dt's classification for each example *)
let () =
    for i = 0 to Array.length examples - 1 do
      (* List.iter (fun x -> Printf.printf "%s " x) examples.(i).attributes; *)
      print_endline (classify decisionTree examples.(i));
    done;;
