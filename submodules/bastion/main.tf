data "aws_partition" "current" {}
data "aws_caller_identity" "aws_account" {}

locals {
  dns_suffix     = data.aws_partition.current.dns_suffix
  aws_account_id = data.aws_caller_identity.aws_account.account_id

  # bastion_security_group_rules = {
  #   bastion_outbound_traffic = {
  #     description = "Allow all outbound traffic by default"
  #     protocol    = "-1"
  #     from_port   = "0"
  #     to_port     = "0"
  #     type        = "egress"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   },

  #   bastion_inbound_ssh = {
  #     description = "Inbound ssh"
  #     protocol    = "-1"
  #     from_port   = "22"
  #     to_port     = "22"
  #     type        = "ingress"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # }
}
