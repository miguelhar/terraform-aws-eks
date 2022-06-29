
data "aws_route53_zone" "this" {
  name         = var.route53_hosted_zone
  private_zone = false
}

data "aws_caller_identity" "current" {}
data "aws_canonical_user_id" "current" {}



data "aws_iam_policy_document" "backups" {
  statement {
    effect = "Deny"

    resources = [
      "arn:aws:s3:::${var.deploy_id}-backups",
      "arn:aws:s3:::${var.deploy_id}-backups/*",
    ]

    actions = ["s3:*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    resources = ["arn:aws:s3:::${var.deploy_id}-backups/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyUnEncryptedObjectUploads"
    effect    = "Deny"
    resources = ["arn:aws:s3:::${var.deploy_id}-backups/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "backups" {
  bucket              = "${var.deploy_id}-backups"
  force_destroy       = "false"
  hosted_zone_id      = data.aws_route53_zone.this.zone_id
  object_lock_enabled = "false"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      hosted_zone_id,
    ]
  }
}

data "aws_iam_policy_document" "blobs" {
  statement {

    effect = "Deny"

    resources = [
      "arn:aws:s3:::${var.deploy_id}-blobs",
      "arn:aws:s3:::${var.deploy_id}-blobs/*",
    ]

    actions = ["s3:*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }


  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    resources = ["arn:aws:s3:::${var.deploy_id}-blobs/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyUnEncryptedObjectUploads"
    effect    = "Deny"
    resources = ["arn:aws:s3:::${var.deploy_id}-blobs/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "blobs" {
  bucket              = "${var.deploy_id}-blobs"
  force_destroy       = "false"
  hosted_zone_id      = data.aws_route53_zone.this.zone_id
  object_lock_enabled = "false"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      hosted_zone_id,
    ]
  }
}

data "aws_iam_policy_document" "logs" {
  statement {

    effect = "Deny"

    resources = [
      "arn:aws:s3:::${var.deploy_id}-logs",
      "arn:aws:s3:::${var.deploy_id}-logs/*",
    ]

    actions = ["s3:*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    resources = ["arn:aws:s3:::${var.deploy_id}-logs/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyUnEncryptedObjectUploads"
    effect    = "Deny"
    resources = ["arn:aws:s3:::${var.deploy_id}-logs/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "logs" {
  bucket              = "${var.deploy_id}-logs"
  force_destroy       = "false"
  hosted_zone_id      = data.aws_route53_zone.this.zone_id
  object_lock_enabled = "false"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      hosted_zone_id,
    ]
  }
}

data "aws_iam_policy_document" "monitoring" {
  statement {

    effect = "Deny"

    resources = [
      "arn:aws:s3:::${var.deploy_id}-monitoring",
      "arn:aws:s3:::${var.deploy_id}-monitoring/*",
    ]

    actions = ["s3:*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }


  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.deploy_id}-monitoring/*"]

    actions = [
      "s3:PutObject*",
      "s3:Abort*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.id}:root"]
    }
  }

  statement {
    sid       = "AWSLogDeliveryWrite"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.deploy_id}-monitoring/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }

  statement {
    sid       = "AWSLogDeliveryCheck"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.deploy_id}-monitoring"]

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket",
    ]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket" "monitoring" {
  bucket              = "${var.deploy_id}-monitoring"
  force_destroy       = "true"
  hosted_zone_id      = data.aws_route53_zone.this.zone_id
  object_lock_enabled = "false"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      hosted_zone_id,
    ]
  }
}

resource "aws_s3_bucket_acl" "monitoring" {
  bucket = aws_s3_bucket.monitoring.id

  access_control_policy {

    owner {
      id = data.aws_canonical_user_id.current.id
    }

    grant {
      grantee {
        type = "CanonicalUser"
        id   = data.aws_canonical_user_id.current.id
      }
      permission = "FULL_CONTROL"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "WRITE"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }
  }
}

data "aws_iam_policy_document" "registry" {
  statement {
    effect = "Deny"
    resources = [
      "arn:aws:s3:::${var.deploy_id}-registry",
      "arn:aws:s3:::${var.deploy_id}-registry/*",
    ]

    actions = ["s3:*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    resources = ["arn:aws:s3:::${var.deploy_id}-registry/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyUnEncryptedObjectUploads"
    effect    = "Deny"
    resources = ["arn:aws:s3:::${var.deploy_id}-registry/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "registry" {
  arn                 = "arn:aws:s3:::${var.deploy_id}-registry"
  bucket              = "${var.deploy_id}-registry"
  force_destroy       = "false"
  hosted_zone_id      = data.aws_route53_zone.this.zone_id
  object_lock_enabled = "false"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      hosted_zone_id,
    ]
  }
}

locals {
  s3_buckets = {
    backups = {
      bucket_name = aws_s3_bucket.backups.bucket
      id          = aws_s3_bucket.backups.id
      policy_json = data.aws_iam_policy_document.backups.json
    }
    blobs = {
      bucket_name = aws_s3_bucket.blobs.bucket
      id          = aws_s3_bucket.blobs.id
      policy_json = data.aws_iam_policy_document.blobs.json
    }
    logs = {
      bucket_name = aws_s3_bucket.logs.bucket
      id          = aws_s3_bucket.logs.id
      policy_json = data.aws_iam_policy_document.logs.json
    }
    monitoring = {
      bucket_name = aws_s3_bucket.monitoring.bucket
      id          = aws_s3_bucket.monitoring.id
      policy_json = data.aws_iam_policy_document.monitoring.json
    }
    registry = {
      bucket_name = aws_s3_bucket.registry.bucket
      id          = aws_s3_bucket.registry.id
      policy_json = data.aws_iam_policy_document.registry.json
    }
  }
}


resource "aws_s3_bucket_policy" "bucket_policies" {
  for_each = local.s3_buckets
  bucket   = each.value.id
  policy   = each.value.policy_json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "buckets_encryption" {
  for_each = local.s3_buckets

  bucket = each.value.bucket_name
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = "false"
  }
}

resource "aws_s3_bucket_request_payment_configuration" "buckets_payer" {
  for_each = local.s3_buckets
  bucket   = each.value.bucket_name
  payer    = "BucketOwner"
}

resource "aws_s3_bucket_logging" "buckets_logging" {
  for_each      = { for k, v in local.s3_buckets : k => v if v.bucket_name != aws_s3_bucket.monitoring.bucket }
  bucket        = each.value.id
  target_bucket = aws_s3_bucket.monitoring.bucket
  target_prefix = "${each.value.bucket_name}/"
}

resource "aws_s3_bucket_versioning" "buckets_versioning" {
  for_each = local.s3_buckets
  bucket   = each.value.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

