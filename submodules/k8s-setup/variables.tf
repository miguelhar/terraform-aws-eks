variable "deploy_id" {
  type        = string
  description = "Domino Deployment ID"

  validation {
    condition     = can(regex("^[a-z-0-9]{3,32}$", var.deploy_id))
    error_message = "Argument deploy_id must: start with a letter, contain lowercase alphanumeric characters(can contain hyphens[-]) with length between 3 and 32 characters."
  }
}

variable "tags" {
  type        = map(string)
  description = "Deployment tags"
}

variable "kubeconfig_path" {
  type    = string
  default = "kubeconfig"
}


variable "pvt_key_path" {
  type = string
}

variable "bastion_user" {
  type    = string
  default = "ec2-user"

}

variable "bastion_public_ip" {
  type = string
}
variable "k8s_cluster_endpoint" {
  type = string
}

variable "managed_nodes_role_arns" {
  type = list(string)
}

variable "eks_master_role_names" {
  type    = list(string)
  default = []
}

variable "add_ons" {
  default = {
    calico = {
      version = "v3.23.2"
    }
  }
}

variable "mallory_local_normal_port" {
  type    = string
  default = "1315"
}

variable "mallory_local_smart_port" {
  type    = string
  default = "1316"
}

variable "k8s_pre_setup" {
  type    = bool
  default = false
}

