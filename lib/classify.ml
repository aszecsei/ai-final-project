open Decision_tree_j
open Types
open Reader

(* Used to grab the attribute being considered at a node in dt *)
let rec get_nth l n =
        if n < 0 then failwith "invalid index"
        else match l with
             | [] -> "index out of bounds"
             | h::_ when n = 0 -> h
             | _::t -> get_nth t (n-1)
;;

let rec classify dt (ex: example):string =
        match dt with
        | `Leaf v -> v.result
        | `Node n ->(
                let attr_val = get_nth (ex.attributes) n.category_index in
                let rec findChild nc opt =
                        match nc with
                        | [] -> failwith "No children with option"
                        | h::_ when h.option = opt -> h.child
                        | _::t -> findChild t opt
                in
                let subtree = findChild n.children attr_val in
                classify subtree ex;
        )
;;

let do_classify file dataset write_to =
        let file_contents =
                let ic = open_in file in
                try
                        let contents = input_line ic in
                        close_in ic;
                        contents
                with e ->
                        close_in_noerr ic;
                        raise e in

        let decisionTree = decision_tree_of_string file_contents in

        (* get parsed dataset using reader/parser *)
        let examples = read_gen dataset 1000 in

        (* print dt's classification for each example *)
        let outputStr = ref "" in
        for i = 0 to Array.length examples - 1 do
                (*List.iter (fun x -> Printf.printf "%s " x) examples.(i).attributes;
                print_endline (classify decisionTree examples.(i));*)
                outputStr := (!outputStr)^"\n"^(classify decisionTree examples.(i));
        done;
        print_endline !outputStr;
        match write_to with
        | Some(out_path) -> (
                let outf = open_out out_path in
                Printf.fprintf outf "%s" !outputStr;
                close_out outf
                )
        | _ -> ()
;;
