
## EKS Nodes
data "aws_iam_policy_document" "eks_nodes" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${local.dns_suffix}"]
    }
  }
}

data "aws_route53_zone" "this" {
  name         = var.route53_hosted_zone
  private_zone = false
}

resource "aws_iam_role" "eks_nodes" {
  name               = "${var.deploy_id}-eks-nodes"
  assume_role_policy = data.aws_iam_policy_document.eks_nodes.json
  tags               = var.tags
}

## EKS Nodes security-group
locals {
  node_sg_name         = "${var.deploy_id}-eks-node"
  aws_route53_zone_arn = data.aws_route53_zone.this.arn

  node_security_group_rules = {
    egress_cluster_443 = {
      description                   = "Node groups to cluster API"
      protocol                      = "tcp"
      from_port                     = 443
      to_port                       = 443
      type                          = "egress"
      source_cluster_security_group = true
    }
    ingress_cluster_443 = {
      description                   = "Cluster API to node groups"
      protocol                      = "tcp"
      from_port                     = 443
      to_port                       = 443
      type                          = "ingress"
      source_cluster_security_group = true
    }
    ingress_cluster_kubelet = {
      description                   = "Cluster API to node kubelets"
      protocol                      = "tcp"
      from_port                     = 10250
      to_port                       = 10250
      type                          = "ingress"
      source_cluster_security_group = true
    }
    # ingress_ssh = {
    #   description              = "Bastion ssh to nodes"
    #   protocol                 = "tcp"
    #   from_port                = 22
    #   to_port                  = 22
    #   type                     = "ingress"
    #   source_security_group_id = aws_security_group.bastion.id
    # }
    ingress_self_coredns_tcp = {
      description = "Node to node CoreDNS"
      protocol    = "tcp"
      from_port   = 53
      to_port     = 53
      type        = "ingress"
      self        = true
    }
    egress_self_coredns_tcp = {
      description = "Node to node CoreDNS"
      protocol    = "tcp"
      from_port   = 53
      to_port     = 53
      type        = "egress"
      self        = true
    }
    ingress_self_coredns_udp = {
      description = "Node to node CoreDNS"
      protocol    = "udp"
      from_port   = 53
      to_port     = 53
      type        = "ingress"
      self        = true
    }
    egress_self_coredns_udp = {
      description = "Node to node CoreDNS"
      protocol    = "udp"
      from_port   = 53
      to_port     = 53
      type        = "egress"
      self        = true
    }
    egress_https = {
      description = "Egress all HTTPS to internet"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_ntp_tcp = {
      description = "Egress NTP/TCP to internet"
      protocol    = "tcp"
      from_port   = 123
      to_port     = 123
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_ntp_udp = {
      description = "Egress NTP/UDP to internet"
      protocol    = "udp"
      from_port   = 123
      to_port     = 123
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.deploy_id}-nodes"
  description = "EKS cluster Nodes security group"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
  tags = merge({ "Name" = "${var.deploy_id}-eks-nodes" }, var.tags)
}

resource "aws_security_group_rule" "node" {
  for_each = local.node_security_group_rules

  # Required
  security_group_id = aws_security_group.eks_nodes.id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type
  description       = each.value.description
  cidr_blocks       = try(each.value.cidr_blocks, null)
  self              = try(each.value.self, null)
  source_security_group_id = try(
    each.value.source_security_group_id,
    try(each.value.source_cluster_security_group, false) ? aws_security_group.eks_cluster.id : null
  )
}

## END - EKS Nodes security-group


data "aws_ami" "eks_default" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.k8s_version}-v*"]
  }
  most_recent = true
  owners      = ["amazon"]
}

data "aws_ami" "eks_gpu" {
  filter {
    name   = "name"
    values = ["amazon-eks-gpu-node-${var.k8s_version}-v*"]
  }
  most_recent = true
  owners      = ["amazon"]
}

data "aws_ec2_instance_type_offerings" "compute" {

  filter {
    name   = "instance-type"
    values = [var.node_groups.compute.instance_type]
  }
  location_type = "availability-zone-id"
}

data "aws_ec2_instance_type_offerings" "platform" {

  filter {
    name   = "instance-type"
    values = [var.node_groups.platform.instance_type]
  }
  location_type = "availability-zone-id"
}

data "aws_ec2_instance_type_offerings" "gpu" {

  filter {
    name   = "instance-type"
    values = [var.node_groups.gpu.instance_type]
  }
  location_type = "availability-zone-id"
}

output "instance_offerings" {
  value = data.aws_ec2_instance_type_offerings.compute.locations
}

resource "aws_launch_template" "compute" {
  name = "${var.deploy_id}-compute"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = "true"
      encrypted             = "true"
      volume_size           = "100"
      volume_type           = "gp3"
    }
  }

  disable_api_termination = "false"
  instance_type           = var.node_groups.compute.instance_type
  key_name                = var.ssh_pvt_key_name
  vpc_security_group_ids  = [aws_security_group.eks_nodes.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = "2"
    http_tokens                 = "required"
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge({
      "Name" = "${var.deploy_id}-compute"
    }, var.tags)
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge({ "Name" = "${var.deploy_id}-compute" }, var.tags)
  }
  tags = var.tags
}

resource "aws_eks_node_group" "compute" {
  for_each        = { for sb in var.private_subnets : sb.zone => sb }
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.deploy_id}-compute-${each.value.zone}"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [each.value.id]

  scaling_config {
    min_size     = var.node_groups.compute.min
    max_size     = var.node_groups.compute.max
    desired_size = var.node_groups.compute.desired
  }

  launch_template {
    id      = aws_launch_template.compute.id
    version = aws_launch_template.compute.latest_version
  }


  labels = {
    "lifecycle"                     = "OnDemand"
    "dominodatalab.com/node-pool"   = "compute"
    "dominodatalab.com/domino-node" = "true"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size,
    ]
  }

  tags = var.tags
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_nodes,
    aws_iam_role_policy_attachment.custom_eks_nodes
  ]
}

resource "aws_launch_template" "platform" {
  name = "${var.deploy_id}-platform"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = "true"
      encrypted             = "true"
      volume_size           = "100"
      volume_type           = "gp3"
    }
  }

  disable_api_termination = "false"
  instance_type           = var.node_groups.platform.instance_type
  key_name                = var.ssh_pvt_key_name
  vpc_security_group_ids  = [aws_security_group.eks_nodes.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = "2"
    http_tokens                 = "required"
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge({
      "Name" = "${var.deploy_id}-platform"
    }, var.tags)
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge({ "Name" = "${var.deploy_id}-platform" }, var.tags)
  }
  tags = var.tags
}

resource "aws_eks_node_group" "platform" {
  for_each        = { for sb in var.private_subnets : sb.zone => sb }
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.deploy_id}-platform-${each.value.zone}"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [each.value.id]

  scaling_config {
    min_size     = var.node_groups.platform.min
    max_size     = var.node_groups.platform.max
    desired_size = var.node_groups.platform.desired
  }

  launch_template {
    id      = aws_launch_template.platform.id
    version = aws_launch_template.platform.latest_version
  }


  labels = {
    "lifecycle"                     = "OnDemand"
    "dominodatalab.com/node-pool"   = "platform"
    "dominodatalab.com/domino-node" = "true"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size,
    ]
  }

  tags = var.tags
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_nodes,
    aws_iam_role_policy_attachment.custom_eks_nodes
  ]
}


resource "aws_launch_template" "gpu" {
  name     = "${var.deploy_id}-gpu"
  image_id = data.aws_ami.eks_gpu.image_id
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = "true"
      encrypted             = "true"
      volume_size           = "100"
      volume_type           = "gp3"
    }
  }

  disable_api_termination = "false"
  instance_type           = var.node_groups.gpu.instance_type
  key_name                = var.ssh_pvt_key_name
  vpc_security_group_ids  = [aws_security_group.eks_nodes.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = "2"
    http_tokens                 = "required"
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge({
      "Name" = "${var.deploy_id}-gpu"
    }, var.tags)
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge({ "Name" = "${var.deploy_id}-gpu" }, var.tags)
  }
  tags = var.tags
}

resource "aws_eks_node_group" "gpu" {
  for_each        = { for sb in var.private_subnets : sb.zone => sb }
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.deploy_id}-gpu-${each.value.zone}"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [each.value.id]

  scaling_config {
    min_size     = var.node_groups.gpu.min
    max_size     = var.node_groups.gpu.max
    desired_size = var.node_groups.gpu.desired
  }

  launch_template {
    id      = aws_launch_template.gpu.id
    version = aws_launch_template.gpu.latest_version
  }


  labels = {
    "lifecycle"                     = "OnDemand"
    "dominodatalab.com/node-pool"   = "gpu"
    "dominodatalab.com/domino-node" = "true"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size,
    ]
  }

  tags = var.tags
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_nodes,
    aws_iam_role_policy_attachment.custom_eks_nodes
  ]
}
