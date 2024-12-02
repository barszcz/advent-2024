import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import gleam/string

fn map_pair(of pair: #(a, a), with fun: fn(a) -> b) -> #(b, b) {
  #(fun(pair.first(pair)), fun(pair.second(pair)))
}

fn zip_pair(pair: #(List(a), List(b))) -> List(#(a, b)) {
  let #(fst, snd) = pair
  list.zip(fst, snd)
}

fn parse_line(line: String) -> #(Int, Int) {
  let assert Ok(split) = string.split_once(line, "   ")
  use el <- map_pair(split)
  io.debug(el)
  let assert Ok(parsed) = int.parse(el)
  parsed
}

pub fn parse(input: String) -> #(List(Int), List(Int)) {
  input |> string.split("\n") |> list.map(parse_line) |> list.unzip
}

pub fn pt_1(input: #(List(Int), List(Int))) {
  let sorted_lists =
    input
    |> map_pair(list.sort(_, int.compare))
    |> zip_pair

  let distances =
    list.map(sorted_lists, fn(a) {
      let #(fst, snd) = a
      int.absolute_value(fst - snd)
    })

  int.sum(distances)
}

pub fn pt_2(input: #(List(Int), List(Int))) {
  let #(left, right) = input
  let freqs =
    right
    |> list.fold(dict.new(), fn(d, el) {
      dict.upsert(d, el, fn(count) {
        case count {
          option.None -> 1
          option.Some(n) -> n + 1
        }
      })
    })

  left
  |> list.fold(0, fn(sum, el) {
    let freq = dict.get(freqs, el) |> result.unwrap(0)
    sum + el * freq
  })
}
