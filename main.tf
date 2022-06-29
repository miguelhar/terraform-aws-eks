variable "ssh_pvt_key_path" {
  type    = string
  default = "domino.pem"
}


data "tls_public_key" "domino" {
  count           = fileexists(var.ssh_pvt_key_path) ? 1 : 0
  private_key_pem = file(var.ssh_pvt_key_path)
}

resource "tls_private_key" "domino" {
  count     = fileexists(var.ssh_pvt_key_path) ? 0 : 1
  algorithm = "RSA"
}


locals {
  pvt_key = try(data.tls_public_key.domino[0].public_key_pem, tls_private_key.domino[0].public_key_openssh)
}

resource "aws_key_pair" "domino" {
  key_name   = var.deploy_id
  public_key = trimspace(local.pvt_key)
}

resource "local_sensitive_file" "pvt_key" {
  count           = fileexists(var.ssh_pvt_key_path) ? 0 : 1
  content         = tls_private_key.domino[0].private_key_openssh
  file_permission = "0400"
  filename        = var.ssh_pvt_key_path
}

data "aws_caller_identity" "aws_account" {}

data "aws_route53_zone" "this" {
  name         = var.route53_hosted_zone
  private_zone = false
}

data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.region]
  }
}


data "aws_partition" "current" {}

locals {
  aws_account_id          = data.aws_caller_identity.aws_account.account_id
  availability_zones_data = zipmap(data.aws_availability_zones.available.names, data.aws_availability_zones.available.zone_ids)
  ## EKS needs at least 2 availability zones: https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
  availability_zone_names = length(var.availability_zones) >= 2 ? toset(var.availability_zones) : toset(slice(keys(local.availability_zones_data), 0, var.number_of_azs))
  availability_zone_ids   = [for name in local.availability_zone_names : local.availability_zones_data[name]]
  availability_zones      = zipmap(local.availability_zone_names, local.availability_zone_ids)
  dns_suffix              = data.aws_partition.current.dns_suffix
  bastion_user            = "ec2-user"
}

module "subnets_cidr" {
  source                    = "./submodules/subnets-cidr"
  availability_zones        = local.availability_zones
  base_cidr_block           = var.base_cidr_block
  public_cidr_network_bits  = var.public_cidr_network_bits
  private_cidr_network_bits = var.private_cidr_network_bits
  subnet_name_prefix        = var.deploy_id
}

module "network" {
  source          = "./submodules/network"
  region          = var.region
  public_subnets  = module.subnets_cidr.public_subnets
  private_subnets = module.subnets_cidr.private_subnets
  deploy_id       = var.deploy_id
  base_cidr_block = var.base_cidr_block
  vpc_id          = var.vpc_id
  tags            = var.tags
}

locals {
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets
}

module "bastion" {
  count = var.create_bastion ? 1 : 0

  source                   = "./submodules/bastion"
  region                   = var.region
  vpc_id                   = module.network.vpc_id
  deploy_id                = var.deploy_id
  ssh_pvt_key_name         = aws_key_pair.domino.key_name
  bastion_public_subnet_id = local.public_subnets[0].id
  tags                     = var.tags
}

module "eks" {
  source                    = "./submodules/eks"
  region                    = var.region
  k8s_version               = var.k8s_version
  vpc_id                    = module.network.vpc_id
  deploy_id                 = var.deploy_id
  private_subnets           = local.private_subnets
  ssh_pvt_key_name          = aws_key_pair.domino.key_name
  route53_hosted_zone       = var.route53_hosted_zone
  bastion_security_group_id = try(module.bastion.security_group_id, "")
  enable_route53_iam_policy = var.enable_route53_iam_policy
  tags                      = var.tags
  depends_on                = [module.bastion]
}


module "storage" {
  source                = "./submodules/storage"
  deploy_id             = var.deploy_id
  efs_access_point_path = var.efs_access_point_path
  route53_hosted_zone   = var.route53_hosted_zone
  tags                  = var.tags
}

# locals {
#   bastion_eks_security_group_rules = {
#     bastion_to_eks_api = {
#       description              = "Bastion outbound to eks cluster ${var.deploy_id}:443 API"
#       protocol                 = "tcp"
#       from_port                = "443"
#       to_port                  = "443"
#       type                     = "egress"
#       security_group_id        = module.bastion.security_group_id
#       source_security_group_id = module.eks.security_group_id
#     }
#     bastion_to_eks_nodes_ssh = {
#       description              = "Bastion ssh to eks cluster nodes outbound"
#       protocol                 = "tcp"
#       from_port                = "22"
#       to_port                  = "22"
#       type                     = "egress"
#       security_group_id        = module.bastion.security_group_id
#       source_security_group_id = module.eks.nodes_security_group_id
#     }
#     eks_api_from_bastion = {
#       description              = "Eks cluster ${var.deploy_id}:443 inbound from bastion"
#       protocol                 = "tcp"
#       from_port                = "443"
#       to_port                  = "443"
#       type                     = "ingress"
#       security_group_id        = module.eks.security_group_id
#       source_security_group_id = module.bastion.security_group_id
#     }
#     eks_nodes_ssh_from_bastion = {
#       description              = "Bastion ssh to eks cluster nodes inbound"
#       protocol                 = "tcp"
#       from_port                = "22"
#       to_port                  = "22"
#       type                     = "ingress"
#       security_group_id        = module.bastion.security_group_id
#       source_security_group_id = module.eks.nodes_security_group_id
#     }
#   }
# }

# resource "aws_security_group_rule" "bastion_eks" {
#   for_each = local.bastion_eks_security_group_rules

#   security_group_id        = each.value.security_group_id
#   protocol                 = each.value.protocol
#   from_port                = each.value.from_port
#   to_port                  = each.value.to_port
#   type                     = each.value.type
#   description              = each.value.description
#   source_security_group_id = each.value.source_security_group_id
# }

# module "k8s_setup" {
#   count                     = var.k8s_setup ? 1 : 0
#   source                    = "./submodules/k8s-setup"
#   deploy_id                 = var.deploy_id
#   pvt_key_path              = abspath(local.pvt_key)
#   bastion_user              = local.bastion_user
#   bastion_public_ip         = module.bastion.public_ip
#   k8s_cluster_endpoint      = module.eks.cluster_endpoint
#   managed_nodes_role_arns   = module.eks.managed_nodes_role_arns
#   eks_master_role_names     = var.eks_master_role_names
#   tags                      = var.tags
#   mallory_local_normal_port = local.mallory_local_normal_port
#   mallory_local_smart_port  = local.mallory_local_smart_port
#   k8s_pre_setup             = var.k8s_pre_setup
#   depends_on                = [module.eks]
# }
