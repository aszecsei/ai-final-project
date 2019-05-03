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

    "decsion_tree_learning" >:: (fun () ->
      let possible_classifications = [|"yes"; "no"|] in
      let outlook = { name = "outlook"; possible_values=[|"sunny"; "overcast"; "rain"|]; index=0; } in
      let temperature = { name = "temperature"; possible_values=[|"hot"; "mild"; "cool"|]; index=1; } in
      let humidity = { name = "humidity"; possible_values=[|"high"; "normal"|]; index=2; } in
      let wind = { name = "wind"; possible_values=[|"weak"; "strong"|]; index=3; } in
      let examples = [|
        { attributes=["sunny"; "hot"; "high"; "weak"]; value="no"; }
        { attributes=["sunny"; "hot"; "high"; "strong"]; value="no"; }
        { attributes=["overcast"; "hot"; "high"; "weak"]; value="yes"; }
        { attributes=["rain"; "mild"; "high"; "weak"]; value="yes"; }
        { attributes=["rain"; "cool"; "normal"; "weak"]; value="yes"; }
        { attributes=["rain"; "cool"; "normal"; "strong"]; value="no"; }
        { attributes=["overcast"; "cool"; "normal"; "strong"]; value="yes"; }
        { attributes=["sunny"; "mild"; "high"; "weak"]; value="no"; }
        { attributes=["sunny"; "cool"; "normal"; "weak"]; value="yes"; }
        { attributes=["rain"; "mild"; "normal"; "weak"]; value="yes"; }
        { attributes=["sunny"; "mild"; "normal"; "strong"]; value="yes"; }
        { attributes=["overcast"; "mild"; "high"; "strong"]; value="yes"; }
        { attributes=["overcast"; "hot"; "normal"; "weak"]; value="yes"; }
        { attributes=["rain"; "mild"; "high"; "strong"]; value="no"; }
      |] in
      let result = decision_tree_learning examples [|outlook; temperature; humidity; wind;|] [| |] possible_classifications in
      assert_equal result `Leaf "yes"
    );
  ]

let _ = run_test_tt suite