
locals {
  domino_namespaces = toset(["${var.deploy_id}-compute", "${var.deploy_id}-platform"])
  aws_auth_cm = yamldecode(templatefile("${path.module}/templates/aws_auth_cm.tftpl",
    {
      eks_managed_nodes_role_arns = var.managed_nodes_role_arns
      eks_master_role_arns        = try({ for r in var.eks_master_role_names : r => data.aws_iam_role.eks_master_roles[r].arn }, {})

  }))
}

resource "kubernetes_namespace" "domino" {
  count = var.k8s_pre_setup ? 0 : length(local.domino_namespaces)
  metadata {
    name = tolist(local.domino_namespaces)[count.index]
  }
  # depends_on = [docker_container.mallory] ## NEED TO CHECK IF PROXY IS RUNNING
}

data "aws_iam_role" "eks_master_roles" {
  for_each = toset(var.eks_master_role_names)
  name     = each.key
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  count = var.k8s_pre_setup ? 0 : 1
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data  = local.aws_auth_cm.data
  force = true
}
