open OUnit
open Decision_tree

let suite =
  "Project" >::: [
    "0 + 0 = 0" >:: (fun () ->
      assert_equal (add 0 0) 0;
    );
  ]

let _ = run_test_tt suite