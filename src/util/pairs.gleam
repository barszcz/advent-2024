import gleam/list

pub fn map_pair(of pair: #(a, a), with fun: fn(a) -> b) -> #(b, b) {
  #(fun(pair.0), fun(pair.1))
}

pub fn zip_pair(pair: #(List(a), List(b))) -> List(#(a, b)) {
  let #(fst, snd) = pair
  list.zip(fst, snd)
}
