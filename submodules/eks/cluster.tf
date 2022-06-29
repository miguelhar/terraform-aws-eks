## EKS IAM
data "aws_iam_policy_document" "eks_cluster" {
  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.${local.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "eks_cluster" {
  name               = "${var.deploy_id}-eks"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}


## EKS key
data "aws_iam_policy_document" "kms_key" {
  statement {
    actions = [
      "kms:Create*", "kms:Describe*", "kms:Enable*", "kms:List*", "kms:Put*", "kms:Update*", "kms:Revoke*", "kms:Disable*", "kms:Get*", "kms:Delete*", "kms:ScheduleKeyDeletion", "kms:CancelKeyDeletion", "kubeconms:GenerateDataKey", "kms:TagResource", "kms:UntagResource"
    ]
    resources = ["*"]
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.aws_account_id}:root"]
    }
  }
}

resource "aws_kms_key" "eks_cluster" {
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = "true"
  is_enabled               = "true"
  key_usage                = "ENCRYPT_DECRYPT"
  multi_region             = "false"
  policy                   = data.aws_iam_policy_document.kms_key.json
  tags                     = merge({ "Name" = "${var.deploy_id}-eks-cluster" }, var.tags)

}
## END - EKS key

## EKS security-group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.deploy_id}-cluster"
  description = "EKS cluster security group"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
  tags = merge({ "Name" = "${var.deploy_id}-eks-cluster" }, var.tags)
}

resource "aws_security_group_rule" "eks_cluster" {
  for_each = local.eks_cluster_security_group_rules

  security_group_id        = aws_security_group.eks_cluster.id
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  type                     = each.value.type
  description              = each.value.description
  cidr_blocks              = try(each.value.cidr_blocks, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}

## END - EKS security-group

## EKS cluster
resource "aws_eks_cluster" "this" {
  name                      = var.deploy_id
  role_arn                  = aws_iam_role.eks_cluster.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  version                   = var.k8s_version
  tags                      = var.tags

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_cluster.arn
    }
    resources = ["secrets"]
  }

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "172.20.0.0/16"
  }


  vpc_config {
    endpoint_private_access = "true"
    endpoint_public_access  = "false"
    security_group_ids      = [aws_security_group.eks_cluster.id]
    subnet_ids              = [for sb in var.private_subnets : sb.id]
  }
  depends_on = [aws_iam_role_policy_attachment.eks_cluster]
}

resource "aws_eks_addon" "this" {
  for_each          = toset(var.eks_cluster_addons)
  cluster_name      = aws_eks_cluster.this.name
  resolve_conflicts = "OVERWRITE"
  addon_name        = each.key

  depends_on = [
    aws_eks_node_group.compute,
    aws_eks_node_group.platform,
    aws_eks_node_group.gpu,
  ]

  tags = var.tags
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "export KUBECONFIG=${var.kubeconfig_path}  && aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.this.name}"
  }
  triggers = {
    domino_eks_cluster_ca = aws_eks_cluster.this.certificate_authority[0].data
  }
  depends_on = [aws_eks_cluster.this]
}
