(* Auto-generated from "decision_tree.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type decision_tree_leaf = { result: string }

type decision_tree = [
    `Leaf of decision_tree_leaf
  | `Node of decision_tree_node
]

and decision_tree_child = { option: string; child: decision_tree }

and decision_tree_node = {
  category: string;
  children: decision_tree_child list
}
