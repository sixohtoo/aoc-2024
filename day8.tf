locals {
  d8_input = local.days[8] ? module.d8_parse_input.second : [[]]
  d8_unique_chars = toset(flatten([
    for line in local.d8_input : [
      for c in line : c if c != "."
    ]
  ]))

  d8_height = length(local.d8_input)
  d8_length = length(local.d8_input[0])

  d8_positions = {
    for v in local.d8_unique_chars : v => flatten([
      for i, line in local.d8_input : [
        for j, c in line : { "row" : i, "col" : j } if c == v
      ]
    ])
  }

  d8_antenna_positions = toset(flatten([
    for l, positions in local.d8_positions : [
      for i, first in positions : [
        for j, second in positions : "${first.row * 2 - second.row}-${first.col * 2 - second.col}" if first.row * 2 - second.row >= 0 && first.row * 2 - second.row < local.d8_height && first.col * 2 - second.col >= 0 && first.col * 2 - second.col < local.d8_length && first != second
      ]
    ]
  ]))

  d8_b_antenna_positions = toset(flatten([
    for l, positions in local.d8_positions : [
      for i, first in positions : [
        for j, second in positions : [
          for mul in range(0, max(local.d8_height, local.d8_length)) : "${first.row + (second.row - first.row) * mul}-${first.col + (second.col - first.col) * mul}" if first.row + (second.row - first.row) * mul >= 0 && first.row + (second.row - first.row) * mul < local.d8_height && first.col + (second.col - first.col) * mul >= 0 && first.col + (second.col - first.col) * mul < local.d8_length && first != second
        ]
      ]
    ]
  ]))
}

module "d8_parse_input" {
  source   = "./parse-input"
  filename = "./inputs/day8.input"
  sep      = ["\n", ""]
}

output "day8-a" {
  value = local.days[8] ? ength(local.d8_antenna_positions) : null
}

output "day8-b" {
  value = local.days[8] ? length(local.d8_b_antenna_positions) : null
}
