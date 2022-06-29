variable "deploy_id" {
  type        = string
  description = "Domino Deployment ID"

  validation {
    condition     = can(regex("^[a-z-0-9]{3,32}$", var.deploy_id))
    error_message = "Argument deploy_id must: start with a letter, contain lowercase alphanumeric characters(can contain hyphens[-]) with length between 3 and 32 characters."
  }
}

variable "region" {
  type        = string
  description = "AWS region for the deployment"
}

variable "tags" {
  type        = map(string)
  description = "Deployment tags"
}

variable "k8s_version" {
  default = "1.22"
}

variable "node_groups" {
  type = map(map(any))
  default = {
    "compute" = {
      instance_type = "m5.2xlarge"
      min           = 0
      max           = 10
      desired       = 1
    },
    "platform" = {
      instance_type = "m5.4xlarge"
      min           = 0
      max           = 10
      desired       = 1
    },
    "gpu" = {
      instance_type = "g4dn.xlarge"
      min           = 0
      max           = 10
      desired       = 1
    }
  }
}

variable "kubeconfig_path" {
  type    = string
  default = "kubeconfig"
}

variable "private_subnets" {
  type = list(map(any))
}

variable "vpc_id" {
  type = string
}

variable "ssh_pvt_key_name" {
  type = string
}

variable "route53_hosted_zone" {
  type = string
}

variable "bastion_security_group_id" {
  type    = string
  default = ""
}

variable "enable_route53_iam_policy" {
  type    = bool
  default = false
}

variable "eks_cluster_addons" {
  type    = list(string)
  default = ["vpc-cni", "kube-proxy", "coredns", "aws-ebs-csi-driver"]
}

variable "eks_security_group_rules" {
  type    = map(any)
  default = {}
}
