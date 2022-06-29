locals {
  subnet_output_keys = ["cidr_block", "name", "type", "zone", "zone_id"]
}

# output "pod_subnets" {
#   description = "Map containing the CIDR information for the pod subnets"
#   value       = local.pod_subnets
#   precondition {
#     condition = length(local.pod_subnets) == length(var.availability_zones) && alltrue([
#       for ps in local.pod_subnets :
#       ps["type"] == "pod" && alltrue([for k in keys(ps) : ps[k] != "" && contains(local.subnet_output_keys, k)])
#     ])
#     error_message = "The public subnet map is missing a required key, a value is empty or has the wrong type."
#   }
# }

output "public_subnets" {
  description = "Map containing the CIDR information for the public subnets"
  value       = local.public_subnets
}

output "private_subnets" {
  description = "Map containing the CIDR information for the private subnets"
  value       = local.private_subnets
}
