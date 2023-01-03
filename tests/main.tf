variable "test" {
  default = "tag A"
}

output "test" {
  value = var.test
}
