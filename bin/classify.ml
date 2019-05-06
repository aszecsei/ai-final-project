open Lib.Decision_tree_j
open Lib.Types
open Lib.Reader
open Cmdliner

let classify file dataset =
        let file_contents = 
                let ic = open_in file in
                try
                        let contents = input_line ic in
                        close_in ic;
                        contents
                with e ->
                        close_in_noerr ic;
                        raise e in
        
        (* Used to grab the attribute being considered at a node in dt *)
        let rec get_nth l n = 
                if n < 0 then failwith "invalid index"
                else match l with 
                     | [] -> "index out of bounds"
                     | h::_ when n = 0 -> h
                     | _::t -> get_nth t (n-1) in
        
        let decisionTree = decision_tree_of_string file_contents in

        (* get parsed dataset using reader/parser *)
        let examples = read_gen dataset 1000 in

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
                classify subtree ex in
        (* print dt's classification for each example *)
        for i = 0 to Array.length examples - 1 do
                (* List.iter (fun x -> Printf.printf "%s " x) examples.(i).attributes; *)
                print_endline (classify decisionTree examples.(i));
        done;;

let tree =
        let doc = "The path to the file containing a decision tree JSON." in
        Arg.(required & (pos 0 (some non_dir_file) None) & info [] ~docv:"TREE" ~doc)

let dataset =
        let doc = "The path to the file containing a comma-separated list of records." in
        Arg.(required & (pos 1 (some non_dir_file) None) & info [] ~docv:"DATA" ~doc)

let classify_t = Term.(const classify $ tree $ dataset)
let info =
        let doc = "classify data using a decision tree" in
        let man = [
                `S Manpage.s_description;
                `P "$(tname) classifies data using a decision tree.";
                `S Manpage.s_bugs;
                `P "Email bug reports to <aszecsei@gmail.com>."
        ] in
        Term.info "classify" ~version:"v1.0.0" ~doc ~exits:Term.default_exits ~man

let () = Term.exit @@ Term.eval (classify_t, info)