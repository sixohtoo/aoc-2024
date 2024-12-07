locals {
  d1_input = local.days[1] ? split("\n", file("./day1.d1_input")) : []

  d1_l1_s = sort([
    for line in local.d1_input : format("%05d", trimspace(regexall("\\d+ ", line)[0]))
  ])
  d1_l1 = [
    for n in local.d1_l1_s : tonumber(n)
  ]

  d1_l2_s = sort([
    for line in local.d1_input : format("%05d", trimspace(regexall(" \\d+", line)[0]))
  ])
  d1_l2 = [
    for n in local.d1_l2_s : tonumber(n)
  ]

  d1_distances = [
    for i, n in local.d1_l1 : abs(n - local.d1_l2[i])
  ]

  d1_freq = {
    for v in toset(local.d1_l2) : v => length([
      for n in local.d1_l2 : n if n == v
    ])
  }
  d1_similarity = [
    for n in local.d1_l1 : n * lookup(local.d1_freq, n, 0)
  ]
}

output "day1-a" {
  value = length(local.d1_distances) != 0 ? sum(local.d1_distances) : null
}

output "day1-b" {
  value = length(local.d1_distances) != 0 ? sum(local.d1_similarity) : null
}
