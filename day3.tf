locals {
  d3_input_raw = local.days[3] ? module.d3_parse_input.first : [""]
  d3_input     = "${join("a", local.d3_input_raw)}don't()do()"

  d3_mul = regexall("mul\\((\\d{1,3}),(\\d{1,3})\\)", local.d3_input)
  d3_muls = [
    for group in local.d3_mul : tonumber(group[0]) * tonumber(group[1])
  ]

  d3_b_valid = join("", compact(flatten(regexall("(.*?)don't\\(\\).*?do\\(\\)", local.d3_input))))

  d3_b_mul = regexall("mul\\((\\d{1,3}),(\\d{1,3})\\)", local.d3_b_valid)
  d3_b_muls = [
    for group in local.d3_b_mul : tonumber(group[0]) * tonumber(group[1])
  ]
}

module "d3_parse_input" {
  source   = "./parse-input"
  filename = "./inputs/day3.input"
  sep      = ["\n"]
}

output "day3-a" {
  value = local.days[3] ? sum(local.d3_muls) : null
}

output "day3-b" {
  value = local.days[3] ? sum(local.d3_b_muls) : null
}
