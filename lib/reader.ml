open Types
(*type example={attributes:string list; value:string}*)

let example_to_str (ex:example) :string=
        let rec mk_attrs_str attrs first=
                match attrs,first with
                | _, true -> "["^(mk_attrs_str attrs false)
                | [], _   -> "]"
                | h::t, _ -> h^";"^(mk_attrs_str t false)
        in
        "{value: "^ex.value^"; attributes: "^(mk_attrs_str ex.attributes true)^"}"
;;

let print_example (ex:example) =
        Printf.printf "%s" ((example_to_str ex)^"\n")
;;

let print_example_array (exs:example array) =
        let len = (Array.length exs); in
        let rec for_loop (i:int) =
                if (i>=len) then () 
                else (print_example (Array.get exs i);
                     (for_loop (i+1)));
        in
        for_loop 0
;;

let create_example_from_list (l:string list) (cci:int) : example=
        let rec build_ex (l:string list) (ind:int) (attr:string list) : example=
                match l, ind=cci with
                | h::t, true -> {attributes = (attr@t); value=h}
                | h::t, false ->(build_ex t (ind+1) (attr@[h]))
                | _,_ -> failwith "oops build_ex failed"
        in
        let len = List.length l in
        match cci<len with
        | true  -> (build_ex l 0 [])
        | false -> failwith "oops create_example_list failed"
;;

(*print_example (create_example_from_list ["1";"3";"5";"7"] 2)*)

let create_example_from_str (s:string) (cci:int) : example=
        create_example_from_list (String.split_on_char ',' s) cci
       
;;

(*print_example (create_example_from_str "1,3,5,7" 2)*)

let read_gen (file:string) (cci:int) : example array=
        let inf=open_in file in
        let exs = ref [] in
        try
          while true; do
                  let ex= (create_example_from_str (input_line inf) cci) in
                  exs:= ex::!exs;
          done; Array.of_list (List.rev !exs);
        with End_of_file ->
                close_in inf;
                Array.of_list (List.rev !exs)
;;
(*print_example_array (read_gen "test.txt" 0);;*)
