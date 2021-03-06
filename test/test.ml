open OUnit
open Lib.Creator
open Lib.Decision_tree
open Lib.Decision_tree_j
open Lib.Types
open Lib.Classify

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

    "number_of_examples_with_value" >:: (fun () ->
      let examples = [|
        { attributes=["good"; "heads"]; value="yes" };
        { attributes=["good"; "tails"]; value="yes" };
        { attributes=["bad"; "heads"]; value="no" };
        { attributes=["bad"; "tails"]; value="no" };
        { attributes=["ugly"; "heads"]; value="no" };
        { attributes=["ugly"; "tails"]; value="no" };
      |] in
      let result_yes = number_of_examples_with_value "yes" examples in
      let result_no = number_of_examples_with_value "no" examples in
      assert_equal result_yes 2;
      assert_equal result_no 4;
    );

    "number_of_examples_with_attribute_and_value 1" >:: (fun () ->
      let examples = [|
        { attributes=["good"; "heads"]; value="yes" };
        { attributes=["good"; "tails"]; value="yes" };
        { attributes=["bad"; "heads"]; value="no" };
        { attributes=["bad"; "tails"]; value="no" };
        { attributes=["ugly"; "heads"]; value="no" };
        { attributes=["ugly"; "tails"]; value="no" };
      |] in
      let result = number_of_examples_with_attribute_and_value "good" 0 "yes" examples in
      assert_equal result 2
    );

    "number_of_examples_with_attribute_and_value 2" >:: (fun () ->
      let examples = [|
        { attributes=["good"; "heads"]; value="yes" };
        { attributes=["good"; "tails"]; value="yes" };
        { attributes=["bad"; "heads"]; value="no" };
        { attributes=["bad"; "tails"]; value="no" };
        { attributes=["ugly"; "heads"]; value="no" };
        { attributes=["ugly"; "tails"]; value="no" };
      |] in
      let result = number_of_examples_with_attribute_and_value "tails" 1 "yes" examples in
      assert_equal result 1
    );

    "number_of_examples_with_attribute_and_value 3" >:: (fun () ->
      let examples = [|
        { attributes=["good"; "heads"]; value="yes" };
        { attributes=["good"; "tails"]; value="yes" };
        { attributes=["bad"; "heads"]; value="no" };
        { attributes=["bad"; "tails"]; value="no" };
        { attributes=["ugly"; "heads"]; value="no" };
        { attributes=["ugly"; "tails"]; value="no" };
      |] in
      let result = number_of_examples_with_attribute_and_value "tails" 1 "no" examples in
      assert_equal result 2
    );

    "number_of_examples_with_attribute 1" >:: (fun () ->
      let examples = [|
        { attributes=["good"; "heads"]; value="yes" };
        { attributes=["good"; "tails"]; value="yes" };
        { attributes=["bad"; "heads"]; value="no" };
        { attributes=["bad"; "tails"]; value="no" };
        { attributes=["ugly"; "heads"]; value="no" };
        { attributes=["ugly"; "tails"]; value="no" };
      |] in
      let result = number_of_examples_with_attribute "tails" 1 examples in
      assert_equal result 3
    );

    "number_of_examples_with_attribute 2" >:: (fun () ->
      let examples = [|
        { attributes=["good"; "heads"]; value="yes" };
        { attributes=["good"; "tails"]; value="yes" };
        { attributes=["bad"; "heads"]; value="no" };
        { attributes=["bad"; "tails"]; value="no" };
        { attributes=["ugly"; "heads"]; value="no" };
        { attributes=["ugly"; "tails"]; value="no" };
      |] in
      let result = number_of_examples_with_attribute "bad" 0 examples in
      assert_equal result 2
    );

    "entropy, fully ordered" >:: (fun () ->
      let possible_classifications = [|"true"; "false"|] in
      let examples = [|
        { attributes=["true"; "true"]; value="true"; };
        { attributes=["true"; "false"]; value="true"; };
        { attributes=["true"; "true"]; value="true"; };
        { attributes=["true"; "false"]; value="true"; };
      |] in
      let result = entropy "true" 0 examples possible_classifications in
      assert_equal result 0.
    );

    "entropy, fully random" >:: (fun () ->
      let possible_classifications = [|"true"; "false"|] in
      let examples = [|
        { attributes=["true"; "true"]; value="true"; };
        { attributes=["true"; "false"]; value="true"; };
        { attributes=["true"; "true"]; value="false"; };
        { attributes=["true"; "false"]; value="false"; };
      |] in
      let result = entropy "true" 0 examples possible_classifications in
      assert_equal result 1.
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

    "argmax" >:: (fun () ->
      let possible_classifications = [|"yes"; "no"|] in
      let good_attribute = {name="good"; possible_values=[|"good"; "bad"; "ugly"|]; index=0;} in
      let bad_attribute = {name="bad"; possible_values=[|"heads"; "tails"|]; index=1;} in
      let examples = [|
        { attributes=["good"; "heads"]; value="yes" };
        { attributes=["good"; "tails"]; value="yes" };
        { attributes=["bad"; "heads"]; value="no" };
        { attributes=["bad"; "tails"]; value="no" };
        { attributes=["ugly"; "heads"]; value="no" };
        { attributes=["ugly"; "tails"]; value="no" };
      |] in
      let result = argmax examples [|good_attribute; bad_attribute|] possible_classifications in
      match result with
      | Some(res) -> assert_equal res.name "good"
      | None -> failwith "No result found"
    );

    "classify balance" >:: (fun () ->
      let balanced_leaf = `Leaf { result="B" } in
      let right_leaning_leaf = `Leaf {result="R"} in
      let right_weight_node = `Node {category="Right-Weight"; category_index=2; children=[
        { option="1"; child=balanced_leaf};
        { option="2"; child=right_leaning_leaf};]} in
      let right_distance_node = `Node {category="Right-Distance"; category_index=3; children=[
        { option="1"; child=right_weight_node};]} in
      let left_distance_node = `Node {category="Left-Distance"; category_index=1; children=[
        { option="1"; child=right_distance_node};]} in
      let root_node = `Node {category="Left-Weight"; category_index=0; children=[
        { option="1"; child=left_distance_node};]} in
      let examples = [|
        { attributes=["1"; "1"; "1"; "1";]; value="B" };
        { attributes=["1"; "1"; "2"; "1";]; value="R" };
      |] in 
      assert_equal (classify root_node examples.(0)) examples.(0).value;
      assert_equal (classify root_node examples.(1)) examples.(1).value;
    );

    "classify cars" >:: (fun () ->
      let acc_leaf = `Leaf { result="acc" } in
      let unacc_leaf = `Leaf {result="unacc" } in 
      let maint_node = `Node { category="maint"; category_index=1; children=[
        { option="med"; child=acc_leaf};
        { option="vhigh"; child=unacc_leaf}
      ]} in
      let buying_node = `Node { category="buying"; category_index=0; children=[
        { option="vhigh"; child=maint_node}]} in
      let examples = [|
        { attributes = ["vhigh"; "med"; "2"; "4"; "big"; "med"; "acc"]; value="acc"};
        { attributes = ["vhigh"; "vhigh"; "2"; "2"; "small"; "low"; "unacc"]; value="unacc"}
      |] in 

      assert_equal (classify buying_node examples.(0)) examples.(0).value;
      assert_equal (classify buying_node examples.(1)) examples.(1).value;
    );

    "classify coin flip is heads" >:: (fun () ->
      let yes_leaf = `Leaf { result="yes" } in
      let no_leaf = `Leaf { result="no" } in
      let root_node = `Node { category="heads_or_tails"; category_index=0; children=[
        { option="heads"; child=yes_leaf};
        { option="tails"; child=no_leaf};
      ]} in
      let examples = [|
        { attributes=["heads"]; value="yes"};
        { attributes=["tails"]; value="no"};
      |] in

      assert_equal (classify root_node examples.(0)) examples.(0).value;
      assert_equal (classify root_node examples.(1)) examples.(1).value
    );

(* 
    "decsion_tree_learning" >:: (fun () ->
      let possible_classifications = [|"yes"; "no"|] in
      let outlook = { name = "outlook"; possible_values=[|"sunny"; "overcast"; "rain"|]; index=0; } in
      let temperature = { name = "temperature"; possible_values=[|"hot"; "mild"; "cool"|]; index=1; } in
      let humidity = { name = "humidity"; possible_values=[|"high"; "normal"|]; index=2; } in
      let wind = { name = "wind"; possible_values=[|"weak"; "strong"|]; index=3; } in
      let examples = [|
        { attributes=["sunny"; "hot"; "high"; "weak"]; value="no"; };
        { attributes=["sunny"; "hot"; "high"; "strong"]; value="no"; };
        { attributes=["overcast"; "hot"; "high"; "weak"]; value="yes"; };
        { attributes=["rain"; "mild"; "high"; "weak"]; value="yes"; };
        { attributes=["rain"; "cool"; "normal"; "weak"]; value="yes"; };
        { attributes=["rain"; "cool"; "normal"; "strong"]; value="no"; };
        { attributes=["overcast"; "cool"; "normal"; "strong"]; value="yes"; };
        { attributes=["sunny"; "mild"; "high"; "weak"]; value="no"; };
        { attributes=["sunny"; "cool"; "normal"; "weak"]; value="yes"; };
        { attributes=["rain"; "mild"; "normal"; "weak"]; value="yes"; };
        { attributes=["sunny"; "mild"; "normal"; "strong"]; value="yes"; };
        { attributes=["overcast"; "mild"; "high"; "strong"]; value="yes"; };
        { attributes=["overcast"; "hot"; "normal"; "weak"]; value="yes"; };
        { attributes=["rain"; "mild"; "high"; "strong"]; value="no"; };
      |] in
      let result = decision_tree_learning examples [|outlook; temperature; humidity; wind;|] [| |] possible_classifications in

      let yes_leaf = `Leaf { result="yes" } in
      let no_leaf = `Leaf { result="no" } in

      let humidity_node = `Node { category="humidity"; category_index=2; children=[
        { option="normal"; child=yes_leaf};
        { option="high"; child=no_leaf};
      ] } in

      let wind_node = `Node { category="wind"; category_index=3; children=[
        { option="strong"; child=no_leaf};
        { option="weak"; child=yes_leaf};
      ]} in

      let outlook_node = `Node {category="outlook"; category_index=0; children=[
        { option="rain"; child=wind_node};
        { option="overcast"; child=yes_leaf};
        { option="sunny"; child=humidity_node};
      ]} in

      assert_equal (string_of_decision_tree result) (string_of_decision_tree (outlook_node :> decision_tree))
      (* TODO: Make a function to check actual tree equality *)
      (* Currently this is order-dependent *)
    ); *)
  ]

let _ = run_test_tt suite