open Types
open Classify
open Creator

let _ = Random.self_init ();;
let partition (exs:example array) (k:int) =
        let len = Array.length exs in
        let number = len/k in
        let shuffle (d:example array) : example array=
                let nd = Array.map (fun c->(Random.bits (), c)) d in
                Array.sort compare nd;
                let strip c = 
                        match c with
                        | (_,b) -> b
                in
                Array.map (strip) nd
        in
        let shexs = shuffle exs in
        let vSet  = Array.sub shexs 0 number in
        let tSet  = Array.sub shexs number (len-number) in
        (tSet, vSet)
;;

let errRate tree exs =
        let numWrong = ref 0 in
        let len = Array.length exs in
        for i = 0 to len-1 do
                let ex = Array.get exs i in
                let classi = classify tree ex in
                if classi<>(ex.value) then
                        numWrong := !numWrong+1;
        done;
        (float_of_int !numWrong)/.(float_of_int len)
;;


let cross_validation (depth:int) (k:int) (examples:example array) attributes classes  =
        let fold_errT = ref 0.0 in
        let fold_errV = ref 0.0 in
        let i = ref 1 in
        while !i<=k do
                let (tSet:example array), (vSet:example array) = partition examples k in
                let tree = decision_tree_learning tSet attributes [||] classes depth in
                fold_errT := !fold_errT+.(errRate tree tSet);
                fold_errV := !fold_errV+.(errRate tree vSet);
                i:=!i+1;
        done;
        (((!fold_errT)/.(float_of_int k)), ((!fold_errV)/.(float_of_int k)))
;;

let model_selection_cross_validation (kind:dataType) (k:int) (top_depth:int) (examples:example array) =
        let classes = getClassifications kind in
        let attributes = getAttributes kind in
        let findMinInd (arr:float array) =
                let minInd = ref 1 in
                let len = Array.length arr in
                for i=1 to len-1 do
                        if (Array.get arr i)<(Array.get arr !minInd) then minInd:=i;
                done;
                !minInd;
        in
        let errT      = ref [|1000.0|] in (*not a real thing at indicy 0*)
        let errV      = ref [|1000.0|] in (*not a real thing at indicy 0*)
        let depth     = ref 1 in
        (*let break     = ref false in*)
        let bestDepth = ref 1 in
        while (*(not !break)&&*)(!depth)<=top_depth do
                let temp_errT, temp_errV = cross_validation !depth k examples attributes classes in
                errT:=Array.append !errT [|temp_errT|];
                errV:=Array.append !errV [|temp_errV|];
                (*let past = Array.get !errT (!depth-1) in
                if (temp_errT>=past)||(!depth)=top_depth then (
                        bestDepth := findMinInd !errV;
                        break:=true;
                );*)
                depth := !depth +1;
        done;
        bestDepth := findMinInd !errV;
        let tree = decision_tree_learning examples attributes [||] classes !bestDepth in
        (!bestDepth, !errT, !errV, tree)
;;
