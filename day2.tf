locals {
  d2_lines_str = module.parse_input.second

  d2_lines = [
    for line in local.d2_lines_str : [
      for num in line : format("%05d", num)
    ]
  ]

  d2_is_ascending = [
    for i, line in local.d2_lines : line if tolist(line) == sort(line)
  ]

  d2_is_ascending_small = [
    for line in local.d2_is_ascending : line if length([
      for i, v in slice(line, 0, length(line) - 1) :
      1 if line[i + 1] - v <= 3 && line[i + 1] - v > 0
    ]) == length(line) - 1
  ]

  d2_is_descending = [
    for i, line in local.d2_lines : line if tolist(line) == reverse(sort(line))
  ]

  d2_is_descending_small = [
    for line in local.d2_is_descending : line if length([
      for i, v in slice(line, 0, length(line) - 1) :
      1 if v - line[i + 1] <= 3 && v - line[i + 1] > 0
    ]) == length(line) - 1
  ]
}

module "parse_input" {
  source   = "./parse-input"
  filename = "./day2.input"
  sep      = ["\n", " "]
}

output "day2-a" {
  value = length(local.d2_is_ascending_small) + length(local.d2_is_descending_small)
}
