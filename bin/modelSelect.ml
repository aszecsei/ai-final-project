open Lib.Reader
open Lib.Cross
open Lib.Types
open Yojson.Safe
open Lib.Decision_tree_j
open Cmdliner

let model_select _kind _examples _k write_tree_to write_stat_to should_pretty_print _max_depth =
        let kind = getDataType _kind in
        let cci = getCCI kind in
        let max_depth =
                match _max_depth with
                | Some(_max_dep) -> _max_dep
                | _              -> 10
        in
        let k = 
                match _k with
                | Some(k_) -> k_
                | _        -> 4
        in
        
        let examples = read_gen _examples cci in

        let bestDepth, errT, errV, tree = model_selection_cross_validation kind k max_depth examples in
        
        let tree_str = if should_pretty_print then
                           (pretty_to_string (from_string (string_of_decision_tree tree)))
                       else
                           (string_of_decision_tree tree) 
        in
        let arr_to_csv arr =
                let str = ref (string_of_float (Array.get arr 1)) in
                for i=2 to ((Array.length arr)-1) do
                        str:= !str^","^(string_of_float (Array.get arr i));
                done;
                !str
        in
        let printHeader outf len =
                Printf.fprintf outf "%d" 1;
                for i=2 to len do
                        Printf.fprintf outf ",%d" i;
                done;
                Printf.fprintf outf "\n";
        in
        let errTstr = arr_to_csv errT in
        let errVstr = arr_to_csv errV in
        Printf.printf "%s\n\n" tree_str;
        Printf.printf "Best Depth: %d\n" bestDepth;
        Printf.printf "errT: %s\n" errTstr;
        Printf.printf "errV: %s\n" errVstr;
        let _ =
                match write_tree_to with
                | Some(out_path) -> (
                                        let outf = open_out out_path in
                                        Printf.fprintf outf "%s" tree_str ;
                                        close_out outf;
                                    )
                | _ -> ()
        in
        match write_stat_to with 
        | Some(out_path) -> (
                                let outf = open_out out_path in
                                printHeader outf (Array.length errT);
                                Printf.fprintf outf "%s\n" (arr_to_csv errT);
                                Printf.fprintf outf "%s\n" (arr_to_csv errV);
                                Printf.fprintf outf "%d" bestDepth;
                                close_out outf;
                            )
        | _ -> ()

let kind =
        let doc = "A flag to determine which dataset is being used by the application." in
        Arg.(required & (pos 0 (some string) None) & info [] ~docv:"FLAG" ~doc)

let examples =
        let doc = "The path to the file of data in CSV format." in
        Arg.(required & (pos 1 (some non_dir_file) None) & info [] ~docv:"EXAMPLES" ~doc)

let kValue = 
        let doc = "An optional int to set k (defualt is 4)" in
        Arg.(value & opt (some int) None & info ["k"; "k_value"] ~docv:"K_VALUE" ~doc)

let write_tree_to =
        let doc = "An optional file to write the tree as JSON output." in
        Arg.(value & opt (some string) None & info ["w"; "tree_dest"] ~docv:"TREE_DEST" ~doc)

let write_stat_to =
        let doc = "An optional file to write the stats in order of rows; depth, errT, errV, depth with berst errv." in
        Arg.(value & opt (some string) None & info ["W"; "stat_dest"] ~docv:"STAT_DEST" ~doc)

let should_pretty_print =
        let doc = "Output a human-readable JSON file." in
        Arg.(value & flag & info ["p"; "pretty"] ~doc)

let max_depth =
        let doc = "An optional maximum depth. (defualt is 10)" in
        Arg.(value & opt (some int) None & info ["d"; "depth"] ~docv:"DEPTH" ~doc)

let model_select_t = Term.(const model_select $ kind $ examples $ kValue $ write_tree_to $ write_stat_to $ should_pretty_print $ max_depth)

let info =
        let doc = "does model selection with DTL with max depth" in
        let man = [
                    `S Manpage.s_description;
                    `P "$(tname) constructs a decision tree for a given set of data.";
                    `S Manpage.s_bugs;
                    `P "Email bug reports to <aszecsei@gmail.com>."
                  ] in
        Term.info "modelSelection" ~version:"v1.0.0" ~doc ~exits:Term.default_exits ~man

let () = Term.exit @@ Term.eval (model_select_t, info)
