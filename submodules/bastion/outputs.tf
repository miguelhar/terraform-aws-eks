output "security_group_id" {
  value = aws_security_group.bastion.id
}

output "public_ip" {
  value = aws_eip.bastion.public_ip
}
