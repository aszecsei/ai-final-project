open Lib.Classify
open Cmdliner

let write_to =
        let doc = "An optional file to write the output." in
        Arg.(value & opt (some string) None & info ["w"; "dest"] ~docv:"DEST" ~doc)

let tree =
        let doc = "The path to the file containing a decision tree JSON." in
        Arg.(required & (pos 0 (some non_dir_file) None) & info [] ~docv:"TREE" ~doc)

let dataset =
        let doc = "The path to the file containing a comma-separated list of records." in
        Arg.(required & (pos 1 (some non_dir_file) None) & info [] ~docv:"DATA" ~doc)

let classify_t = Term.(const do_classify $ tree $ dataset $ write_to)
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
