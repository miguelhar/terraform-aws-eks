
data "aws_partition" "current" {}
data "aws_caller_identity" "aws_account" {}

locals {
  aws_account_id              = data.aws_caller_identity.aws_account.account_id
  dns_suffix                  = data.aws_partition.current.dns_suffix
  policy_arn_prefix           = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
  private_subnets_cidr_blocks = [for sb in var.private_subnets : sb.cidr_block]
  eks_cluster_add_ons         = toset(["vpc-cni", "kube-proxy", "coredns", "aws-ebs-csi-driver"])
  eks_cluster_security_group_rules = {
    ingress_nodes_443 = {
      description = "Private subnets to ${var.deploy_id} EKS cluster API"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [for sb in var.private_subnets : sb.cidr_block]
    }
    egress_nodes_443 = {
      description = "${var.deploy_id} EKS cluster API to private subnets"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "egress"
      cidr_blocks = [for sb in var.private_subnets : sb.cidr_block]
    }
    egress_nodes_kubelet = {
      description = "${var.deploy_id} EKS cluster API to private subnets"
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250
      type        = "egress"
      cidr_blocks = [for sb in var.private_subnets : sb.cidr_block]
    }
  }
}
