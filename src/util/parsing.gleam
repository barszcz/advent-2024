import gleam/int
import gleam/list
import gleam/string

pub fn parse_lines(input: String, f: fn(String) -> a) -> List(a) {
  input |> string.split("\n") |> list.map(f)
}

pub fn parse_int(input: String) {
  int.parse(input) |> must
}

pub fn must(in: Result(a, b)) -> a {
  let assert Ok(out) = in
  out
}
