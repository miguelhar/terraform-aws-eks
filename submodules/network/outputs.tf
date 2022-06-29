output "vpc_id" {
  value = local.vpc_id
}

output "private_subnets" {
  value = [for sb in var.private_subnets : merge(sb, { id = aws_subnet.private[sb.name].id })]
}

output "public_subnets" {
  value = [for sb in var.public_subnets : merge(sb, { id = aws_subnet.public[sb.name].id })]
}
