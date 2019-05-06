open Decision_tree_t

let create_leaf x =
  `Leaf { result = x; }

let create_node category category_index =
  `Node { category = category; category_index = category_index; children = []; }

let add_child (`Node { category = p_cat; category_index = p_cat_i; children = p_chi; }) option child =
  `Node { category = p_cat; category_index = p_cat_i; children = { option = option; child = child; } :: p_chi; }

