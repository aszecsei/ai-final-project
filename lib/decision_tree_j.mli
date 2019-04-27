(* Auto-generated from "decision_tree.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type decision_tree_leaf = Decision_tree_t.decision_tree_leaf = {
  result: string
}

type decision_tree = Decision_tree_t.decision_tree

and decision_tree_child = Decision_tree_t.decision_tree_child = {
  option: string;
  child: decision_tree
}

and decision_tree_node = Decision_tree_t.decision_tree_node = {
  category: string;
  children: decision_tree_child list
}

val write_decision_tree_leaf :
  Bi_outbuf.t -> decision_tree_leaf -> unit
  (** Output a JSON value of type {!decision_tree_leaf}. *)

val string_of_decision_tree_leaf :
  ?len:int -> decision_tree_leaf -> string
  (** Serialize a value of type {!decision_tree_leaf}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_decision_tree_leaf :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> decision_tree_leaf
  (** Input JSON data of type {!decision_tree_leaf}. *)

val decision_tree_leaf_of_string :
  string -> decision_tree_leaf
  (** Deserialize JSON data of type {!decision_tree_leaf}. *)

val write_decision_tree :
  Bi_outbuf.t -> decision_tree -> unit
  (** Output a JSON value of type {!decision_tree}. *)

val string_of_decision_tree :
  ?len:int -> decision_tree -> string
  (** Serialize a value of type {!decision_tree}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_decision_tree :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> decision_tree
  (** Input JSON data of type {!decision_tree}. *)

val decision_tree_of_string :
  string -> decision_tree
  (** Deserialize JSON data of type {!decision_tree}. *)

val write_decision_tree_child :
  Bi_outbuf.t -> decision_tree_child -> unit
  (** Output a JSON value of type {!decision_tree_child}. *)

val string_of_decision_tree_child :
  ?len:int -> decision_tree_child -> string
  (** Serialize a value of type {!decision_tree_child}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_decision_tree_child :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> decision_tree_child
  (** Input JSON data of type {!decision_tree_child}. *)

val decision_tree_child_of_string :
  string -> decision_tree_child
  (** Deserialize JSON data of type {!decision_tree_child}. *)

val write_decision_tree_node :
  Bi_outbuf.t -> decision_tree_node -> unit
  (** Output a JSON value of type {!decision_tree_node}. *)

val string_of_decision_tree_node :
  ?len:int -> decision_tree_node -> string
  (** Serialize a value of type {!decision_tree_node}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_decision_tree_node :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> decision_tree_node
  (** Input JSON data of type {!decision_tree_node}. *)

val decision_tree_node_of_string :
  string -> decision_tree_node
  (** Deserialize JSON data of type {!decision_tree_node}. *)

