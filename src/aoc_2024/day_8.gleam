import gleam/dict
import gleam/io
import gleam/list
import gleam/option
import gleam/set
import gleam/string
import gleam/yielder
import util/parsing
import util/vector.{type Vector}

pub fn parse(input: String) {
  let lines = string.split(input, "\n")
  let bound = list.length(lines)
  let antennas = {
    use acc, line, x <- list.index_fold(lines, dict.new())
    let nodes = string.to_graphemes(line)
    use acc2, c, y <- list.index_fold(nodes, acc)
    case c {
      "." -> acc2
      c -> {
        use d <- dict.upsert(acc2, c)
        let d = option.unwrap(d, [])
        [#(x, y), ..d]
      }
    }
  }
  #(antennas, bound)
}

fn is_in_bounds(point: Vector, bound: Int) -> Bool {
  point.0 >= 0 && point.0 < bound && point.1 >= 0 && point.1 < bound
}

fn antennas_to_heaven(antenna: Vector, dist: Vector) -> yielder.Yielder(Vector) {
  yielder.iterate(antenna, fn(a) { vector.add(a, dist) })
}

pub fn pt_1(input: #(dict.Dict(String, List(Vector)), Int)) {
  let #(antennas, bound) = input
  let antinodes =
    {
      use acc, _k, v <- dict.fold(antennas, set.new())
      let pairs = list.combination_pairs(v)
      {
        use #(antenna1, antenna2) <- list.flat_map(pairs)
        let dist = vector.sub(antenna1, antenna2)
        let antinode_1 = vector.add(antenna1, dist)
        let antinode_2 = vector.sub(antenna2, dist)
        [antinode_1, antinode_2]
      }
      |> set.from_list
      |> set.union(acc)
    }
    |> set.filter(is_in_bounds(_, bound))
  set.size(antinodes)
}

pub fn pt_2(input: #(dict.Dict(String, List(Vector)), Int)) {
  let #(antennas, bound) = input
  let pairs = antennas |> dict.values |> list.flat_map(list.combination_pairs)
  let antinodes = {
    use acc, #(antenna1, antenna2) <- list.fold(pairs, set.new())
    let dist = vector.sub(antenna1, antenna2)
    let antinodes_1 =
      antennas_to_heaven(antenna1, dist)
      |> yielder.take_while(is_in_bounds(_, bound))
      |> yielder.to_list
    let antinodes_2 =
      antennas_to_heaven(antenna1, vector.negate(dist))
      |> yielder.take_while(is_in_bounds(_, bound))
      |> yielder.to_list

    set.union(acc, list.append(antinodes_1, antinodes_2) |> set.from_list)
  }
  set.size(antinodes)
}
