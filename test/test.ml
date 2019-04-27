open OUnit
open Lib.Creator
open Lib.Decision_tree
open Lib.Decision_tree_t

let suite =
  "Project" >::: [
    "decision tree" >:: (fun () ->
      let (`Leaf x) = create_leaf "true" in
      assert_equal x.result "true"
    );

    "plurality_value" >:: (fun () ->
      let arr = [|0; 2; 3; 4; 2; 0; 3; 0|] in
      assert_equal (Lib.Creator.plurality_value arr) 0
    );

    "importance" >:: (fun () ->
      let possible_classifications = [|"true"; "false"|] in
      let a_val = { name="heads_or_tails"; possible_values=[|"true"; "false"|]; index=0; } in
      let examples = [|
        { attributes=["true"]; value="true"; };
        { attributes=["false"]; value="true"; };
        { attributes=["true"]; value="false"; };
        { attributes=["false"]; value="false"; };
      |] in
      let result = importance a_val examples possible_classifications in
      assert_equal result 0.
    );
  ]

let _ = run_test_tt suite