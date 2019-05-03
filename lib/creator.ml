open Decision_tree
open Decision_tree_t

(* Counts the number of times the given value is present in arr *)
let count_occurrences value arr =
  Array.fold_left (fun a b -> if b = value then a + 1 else a) 0 arr

(* Selects the most common element in the given array, breaking ties randomly. *)
let plurality_value arr =
  let max_value = Array.fold_left (fun a b ->
    let occur = count_occurrences b arr in
    if a > occur then a else occur) 0 arr in
  let selected = Array.of_list (List.find_all (fun a -> (count_occurrences a arr) = max_value) (Array.to_list arr)) in
  let n = Random.int (Array.length selected) in
  Array.get selected n

type example = { attributes:string list; value:string; }
type attribute = { name:string; possible_values:string array; index: int; }

let number_of_examples_with_value value examples =
  Array.fold_left (fun agg v -> if v.value = value then (succ agg) else agg) 0 examples

let number_of_examples_with_attribute_and_value a_val a_num value examples =
  Array.fold_left (fun agg v -> if v.value = value && List.nth v.attributes a_num = a_val then (succ agg) else agg) 0 examples

let number_of_examples_with_attribute a_val a_num examples =
  Array.fold_left (fun agg v -> if List.nth v.attributes a_num = a_val then (succ agg) else agg) 0 examples

let pknk_over_pk a_val a_num examples =
  (float_of_int (number_of_examples_with_attribute a_val a_num examples)) /. (float_of_int (Array.length examples))

let entropy a_val a_num examples possible_values =
  let fraction value =
    (float_of_int (number_of_examples_with_attribute_and_value a_val a_num value examples) /. float_of_int (number_of_examples_with_attribute a_val a_num examples)) in
  Array.fold_left (fun agg value -> agg -. (fraction value) *. log (fraction value) /. log 2.0) 0.0 possible_values

let remainder attribute examples possible_values =
  Array.fold_left (fun agg value ->
    agg +. ((float_of_int (number_of_examples_with_attribute value attribute.index examples)) /. (float_of_int (Array.length examples))) *. (entropy value attribute.index examples possible_values)) 0.0 attribute.possible_values

let importance attribute examples possible_values =
  1.0 -. (remainder attribute examples possible_values)

let argmax examples attributes possible_classifications =
  Array.fold_left (fun agg value ->
    let e1 = (importance value examples possible_classifications) in
    match agg with
    | Some(v2) when (importance v2 examples possible_classifications) < e1 -> agg
    | _ -> Some(value)
  ) None attributes

let rec decision_tree_learning examples attributes parent_examples possible_classifications =
  if Array.length examples = 0 then
    (`Leaf { result=(plurality_value parent_examples).value; } :> decision_tree)
  else
    let first_val = (Array.get examples 0).value in
    if (Array.for_all (fun value -> (value.value = first_val)) examples) then
      (`Leaf { result=first_val; }  :> decision_tree)
    else if (Array.length attributes = 0) then
      (`Leaf { result=(plurality_value examples).value; } :> decision_tree)
    else
      match (argmax examples attributes possible_classifications) with
      | Some(a) -> (
          let tree = `Node { category=a.name; category_index=a.index; children=[]; } in
          (Array.fold_left (fun agg value ->
            let new_examples = Array.of_list (List.filter (fun v -> (List.nth v.attributes a.index) = value) (Array.to_list examples)) in
            let subtree = decision_tree_learning new_examples (Array.of_list (List.filter (fun v -> v.index != a.index) (Array.to_list attributes))) examples possible_classifications in
            add_child agg value subtree
          ) tree a.possible_values :> decision_tree)
        ) 
      | _ -> (`Leaf { result=(plurality_value parent_examples).value; } :> decision_tree)
