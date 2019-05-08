open Lib.Reader
open Lib.Types
open Lib.Creator
open Lib.Decision_tree_j
open Yojson.Safe
open Cmdliner


let dtl _kind _examples write_to should_pretty_print _max_depth _should_prune =
        let kind = getDataType _kind in
        let cci = getCCI kind in
        let classes = getClassifications kind in
        let examples = read_gen _examples cci in
        let attributes = getAttributes kind in
        let max_depth =
                match _max_depth with
                | Some(_max_dep) -> _max_dep
                | _              -> Array.length attributes (*no depth limit as no tree can go deeper than number of attributes*)
        in
        let tree = decision_tree_learning examples attributes [||] classes max_depth in
        let tree_str = if should_pretty_print then
                (pretty_to_string (from_string (string_of_decision_tree tree))) 
        else 
                (string_of_decision_tree tree) in
        Printf.printf "%s\n" tree_str;
        match write_to with
        | Some(out_path) -> (
                let outf = open_out out_path in
                Printf.fprintf outf "%s" tree_str ;
                close_out outf
        )
        | _ -> ()

let kind =
        let doc = "A flag to determine which dataset is being used by the application." in
        Arg.(required & (pos 0 (some string) None) & info [] ~docv:"FLAG" ~doc)
        
let examples =
        let doc = "The path to the file of training data in CSV format." in
        Arg.(required & (pos 1 (some non_dir_file) None) & info [] ~docv:"EXAMPLES" ~doc)

let write_to =
        let doc = "An optional file to write the JSON output." in
        Arg.(value & opt (some string) None & info ["w"; "dest"] ~docv:"DEST" ~doc)

let should_pretty_print =
        let doc = "Output a human-readable JSON file." in
        Arg.(value & flag & info ["p"; "pretty"] ~doc)

let max_depth =
        let doc = "An optional maximum depth for the tree." in
        Arg.(value & opt (some int) None & info ["d"; "depth"] ~docv:"DEPTH" ~doc)

let should_prune =
        let doc = "Use chi-squared pruning on the decision tree." in
        Arg.(value & flag & info ["P"; "prune"] ~doc)

let dtl_t = Term.(const dtl $ kind $ examples $ write_to $ should_pretty_print $ max_depth $ should_prune)
let info =
        let doc = "construct a decision tree" in
        let man = [
                `S Manpage.s_description;
                `P "$(tname) constructs a decision tree for a given set of data.";
                `S Manpage.s_bugs;
                `P "Email bug reports to <aszecsei@gmail.com>."
        ] in
        Term.info "dtl" ~version:"v1.0.0" ~doc ~exits:Term.default_exits ~man

let () = Term.exit @@ Term.eval (dtl_t, info)
