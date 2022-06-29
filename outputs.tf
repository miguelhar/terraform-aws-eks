# output "k8s_tunnel_command" {
#   value = module.k8s_setup[0].k8s_tunnel_command
# }

# output "bastion_ip" {
#   value = module.bastion.public_ip
# }

# output "ssh_bastion_command" {
#   value = "ssh -i ${local.pvt_key} -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no ${local.bastion_user}@${module.bastion.public_ip}"
# }

# output "aws_auth" {
#   value = module.k8s.aws_auth
# }
