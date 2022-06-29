variable "deploy_id" {
  type        = string
  description = "Domino Deployment ID"

  validation {
    condition     = can(regex("^[a-z-0-9]{3,32}$", var.deploy_id))
    error_message = "Argument deploy_id must: start with a letter, contain lowercase alphanumeric characters(can contain hyphens[-]) with length between 3 and 32 characters."
  }
}

variable "efs_access_point_path" {
  type = string
}

variable "route53_hosted_zone" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "Deployment tags"
}
