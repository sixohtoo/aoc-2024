variable "filename" {
  type = string
}

variable "sep" {
  type = list(string)
}

variable "tonum" {
  type = number
}

locals {
  input = file(var.filename)

  first = [
    for v in length(var.sep) >= 1 ? split(var.sep[0], local.input) : [local.input] :
    var.tonum == 1 ? format("%05d", v) : v
  ]


  second = length(var.sep) >= 2 ? [
    for line in local.first : [
      for v in split(var.sep[1], line) : var.tonum == 2 ? format("%05d", v) : v
    ]
  ] : null
}

output "first" {
  value = local.first
}

output "second" {
  value = local.second
}
