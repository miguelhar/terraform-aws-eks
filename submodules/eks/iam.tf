

## Customer managed policies
data "aws_iam_policy_document" "domino_ecr_restricted" {
  statement {

    effect    = "Deny"
    resources = ["arn:aws:ecr:*:${local.aws_account_id}:*"]

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]

    condition {
      test     = "StringNotEqualsIfExists"
      variable = "ecr:ResourceTag/domino-deploy-id"
      values   = [var.deploy_id]
    }
  }
}

resource "aws_iam_policy" "domino_ecr_restricted" {
  name   = "${var.deploy_id}-DominoEcrRestricted"
  path   = "/"
  policy = data.aws_iam_policy_document.domino_ecr_restricted.json
}

data "aws_iam_policy_document" "s3" {
  statement {

    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
    ]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${var.deploy_id}-blobs*",
      "arn:aws:s3:::${var.deploy_id}-logs*",
      "arn:aws:s3:::${var.deploy_id}-backups*",
      "arn:aws:s3:::${var.deploy_id}-registry*",
    ]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
    ]
  }
}

resource "aws_iam_policy" "s3" {
  name   = "${var.deploy_id}-S3"
  path   = "/"
  policy = data.aws_iam_policy_document.s3.json
}

data "aws_iam_policy_document" "autoscaler" {
  statement {

    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]
  }

  statement {

    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/eks:cluster-name"
      values   = [var.deploy_id]
    }
  }
}

resource "aws_iam_policy" "autoscaler" {
  name   = "${var.deploy_id}-Autoscaler"
  path   = "/"
  policy = data.aws_iam_policy_document.autoscaler.json
}

data "aws_iam_policy_document" "ebs_csi" {
  statement {

    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
    ]
  }

  statement {

    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:CreateSnapshot",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${var.deploy_id}"
      values   = ["owned"]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*",
    ]

    actions = ["ec2:CreateTags"]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"

      values = [
        "CreateVolume",
        "CreateSnapshot",
      ]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*",
    ]

    actions = ["ec2:DeleteTags"]
  }

  statement {

    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:CreateVolume"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/KubernetesCluster"
      values   = [var.deploy_id]
    }
  }

  statement {

    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DeleteVolume",
      "ec2:DeleteSnapshot",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/KubernetesCluster"
      values   = [var.deploy_id]
    }
  }
}

resource "aws_iam_policy" "ebs_csi" {
  name   = "${var.deploy_id}-ebs-csi"
  path   = "/"
  policy = data.aws_iam_policy_document.ebs_csi.json
}

data "aws_iam_policy_document" "route53" {
  statement {

    effect    = "Allow"
    resources = ["*"]
    actions   = ["route53:ListHostedZones"]
  }

  statement {

    effect    = "Allow"
    resources = [local.aws_route53_zone_arn]

    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]
  }
}

resource "aws_iam_policy" "route53" {
  count  = var.enable_route53_iam_policy ? 1 : 0
  name   = "${var.deploy_id}-Route53"
  path   = "/"
  policy = data.aws_iam_policy_document.route53.json
}

data "aws_iam_policy_document" "snapshot" {
  statement {

    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
    ]
  }
}

resource "aws_iam_policy" "snapshot" {
  name   = "${var.deploy_id}-snapshot"
  path   = "/"
  policy = data.aws_iam_policy_document.snapshot.json
}

locals {

  eks_aws_node_iam_policies = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])

  eks_custom_node_iam_policies = {
    "domino_ecr_restricted" = aws_iam_policy.domino_ecr_restricted.arn,
    "s3"                    = aws_iam_policy.s3.arn,
    "autoscaler"            = aws_iam_policy.autoscaler.arn,
    "ebs_csi"               = aws_iam_policy.ebs_csi.arn,
    "route53"               = try(aws_iam_policy.route53[0].arn, ""),
    "snapshot"              = aws_iam_policy.snapshot.arn
  }
}

resource "aws_iam_role_policy_attachment" "aws_eks_nodes" {
  for_each   = toset(local.eks_aws_node_iam_policies)
  policy_arn = each.key
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "custom_eks_nodes" {
  for_each   = { for name, arn in local.eks_custom_node_iam_policies : name => arn if name != "route53" }
  policy_arn = each.value
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "custom_eks_nodes_route53" {
  count      = var.enable_route53_iam_policy ? 1 : 0
  policy_arn = local.eks_custom_node_iam_policies["route53"]
  role       = aws_iam_role.eks_nodes.name
}
