variable "filename" {
  type = string
}

variable "sep" {
  type = list(string)
}

locals {
  input = file(var.filename)

  first = [
    for v in length(var.sep) >= 1 ? split(var.sep[0], local.input) : [local.input] : v
  ]


  second = length(var.sep) >= 2 ? [
    for line in local.first : split(var.sep[1], line)
  ] : null

}

output "first" {
  value = local.first
}

output "second" {
  value = local.second
}
