
let expectedV (e:float) (o:float) (pi:float) (ni:float) : float = 
(*used to calculate either expected positive or expected negative pg 706 in text book*)
        e*.((pi+.ni)/.(e+.o))
;;

let delta (pis:int array) (nis:int array) : float =
        let d = if (Array.length pis)=(Array.length nis) then (Array.length pis) 
                else failwith "nis and pis must be same length" in
        let rec sum (arr:int array) (i:int) : float =
                match i=d with
                | true  -> 0.0
                | false -> (float_of_int (Array.get arr i)) +. (sum arr (i+1))
        in
        let p = sum pis 0 in
        let n = sum nis 0 in
        let rec sumdelta (i:int) : float =
                match i=d with
                | true  -> 0.0
                | false -> (
                        let pi     = (float_of_int (Array.get pis i)) in
                        let ni     = (float_of_int (Array.get nis i)) in
                        let exp_pi = (expectedV p n pi ni) in
                        let exp_ni = (expectedV n p pi ni) in
                        let p2     = (pi -. exp_pi)**2.0 in
                        let n2     = (ni -. exp_ni)**2.0 in
                        let p2depi = p2 /. exp_pi in
                        let n2deni = n2 /. exp_ni in
                        let added  = p2depi +. n2deni in
                        added +. (sumdelta (i+1))
                )
        in
        sumdelta 0
;;
(*Printf.printf "%f\n" (delta [|2;3;5|] [|3;6;1|])*)
