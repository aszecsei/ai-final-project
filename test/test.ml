open OUnit
open Lib.Decision_tree
open Lib.Decision_tree_t

let suite =
  "Project" >::: [
    "decision tree" >:: (fun () ->
      let (`Leaf x) = create_leaf "true" in
      assert_equal x.result "true"
    );
  ]

let _ = run_test_tt suite