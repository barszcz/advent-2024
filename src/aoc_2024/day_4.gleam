import gleam/bool
import gleam/deque
import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import util/parsing

pub type Letter {
  X
  M
  A
  S
}

pub type Grid =
  dict.Dict(#(Int, Int), Letter)

fn parse_line(line: String) {
  string.to_graphemes(line)
  |> list.map(fn(c) {
    case c {
      "X" -> X
      "M" -> M
      "A" -> A
      "S" -> S
      _ -> panic as "nope"
    }
  })
}

pub fn parse(input: String) -> Grid {
  parsing.parse_lines(input, parse_line)
  |> list.index_fold(dict.new(), fn(acc, line, i) {
    list.index_fold(line, acc, fn(acc2, c, j) { dict.insert(acc2, #(i, j), c) })
  })
}

fn get_next(l: Letter) -> Result(Letter, Nil) {
  case l {
    X -> Ok(M)
    M -> Ok(A)
    A -> Ok(S)
    S -> {
      io.println("got an s")
      Error(Nil)
    }
  }
}

fn get_neighbor_coords(coords: #(Int, Int)) {
  let distance_units = [-1, 0, 1]
  let distances =
    list.flat_map(distance_units, fn(d1) {
      list.map(distance_units, fn(d2) { #(d1, d2) })
    })
  list.filter_map(distances, fn(d) {
    case d {
      #(0, 0) -> Error(Nil)
      _ -> Ok(#(coords.0 + d.0, coords.1 + d.1))
    }
  })
}

fn do_pt_1(
  grid: Grid,
  q: deque.Deque(#(#(Int, Int), Letter)),
  seen: set.Set(#(Int, Int)),
  total: Int,
) {
  case deque.pop_front(q) {
    Ok(#(el, q)) -> {
      let #(coord, letter) = el
      let seen = set.insert(seen, el.0)
      case get_next(letter) {
        Error(_) -> do_pt_1(grid, q, seen, total + 1)
        Ok(next_letter) -> {
          let neighbors =
            get_neighbor_coords(coord)
            |> list.filter_map(fn(coord) {
              use l <- result.try(dict.get(grid, coord))
              use <- bool.guard(l != next_letter, Error(Nil))
              use <- bool.guard(set.contains(seen, coord), Error(Nil))
              Ok(#(coord, l))
            })
          io.debug(neighbors)
          let q = list.fold(neighbors, q, deque.push_front)
          do_pt_1(grid, q, seen, total)
        }
      }
    }
    Error(_) -> total
  }
}

pub fn pt_1(input: Grid) -> Int {
  let q =
    input
    |> dict.filter(fn(_, v) { v == X })
    |> dict.to_list
    |> deque.from_list

  do_pt_1(input, q, set.new(), 0)
}

pub fn pt_2(input: Grid) {
  todo as "part 2 not implemented"
}
