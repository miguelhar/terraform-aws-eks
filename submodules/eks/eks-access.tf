
locals {
  bastion_eks_security_group_rules = merge(var.bastion_security_group_id != "" ? {
    bastion_to_eks_api = {
      description              = "Bastion outbound to eks cluster ${var.deploy_id}:443 API"
      protocol                 = "tcp"
      from_port                = "443"
      to_port                  = "443"
      type                     = "egress"
      security_group_id        = var.bastion_security_group_id
      source_security_group_id = aws_security_group.eks_cluster.id
    }
    bastion_to_eks_nodes_ssh = {
      description              = "Bastion ssh to eks cluster nodes outbound"
      protocol                 = "tcp"
      from_port                = "22"
      to_port                  = "22"
      type                     = "egress"
      security_group_id        = var.bastion_security_group_id
      source_security_group_id = aws_security_group.eks_nodes.id
    }
    eks_api_from_bastion = {
      description              = "Eks cluster ${var.deploy_id}:443 inbound from bastion"
      protocol                 = "tcp"
      from_port                = "443"
      to_port                  = "443"
      type                     = "ingress"
      security_group_id        = aws_security_group.eks_cluster.id
      source_security_group_id = var.bastion_security_group_id
    }
    eks_nodes_ssh_from_bastion = {
      description              = "Bastion ssh to eks cluster nodes inbound"
      protocol                 = "tcp"
      from_port                = "22"
      to_port                  = "22"
      type                     = "ingress"
      security_group_id        = var.bastion_security_group_id
      source_security_group_id = aws_security_group.eks_nodes.id
    }
  } : {}, var.eks_security_group_rules)
}


resource "aws_security_group_rule" "bastion_eks" {
  for_each = local.bastion_eks_security_group_rules

  security_group_id        = each.value.security_group_id
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  type                     = each.value.type
  description              = each.value.description
  source_security_group_id = each.value.source_security_group_id
}
