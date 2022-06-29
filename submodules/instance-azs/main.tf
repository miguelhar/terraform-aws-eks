
variable "instance_types" {
  type = list(string)
  default = [
    "m5.2xlarge",
    "m5.4xlarge",
    "g4dn.xlarge"
  ]
}

data "aws_ec2_instance_type_offerings" "instance_types" {
  for_each = toset(var.instance_types)
  filter {
    name   = "instance-type"
    values = [each.key]
  }
  location_type = "availability-zone-id"
}

output "instance_azs" {
  value = { for k, v in data.aws_ec2_instance_type_offerings.instance_types : k => toset(v.locations) }
}

