variable "tag" {
  default = "v0.0.0"
}
variable "release" {
  default = "release 1"
}

output "tag" {
  value = var.tag
}

output "release" {
  value = var.release
}
