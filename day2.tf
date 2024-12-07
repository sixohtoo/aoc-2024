locals {
  d2_lines = module.parse_input.second

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

  d2_b_lines = [
    for line in local.d2_lines : concat(
      [
        line,
      ],
      [for i in range(length(line)) :
        concat(
          slice(line, 0, i),
          slice(line, min(length(line), i + 1), length(line))
        )
      ],
    )
  ]

  d2_b_is_ascending = [
    for i, line1 in local.d2_b_lines : [
      for j, line2 in line1 : line2 if tolist(line2) == sort(line2)
    ]
  ]

  d2_b_is_ascending_small = [
    for group in local.d2_b_is_ascending : true if length([
      for line in group : line if length([
        for i, v in slice(line, 0, length(line) - 1) :
        1 if line[i + 1] - v <= 3 && line[i + 1] - v > 0
      ]) == length(line) - 1
    ]) != 0
  ]

  d2_b_is_descending = [
    for i, line1 in local.d2_b_lines : [
      for j, line2 in line1 : line2 if tolist(line2) == reverse(sort(line2))
    ]
  ]

  d2_b_is_descending_small = [
    for group in local.d2_b_is_descending : true if length([
      for line in group : line if length([
        for i, v in slice(line, 0, length(line) - 1) :
        1 if v - line[i + 1] <= 3 && v - line[i + 1] > 0
      ]) == length(line) - 1
    ]) != 0
  ]
  # d2_b_is_ascending_small = [
  #   for line in local.d2_b_is_ascending : line if length([
  #     for i, v in slice(line, 0, length(line) - 1) :
  #     1 if line[i + 1] - v <= 3 && line[i + 1] - v > 0
  #   ]) == length(line) - 1
  # ]

  # d2_b_is_descending = [
  #   for i, line in local.d2_b_lines : line if tolist(line) == reverse(sort(line))
  # ]

  # d2_b_is_descending_small = [
  #   for line in local.d2_b_is_descending : line if length([
  #     for i, v in slice(line, 0, length(line) - 1) :
  #     1 if v - line[i + 1] <= 3 && v - line[i + 1] > 0
  #   ]) == length(line) - 1
  # ]

}

module "parse_input" {
  source   = "./parse-input"
  filename = "inputs/day2.input"
  sep      = ["\n", " "]
  tonum    = 2
}

output "day2-a" {
  value = length(local.d2_is_ascending_small) + length(local.d2_is_descending_small)
  # value = local.d2_lines
}

output "day2-b" {
  value = length(local.d2_b_is_ascending_small) + length(local.d2_b_is_descending_small)
}
