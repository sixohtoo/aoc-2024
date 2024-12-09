locals {
  d5_input = module.d5_parse_input.first
  d5_rules_raw = local.days[5] ? [
    for line in split("\n", local.d5_input[0]) : split("|", line)
  ] : []
  d5_rules_after_vals = toset([
    for rule in local.d5_rules_raw : rule[1]
  ])
  d5_rules = {
    for v in local.d5_rules_after_vals : v => toset([
      for rule in local.d5_rules_raw : rule[0] if rule[1] == v
    ])
  }

  d5_orders = local.days[5] ? [
    for line in split("\n", local.d5_input[1]) : split(",", line)
  ] : []

  d5_valid = [
    for order in local.d5_orders : tonumber(order[floor(length(order) / 2)]) if length([
      for i, page in order : page if length(setintersection(lookup(local.d5_rules, page, toset([])), toset(slice(order, i + 1, length(order))))) == 0
    ]) == length(order)
  ]

  d5_b_valid = [
    for order in local.d5_orders : order if length([
      for i, page in order : page if length(setintersection(lookup(local.d5_rules, page, toset([])), toset(slice(order, i + 1, length(order))))) == 0
    ]) != length(order)
  ]

  d5_b_sorted = flatten([
    for order in local.d5_b_valid : [
      for page in order : page if length(setintersection(lookup(local.d5_rules, page, toset([])), toset(order))) == floor(length(order) / 2)
    ]
  ])
}



module "d5_parse_input" {
  source   = "./parse-input"
  filename = "./inputs/day5.input"
  sep      = ["\n\n"]
}


output "day5-a" {
  value = local.days[5] ? sum(local.d5_valid) : null
}

output "day5-b" {
  value = local.days[5] ? sum(local.d5_b_sorted) : null
}
