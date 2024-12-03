import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regexp

fn parse_int(str: String) -> Int {
  let assert Ok(n) = int.parse(str)
  n
}

pub fn pt_1(input: String) {
  let assert Ok(mul_re) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")
  let matches = regexp.scan(mul_re, input)
  // io.debug(matches)
  list.map(matches, fn(match) {
    let assert [Some(n1), Some(n2)] = match.submatches
    parse_int(n1) * parse_int(n2)
  })
  |> int.sum
}

type Acc {
  Acc(total: Int, enabled: Bool)
}

pub fn pt_2(input: String) {
  let assert Ok(mul_re) =
    regexp.from_string("(mul\\((\\d+),(\\d+)\\)|do\\(\\)|don't\\(\\))")
  let matches = regexp.scan(mul_re, input)
  // io.debug(matches)

  list.fold(matches, Acc(0, True), fn(acc, match) {
    case match.content {
      "do()" -> Acc(..acc, enabled: True)
      "don't()" -> Acc(..acc, enabled: False)
      _ -> {
        case acc.enabled {
          False -> acc
          True -> {
            let assert [_, Some(n1), Some(n2)] = match.submatches
            let p = parse_int(n1) * parse_int(n2)
            Acc(..acc, total: acc.total + p)
          }
        }
      }
    }
  }).total
}
