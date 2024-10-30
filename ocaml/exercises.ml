exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

let rec first_then_apply lst predicate transform =
  match lst with
  | [] -> None (* Return None if the list is empty *)
  | x :: xs ->
      if predicate x then transform x else first_then_apply xs predicate transform

let powers_generator base =
  let rec aux n () =
    Seq.Cons (n, aux (n * base))
  in
  aux 1

let meaningful_line_count filename =
  let in_channel = open_in filename in 
  let rec count_lines acc =
    try
      let line = input_line in_channel |> String.trim in 
      if line <> "" && not (String.starts_with ~prefix:"#" line) then
        count_lines (acc + 1) 
      else
        count_lines acc 
    with End_of_file ->
      close_in in_channel; 
      acc
  in
  count_lines 0


type shape = 
  | Sphere of float
  | Box of float * float * float
(* volume of the shape *)
let volume s =
  match s with
  | Sphere r -> Float.pi *. (r ** 3.) *. 4. /. 3.
  | Box (l, w, h) -> l *. w *. h 
(* surface area of the shape *)
let surface_area s =
  match s with
  | Sphere r -> 4. *. Float.pi *. (r ** 2.)
  | Box (l, w, h) -> 2. *. (l *. w +. l *. h +. w *. h)




type 'a binary_search_tree = 
  | Empty
  | Node of 'a binary_search_tree * 'a * 'a binary_search_tree
(* size of the tree *)
let rec size tree = 
  match tree with 
  | Empty -> 0
  | Node (left, _, right) -> 1 + size left + size right

(*  check if a value exists in the tree *)
let rec contains value tree =
  match tree with 
  | Empty -> false
  | Node (left, v, right) -> 
      if value = v then true
      else if value < v then contains value left
      else contains value right

(* return the inorder traversal of the tree *)
let rec inorder tree = 
  match tree with 
  | Empty -> []
  | Node (left, v, right) -> inorder left @ [v] @ inorder right

(* insert a value into the tree *)
let rec insert value tree =
  match tree with
  | Empty -> Node (Empty, value, Empty)
  | Node (left, v, right) ->
      if value < v then Node (insert value left, v, right)
      else if value > v then Node (left, v, insert value right)
      else tree  
