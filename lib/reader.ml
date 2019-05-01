(*type example=Creator.example;*)
type example={attributes:string list; value:string}

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

let rec print_example_list (exs:example list) =
        match exs with
        |[] ->0;
        |h::t -> (print_example h); (print_example_list t)
;;

let create_example_list (l:string list) (cci:int) : example=
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

(*print_example (create_example_list ["1";"3";"5";"7"] 2)*)

let create_example_str (s:string) (cci:int) : example=
        create_example_list (String.split_on_char ',' s) cci
;;

(*print_example (create_example_str "1,3,5,7" 2)*)

let read_gen (file:string) (cci:int) : example list=
        let inf=open_in file in
        let exs = ref [] in
        try
          while true; do
                  let ex= (create_example_str (input_line inf) cci) in
                  (*print_example ex;*)
                  exs:= ex::!exs;
          done; !exs
        with End_of_file ->
                close_in inf;
                List.rev !exs
;;
(*print_example_list (read_gen "test.txt" 0);;*)

Random.self_init ();;
let sublist_ex (exs:example list) (number:int) : example list=
        let shuffle d=
                let nd = List.map (fun c->(Random.bits (), c)) d in
                let sond = List.sort compare nd in
                List.map snd sond
        in
        let rec subExs exss num =
                match exss, num with
                | _, 0 -> []
                | [], _ -> []
                | h::t,_ -> h::(subExs t (num-1))
        in
        subExs (shuffle exs) number
;;

(*print_example_list (sublist_ex (read_gen "test.txt" 0) 3)*)

let write_gen (file:string) (exs:example list) =
        let outf = open_out file in
        let rec fprint_exs (exss:example list) =
                match exss with
                | []   -> "done"
                | h::t -> Printf.fprintf outf "%s\n" (example_to_str h); (fprint_exs t);
        in 
        fprint_exs exs;
        close_out outf;
;;
(*write_gen "testout.txt" (sublist_ex (read_gen "test.txt" 0) 3);;*)
