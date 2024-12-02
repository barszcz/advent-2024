import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn parse_line(line: String) -> List(Int) {
  let level_strings = string.split(line, " ")
  list.filter_map(level_strings, int.parse)
}

pub fn parse(input: String) -> List(List(Int)) {
  let lines = string.split(input, "\n")
  list.map(lines, parse_line)
}

fn delete_at(ls: List(a), idx_to_delete: Int) -> List(a) {
  list.index_fold(ls, [], fn(acc, el, idx) {
    case idx == idx_to_delete {
      True -> acc
      False -> [el, ..acc]
    }
  })
  |> list.reverse
}

fn get_deletions(report: List(Int)) -> List(List(Int)) {
  list.index_map(report, fn(_a, idx) { delete_at(report, idx) })
}

fn is_safe_p1(report: List(Int)) -> Bool {
  let sorted = list.sort(report, int.compare)
  use <- bool.guard(sorted != report && sorted != list.reverse(report), False)

  sorted
  |> list.window_by_2
  |> list.all(fn(window) {
    let #(first, second) = window
    let diff = second - first
    diff > 0 && diff <= 3
  })
}

fn is_safe_p2(report: List(Int)) -> Bool {
  use <- bool.guard(is_safe_p1(report), True)
  let deletions = get_deletions(report)
  list.any(deletions, is_safe_p1)
}

pub fn pt_1(input: List(List(Int))) {
  input |> list.count(is_safe_p1)
}

pub fn pt_2(input: List(List(Int))) {
  input |> list.count(is_safe_p2)
}
