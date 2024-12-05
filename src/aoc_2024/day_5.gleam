import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/set
import gleam/string
import util/pairs
import util/parsing

pub type Input =
  #(set.Set(#(Int, Int)), List(List(Int)))

pub fn parse(input: String) {
  let assert Ok(#(rules_input, pages_input)) = string.split_once(input, "\n\n")
  let rules =
    rules_input
    |> string.split("\n")
    |> list.map(fn(rule) {
      rule
      |> string.split_once("|")
      |> parsing.must
      |> pairs.map_pair(parsing.parse_int)
    })
    |> list.fold(set.new(), set.insert)
  let pages =
    pages_input
    |> string.split("\n")
    |> list.map(fn(line) {
      string.split(line, ",") |> list.map(parsing.parse_int)
    })
  #(rules, pages)
}

fn compare_pages(orderings: set.Set(#(Int, Int))) {
  fn(a: Int, b: Int) -> order.Order {
    use <- bool.guard(set.contains(orderings, #(a, b)), order.Lt)
    use <- bool.guard(set.contains(orderings, #(b, a)), order.Gt)
    order.Eq
  }
}

fn is_sorted(l, cmp) {
  list.sort(l, cmp) == l
}

fn get_midpoint(l) {
  let len = list.length(l)
  l |> list.drop(len / 2) |> list.first
}

pub fn pt_1(input: Input) {
  let cmp = compare_pages(input.0)
  input.1
  |> list.filter_map(fn(pages) {
    case is_sorted(pages, cmp) {
      False -> Error(Nil)
      True -> get_midpoint(pages)
    }
  })
  |> int.sum
}

pub fn pt_2(input: Input) {
  let cmp = compare_pages(input.0)
  input.1
  |> list.filter_map(fn(pages) {
    case is_sorted(pages, cmp) {
      True -> Error(Nil)
      False -> get_midpoint(list.sort(pages, cmp))
    }
  })
  |> int.sum
}
