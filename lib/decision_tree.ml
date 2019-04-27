open Decision_tree_t

let create_leaf x =
  `Leaf { result = x; }

let create_node category =
  `Node { category = category; children = []; }

let add_child (`Node { category = p_cat; children = p_chi; }) option child =
  `Node { category = p_cat; children = { option = option; child = child; } :: p_chi; }